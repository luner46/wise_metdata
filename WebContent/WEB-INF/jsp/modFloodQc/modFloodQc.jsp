<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<head>
<style>
#treeBox { background-color: #e0e0e0; padding: 20px; border: 1px solid #999; width: 420px; max-height: 500px; overflow-y: auto; margin-top: 10px; font-family: "맑은 고딕", sans-serif;}
ul { list-style-type: none; padding-left: 18px; margin: 0; }
ul li { margin: 4px 0; position: relative; padding-left: 18px; font-size: 14px; }
label { margin-left: 4px; vertical-align: middle; }
.toggle-icon { cursor: pointer; display: inline-block; width: 14px; text-align: center; margin-right: 4px; }
</style>
<script src="/js/plugin/jquery/jquery-1.12.4.min.js"></script>

</head>

<script>
var monitorInterval = null;

function safeBtoa(str) {
    return btoa(unescape(encodeURIComponent(str))).replace(/=/g, '');
}

function parseDbf(arrayBuffer) {
    var view = new DataView(arrayBuffer);
    var decoder = new TextDecoder('ascii');

    var numRecords = view.getUint32(4, true);
    var headerLength = view.getUint16(8, true);
    var recordLength = view.getUint16(10, true);

    var fields = [];
    var offset = 32;

    while (view.getUint8(offset) !== 0x0D) {
        var name = decoder.decode(new Uint8Array(arrayBuffer, offset, 11)).replace(/\0/g, '').trim();
        var fieldType = String.fromCharCode(view.getUint8(offset + 11));
        var length = view.getUint8(offset + 16);
        fields.push({ name, type: fieldType, length });
        offset += 32;
    }

    var records = [];
    offset = headerLength;

    for (let i = 0; i < numRecords; i++) {
        var record = {};
        let fieldOffset = 1;

        for (var field of fields) {
            var raw = new Uint8Array(arrayBuffer, offset + fieldOffset, field.length);
            var value = decoder.decode(raw).trim();
            record[field.name] = value;
            fieldOffset += field.length;
        }

        records.push(record);
        offset += recordLength;
    }
    
    return records;
}

// 트리 생성
function renderTree(parentElement, treeData, basePath, isRoot) {
    var ul = $('<ul></ul>');

    $.each(treeData, function (name, children) {
        var fullPath = basePath + '/' + name;
        var nodeId = safeBtoa(fullPath);
        var li = $('<li></li>');

        var isFolder = (children !== null);

        if (isRoot && basePath === '') {
            li.append($('<span></span>').css({ 'font-weight': 'bold', 'font-size': '15px' }).text(name));
            renderTree(li, children, fullPath, false);
        } else {
            var toggleIcon = $('<span class="toggle-icon">▶</span>').css('visibility', isFolder ? 'visible' : 'hidden');
            var checkbox = $('<input type="checkbox">')
                .attr('id', nodeId)
                .attr('data-path', fullPath)
                .on('change', function () {
                    if (isFolder) {
                        li.find('input[type="checkbox"]').prop('checked', this.checked);
                    }
                    toggleParentCheckState($(this));
                });

            var label = $('<label></label>').attr('for', nodeId).text(' ' + name);
            li.append(toggleIcon).append(checkbox).append(label);

            if (isFolder) {
                var childWrapper = $('<div></div>').hide();
                renderTree(childWrapper, children, fullPath, false);
                li.append(childWrapper);

                toggleIcon.on('click', function () {
                    var visible = childWrapper.is(':visible');
                    childWrapper.slideToggle(100);
                    toggleIcon.text(visible ? '▶' : '▼');
                });

                toggleIcon.text('▼');
            }
        }

        ul.append(li);
    });

    parentElement.append(ul);
}

// 부모 체크 상태 갱신
function toggleParentCheckState(childCheckbox) {
    var parentLi = childCheckbox.closest('ul').closest('li');
    var parentCheckbox = parentLi.children('input[type="checkbox"]');

    if (parentCheckbox.length) {
        var childCheckboxes = parentLi.find('> div > ul > li > input[type="checkbox"]');
        var allChecked = childCheckboxes.length > 0 && childCheckboxes.filter(':checked').length === childCheckboxes.length;
        parentCheckbox.prop('checked', allChecked);
        toggleParentCheckState(parentCheckbox);
    }
}


// 면적 역전 검수 트리 체크
function areaReversedCheck(dataList) {
	console.log(dataList);
    $.ajax({
        url: "/modFloodQc/checkShpCodeValid.do",
        method: "POST",
        contentType: "application/json",
        data: JSON.stringify(dataList),
        success: function(res) {
            var validDataIds = res.filter(r => r.valid).map(r => r.data_id);

            if (validDataIds.length === 0) {
                alert("유효한 파일이 없습니다.");
                return;
            }

            $.ajax({
                url: "/modFloodQc/runAreaReverseCheck.do",
                method: "POST",
                contentType: "application/json",
                data: JSON.stringify(validDataIds),
                success: function(startRes) {
                    if (startRes.success) {
                        alert("면적 역전 검수가 시작되었습니다. group_no: " + startRes.group_no);
                        
                        selectCheckList();
                        
                        if (monitorInterval) clearInterval(monitorInterval);
                        
                        monitorInterval = setInterval(selectCheckList, 3000);
                        
                        
                    } else {
                        alert("검수 시작 실패: " + startRes.message);
                    }
                },
                error: function(err) {
                    alert("runAreaReverseCheck 요청 실패");
                    console.error(err);
                }
            });
        },
        error: function(err) {
            alert("checkShpCodeValid 요청 오류");
            console.error(err);
        }
    });
    
}

