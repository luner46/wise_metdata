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

var satellite = createResilientXYZLayer(
	"satellite",
	"https://xdworld.vworld.kr/2d/Satellite/service/{z}/{x}/{y}.jpeg",
	"/wiseWorld/2d/Satellite/service/{z}/{x}/{y}.png",
	true
);

var hybrid = createResilientXYZLayer(
	"hybrid",
	"https://xdworld.vworld.kr/2d/Hybrid/service/{z}/{x}/{y}.png",
	"/wiseWorld/2d/Hybrid/service/{z}/{x}/{y}.png",
	true
);

// VWorld 백맵 오류 여부 판단 전역 변수
var vworldGlobalError = false;

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

/**
 * VWorld 서비스 상태 점검 함수
 *
 * - Hybrid 레이어의 타일 5개를 병렬로 요청하여 상태를 검사함
 * - 각 타일 요청은 2초(timeout) 안에 응답을 받아야 함
 * - 5개 모두 응답 실패 또는 2초 초과 시 → VWorld 전체 오류로 간주
 * - 결과는 전역 변수 vworldGlobalError에 반영됨
 *
 * @param {Function} callback - 상태 점검 이후 호출할 함수 (선택적)
 */
function checkVworldHealth(callback) {
	const TIMEOUT_MS = 2000; // 응답시간 2초 
	const testTile = [
		"https://xdworld.vworld.kr/2d/Hybrid/service/8/218/99.png",
		"https://xdworld.vworld.kr/2d/Hybrid/service/8/218/100.png",
		"https://xdworld.vworld.kr/2d/Hybrid/service/8/218/101.png",
		"https://xdworld.vworld.kr/2d/Hybrid/service/8/219/99.png",
		"https://xdworld.vworld.kr/2d/Hybrid/service/8/219/100.png",
	];

	function fetchWithTimeout(url, timeout) {
		return Promise.race([
			fetch(url).then(res => res.ok),
			new Promise(resolve => setTimeout(() => resolve(false), timeout))
		]);
	}

	const checks = testTile.map(url => fetchWithTimeout(url, TIMEOUT_MS));

	Promise.all(checks).then(results => {
		vworldGlobalError = results.every(res => res === false);
		console.log("vworld 상태:", vworldGlobalError ? "에러 있음 → 로컬 타일 사용" : "정상");
		if (callback) callback();
	});
}

/**
 * VWorld 타일 요청이 실패한 경우 사내 타일 백맵으로 대체되는 XYZ 타일 레이어 생성 함수
 *
 * - 타일 요청 시, vworldGlobalError 값을 참조해 VWorld 또는 사내 타일 백맵 URL 사용
 * - VWorld 상태 비정상(vworldGlobalError=true)인 경우, 사내 타일 백맵을 자동으로 사용
 *
 * @param {String} name - 레이어 이름
 * @param {String} vworldUrl - VWorld 타일 URL 템플릿
 * @param {String} replaceUrl - 사내 타일 백맵 URL 템플릿
 * @param {Boolean} visible - 레이어 표시 여부
 * @returns {ol.layer.Tile} - OpenLayers 타일 레이어 객체
 */
function createResilientXYZLayer(name, vworldUrl, replaceUrl, visible) {
	return new ol.layer.Tile({
		name: name,
		visible: visible,
		source: new ol.source.XYZ({
			tileUrlFunction: function (tileCoord) {
				const z = tileCoord[0];
				const x = tileCoord[1];
				const y = -tileCoord[2] - 1;

				let urlTemplate;
				if (vworldGlobalError) {
					urlTemplate = replaceUrl; // 오류 시 대체 타일 사용
				} else {
					urlTemplate = vworldUrl; // 정상 시 VWorld 타일 사용
				}

				return urlTemplate.replace("{z}", z).replace("{x}", x).replace("{y}", y);
			}
		})
	});
}
