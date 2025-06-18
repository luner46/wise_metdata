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
<title>GIS 관측소 제원 모듈</title>
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
// AWS 관측소 정보 테이블 생성
function selectKmaAwsStnInfo(){
	let issueDt = $('.issueDt').val();
	
	$.ajax({
		url: '/modStnInfo/selectKmaAwsStnInfo.do',
		data: {issueDt: issueDt},
		success: function(data){
			var tblCont = "";
			var feature = "";
			
			for (var i = 0; i < data.length; i++) {
				var stnId = data[i]["stn_id"];
				var stnNm = data[i]["stn_nm"];
				var lat = data[i]["lat"];
				var lon = data[i]["lon"];
				var ht = data[i]["ht"];
				var yyyymm = data[i]["yyyymm"];
				var flag = data[i]["flag"];
				var flagNm = data[i]["flag_nm"];
				
				feature = kma_aws_stn_info_layer.getSource().getFeatureById(stnId);

				// 종료된 관측소일 경우, 종료 목로에 추가
				if (flag == '2'){endAwsObsList.push(stnId);}
				
				// 스타일을 설정하기 위해 flag 부여
				if (feature) {feature.set('flag', flag);}
				
				tblCont += '<tr class="stnId_' + stnId + '" data-stn_id="' + stnId + '" data-lat="' + lat + '" data-lon="' + lon + '"><td>' + stnId + '</td><td>' + stnNm + '</td><td>' + lat + '</td><td>' + lon + '</td><td>' + flagNm + '</td></tr>'
			}

			if (tblCont.length == 0) {
				$('.tbl_aws_stn_info tbody').html('<tr><td colspan=5>조건에 맞는 검색 결과가 없습니다.</td></tr>');
			} else {
				$('.tbl_aws_stn_info tbody').html(tblCont);		
			}
			
			// 위에 추가된 stnId와 flag 값으로 각 feature에 스타일 적용
			// setMarkerStyleAsStnType 변수 : 해당 레이어명
			setMarkerStyleAsStnType(kma_aws_stn_info_layer);
		}
	});
}

//AWS 관측소 정보 테이블 생성
function selectKmaAsosStnInfo(){
	let issueDt = $('.issueDt').val();
	
	$.ajax({
		url: '/modStnInfo/selectKmaAsosStnInfo.do',
		data: {issueDt: issueDt},
		success: function(data){
			var tblCont = "";
			var feature = "";
			
			for (var i = 0; i < data.length; i++) {
				var stnId = data[i]["stn_id"];
				var stnNm = data[i]["stn_nm"];
				var lat = data[i]["lat"];
				var lon = data[i]["lon"];
				var ht = data[i]["ht"];
				var yyyymm = data[i]["yyyymm"];
				var flag = data[i]["flag"];
				var flagNm = data[i]["flag_nm"];
				
				feature = kma_asos_stn_info_layer.getSource().getFeatureById(stnId);

				// 종료된 관측소일 경우, 종료 목로에 추가
				if (flag == '2'){endAsosObsList.push(stnId);}
				
				// 스타일을 설정하기 위해 flag 부여
				if (feature) {feature.set('flag', flag);}
				
				tblCont += '<tr class="stnId_' + stnId + '" data-stn_id="' + stnId + '" data-lat="' + lat + '" data-lon="' + lon + '"><td>' + stnId + '</td><td>' + stnNm + '</td><td>' + lat + '</td><td>' + lon + '</td><td>' + flagNm + '</td></tr>'
			}

			if (tblCont.length == 0) {
				$('.tbl_asos_stn_info tbody').html('<tr><td colspan=5>조건에 맞는 검색 결과가 없습니다.</td></tr>');
			} else {
				$('.tbl_asos_stn_info tbody').html(tblCont);		
			}
			
			// 위에 추가된 stnId와 flag 값으로 각 feature에 스타일 적용
			// setMarkerStyleAsStnType 변수 : 해당 레이어명
			setMarkerStyleAsStnType(kma_asos_stn_info_layer);
		}
	});
}

