<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
<style>
#jsonView {border: 1px solid #ccc; background-color: #fff; padding: 10px; white-space: pre; overflow-x: auto;}
</style>
<script src="/js/plugin/jquery/jquery-1.12.4.min.js"></script>
</head>

<script>
var intervalId = null;
var groupNo = ${groupNo};

function fetchMonitoringStatus() {
	var url = "/modFloodQc/statusMonitoring.do";

	if (!isNaN(groupNo) && groupNo > 0) {
        url += "?group_no=" + groupNo;
    }
	
    $.ajax({
        url: url,
        method: "GET",
        dataType: "json",
        success: function(data) {
            var jsonData = JSON.stringify(data, null, 2); 
            $("#jsonView").text(jsonData); 
            
            var allComplete = data.every(item => item.complete_yn === 'y');

            if (allComplete && intervalId) {
                clearInterval(intervalId);
                intervalId = null;
            }
        },
        error: function() {
            $("#jsonView").text("데이터 로딩 실패");
        }
    });
}

function controlProc(action) {
	$.ajax({
	    url: "/modFloodQc/controlProc.do",
	    type: "POST",
	    contentType: "application/json",
	    data: JSON.stringify({ group_no: groupNo, action: action }),
	    success: function(res) {
	        
	    },
	    error: function(err) {
	        console.error("에러:", err);
	    }
	});
}

$(function () {

	fetchMonitoringStatus(); 
    intervalId = setInterval(fetchMonitoringStatus, 3000); 
	
});


</script>
<body>
	<div id="jsonView">로딩 중...</div>
	<div style="margin: 10px 1200; margin-top: 10px">
    <button onclick="controlProc('stop')">중지</button>
    <button onclick="controlProc('start')">재시작</button>
	</div>
</body>
</html>
