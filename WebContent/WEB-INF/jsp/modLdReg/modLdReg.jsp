<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Cache-Control" content="No-Cache"/>
<meta name="viewport" content="widivh=device-widivh, initial-scale=1.0">
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta name="format-detection" content="telephone=no" />
<title>지적도 표출 모듈</title>
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
// 사용자의 moveend 이벤트가 종료된 뒤, 얼마나 머무는지 저장하기 위한 변수
let labelTimeout;

// 지적도 타일화 자료 레이어
var layer_ldreg_ansung = new ol.layer.Tile({
    name : "layer_ldreg_ansung",
    visible: true,
    wrapX: false,
    crossOrigin: 'anonymous',
    extent: [14148910.9993, 4424204.7212, 14195699.6184, 4563165.2378],
    source: new ol.source.XYZ({
        minZoom: 8,
        maxZoom: 18,
        
     	// /basePath는 Servers/server.xml에서 따로 설정해준 로컬 디렉토리 경로
     	// <Context docBase="C:/tiles/flood_eh_ansung_st" path="/basePath" reloadable="false"/>
     	// * JavaScript에서는 로컬 경로로의 접근을 혀용하지 않기 때문에 Tomcat 쪽에서 접근
        url: "/basePath/{z}/{x}/{y}.png"
    }),
    opacity: 0.5
});

// 특정 레이어 선택 시, 해당 부분을 빨간색 stroke로 하이라이트
var layer_highlight = new ol.layer.Vector({
	source: new ol.source.Vector(),
	style: new ol.style.Style({
		stroke: new ol.style.Stroke({
			color: '#F41A64',
			width: 3
		})
	})
});

// 각 구역별 정보를 표출하는 레이어
var layer_jibun = new ol.layer.Vector({
    source: new ol.source.Vector(),
    visible: false,
    style: function (feature) {
		return new ol.style.Style({
			text: new ol.style.Text({
				text: feature.get('name'),
				fill: new ol.style.Fill({color: '#000000'}),
				stroke: new ol.style.Stroke({color: '#FFFFFF', width: 1})
			})
		});
	}
});

// layer_highlight에 geom 정보를 전달하여 feature에 따라 하이라이트 생성
// DB에서 geom을 가져올 때, GeoJSON 형태로 가져와야함
// ex) ST_AsGeoJSON(ST_Transform(geom, 3857)) AS geom
function highlightLayer(geom){
	const parseJson = JSON.parse(geom);
	const feature = new ol.format.GeoJSON().readFeature({
		type: 'Feature',
		geometry: parseJson,
		properties: {}
	}, {
		// dataProjection은 DB 데이터(geom)에 저장되어있는 좌표계
		dataProjection: 'EPSG:3857',
		
		// featureProjection은 현재 map에 적용되어있는 좌표계 (현재는 EPSG:3857)
		featureProjection: map.getView().getProjection()
	});
	
	// 기존에 적용되어있던 레이어 제거 후, 새로 생성
	layer_highlight.getSource().clear();
	layer_highlight.getSource().addFeature(feature);
}

// 줌 레벨, 사용자의 map 조작에 따른 정보 레이어 표출을 컨트롤
function dataLblClotCnd() {

	// 현재 사용자의 브라우저 화면에 보이는 지도의 extent를 가지고 정보 레이어의 호출 범위를 설정
	const viewExtent = map.getView().calculateExtent(map.getSize());
    const zoom = map.getView().getZoom();
    
    // zoomLevel이 17 이상일 경우, 정보 레이어를 표출
    if (zoom >= 17) {
        if (layer_jibun) {
            layer_jibun.setVisible(true);
            
            // 과도한 DB 호출을 막기 위한 timeOut 설정
            // 사용자가 0.3초 이상 머물러야 DB 호출을 통한 정보 표출 함수 작동
            clearTimeout(labelTimeout);
            labelTimeout = setTimeout(() => {
                createJibunLabels(viewExtent);
            }, 300);
        }
    } else {
    	
    	// zoomLevel이 17보다 작을 경우, 정보 레이어 숨김 처리
        if (layer_jibun) {
            layer_jibun.setVisible(false);
        }
    }
}

// 정보 레이어 생성
function createJibunLabels(viewExtent) {
	
	// 현재 사용자의 브라우저 화면에 보이는 지도의 extent 배열
	const [minX, minY, maxX, maxY] = viewExtent;
	
    $.ajax({
        url: '/modLdReg/selectAllJibunInfo.do',
        data: {minX: minX, minY: minY, maxX: maxX, maxY: maxY},
        success: function (data) {
            const features = [];

            for (let i = 0; i < data.length; i++) {
            	let pnu = data[i]["pnu"];
				let jibun = data[i]["jibun"];
				let bchk = data[i]["bchk"];
				let sggOid = data[i]["sggoid"];
				let colAdmSe = data[i]["coladmse"];
				let geom = data[i]["geom"];
				
				// geom이 없는 경우, 대상 레이어의 범위가 아닌 경우 생략
				if (!geom) {continue;}
				
				// 정보 레이어를 각 geom(MultiPolygon)의 center점에 위치시키기 위한 데이터 호출
				const parseJson = JSON.parse(geom);
				const geometry = new ol.format.GeoJSON().readGeometry(parseJson, {
                    dataProjection: 'EPSG:3857',
                    featureProjection: map.getView().getProjection()
                });
				
				const center = ol.extent.getCenter(geometry.getExtent());
				
				// center점과 각 데이터를 가지고 layer_jibun에 feature 항목 추가
				const label = new ol.Feature({
                    geometry: new ol.geom.Point(center),
                    name: jibun
                });
				
				features.push(label);
            }

            // 브라우저 화면 밖에 있는 레이어의 feature는 삭제하고 현재 화면에 보이는 부분의 feature만 추가
            layer_jibun.getSource().clear();
            layer_jibun.getSource().addFeatures(features);
        }
    });
}

