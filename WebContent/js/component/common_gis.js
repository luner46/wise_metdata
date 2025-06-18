var map = "";
var geoserver_path = "http://211.209.185.144:3010";
var base_layer = "";
var endAwsObsList = [];
var endAsosObsList = [];
var endRnObsList = [];
var endWlObsList = [];
var endDamObsList = [];

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

var kma_aws_stn_info_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/kma_aws_stn_info.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
		image: new ol.style.Circle({
			radius: 7,
			fill: new ol.style.Fill({color: '#FFFFFF'}),
			stroke: new ol.style.Stroke({color: '#000000', width: 2})
		})
	})
});

var kma_asos_stn_info_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/kma_asos_stn_info.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
		image: new ol.style.Circle({
			radius: 7,
			fill: new ol.style.Fill({color: '#FFFFFF'}),
			stroke: new ol.style.Stroke({color: '#000000', width: 2})
		})
	})
});

var me_rn_stn_info_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/me_rn_stn_info.kml',
		format: new ol.format.KML({
			extractStyles: false
	    })
	}),
	style: new ol.style.Style({
    	image: new ol.style.Circle({
    		radius: 7,
    		fill: new ol.style.Fill({color: '#FFFFFF'}),
    		stroke: new ol.style.Stroke({color: '#000000', width: 2})
    	})
    })
});

var me_wl_stn_info_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/me_wl_stn_info.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
    	image: new ol.style.Circle({
    		radius: 7,
    		fill: new ol.style.Fill({color: '#FFFFFF'}),
    		stroke: new ol.style.Stroke({color: '#000000', width: 2})
    	})
    })
});

var me_dam_info_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/me_dam_info.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
    	image: new ol.style.Circle({
    		radius: 7,
    		fill: new ol.style.Fill({color: '#FFFFFF'}),
    		stroke: new ol.style.Stroke({color: '#000000', width: 2})
    	})
    })
});

var floodmap_adm_emd_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/floodmap_adm_emd.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
		stroke: new ol.style.Stroke({
			color: '#FF4500',
			width: 1
		})
	})
});

var floodmap_adm_sido_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/floodmap_adm_sido.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
		stroke: new ol.style.Stroke({
			color: '#708090',
			width: 1
		})
	})
});

var floodmap_adm_sgg_layer = new ol.layer.Vector({
	source: new ol.source.Vector({
		url: '/kml/floodmap_adm_sgg.kml',
		format: new ol.format.KML({
			extractStyles: false
		})
	}),
	style: new ol.style.Style({
		stroke: new ol.style.Stroke({
			color: '#663399',
			width: 1
		})
	})
});