// 강우 관측소 정보 테이블 생성
function selectMeRnStnInfo(){
	let issueDt = $('.issueDt').val();
	let endObsCheck = $('.endObsCheck').val();
	
	$.ajax({
		url: '/modStnInfo/selectMeRnStnInfo.do',
		data: {issueDt: issueDt, endObsCheck: endObsCheck},
		success: function(data){
			var tblCont = "";
			var feature = "";
			
			for(var i = 0; i < data.length; i++){
				var rfobscd = data[i]["rfobscd"];
				var obsnm = data[i]["obsnm"] || '-';
				var lat = data[i]["lat"] || '-';
				var lon = data[i]["lon"] || '-';
				var flag = data[i]["flag"] || '-';
				var flagNm = data[i]["flag_nm"];
				
				// 종료된 관측소일 경우, 종료 목로에 추가
				if (flag == '2'){endRnObsList.push(rfobscd);}
				
				// KML로 생성된 레이어의 관측소 코드
				feature = me_rn_stn_info_layer.getSource().getFeatureById(rfobscd);
				
				// 스타일을 설정하기 위해 flag 부여
				if (feature) {feature.set('flag', flag);}
				
				tblCont += '<tr class="rfobscd_' + rfobscd + '" data-rfobscd="' + rfobscd + '" data-lat="' + lat + '" data-lon="' + lon + '"><td>' + rfobscd + '</td><td>' + obsnm + '</td><td>' + lat + '</td><td>' + lon + '</td><td>' + flagNm + '</td></tr>'
			}
			
			if (tblCont.length == 0) {
				$('.tbl_rn_stn_info tbody').html('<tr><td colspan=5>조건에 맞는 검색 결과가 없습니다.</td></tr>');
			} else {
				$('.tbl_rn_stn_info tbody').html(tblCont);		
			}
			
			// 위에 추가된 rfobscd와 flag 값으로 각 feature에 스타일 적용
			// setMarkerStyleAsStnType 변수 : 해당 레이어명
			setMarkerStyleAsStnType(me_rn_stn_info_layer);
		}
	});
}

// 수위 관측소 정보 테이블 생성
function selectMeWlStnInfo(){
	let issueDt = $('.issueDt').val();
	let endObsCheck = $('.endObsCheck').val();
	
	$.ajax({
		url: '/modStnInfo/selectMeWlStnInfo.do',
		data: {issueDt: issueDt, endObsCheck: endObsCheck},
		success: function(data){
			var tblCont = "";
			var feature = "";

			for(var i = 0; i < data.length; i++){
				var wlobscd = data[i]["wlobscd"];
				var obsnm = data[i]["obsnm"] || '-';
				var lat = data[i]["lat"] || '-';
				var lon = data[i]["lon"] || '-';
				var flag = data[i]["flag"] || '-';
				var flagNm = data[i]["flag_nm"];
				
				// 종료된 관측소일 경우, 종료 목로에 추가
				if (flag == '2'){endWlObsList.push(wlobscd);}
				
				// KML로 생성된 레이어의 관측소 코드
				feature = me_wl_stn_info_layer.getSource().getFeatureById(wlobscd);
				
				// 스타일을 설정하기 위해 flag 부여
				if (feature) {feature.set('flag', flag);}
				
				tblCont += '<tr class="wlobscd_' + wlobscd + '" data-wlobscd="' + wlobscd + '" data-lat="' + lat + '" data-lon="' + lon + '"><td>' + wlobscd + '</td><td>' + obsnm + '</td><td>' + lat + '</td><td>' + lon + '</td><td>' + flagNm + '</td></tr>'
			}

			if (tblCont.length == 0) {
				$('.tbl_wl_stn_info tbody').html('<tr><td colspan=5>조건에 맞는 검색 결과가 없습니다.</td></tr>');
			} else {
				$('.tbl_wl_stn_info tbody').html(tblCont);				
			}
			
			// 위에 추가된 wlobscd와 flag 값으로 각 feature에 스타일 적용
			// setMarkerStyleAsStnType 변수 : 해당 레이어명
			setMarkerStyleAsStnType(me_wl_stn_info_layer);
		}
	});
}

