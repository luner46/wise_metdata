<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta name="viewport" content="widivh=device-widivh, initial-scale=1.0">
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta name="format-detection" content="telephone=no" />
<title>GIS 관측소 강우 표출 모듈</title>
<script type="text/javascript" src="/js/plugin/ol_4/ol.js"></script>
<script type="text/javascript" src="/js/plugin/ol_3/proj4.js"></script>
<script type="text/javascript" src="/js/plugin/jquery/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src="/js/plugin/highcharts/highcharts.js"></script>
<script type="text/javascript" src="/js/plugin/jquery/jquery.bxslider.min.js"></script>
<script type="text/javascript" src="/js/plugin/jquery/jquery-ui.min.js"></script>
<script type="text/javascript" src="/js/component/common_gis.js"></script>
<script type="text/javascript" src="/js/component/common_kml.js"></script>
<link rel="stylesheet" type="text/css" href="/js/plugin/ol_4/ol.css" />
<link rel="stylesheet" type="text/css" href="/css/jquery-ui.min.css" />
<script>
function selectHourProc() {
    $('#hourly').empty();
    
    var issue_date = $('.issueDt').val();
    var datepicker_date = $('.datepicker').val();
    var issue_dt = issue_date.substr(0,8);
    
    if (typeof(datepicker_date) == 'undefined' ) {
        datepicker_date = issue_date;
    }
    
    var date_dt = datepicker_date.substr(0,4) + datepicker_date.substr(5,2) + datepicker_date.substr(8,2);
    var currentHour = 23;

	for (var i = 0; i <= currentHour; i++) {
        var option = document.createElement('option');
        option.value = i < 10 ? '0' + i : i;
        option.text = i < 10 ? '0' + i : i ;
        $('#hourly').append(option);
    }

    $('#hourly').val('00');
}   

// 10min 자료가 필요할 때 사용
/* function selectMinuteProc() {
    $('#minute').empty();

    var issue_date = $('.issueDt').val();
    var datepicker_date = $('.datepicker').val();
    var issue_dt = issue_date.substr(0, 8);
    
    if (typeof(datepicker_date) == 'undefined' ) {
        datepicker_date = issue_date;
    }
    
    var date_dt = datepicker_date.substr(0, 4) + datepicker_date.substr(5, 2) + datepicker_date.substr(8, 2);
    
    var issue_hour = parseInt(issue_date.substr(8, 2)); 
    var selected_hour = parseInt($('#hourly').val()); 
    
    var allowedMinutes = ['00', '10', '20', '30', '40', '50'];
    
    for (var i = 0; i < allowedMinutes.length; i++) {
        var option = document.createElement('option');
        option.value = allowedMinutes[i];
        option.text = allowedMinutes[i];
        $('#minute').append(option);
    }

	$('#minute').val('00');
} */

function selectMeRn1hr(){
	let issueDt = $('.issueDt').val();
	let endObsCheck = $('.endObsCheck').val();

	$.ajax({
		url: '/modStnRn/selectMeRn1hr.do',
		data: {issueDt: issueDt, endObsCheck: endObsCheck},
		success: function(data){
			var tblCont = "";
			var feature = "";
			
			for(var i = 0; i < data.length; i++){
				var initDt = data[i]["initDt"];
				var rfobscd = data[i]["rfobscd"];
				var obsnm = data[i]["obsnm"] || '-';
				var lat = data[i]["lat"] || '-';
				var lon = data[i]["lon"] || '-';
				var rnmm = data[i]["rnmm"];
				var flag = data[i]["flag"] || '-';
				var flagNm = data[i]["flagNm"];

				if (flag == '2'){endRnObsList.push(rfobscd);}
				
				feature = me_rn_stn_info_layer.getSource().getFeatureById(rfobscd);

				if (feature) {feature.set('val', rnmm);}
				
				tblCont += '<tr class="rfobscd_' + rfobscd + '" data-rfobscd="' + rfobscd + '" data-lat="' + lat + '" data-lon="' + lon + '"><td>' + rfobscd + '</td><td>' + obsnm + '</td><td>' + lat + '</td><td>' + lon + '</td><td>' + rnmm + '</td></tr>'
			}
			
			if (tblCont.length == 0) {
				$('.tbl_rn_stn_info tbody').html('<tr><td colspan=5>조건에 맞는 검색 결과가 없습니다.</td></tr>');
			} else {
				$('.tbl_rn_stn_info tbody').html(tblCont);
			}

			// 위에 추가된 rfobscd와 flag 값으로 각 feature에 스타일 적용
			// setMarkerStyleAsRnmm 변수 : 해당 레이어명
			setMarkerStyleAsRnmm(me_rn_stn_info_layer);
		}
	})
}

