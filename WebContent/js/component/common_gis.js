var map = "";
var geoserver_path = "http://211.209.185.144:3010";
var base_layer = "";

var view = new ol.View({
	projection: ol.proj.get('EPSG:5181'),
	center: ol.proj.fromLonLat([127.7669, 35.9078]),
	zoom: 8,
	minZoom: 7
});

var base = new ol.layer.Tile({
    name : "base",
    visible: true,
    source: new ol.source.XYZ({
    	url: "https://xdworld.vworld.kr/2d/Base/service/{z}/{x}/{y}.png"
    })
});

var satellite = new ol.layer.Tile({
    name : "satellite",
    visible: true,
    source: new ol.source.XYZ({
		url: "https://xdworld.vworld.kr/2d/Satellite/service/{z}/{x}/{y}.jpeg"
    })
});

var hybrid = new ol.layer.Tile({
 	name : "hybrid",
 	visible: true,
    source: new ol.source.XYZ({
        url: "https://xdworld.vworld.kr/2d/Hybrid/service/{z}/{x}/{y}.png"
    })
});

var gray = new ol.layer.Tile({
    name : "gray",
    visible: true,
    source: new ol.source.XYZ({
    	url: "https://xdworld.vworld.kr/2d/gray/service/{z}/{x}/{y}.png"
    })
});

var midnight = new ol.layer.Tile({
    name : "midnight",
    visible: true,
    source: new ol.source.XYZ({
    	url: "https://xdworld.vworld.kr/2d/midnight/service/{z}/{x}/{y}.png"
    }) 
}); 
