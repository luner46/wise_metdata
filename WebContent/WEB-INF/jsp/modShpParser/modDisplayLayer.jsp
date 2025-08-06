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
<title>GeoJSON / KML</title>
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
let geoJsonLayer = null;
let kmlLayer = null;
let geojson_time;
let kml_time;

function getColorOfLayer(code) {
	if (code == 'N330') {return "#fdfbc7";}
	if (code == 'N331') {return "#e6ff99";}
	if (code == 'N332') {return "#38fefd";}
	if (code == 'N333') {return "#ce9afe";}
	if (code == 'N334') {return "#ce3f87";}
	return "#cccccc";
}

$(function(){
	l_map = new ol.Map({
		logo: false,
		target: 'l-map-wrap',
		layers: [base],
		view: new ol.View({
			projection: ol.proj.get('EPSG:5181'),
			center: ol.proj.fromLonLat([127.6350, 36.2225]),
			zoom: 8,
			minZoom: 8,
			maxZoom: 18
		}),
		controls: ol.control.defaults({
			zoom: false
		})
	});
	
	r_map = new ol.Map({
		logo: false,
		target: 'r-map-wrap',
		layers: [base],
		view: new ol.View({
			projection: ol.proj.get('EPSG:5181'),
			center: ol.proj.fromLonLat([127.6350, 36.2225]),
			zoom: 8,
			minZoom: 8,
			maxZoom: 18
		}),
		controls: ol.control.defaults({
			zoom: false
		})
	});
	
	$('#fileInptGeo').on('change', function(e){
		let geoJsonFile = e.target.files[0];
		if (!geoJsonFile) {return;}
		
		let reader = new FileReader();
		reader.onload = function(evt) {
			const geoJsonData = JSON.parse(evt.target.result);
			const format = new ol.format.GeoJSON();
			const features = format.readFeatures(geoJsonData, {
				dataProjection: 'EPSG:5181',
				featureProjection: l_map.getView().getProjection().getCode()
			});
			
			const source = new ol.source.Vector({features: features});
			geoJsonLayer = new ol.layer.Vector({
				source: source,
				style: function(feature) {
					let code = feature.get('SEG_CODE');
					return new ol.style.Style({
						fill: new ol.style.Fill({
							color: getColorOfLayer(code)
						})
					});
				}
			});
			
			l_map.addLayer(geoJsonLayer);
			l_map.getView().fit(source.getExtent(), {padding: [20, 20, 20, 20]});

			features.length = 0;
			reader = null;
		};
		reader.readAsText(geoJsonFile);
	});
	
	$('#fileInptKml').on('change', function(e){
		const kmlFile = e.target.files[0];
		if (!kmlFile) return;
		
		let reader = new FileReader();
		reader.onload = function(evt){
			const kmlText = evt.target.result;
			const format = new ol.format.KML({extractStyles: false});
			const features = format.readFeatures(kmlText, {
				dataProjection: 'EPSG:4326',
				featureProjection: r_map.getView().getProjection().getCode()
			});
			
			const source = new ol.source.Vector({features: features});
			kmlLayer = new ol.layer.Vector({
				source: source,
				style: function(feature){
					let props = feature.getProperties();
				    let code = props['SEG_CODE'];
					return new ol.style.Style({
						fill: new ol.style.Fill({
							color: getColorOfLayer(code)
						})
					});
				}
			});
			r_map.addLayer(kmlLayer);
			r_map.getView().fit(source.getExtent(), {padding: [20, 20, 20, 20]});

			features.length = 0;
			reader = null;
		};
		reader.readAsText(kmlFile);
	});
	
	$('.removeGeoJson').on('click',function(){
		if (geoJsonLayer && l_map.getLayers().getArray().includes(geoJsonLayer)) {
			const source = geoJsonLayer.getSource();
			if (source) {source.clear();}
			l_map.removeLayer(geoJsonLayer);
			geoJsonLayer = null;
		}

		$('#fileInptGeo').val('');
	});
	
	$('.removeKml').on('click',function(){
		if (kmlLayer && r_map.getLayers().getArray().includes(kmlLayer)) {
			const source = kmlLayer.getSource();
			if (source) {source.clear();}
			r_map.removeLayer(kmlLayer);
			kmlLayer = null;
		}
		
		$('#fileInptKml').val('');
	});
});
</script>
</head>
<body>
	<div class="container">
		<div class="l_container">
			<div class="title">
				<div class="titleAndTime">
					<p>GeoJSON</p>
					<input type="file" id="fileInptGeo" accept=".geojson, .json" /><br />
					<button type="button" class="removeGeoJson">제거</button>
				</div>
			</div>
			<div class="map-wrap" id="l-map-wrap"></div>
		</div>
		<div class="middle-line"></div>
		<div class="r_container">
			<div class="title">
				<div class="titleAndTime">
					<p>KML</p>
					<input type="file" id="fileInptKml" accept=".kml" /><br />
					<button type="button" class="removeKml">제거</button>
				</div>
			</div>
			<div class="map-wrap" id="r-map-wrap"></div>
		</div>
	</div>
</body>
</html>