// 년월일 Datepicker 생성
function createDatepicker(){
	// 관할기관
	var agcType = $('.agcType').val();
	// 관측소 타입
	var stnType = $('.stnType').val();
	// 일자
	var issueDt = $('.issueDt').val();
	var maxDate = new Date(2024, 11, 31);

	$(".datepicker").datepicker({
	    firstDay: 1,
	    showOtherMonths: true,
	    changeMonth: false,
	    changeYear: false,
	    dateFormat: "yy.mm.dd",
	    minDate: new Date(2024, 0, 1),
	    maxDate: maxDate,
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토']
	});
	
	$(".datepicker").datepicker('setDate', new Date(2024, 0, 1));
	
	$(".datepicker").on("change", function() {
		
	    $(".issueDt").val($(this).val().replace(/\./g, ""));
	    
	    if ($('.stnType').val() == 'aws') {
	    	selectKmaAws1hr();
	    } else if ($('.stnType').val() == 'asos') {
	    	selectKmaAsos1hr();
	    }  else if ($('.stnType').val() == 'rnStn') {
	    	selectMeRn1hr();
	    }
	});
	
	$(document).on("mousedown", ".date", function () {
	    $(".ui-datepicker").addClass("active");
	});
	
	$(document).on("click", ".btn_state", function () {
	    $(this).toggleClass("active");
	});
	
	selectHourProc();
}