// 댐 정보 테이블 생성
function selectMeDamInfo(){
	let issueDt = $('.issueDt').val();
	let endObsCheck = $('.endObsCheck').val();
	
	$.ajax({
		url: '/modStnInfo/selectMeDamInfo.do',
		data: {issueDt: issueDt, endObsCheck: endObsCheck},
		success: function(data){
			var tblCont = "";
			var feature = "";

			for(var i = 0; i < data.length; i++){
				var dmobscd = data[i]["dmobscd"];
				var obsnm = data[i]["obsnm"] || '-';
				var lat = data[i]["lat"] || '-';
				var lon = data[i]["lon"] || '-';
				var flag = data[i]["flag"] || '-';
				var flagNm = data[i]["flag_nm"];
				
				// 종료된 관측소일 경우, 종료 목로에 추가
				if (flag == '2'){endDamObsList.push(dmobscd);}
				
				// KML로 생성된 레이어의 관측소 코드
				feature = me_dam_info_layer.getSource().getFeatureById(dmobscd);
				
				// 스타일을 설정하기 위해 flag 부여
				if (feature) {feature.set('flag', flag);}
				
				tblCont += '<tr class="dmobscd_' + dmobscd + '" data-dmobscd="' + dmobscd + '" data-lat="' + lat + '" data-lon="' + lon + '"><td>' + dmobscd + '</td><td>' + obsnm + '</td><td>' + lat + '</td><td>' + lon + '</td><td>' + flagNm + '</td></tr>'
			}
			
			if (tblCont.length == 0) {
				$('.tbl_dam_info tbody').html('<tr><td colspan=5>조건에 맞는 검색 결과가 없습니다.</td></tr>');
			} else {
				$('.tbl_dam_info tbody').html(tblCont);				
			}

			// 위에 추가된 dmobscd와 flag 값으로 각 feature에 스타일 적용
			// setMarkerStyleAsStnType 변수 : 해당 레이어명
			setMarkerStyleAsStnType(me_dam_info_layer);
		}
	});
}

// 년월일 Datepicker 생성
function createDatepicker(){
	// 관할기관
	var agcType = $('.agcType').val();
	// 관측소 타입
	var stnType = $('.stnType').val();
	// 일자
	var issueDt = $('.issueDt').val();
	var maxDate = new Date(parseInt(issueDt.substr(0,4), 10), parseInt(issueDt.substr(4, 2), 10) - 1, parseInt(issueDt.substr(6,2), 10));
	
	// datepicker 초기화
	$(".datepicker").datepicker("destroy");
	
	$(".datepicker").datepicker({
	    firstDay: 1,
	    showOtherMonths: true,
	    changeMonth: false,
	    changeYear: false,
	    dateFormat: "yy.mm.dd",
	    maxDate: maxDate,
	    monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'],
	    dayNames: ['일','월','화','수','목','금','토'],
	    dayNamesShort: ['일','월','화','수','목','금','토'],
	    dayNamesMin: ['일','월','화','수','목','금','토']
	});

	$(".datepicker").datepicker('setDate', maxDate);
	
	$(".datepicker").on("change", function() {
		
	    $(".issueDt").val($(this).val().replace(/\./g, ""));
	    
	    if ($('.stnType').val() == 'aws') {
	    	selectKmaAwsStnInfo();
	    } else if ($('.stnType').val() == 'asos') {
	    	selectKmaAsosStnInfo();
	    }  else if ($('.stnType').val() == 'rnStn') {
	    	selectMeRnStnInfo();
	    } else if ($('.stnType').val() == 'wlStn') {
	    	selectMeWlStnInfo();	    	
	    } else if ($('.stnType').val() == 'dam') {
	    	selectMeDamInfo();
	    }
	});
	
	$(document).on("mousedown", ".date", function () {
	    $(".ui-datepicker").addClass("active");
	});
	
	$(document).on("click", ".btn_state", function () {
	    $(this).toggleClass("active");
	});
}

