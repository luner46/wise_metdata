<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../include/include_header.jsp" />

<style>
.selector-group {display: flex; align-items: center; gap: 10px;}
</style>

<script>

var activeDate = []; 

function selectCalenderActiveDate(dt) {
	
    var agency = $('#agencySelect').val();
    var dataType = $('#dataTypeSelect').val();

    $.ajax({
        url: "/modRnCalendar/selectCalenderActiveDate.do",
        data: {
            agency: agency,
            dataType: dataType,
            dt: dt
        },
        success: function(data) {
        	activeDates = data.list;
            $(".datepicker").datepicker("refresh"); 
            
        }
    });
}

function getToday(){
    var date = new Date();
    var year = date.getFullYear();
    var month = ("0" + (1 + date.getMonth())).slice(-2);
    var day = ("0" + date.getDate()).slice(-2);

    return year + "-" + month + "-" + day;
}

$(document).ready(function() {
    $('#agencySelect').on('change', function() {
        var agencyVal = $(this).val();
        var dataTypeSelect = $('#dataTypeSelect');
        dataTypeSelect.empty(); 

        if (agencyVal == 0) { 
            dataTypeSelect.append('<option value="0">강우</option>');
        } else if (agencyVal == 1) { 
            dataTypeSelect.append('<option value="0">강우</option>');
        }
    });

    $('#agencySelect').trigger('change');
    updateYearRangeByAgency();
});

function updateYearRangeByAgency() {
    var agency = $('#agencySelect').val();
    var nowYear = new Date().getFullYear();
    var startYear = agency == 1 ? 2001 : 1997;
    var range = startYear + ":" + nowYear;

    $(".datepicker").datepicker("option", "yearRange", range);
}

$(function() {
	var container = document.getElementById('popup');
	var content = document.getElementById('popup-content');
	var overlay = new ol.Overlay(({element: container}));
	
	base_layer = [satellite, hybrid, midnight, base];
	
	map = new ol.Map({
   		logo: false,
   		target: 'map_wrap',
   		overlays : [overlay],
   		layers: base_layer,
		view: view
   	});
	
	<!-- layer select -->
	$('#select_map_type option:eq(1)').attr("selected", "selected");
   	
   	$.each(base_layer, function(idx, layer) {
		layer.set('visible', false);
	});
	
	$.each(base_layer, function(idx, layer) {
		if(layer.get('name') === 'satellite') layer.set('visible', true);
		if(layer.get('name') === 'hybrid') layer.set('visible', true);
	});
	<!-- /layer select -->
	
	var issue_date = getToday();
	
	$('.datepicker').val(issue_date);
	
	$(".datepicker").datepicker({
		showOn: "both",
        buttonImageOnly: true,
        buttonImage: "/img/img_datepicker.png",
        dateFormat: 'yy-mm-dd',
        yearRange: "1997:2025",
        maxDate: "+0D",
        showButtonPanel: false,
        closeText: "닫기",
        currentText: "오늘날짜",
        nextText: "다음",
        prevText: "이전",
        changeYear: true,
        changeMonth: true,
        showMonthAfterYear: true,
        monthNames: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        monthNamesShort: ["1월", "2월", "3월", "4월", "5월", "6월", "7월", "8월", "9월", "10월", "11월", "12월"],
        dayNames: ["일", "월", "화", "수", "목", "금", "토"],
        dayNamesShort: ["일", "월", "화", "수", "목", "금", "토"],
        dayNamesMin: ["일", "월", "화", "수", "목", "금", "토"],

        beforeShow: function(input, inst) {
            var raw = $(input).val();  
            var year = raw.substring(0, 4);
            var month = raw.substring(5, 7);
            var dt = year + month;

            var hasMonthData = activeDates.some(d => d.yyyymmdd.startsWith(dt));
            if (!hasMonthData) selectCalenderActiveDate(dt);
        },
        onChangeMonthYear: function(year, month, inst) {
            var dt = year.toString() + ("0" + month).slice(-2);
            selectCalenderActiveDate(dt);
        },
        onSelect: function(dateText, inst) {
            var selected = $('.datepicker').val();
            $('.datepicker').val(selected); 
        },
        beforeShowDay: function(date) {
            var ymd = $.datepicker.formatDate('yymmdd', date);
            var found = activeDates.find(d => d.yyyymmdd == ymd && d.rn_flag == 1);
            return [!!found];
        }
    });
	
	var dt = $('.datepicker').val().substr(0,4) + $('.datepicker').val().substr(5,2);
	
	selectCalenderActiveDate(dt);
	
	$('#agencySelect').on('change', function() {
		selectCalenderActiveDate(dt);
		updateYearRangeByAgency();
	});
	
	$('#dataTypeSelect').on('change', function() {
		selectCalenderActiveDate(dt);
	});
	
});



</script>

<div class="map_wrap" id="map_wrap">
  <div style="position: absolute; top: 130px; width:540px; left: 30px; z-index: 1000; background: white; border: 1px solid #ccc; padding: 10px; border-radius: 4px;">

    <!-- 셀렉트 박스 그룹 -->
    <div id="locationSelectors">
      
      <!-- 행정구역 -->
      <div class="selector-group">
		  <div class="form-item">
		    <span>관할기관:</span>
		    <select id="agencySelect">
		      <option value="0">기상청</option>
		      <option value="1">환경부</option>
		    </select>
		  </div>
		  <div class="form-item">
		    <span>자료타입:</span>
		    <select id="dataTypeSelect">
		      
		    </select>
		  </div>
		  <div class="time_con">
                <div class="title">기준시간:</div>
                <div class="con flex_col">
                    <div class="item calendar">
                        <input type="text" class="date datepicker" id="select_dt" readonly>
                    </div>
                </div>
            </div>
		</div>


    </div>
  </div>
</div>