$(function(){
	var currentPage = window.location.pathname;
		$('header ul li').removeClass('active');
	if (currentPage == '/modStnInfo/modStnInfo.do') {$('header ul #modStnInfoBtn').addClass('active');} else if (currentPage == '/modStnRn/modStnRn.do') {$('header ul #modStnRnBtn').addClass('active');}
	
	map = new ol.Map({
		logo: false,
		target: 'map_wrap',
		layers: [satellite],
		view: new ol.View({
			projection: ol.proj.get('EPSG:5181'),
			center: ol.proj.fromLonLat([127.5550, 36.3525, 54309]),
			zoom: 8,
			minZoom: 7
		}),
		controls: ol.control.defaults({
		    zoom: false
		})
	});
	
	map.removeLayer(floodmap_adm_emd_layer);
	map.removeLayer(floodmap_adm_sido_layer);
	map.removeLayer(floodmap_adm_sgg_layer);

	map.removeLayer(me_rn_stn_info_layer);
	
	// 레이어의 각 관측소마다 관특소 코드 기반의 아이디 부여
	me_rn_stn_info_layer.getSource().on('addfeature', function (e) {
		var rfobscd = e.feature.get('rfobscd');
		if (rfobscd) e.feature.setId(rfobscd);
	});
	
	// 레이어 로딩 시, 레이어 포인트에 스타일 부여
	me_rn_stn_info_layer.getSource().once('change', function(e) {
	    if (this.getState() == 'ready') {
	    	setMarkerStyleAsRnmm(me_rn_stn_info_layer);
	    }
	});
	
	// 테이블에서 관측소 클릭 시, 레이어 포인트에 스타일 부여
	tblRowClckCntrl(me_rn_stn_info_layer, 'tbl_rn_stn_info', 'rfobscd');

	// 레이어 포인트 클릭 시, 테이블에 스타일 부여
	map.on('singleclick', function (evt) {
		map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
			if (layer == me_rn_stn_info_layer) {
			    lyrClckCntrl(feature, me_rn_stn_info_layer, 'tbl_rn_stn_info', 'rfobscd');
			}
		});
	});
	
	map.on('pointermove', function (evt) {
		let featureYn = false;
		
		map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
			const issueDt = $('.issueDt').val();
			const prevIssueDt = new Date(parseInt(issueDt.substr(0,4), 10), parseInt(issueDt.substr(4, 2), 10) - 1, parseInt(issueDt.substr(6,2), 10));
			prevIssueDt.setDate(prevIssueDt.getDate() - 1);
			
			const targetLayers = [me_rn_stn_info_layer, me_wl_stn_info_layer, me_dam_info_layer];

		    if (!targetLayers.includes(layer)) return false;
			
			let popupHtml = '';

			if (layer == me_rn_stn_info_layer) {
				const rfobscd = feature.get("rfobscd");
				const obsnm = feature.get("obsnm");
				const agcnm = feature.get("agcnm");
				const addr = feature.get("addr");
				const etcaddr = feature.get("etcaddr");
				const rnmm = feature.get("val");

				popupHtml = '<div><p>관측소 번호 : ' + rfobscd + '</p><p>관측소 명 : ' + obsnm + '</p><p>관할기관 명 : ' + agcnm + '</p><p>주소 : ' + addr + '</p><p>상세 주소 : ' + etcaddr + '</p><p>강우량 : ' + rnmm + ' mm</p></div>';
			}
			
			$('.popup_con').html(popupHtml);
			$('.popup_con').css({display: 'block', left: evt.originalEvent.pageX + 10 + 'px', top: evt.originalEvent.pageY + 10 + 'px'});

			map.getTargetElement().style.cursor = 'pointer';
			featureYn = true;
			
			return true;
		});
		
		if (!featureYn) {
			$('.popup_con').hide();
			map.getTargetElement().style.cursor = '';
		}
	});

	$(document).on('change', '.search_wrap .agcnmList', function(){
		$('.agcType').val($(this).val());
		
		map.removeLayer(me_rn_stn_info_layer);
		
		$('.tbl_aws_stn_info, .tbl_asos_stn_info, .tbl_rn_stn_info').css('display', 'none');
		
		if ($(this).val() == 'me') {
			$('.fileTypeList').empty();
			$('.fileTypeList').html('<option value="rnStn">강우 관측소</option>');
			
			$('.stnType').val("rnStn");

			selectMeRn1hr();
			
			$('.tbl_rn_stn_info').css('display', 'table');
			
			map.addLayer(me_rn_stn_info_layer);
		}
	});
	
	$(document).on('change','.search_wrap .fileTypeList', function(){
		$('.stnType').val($(this).val());
		
		const agcType = $('.agcType').val();
		const stnType = $('.stnType').val();
		
		map.removeLayer(me_rn_stn_info_layer);

		$('.tbl_rn_stn_info').css('display', 'none');
		
		if (agcType == 'me') {
			if (stnType == 'rnStn') {
				selectMeRn1hr();
				
				$('.tbl_rn_stn_info').css('display', 'table');
				
				map.addLayer(me_rn_stn_info_layer);
			}
		}
	});

	$(document).on('change', '.search_wrap .endObsCheckBox', function(){
		$('.endObsCheck').val($(this).is(':checked'));
		
		if ($('.stnType').val() == 'rnStn') {
	    	selectMeRn1hr();
	    }
	});
	
	$(document).on('change', '#hourly', function(){
		selected_hour = $('#hourly').val();
		selected_min = $('#minute').val();
		
		$('.issueDt').val($('.issueDt').val().slice(0, 8) + $('.hourly').val());
		selectMeRn1hr();
	});

	if ($('.agcType').val() == 'me') {
		$('.fileTypeList').empty();
		$('.fileTypeList').html('<option value="rnStn">강우 관측소</option>');
	}

	map.addLayer(floodmap_adm_emd_layer);
	map.addLayer(floodmap_adm_sido_layer);
	map.addLayer(floodmap_adm_sgg_layer);
	
	// 초기 함수 실행
	map.addLayer(me_rn_stn_info_layer);
	
	selectMeRn1hr();
	createDatepicker();
});
</script>
<style>
*{margin:0;padding:0;font:inherit;color:inherit; font-family: 'pretendard';}
*, :after, :before {box-sizing:border-box;flex-shrink:0;}
:root {-webkit-tap-highlight-color:transparent;-webkit-text-size-adjust:100%;text-size-adjust:100%;cursor:default;line-height:1.5;overflow-wrap:break-word;-moz-tab-size:4;tab-size:4}
html, body {height:100%; min-height: 860px; width: 100%; min-width: 1920px; font-size: 16px; background-color: #222222; color: #fff; overflow: hidden;}
button {background:none;border:0;cursor:pointer;}
a {text-decoration:none}
table {border-collapse:collapse; border-spacing:0}
ul { list-style: none;}
img {display: block;}

t_left {text-align: left;}
t_center {text-align: center;}
border_r {border-right: 1px solid #000000;}

font_gray {color: #888888;}

header ul {display: flex; gap: 50px; justify-content: center; height: 5%; padding: 5px 0;}
header ul li .changeMod.active {background-color: #004BFC; color: #FFFFFF;}
header .changeMod {cursor: pointer; padding: 5px 10px; color: #000000; border-radius: 10px;}

.container {width: 100%; height: 95%; display: flex;}
.container #map_wrap {flex: 5.5;}
.container .con_wrap {flex: 4.5; display: block; overflow: auto;}
.container .con_wrap .tbl_wrap table {width: 100%;}
.container .con_wrap .tbl_wrap .tbl_right tbody {height: 100%;}
.container .con_wrap .tbl_wrap .tbl_right thead th {background: #222222; border-right: 1px solid #464646; padding: 6px 6px; position: sticky; top: 68px; z-index: 1; color: #FFFFFF;}
.container .con_wrap .tbl_wrap .tbl_right tbody tr {cursor: pointer; background: #F9F9F9;}
.container .con_wrap .tbl_wrap .tbl_right tbody tr:hover {background: #FFD966;}
.container .con_wrap .tbl_wrap .tbl_right tbody tr:hover td {color: #000000;}
.container .con_wrap .tbl_wrap .tbl_right tbody td {border-right: 1px solid #464646; border-bottom: 1px solid #464646;padding: 6px 6px; color: #000000; font-size: .9em; text-align: center;}
.container .con_wrap .tbl_wrap .tbl_right thead th:last-child, .cnt_wrap .tbl-wrap table tbody td:last-child {border-right: none;}
.container .con_wrap .tbl_wrap .tbl_right tbody tr:last-child td {border-bottom: 0;}
.container .con_wrap .tbl_wrap .tbl_right tbody td a {transition: all .2s ease-in-out;}
.container .con_wrap .tbl_wrap .tbl_right tbody td a:hover{color: #FFFFFF;}
.container .con_wrap .tbl_wrap .tbl_right tbody td strong {color: #FFFFFF; font-weight: 600;}
.container .con_wrap .tbl_wrap .tbl_right tbody .active {background-color: #FFD966;}
.container .con_wrap .tbl_wrap .tbl_right tbody .active td {color: #000000;}

.container .con_wrap .tbl_search_wrap {display: flex; flex-direction: column; gap: 0 8px; justify-content: space-between; margin: 0; background-color: #222222; padding: 16px; position: sticky; z-index: 1; top: 0;}
.container .con_wrap .tbl_search_wrap li {flex: 1 1 auto; position: relative; text-align: left;}
.container .con_wrap .tbl_search_wrap li > span {display: block; font-size: 14px; margin-bottom: 6px; color: #0045CC; font-weight: 600;}
.container .con_wrap .tbl_search_wrap li > div {position: relative;}
.container .con_wrap .tbl_search_wrap li > div input {width: 100%; height: 32px; padding: 0 8px; line-height: 30px; font-weight: 400; border: 1px solid #C9E1FD; border-radius: 3px; box-sizing: border-box; color: #4683C9; font-size: 15px; }
.container .con_wrap .tbl_search_wrap .search_wrap {color: #000000; display: flex; margin: 2px 0; padding: 0; display: block; min-height: 1%; display: flex; justify-content: center; gap: 30px;}
.container .con_wrap .tbl_search_wrap .search_wrap:after {content: " "; height: 0; display: block; visibility: hidden; clear: both;}
.container .con_wrap .tbl_search_wrap .search_wrap .title {font-weight: 500; color: #FFFFFF; font-size: 16px; float: left; width: 65px; line-height: 30px; white-space: nowrap;}
.container .con_wrap .tbl_search_wrap .search_wrap .con {float: left; width: calc(100% - 90px);}
.container .con_wrap .tbl_search_wrap .search_wrap .con .item {flex-shrink: 1; width: 50px;}
.container .con_wrap .tbl_search_wrap .search_wrap .time_wrap {display: flex;}
.container .con_wrap .tbl_search_wrap .search_wrap .endObsCheckBox {margin: 0 20px;}
.calendar {flex-grow: 1; position: relative; border: 0;}
.calendar .ui-datepicker-trigger {position: absolute; right: 12px; top: 6px; width: 16px;}
.calendar .datepicker {width: 110px; cursor: pointer; background-color: #fff; border-radius: 3px; height: 32px; line-height: 30px; box-sizing: border-box; text-indent: 12px; border: 1px solid #000000;}
.hourly {height: 32px; line-height: 30px; font-weight: 400; border-radius: 3px; padding: 0 20px 0 8px; box-sizing: border-box; color: #121212; font-size: 15px; background: url(../images/img_select.png) calc(100% - 8px) 50% no-repeat #fff; -webkit-appearance: none; -moz-appearance: none; border: 1px solid #000000;}
.minute {height: 32px; line-height: 30px; font-weight: 400; border-radius: 3px; padding: 0 20px 0 8px; box-sizing: border-box; color: #121212; font-size: 15px; background: url(../images/img_select.png) calc(100% - 8px) 50% no-repeat #fff; -webkit-appearance: none; -moz-appearance: none; border: 1px solid #000000;}

.popup_con {position: absolute; background-color: #FFFFFF; color: #000000; padding: 5px; border: 1px solid #000000; border-radius: 4px; z-index: 999;}

.legend_wrap {position: fixed; top: 80px; right: 900px; background-color: rgba(255,255,255,.8); text-align: right; padding: 10px 6px; border-radius: 4px; z-index: 2;}
.legend_wrap p {font-size: 11px; font-weight: 700; display: block; margin: 0 0 6px; text-align: center; color: #000000;}
.legend_wrap .legend {text-align: left;}
.legend_wrap .legend li {font-size: 11px; color: #444; line-height: 1; font-weight: 400; margin: 0 0 6px; padding: 0;}
.legend_wrap .legend li:last-child { margin: 0; }
.legend_wrap .legend li span {display: inline-block; margin: -2px 4px 0 0; width: 16px; height: 10px; border: 1px solid rgba(0,0,0, .25); vertical-align: middle; border-radius: 2px;}
.legend_wrap .legend li:nth-child(1) span {background-color: #000000;}
.legend_wrap .legend li:nth-child(2) span {background-color: #bf0000;}
.legend_wrap .legend li:nth-child(3) span {background-color: #d50000;}
.legend_wrap .legend li:nth-child(4) span {background-color: #ee0b0b;}
.legend_wrap .legend li:nth-child(5) span {background-color: #f63e3e;}
.legend_wrap .legend li:nth-child(6) span {background-color: #fa8585;}
.legend_wrap .legend li:nth-child(7) span {background-color: #7f00bf;}
.legend_wrap .legend li:nth-child(8) span {background-color: #9200e4;}
.legend_wrap .legend li:nth-child(9) span {background-color: #ad07ff;}
.legend_wrap .legend li:nth-child(10) span {background-color: #c23eff;}
.legend_wrap .legend li:nth-child(11) span {background-color: #e0a9ff;}
.legend_wrap .legend li:nth-child(12) span {background-color: #000390;}
.legend_wrap .legend li:nth-child(13) span {background-color: #1f219d;}
.legend_wrap .legend li:nth-child(14) span {background-color: #4c4eb1;}
.legend_wrap .legend li:nth-child(15) span {background-color: #8081c7;}
.legend_wrap .legend li:nth-child(16) span {background-color: #b3b4de;}
.legend_wrap .legend li:nth-child(17) span {background-color: #0077b3;}
.legend_wrap .legend li:nth-child(18) span {background-color: #008dde;}
.legend_wrap .legend li:nth-child(19) span {background-color: #07abff;}
.legend_wrap .legend li:nth-child(20) span {background-color: #3ec1ff;}
.legend_wrap .legend li:nth-child(21) span {background-color: #87d9ff;}
.legend_wrap .legend li:nth-child(22) span {background-color: #008000;}
.legend_wrap .legend li:nth-child(23) span {background-color: #00a400;}
.legend_wrap .legend li:nth-child(24) span {background-color: #00d500;}
.legend_wrap .legend li:nth-child(25) span {background-color: #1ef31e;}
.legend_wrap .legend li:nth-child(26) span {background-color: #69fc69;}
.legend_wrap .legend li:nth-child(27) span {background-color: #ccaa00;}
.legend_wrap .legend li:nth-child(28) span {background-color: #e0b900;}
.legend_wrap .legend li:nth-child(29) span {background-color: #f9cd00;}
.legend_wrap .legend li:nth-child(30) span {background-color: #ffdc1f;}
.legend_wrap .legend li:nth-child(31) span {background-color: #ffea6e;}
.legend_wrap .legend li:nth-child(32) span {background-color: #ffffff;}

.legend_wrap_2 {position: fixed; top: 80px; right: 900px; background-color: rgba(255,255,255,.8); text-align: right; padding: 10px 6px; border-radius: 4px; z-index: 2;}
.legend_wrap_2 p {font-size: 11px; font-weight: 700; display: block; margin: 0 0 6px; text-align: center; color: #000000;}
.legend_wrap_2 .legend {text-align: left;}
.legend_wrap_2 .legend li {font-size: 11px; color: #444; line-height: 1; font-weight: 400; margin: 0 0 6px; padding: 0;}
.legend_wrap_2 .legend li:last-child { margin: 0; }
.legend_wrap_2 .legend li span {display: inline-block; margin: -2px 4px 0 0; width: 16px; height: 10px; border: 1px solid rgba(0,0,0, .25); vertical-align: middle; border-radius: 2px;}
.legend_wrap_2 .legend li:nth-child(1) span {background-color: #50C878;}
.legend_wrap_2 .legend li:nth-child(2) span {background-color: #FFD700;}
.legend_wrap_2 .legend li:nth-child(3) span {background-color: #E65100;}
.legend_wrap_2 .legend li:nth-child(4) span {background-color: #B40426;}

.legend_wrap_3 {position: fixed; top: 80px; right: 900px; background-color: rgba(255,255,255,.8); text-align: right; padding: 10px 6px; border-radius: 4px; z-index: 2;}
.legend_wrap_3 p {font-size: 11px; font-weight: 700; display: block; margin: 0 0 6px; text-align: center; color: #000000;}
.legend_wrap_3 .legend {text-align: left;}
.legend_wrap_3 .legend li {font-size: 11px; color: #444; line-height: 1; font-weight: 400; margin: 0 0 6px; padding: 0;}
.legend_wrap_3 .legend li:last-child { margin: 0; }
.legend_wrap_3 .legend li span {display: inline-block; margin: -2px 4px 0 0; width: 16px; height: 10px; border: 1px solid rgba(0,0,0, .25); vertical-align: middle; border-radius: 2px;}
.legend_wrap_3 .legend li:nth-child(1) span {background-color: #50C878;}
.legend_wrap_3 .legend li:nth-child(2) span {background-color: #FFD700;}
.legend_wrap_3 .legend li:nth-child(3) span {background-color: #B40426;}

.ui-datepicker {width: 200px; padding: 5px; background: #222222; border-radius: 4px; box-shadow: 0 4px 40px -8px rgba(0, 0, 0, 1); opacity: 0;}
@media screen and (max-width: 580px) {
.ui-datepicker {top: auto !important; right: 0 !important; bottom: 0 !important; left: 0 !important; width: 100%; border-radius: 0px;}
}
.ui-datepicker.active {opacity: 1;}
.ui-datepicker-header {height: 32px; padding: 3px;}
.ui-datepicker-header .ui-datepicker-title {text-align: center; line-height: 1.2;}
.ui-datepicker-month, .ui-datepicker-year {-webkit-appearance: none; border: 0; background: none; outline: none; font-size: 14px; font-weight: 600; color: white; margin: 0 1px;}
.ui-datepicker .ui-datepicker-prev, .ui-datepicker .ui-datepicker-next {top: 0;}
.ui-datepicker-prev, .ui-datepicker-next {position: relative; display: inline-block; width: 34px; height: 34px; cursor: pointer; text-indent: 9999px; overflow: hidden; border-radius: 3px;}
.ui-datepicker-prev:hover, .ui-datepicker-next:hover {background: #444B56;}
.ui-datepicker-prev {float: left;}
.ui-datepicker-prev:after {transform: rotate(45deg);margin-left: 15px;}
.ui-datepicker-next {float: right;}
.ui-datepicker-next:after {transform: rotate(-135deg); margin-left: 13px;}
.ui-datepicker-prev:after, .ui-datepicker-next:after {content: ""; position: absolute; display: block; margin-top: 12px; width: 6px; height: 6px; border-left: 2px solid #C2C7D1; border-bottom: 2px solid #C2C7D1; pointer-events: none;}
.ui-datepicker-calendar {width: 100%; text-align: center;}
.ui-datepicker-calendar thead tr th {width: 40px; padding-bottom: 6px;}
.ui-datepicker-calendar thead tr th span {display: block; width: 100%; padding: 0; color: #8D9298; font-size: 10px; font-weight: 700; text-transform: uppercase; text-align: center;}
.ui-datepicker-calendar tbody tr td {padding-right: 3px; padding-bottom: 3px;}
.ui-datepicker-calendar tbody tr td:first-child {padding-left: 3px;}
.ui-state-default {display: block; text-decoration: none; color: white !important; border-radius: 3px; font-size: .8em;}
.ui-state-default:hover {background: #444B54 !important; text-decoration: none; color: white !important;}
.ui-state-highlight {color: var(--color-blue);}
.ui-state-active:not(.ui-state-highlight) {color: white; background: var(--color-blue);}
.ui-datepicker-unselectable .ui-state-default {color: rgba(255, 255, 255, 0.2); pointer-events: none;}
.ui-widget-header {border: 0; border-radius: 0; background: transparent;}
.ui-datepicker .ui-datepicker-title select {font-size: .8em;}
.ui-widget.ui-widget-content {border: 1px solid rgba(0, 0, 0, .5);}
.ui-state-default {background-color: transparent; font-weight: normal; color: inherit; line-height: 1.2; color: #888; }
.ui-datepicker-unselectable .ui-state-default {background: transparent; color: rgba(255, 255, 255, 0.5); font-weight: normal; }
.ui-datepicker td span, .ui-datepicker td a {text-align: center; padding: .3em;} 
.ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default, .ui-button, .ui-button.ui-state-disabled:hover, .ui-button.ui-state-disabled:active {border: 0 !important; background-color: #666; font-weight: normal;}
.ui-state-active {border: 0 !important; background-color: var(--color-blue) !important;}
.ui-datepicker-prev:hover, .ui-datepicker-next:hover{background: none;}
.ui-state-hover, .ui-widget-content .ui-state-hover, .ui-widget-hover .ui-widget-header .ui-state-hover {border: 0;}
</style>
</head>
<body>
<input type="hidden" class="agcType" value="${agcType}" />
<input type="hidden" class="stnType" value="${stnType}" />
<input type="hidden" class="issueDt" value="${issueDt}" />
<input type="hidden" class="endObsCheck" value="${endObsCheck}" />
<header>
	<ul>
		<li><a href="/modStnInfo/modStnInfo.do"><input type="button" class="changeMod" id="modStnInfoBtn" value="GIS 관측소 제원 모듈" /></a></li>
		<li><a href="/modStnRn/modStnRn.do"><input type="button" class="changeMod" id="modStnRnBtn" value="GIS 관측소 강우 표출 모듈" /></a></li>
	</ul>
</header>
<div class="container">
	<div class="legend_wrap" style="display: block;">
        <p>(mm)</p>
        <ul class="legend">
            <li><span></span>700</li>
            <li><span></span>500</li>
            <li><span></span>400</li>
            <li><span></span>300</li>
            <li><span></span>200</li>
            <li><span></span>100</li>
            <li><span></span>90</li>
            <li><span></span>80</li>
            <li><span></span>70</li>
            <li><span></span>60</li>
            <li><span></span>50</li>
            <li><span></span>40</li>
            <li><span></span>30</li>
            <li><span></span>25</li>
            <li><span></span>20</li>
            <li><span></span>15</li>
            <li><span></span>10</li>
            <li><span></span>9.0</li>
            <li><span></span>8.0</li>
            <li><span></span>7.0</li>
            <li><span></span>6.0</li>
            <li><span></span>5.0</li>
            <li><span></span>4.0</li>
            <li><span></span>3.0</li>
            <li><span></span>2.0</li>
            <li><span></span>1.0</li>
            <li><span></span>0.8</li>
            <li><span></span>0.6</li>
            <li><span></span>0.4</li>
            <li><span></span>0.2</li>
            <li><span></span>0.1</li>
            <li><span></span>0</li>
        </ul>
    </div>
	<div id="map_wrap"></div>
	<div class="con_wrap">
		<div class="tbl_search_wrap">
	        <div class="con search_wrap">
	        	<div>
	        		<div class="item title">관할기관</div>
	                <select name="agcnm" class="item agcnmList">
	                	<!-- <option value="kma">기상청</option> -->
	                	<option value="me">환경부</option>
	                </select>
	        	</div>
                <div>
	                <div class="item title">자료타입</div>
	                <select name="fileType" class="item fileTypeList">
	                </select>
	            </div>
                <div class="item time_wrap">
	                <div class="item calendar">
	                	<div class="title">수집일자</div>
	                	<input type="text" class="date datepicker" placeholder="날짜 선택">
	                </div>
	                <div class="item">
	                    <select class="hourly" id="hourly"></select>
	                </div>
	                <!-- <div class="item">
	                    <select class="minute" id="minute"></select>
	                </div> -->
				</div>
				<div>
                    <div class="item title">종료관측소</div>
                    <input type="checkbox" class="endObsCheckBox" checked>
                </div>
	        </div>
	    </div>
	    <div class="tbl_wrap">
			<table class="tbl_rn_stn_info tbl_right" style="display: table;">
				<colgroup>
					<col style="width: 15%;">
					<col style="width: 30%;">
					<col style="width: 20%;">
					<col style="width: 20%;">
					<col style="width: 15%;">
				</colgroup>
				<thead>
					<tr>
						<th>관측소 번호</th>
						<th>관측소 명</th>
						<th>위도</th>
						<th>경도</th>
						<th>강우량 (mm)</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
		</div>
	</div>
</div>
<div class="popup_con"></div>
</body>
</html>