function openPopup() {
    var x = document.getElementById("popup");
    x.style.display = "block";
}

function closePopup() {
    var x = document.getElementById("popup");
    x.style.display = "none";

	layer_highlight.getSource().clear();
}

$(function() {
	const container = document.getElementById('popup');
	const content = document.getElementById('popup-content');
	const overlay = new ol.Overlay(({element: container}));
		
	map = new ol.Map({
		logo: false,
		target: 'map_wrap',
		layers: [base],
		view: new ol.View({
			projection: ol.proj.get('EPSG:5181'),
			center: ol.proj.fromLonLat([127.3350, 37.0225, 54309]),
			zoom: 12,
			minZoom: 8,
			maxZoom: 18
		}),
		controls: ol.control.defaults({
			zoom: false
		})
	});

	// 팝업 표출을 위한 overlay
	map.addOverlay(overlay);
	
	// 정보 레이어
	map.addLayer(layer_jibun);
	
	// 사용자의 줌 레벨 조작에 따른 함수 호출
	map.getView().on('change:resolution', function () {dataLblClotCnd();});
	
	// 사용자의 지도 위치 조작에 따른 함수 호출
	map.on('moveend', function(){dataLblClotCnd();})
	
	map.on('singleclick', function(evt){
		const coordinate = evt.coordinate;
		const xAxis = coordinate[0];
		const yAxis = coordinate[1];
		
		const layerExtent = layer_ldreg_ansung.getExtent();

		// 레이어 영역 이외의 곳을 클릭했을 때, 표출 중인 팝업 제거
		if (!ol.extent.containsCoordinate(layerExtent, coordinate)) {
			overlay.setPosition(undefined);
			layer_highlight.getSource().clear();
			return;
		}
		
		$.ajax({
			url: '/modLdReg/selectModLdRegInfo.do',
			data: {xAxis: xAxis, yAxis: yAxis},
			success: function(data){
				if (data.length != 0 && typeof(data) != 'undefined') {
					let pnu = data[0]["pnu"];
					let jibun = data[0]["jibun"];
					let bchk = data[0]["bchk"];
					let sggOid = data[0]["sggoid"];
					let colAdmSe = data[0]["coladmse"];
					let geom = data[0]["geom"];
					
					const htmlCont = '<p>pnu : ' + pnu + '</p><p>jibun : ' + jibun + '</p><p>bchk : ' + bchk + '</p><p>sggoid : ' + sggOid + '</p><p>colAdmSe : ' + colAdmSe + '</p>';
					content.innerHTML = htmlCont;
					
					// 마우스 클릭 위치에 팝업 고정
					overlay.setPosition(coordinate);
					openPopup();
					highlightLayer(geom);
				} else {
					content.innerHTML = '';
					overlay.setPosition(undefined);
					closePopup();
					
					// 하이라이트 레이어 제거
					layer_highlight.getSource().clear();
				}
			}
		});
	});
	
	// 지적도 레이어 위에 마우스가 올라가 있을 때만 cursor: pointer 설정
	map.on('pointermove', function(evt){
		const coordinate = evt.coordinate;
		const layerExtent = layer_ldreg_ansung.getExtent();
		
		if (ol.extent.containsCoordinate(layerExtent, coordinate)) {
			map.getTargetElement().style.cursor = 'pointer';
		} else {
			map.getTargetElement().style.cursor = '';
		}
	});

	map.addLayer(layer_ldreg_ansung);
	map.addLayer(layer_highlight);
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

.ol-popup {position: absolute; background: #FFFFFF; border: 1px solid #000000; color: #000000; padding: 6px; border-radius: 4px; pointer-events: none; font-size: 12px; white-space: nowrap; z-index: 9999;}
.ol-popup .btn_close {pointer-events: auto; z-index: 9999;}
</style>
</head>
<body>
<div class="container">
	<div id="map_wrap"></div>
</div>
<div id="popup" class="ol-popup">
	<button type="button" class="btn_close" onclick="closePopup();"><!-- onclick="this.parentNode.style.display = 'none'" --><img src="/images/btn_close.png" alt="닫기"></button>
    <div id="popup-content"></div>
</div>
</body>
</html>