function selectCheckList() {
    $.ajax({
        url: "/modFloodQc/statusMonitoring.do",
        method: "GET",
        data: { 'group_no': null },
        success: function(data) {
            var html = "";
            var allCompleted = true; // 전체 완료 여부 확인용

            for (var i = 0; i < data.length; i++) {
                var d = data[i];
                var data_id = d.data_id;
                var inspector = "관리자";
                var inspect_dt = d.start_time.match(/^\d{4}-\d{2}-\d{2}/)[0];
                var status_msg = d.status_msg;

                var status = "";
                var detailIcon = "";

                if (status_msg.includes("대기")) {
                    status = "대기중";
                    allCompleted = false;
                } else if (status_msg.includes("진행")) {
                    status = "진행중";
                    allCompleted = false;
                } else if (status_msg.includes("완료")) {
                    status = "완료";
                    detailIcon = "<img src='/images/icon_search.png' alt='상세보기' style='cursor:pointer; margin-left:8px; width:18px; height:18px;' onclick=\"viewDetail('" + data_id + "')\" />";
                } else {
                    status = "알수없음";
                    allCompleted = false;
                }

                html += "<tr><td>" + (data.length - i) + "</td><td>" + data_id + "</td><td>" + inspector + "</td><td>" + inspect_dt + "</td><td>" + status + "</td><td>" + detailIcon + "</td></tr>";
            }

            $('#monitorTbody').html(html);

            if ($('#monitorTable').css('display') === 'none') {
                $('#monitorTable').show();
            }

            if (allCompleted && monitorInterval) {
                clearInterval(monitorInterval);
                monitorInterval = null;
                console.log("모든 검수가 완료되어 호출 중지");
            }
        }
    });
}

async function handleAreaReversedCheck() {
    var dataList = [];
    var files = $('#folderPicker')[0].files;
    
    if (!files || files.length === 0) {
        alert("경로를 먼저 불러와 주세요.");
        return;
    }
    
    var checkedExts = Array.from($('#treeView input[type="checkbox"]:checked'))
	    .map(el => el.getAttribute('data-path').split('.').pop().toLowerCase());
	
	var requiredExts = ['shp', 'dbf', 'shx'];
	var missing = requiredExts.filter(ext => !checkedExts.includes(ext));
	if (missing.length > 0) {
	    alert("검수진행시 확장자(.shp, .dbf, .shx) 파일을 모두 선택해 주세요.");
	    return;
	}
    
    for (var file of files) {
        if (!file.name.endsWith('.dbf')) continue;

        var shpFileName = file.name.replace('.dbf', '');
        var checked = $('#treeView input[type="checkbox"][data-path$="' + shpFileName + '.shp"]:checked');

        if (checked.length === 0) continue;

        try {
            var buffer = await file.arrayBuffer();
            var records = parseDbf(buffer);
            var record = records[0] || {};

            var freq = record["FLDLV_FREQ"];

            if (record["SGG_CD"] && freq) {
                dataList.push({ type: "SGG", data_id: shpFileName, code: record["SGG_CD"], freq: freq });
            } else if (record["SAREA_CD"] && freq) {
                dataList.push({ type: "SAREA", data_id: shpFileName, code: record["SAREA_CD"], freq: freq });
            } else if (record["SBSN_CD"] && freq) {
                dataList.push({ type: "SBSN", data_id: shpFileName, code: record["SBSN_CD"], freq: freq });
            } else if (freq) {
                dataList.push({ type: "ALL", data_id: shpFileName, freq: freq });
            } else {
                dataList.push({ type: "ERROR", data_id: shpFileName, freq: "ERROR" });
            }
        } catch (e) {
            dataList.push({
                type: "ERROR",
                fileName: shpFileName,
                freq: "ERROR"
            });
        }
    }

    areaReversedCheck(dataList);
}

$(function () {
    $('#btnSelectFolder').on('click', function () {
        $('#folderPicker').click();
    });

    $('#folderPicker').on('change', function (e) {
        var files = Array.from(e.target.files).filter(file => {
            const ext = file.name.split('.').pop().toLowerCase();
            return ['shp', 'shx', 'dbf'].includes(ext);
        });
        
        if (files.length === 0) return;
        
        $('#monitorTable').hide(); 
        $('#monitorTbody').empty();

        var rootFolder = files[0].webkitRelativePath.split('/')[0];
        var treeData = {}; treeData[rootFolder] = {};

        for (var i = 0; i < files.length; i++) {
            var parts = files[i].webkitRelativePath.split('/'); parts.shift();
            var current = treeData[rootFolder];

            for (var j = 0; j < parts.length; j++) {
                var part = parts[j];
                current[part] = current[part] || (j === parts.length - 1 ? null : {});
                current = current[part];
            }
        }

        $('#treeView').empty();
        renderTree($('#treeView'), treeData, '', true);
    });

    $('#areaReversedCheck').on('click', async function () {
    	handleAreaReversedCheck();
    });
    
    
});


</script>

<input type="file" id="folderPicker" webkitdirectory directory multiple style="display: none;" />
<button id="btnSelectFolder">경로 불러오기</button>

<div id="treeBox">
    <div id="treeView"></div>
</div>
<button id="areaReversedCheck" style="margin-top: 10px;">면적 역전 검수</button>
<div>
	<table id="monitorTable" style="display: none; margin-top: 20px; border-collapse: collapse;" border="1">
	  <thead>
	    <tr>
	      <th>번호</th>
	      <th>검수명</th>
	      <th>검수자</th>
	      <th>검수일자</th>
	      <th>결과</th>
	      <th>상세</th>
	    </tr>
	  </thead>
	  <tbody id="monitorTbody">
	    
	  </tbody>
	</table>
</div>

<jsp:include page="../include/include_footer.jsp" />