function changeDatepicker() {
	let agcType = $('.agcType').val();
	let stnType = $('.stnType').val();

	// 현재 기상청 관측소는 과거 데이터가 최신이기 때문에 임의로 날짜 부여
	if (agcType == 'kma' && stnType == 'aws') {
		$('.issueDt').val('20031231');
	} else if (agcType == 'kma' && stnType == 'asos') {
		$('.issueDt').val('20250131');
	} else if (agcType == 'me') {
		let today = new Date();
		$('.issueDt').val(today.getFullYear().toString() + (today.getMonth() + 1).toString().padStart(2, '0') + (today.getDate() - 1).toString().padStart(2, '0'));
	}
	
	createDatepicker();
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

	map.removeLayer(kma_aws_stn_info_layer);
	map.removeLayer(kma_asos_stn_info_layer);
	map.removeLayer(me_rn_stn_info_layer);
	map.removeLayer(me_wl_stn_info_layer);
	map.removeLayer(me_dam_info_layer);
	
	// 레이어의 각 관측소마다 관특소 코드 기반의 아이디 부여
	kma_aws_stn_info_layer.getSource().on('addfeature', function (e) {
		var stnId = e.feature.get('stnId');
		if (stnId) e.feature.setId(stnId);
	});
	
	kma_asos_stn_info_layer.getSource().on('addfeature', function (e) {
		var stnId = e.feature.get('stnId');
		if (stnId) e.feature.setId(stnId);
	});
	
	me_rn_stn_info_layer.getSource().on('addfeature', function (e) {
		var rfobscd = e.feature.get('rfobscd');
		if (rfobscd) e.feature.setId(rfobscd);
	});
	
	me_wl_stn_info_layer.getSource().on('addfeature', function (e) {
		var wlobscd = e.feature.get('wlobscd');
		if (wlobscd) e.feature.setId(wlobscd);
	});
	
	me_dam_info_layer.getSource().on('addfeature', function (e) {
		var dmobscd = e.feature.get('dmobscd');
		if (dmobscd) e.feature.setId(dmobscd);
	});

	// 레이어 로딩 시, 레이어 포인트에 스타일 부여
	if (kma_aws_stn_info_layer.getSource().getState() == 'ready') {
    	setMarkerStyleAsStnType(kma_aws_stn_info_layer);
	} else {
	    kma_aws_stn_info_layer.getSource().once('change', function () {
	        setMarkerStyleAsStnType(kma_aws_stn_info_layer);
	    });
	}
	
	if (kma_asos_stn_info_layer.getSource().getState() == 'ready') {
    	setMarkerStyleAsStnType(kma_asos_stn_info_layer);
	} else {
		kma_asos_stn_info_layer.getSource().once('change', function () {
	        setMarkerStyleAsStnType(kma_asos_stn_info_layer);
	    });
	}
	
	if (me_rn_stn_info_layer.getSource().getState() == 'ready') {
    	setMarkerStyleAsStnType(me_rn_stn_info_layer);
	} else {
		me_rn_stn_info_layer.getSource().once('change', function () {
	        setMarkerStyleAsStnType(me_rn_stn_info_layer);
	    });
	}
	
	if (me_wl_stn_info_layer.getSource().getState() == 'ready') {
    	setMarkerStyleAsStnType(me_wl_stn_info_layer);
	} else {
		me_wl_stn_info_layer.getSource().once('change', function () {
	        setMarkerStyleAsStnType(me_wl_stn_info_layer);
	    });
	}
	
	if (me_dam_info_layer.getSource().getState() == 'ready') {
    	setMarkerStyleAsStnType(me_dam_info_layer);
	} else {
		me_dam_info_layer.getSource().once('change', function () {
	        setMarkerStyleAsStnType(me_dam_info_layer);
	    });
	}
	
	// 테이블에서 관측소 클릭 시, 레이어 포인트에 스타일 부여
	tblRowClckCntrl(kma_aws_stn_info_layer, 'tbl_aws_stn_info', 'stn_id');
	tblRowClckCntrl(kma_asos_stn_info_layer, 'tbl_asos_stn_info', 'stn_id');
	tblRowClckCntrl(me_rn_stn_info_layer, 'tbl_rn_stn_info', 'rfobscd');
	tblRowClckCntrl(me_wl_stn_info_layer, 'tbl_wl_stn_info', 'wlobscd');
	tblRowClckCntrl(me_dam_info_layer, 'tbl_dam_info', 'dmobscd');
	
	// 레이어 포인트 클릭 시, 테이블에 스타일 부여
	map.on('singleclick', function (evt) {
		map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
			if (layer == kma_aws_stn_info_layer) {
			    lyrClckCntrl(feature, kma_aws_stn_info_layer, 'tbl_aws_stn_info', 'stnId');
			}
			
			if (layer == kma_asos_stn_info_layer) {
				lyrClckCntrl(feature, kma_asos_stn_info_layer, 'tbl_asos_stn_info', 'stnId');
			}

			if (layer == me_rn_stn_info_layer) {
			    lyrClckCntrl(feature, me_rn_stn_info_layer, 'tbl_rn_stn_info', 'rfobscd');
			}
			
			if (layer == me_wl_stn_info_layer) {
				lyrClckCntrl(feature, me_wl_stn_info_layer, 'tbl_wl_stn_info', 'wlobscd');
			}
			
			if (layer == me_dam_info_layer) {
				lyrClckCntrl(feature, me_dam_info_layer, 'tbl_dam_info', 'dmobscd');
			}
		});
	});
	
	map.on('pointermove', function (evt) {
		let featureYn = false;
		
		map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
			const issueDt = $('.issueDt').val();
			const prevIssueDt = new Date(parseInt(issueDt.substr(0,4), 10), parseInt(issueDt.substr(4, 2), 10) - 1, parseInt(issueDt.substr(6,2), 10));
			prevIssueDt.setDate(prevIssueDt.getDate() - 1);
			
			const targetLayers = [kma_aws_stn_info_layer, kma_asos_stn_info_layer, me_rn_stn_info_layer, me_wl_stn_info_layer, me_dam_info_layer];

		    if (!targetLayers.includes(layer)) return false;
			
			let popupHtml = '';
			
			if (layer == kma_aws_stn_info_layer) {
				const stnId = feature.get("stnId");
				const stnNm = feature.get("stnNm");
				const ht = feature.get("ht") ? feature.get("ht") + 'm' : '-';

				popupHtml = '<table><tr><td class="tbl_td_title">관측소 번호</td><td>' + stnId + '</td></tr><tr><td class="tbl_td_title">관측소 명</td><td>' + stnNm + '</td></tr><tr><td class="tbl_td_title">해발고도</td><td>' + ht + '</td></tr></table>';
			}
			
			if (layer == kma_asos_stn_info_layer) {
				const stnId = feature.get("stnId");
				const stnNm = feature.get("stnNm");
				const ht = feature.get("ht") ? feature.get("ht") + 'm' : '-';

				popupHtml = '<table><tr><td class="tbl_td_title">관측소 번호</td><td>' + stnId + '</td></tr><tr><td class="tbl_td_title">관측소 명</td><td>' + stnNm + '</td></tr><tr><td class="tbl_td_title">해발고도</td><td>' + ht + '</td></tr></table>';
			}
			
			if (layer == me_rn_stn_info_layer) {
				const rfobscd = feature.get("rfobscd");
				const obsnm = feature.get("obsnm");
				const agcnm = feature.get("agcnm");
				const addr = feature.get("addr");
				const etcaddr = feature.get("etcaddr");

				popupHtml = '<table><tr><td class="tbl_td_title">관측소 번호</td><td>' + rfobscd + '</td></tr><tr><td class="tbl_td_title">관측소 명</td><td>' + obsnm + '</td></tr><tr><td class="tbl_td_title">관할기관 명</td><td>' + agcnm + '</td></tr><tr><td class="tbl_td_title">주소</td><td>' + addr + '</td></tr><tr><td class="tbl_td_title">상세 주소</td><td>' + etcaddr + '</td></tr></table>';
			}
			
			if (layer == me_wl_stn_info_layer) {
				const wlobscd = feature.get("wlobscd");
				const obsnm = feature.get("obsnm");
				const agcnm = feature.get("agcnm");
				const addr = feature.get("addr");
				const etcaddr = feature.get("etcaddr");
				const gdt = feature.get("gdt") ? feature.get("gdt") + ' EL.m' : '-';
				const attwl = feature.get("attwl") ? feature.get("attwl") + ' m' : '-';
				const wrnwl = feature.get("wrnwl") ? feature.get("wrnwl") + ' m' : '-';
				const almwl = feature.get("almwl") ? feature.get("almwl") + ' m' : '-';
				const srswl = feature.get("srswl") ? feature.get("srswl") + ' m' : '-';
				const pfh = feature.get("pfh") ? feature.get("pfh") + ' m' : '-';
				const fstnyn = feature.get("fstnyn")||'-';
				
				popupHtml = '<table><tr><td class="tbl_td_title">관측소 번호</td><td>' + wlobscd + '</td></tr><tr><td class="tbl_td_title">관측소 명</td><td>' + obsnm + '</td></tr><tr><td class="tbl_td_title">관할기관 명</td><td>' + agcnm + '</td></tr><tr><td class="tbl_td_title">주소</td><td>' + addr + '</td></tr><tr><td class="tbl_td_title">상세 주소</td><td>' + etcaddr + '</td></tr><tr><td class="tbl_td_title">영점표고</td><td>' + gdt + '</td></tr><tr><td class="tbl_td_title">관심 수위</td><td>' + attwl + '</td></tr><tr><td class="tbl_td_title">주의보 수위</td><td>' + wrnwl + '</td></tr><tr><td class="tbl_td_title">경보 수위</td><td>' + almwl + '</td></tr><tr><td class="tbl_td_title">심각 수위</td><td>' + srswl + '</td></tr><tr><td class="tbl_td_title">계획 홍수위</td><td>' + pfh + '</td></tr><tr><td class="tbl_td_title">특보 지점 여부</td><td>' + fstnyn + '</td></tr></table>';
			}
			
			if (layer == me_dam_info_layer) {
				const dmobscd = feature.get("dmobscd");
				const obsnm = feature.get("obsnm");
				const agcnm = feature.get("agcnm");
				const addr = feature.get("addr");
				const etcaddr = feature.get("etcaddr") ? feature.get("etcaddr") : '-';
				const pfh = feature.get("pfh") ? feature.get("pfh") + ' m' : '-';
				const fldlmtwl = feature.get("fldlmtwl") ? feature.get("fldlmtwl") + ' EL.m' : '-';
				
				popupHtml = '<table><tr><td class="tbl_td_title">관측소 번호</td><td>' + dmobscd + '</td></tr><tr><td class="tbl_td_title">관측소 명</td><td>' + obsnm + '</td></tr><tr><td class="tbl_td_title">관할기관 명</td><td>' + agcnm + '</td></tr><tr><td class="tbl_td_title">주소</td><td>' + addr + '</td></tr><tr><td class="tbl_td_title">상세 주소</td><td>' + etcaddr + '</td></tr><tr><td class="tbl_td_title">제한 수위</td><td>' + fldlmtwl + '</td></tr><tr><td class="tbl_td_title">계획 홍수위</td><td>' + pfh + '</td></tr></table>';
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
	
	if ($('.agcType').val() == 'kma') {
		$('.fileTypeList').empty();
		$('.fileTypeList').html('<option value="aws">AWS</option><option value="asos">ASOS</option>');
	} else if ($('.agcType').val() == 'me') {
		$('.fileTypeList').empty();
		$('.fileTypeList').html('<option value="rnStn">강우 관측소</option><option value="wlStn">수위 관측소</option><option value="dam">댐</option>');
	}
	
	$(document).on('change', '.search_wrap .agcnmList', function(){
		$('.agcType').val($(this).val());
		
		changeDatepicker();
		
		map.removeLayer(kma_aws_stn_info_layer);
		map.removeLayer(kma_asos_stn_info_layer);
		map.removeLayer(me_rn_stn_info_layer);
		map.removeLayer(me_wl_stn_info_layer);
		map.removeLayer(me_dam_info_layer);
		
		$('.tbl_aws_stn_info, .tbl_asos_stn_info, .tbl_rn_stn_info, .tbl_wl_stn_info, .tbl_dam_info').css('display', 'none');
		
		if ($(this).val() == 'kma') {
			$('.fileTypeList').empty();
			$('.fileTypeList').html('<option value="aws">AWS</option><option value="asos">ASOS</option>');
		
			$('.stnType').val("aws");
			
			selectKmaAwsStnInfo();
			
			$('.tbl_aws_stn_info').css('display', 'table');
			
			map.addLayer(kma_aws_stn_info_layer);
		} else if ($(this).val() == 'me') {
			$('.fileTypeList').empty();
			$('.fileTypeList').html('<option value="rnStn">강우 관측소</option><option value="wlStn">수위 관측소</option><option value="dam">댐</option>');
			
			$('.stnType').val("rnStn");

			selectMeRnStnInfo();
			
			$('.tbl_rn_stn_info').css('display', 'table');
			
			map.addLayer(me_rn_stn_info_layer);
		}
	});
	
	$(document).on('change','.search_wrap .fileTypeList', function(){
		$('.stnType').val($(this).val());
		
		const agcType = $('.agcType').val();
		const stnType = $('.stnType').val();
		
		changeDatepicker();
		
		map.removeLayer(kma_aws_stn_info_layer);
		map.removeLayer(kma_asos_stn_info_layer);
		map.removeLayer(me_rn_stn_info_layer);
		map.removeLayer(me_wl_stn_info_layer);
		map.removeLayer(me_dam_info_layer);

		$('.tbl_aws_stn_info, .tbl_asos_stn_info, .tbl_rn_stn_info, .tbl_wl_stn_info, .tbl_dam_info').css('display', 'none');
		
		if (agcType == 'kma') {
			if (stnType == 'aws'){
				selectKmaAwsStnInfo();
				
				$('.tbl_aws_stn_info').css('display', 'table');
				
				map.addLayer(kma_aws_stn_info_layer);
			} else if (stnType == 'asos') {
				selectKmaAsosStnInfo();
				
				$('.tbl_asos_stn_info').css('display', 'table');
				
				map.addLayer(kma_asos_stn_info_layer);
			}
		} else if (agcType == 'me') {
			if (stnType == 'rnStn') {
				selectMeRnStnInfo();
				
				$('.tbl_rn_stn_info').css('display', 'table');
				
				map.addLayer(me_rn_stn_info_layer);
			} else if (stnType == 'wlStn') {
				selectMeWlStnInfo();
				
				$('.tbl_wl_stn_info').css('display', 'table');
				
				map.addLayer(me_wl_stn_info_layer);
			} else if (stnType == 'dam') {
				selectMeDamInfo();
				
				$('.tbl_dam_info').css('display', 'table');
				
				map.addLayer(me_dam_info_layer);
			}
		}
	});
	
	$(document).on('change', '.search_wrap .endObsCheckBox', function(){
		$('.endObsCheck').val($(this).is(':checked'));
		
		if ($('.stnType').val() == 'aws') {
	    	selectKmaAwsStnInfo();
	    } else if ($('.stnType').val() == 'asos') {
	    	selectKmaAsosStnInfo();
	    } else if ($('.stnType').val() == 'rnStn') {
	    	selectMeRnStnInfo();
	    } else if ($('.stnType').val() == 'wlStn') {
	    	selectMeWlStnInfo();
	    } else if ($('.stnType').val() == 'dam') {
	    	selectMeDamInfo();
	    }
	});
	
	map.addLayer(floodmap_adm_emd_layer);
	map.addLayer(floodmap_adm_sido_layer);
	map.addLayer(floodmap_adm_sgg_layer);
	
	// 초기 함수 실행
	map.addLayer(kma_aws_stn_info_layer);
	
	selectKmaAwsStnInfo();
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
.popup_con .tbl_td_title {border-right: 1px solid #000000;}
.popup_con td {padding: 3px 10px;}

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
	<div id="map_wrap"></div>
	<div class="con_wrap">
		<div class="tbl_search_wrap">
	        <div class="con search_wrap">
	        	<div>
	        		<div class="item title">관할기관</div>
	                <select name="agcnm" class="item agcnmList">
	                	<option value="kma">기상청</option>
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
	                <!-- <div class="item">
	                    <select class="hourly" id="hourly"></select>
	                </div>
	                <div class="item">
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
	    	<table class="tbl_aws_stn_info tbl_right" style="display: table;">
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
						<th>상태</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
	    	<table class="tbl_asos_stn_info tbl_right" style="display: none;">
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
						<th>상태</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<table class="tbl_rn_stn_info tbl_right" style="display: none;">
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
						<th>상태</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<table class="tbl_wl_stn_info tbl_right" style="display: none;">
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
						<th>상태</th>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<table class="tbl_dam_info tbl_right" style="display: none;">
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
						<th>상태</th>
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