<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../include/include_header.jsp" />

<style>
.tab_menu li {padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; background: #f9f9f9; transition: background 0.3s;}
.tab_menu li.active {background: #007bff; color: white;}
.tab_menu li:not(.active):hover {background: #e0e0e0;}
</style>

<script>

var sidoLayer = "";
var sggLayer = "";
var emdLayer = "";
var bgBasinLayer = "";
var mdBasinLayer = "";
var smBasinLayer = "";
var nationLayer = "";
var regionLayer = "";

var defaultStyles = {
	    sidoLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#cacaca', width: 1 })}),
	    sggLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#E2009E', width: 1 })}),
	    emdLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#FE6800', width: 1 })}),
	    bgBasinLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#cacaca', width: 1 })}),
	    mdBasinLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#E2009E', width: 1 })}),
	    smBasinLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#FE6800', width: 1 })}),
	    nationLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#0065AD', width: 1 })}),
	    regionLayer: new ol.style.Style({ stroke: new ol.style.Stroke({ color: '#72B1DE', width: 1 })})
	};

var previouslyHighlightedFeature = null;

function selectTop(val) {
	$.ajax({
		url: "/modGisMeta/selectTop.do",
		data: {
			val : val
		}, 
		success: function(data) {
			window.topData = data;
			var html = "";
			
			var visibleType = $('.selector-group:visible').data('type');
			
			if(visibleType == 0) {
				for (var i = 0; i < data.groupList.length; i++) {
					var siCode = data.groupList[i].siCode;
					var siNm = data.groupList[i].siNm;
					html += "<option value='" + siCode + "'>" + siNm + "</option>";
				}
				$('#sidoSelect').html(html);

				var defaultVal = '11';
				$('#sidoSelect').val(defaultVal);

				var optionsHtml = "";
				var filteredData = data.gubunListGroupByGroupId[defaultVal];
				if (filteredData) {
					for (var i = 0; i < filteredData.length; i++) {
						var gugunCode = filteredData[i].gugunCode;
						var gugunNm = filteredData[i].gugunNm;
						optionsHtml += "<option value='" + gugunCode + "'>" + gugunNm + "</option>";
					}
				}
				$('#sggSelect').html(optionsHtml);

				$('#sidoSelect').off('change').on('change', function() {
					var group_val = $(this).val();
					var optionsHtml = "";
					var filteredData = data.gubunListGroupByGroupId[group_val];
					if (filteredData) {
						for (var i = 0; i < filteredData.length; i++) {
							var gugunCode = filteredData[i].gugunCode;
							var gugunNm = filteredData[i].gugunNm;
							optionsHtml += "<option value='" + gugunCode + "'>" + gugunNm + "</option>";
						}
					}
					$('#sggSelect').html(optionsHtml);
					
					var firstGugunCode = $('#sggSelect option:first').val();
					if (firstGugunCode) {
						selectDownList(firstGugunCode);
					}
					
				});
			} else if(visibleType == 1) {
				
				for (var i = 0; i < data.groupList.length; i++) {
					var bbCode = data.groupList[i].bbCode;
					var bbNm = data.groupList[i].bbNm;
					html += "<option value='" + bbCode + "'>" + bbNm + "</option>";
				}
				$('#bbsnSelect').html(html);

				var defaultVal = '10';
				$('#bbsnSelect').val(defaultVal);

				var optionsHtml = "";
				var filteredData = data.gubunListGroupByGroupId[defaultVal];
				
				if (filteredData) {
					for (var i = 0; i < filteredData.length; i++) {
						var mbCode = filteredData[i].mbCode;
						var mbNm = filteredData[i].mbNm;
						
						optionsHtml += "<option value='" + mbCode + "'>" + mbNm + "</option>";
					}
				}
				
				$('#sbsnSelect').html(optionsHtml);
				
				$('#bbsnSelect').off('change').on('change', function() {
					var group_val = $(this).val();
					var optionsHtml = "";
					var filteredData = data.gubunListGroupByGroupId[group_val];
					if (filteredData) {
						for (var i = 0; i < filteredData.length; i++) {
							var mbCode = filteredData[i].mbCode;
							var mbNm = filteredData[i].mbNm;
							optionsHtml += "<option value='" + mbCode + "'>" + mbNm + "</option>";
						}
					}
					$('#sbsnSelect').html(optionsHtml);
					
					var firstMbCode = $('#sbsnSelect option:first').val();
					if (firstMbCode) {
						selectDownList(firstMbCode);
					}
					
				});
				
			} else if(visibleType == 2) {
				
				for (var i = 0; i < data.groupList.length; i++) {
					var dstrctCode = data.groupList[i].dstrctCode;
					var dstrctNm = data.groupList[i].dstrctNm;
					html += "<option value='" + dstrctCode + "'>" + dstrctNm + "</option>";
				}
				$('#regionSelect').html(html);

				var defaultVal = '1';
				$('#regionSelect').val(defaultVal);

				var optionsHtml = "";
				var filteredData = data.gubunListGroupByGroupId[defaultVal];
				
				if (filteredData) {
					for (var i = 0; i < filteredData.length; i++) {
						var wrssmCode = filteredData[i].wrssmCode;
						var wrssmNm = filteredData[i].wrssmNm;
						
						optionsHtml += "<option value='" + wrssmCode + "'>" + wrssmNm + "</option>";
					}
				}
				
				$('#watershedSelect').html(optionsHtml);
				
				$('#regionSelect').off('change').on('change', function() {
					var group_val = $(this).val();
					var optionsHtml = "";
					var filteredData = data.gubunListGroupByGroupId[group_val];
					if (filteredData) {
						for (var i = 0; i < filteredData.length; i++) {
							var wrssmCode = filteredData[i].wrssmCode;
							var wrssmNm = filteredData[i].wrssmNm;
							optionsHtml += "<option value='" + wrssmCode + "'>" + wrssmNm + "</option>";
						}
					}
					$('#watershedSelect').html(optionsHtml);
					
					var firstWrssmCode = $('#watershedSelect option:first').val();
					if (firstWrssmCode) {
						selectDownList(firstWrssmCode);
					}
					
				});
			}
			
		}
	});
}

function selectHeaderHtml(type) {
	
	var headHtml = "";
	
	if(type == 0) {
		headHtml += "<tr><th>시군구</th><th>읍면동</th><th>선택</th></tr>";
	}else if(type == 1) {
		headHtml += "<tr><th>중권역</th><th>표준유역</th><th>선택</th></tr>";
	}else if(type == 2) {
		headHtml += "<tr><th>수계</th><th>하천</th><th>선택</th></tr>";
	}
	
	$('#head_target').html(headHtml);
	
}

function selectDownList(code, callback, skipRender) {
	
	var visibleType = $('.selector-group:visible').data('type');
	
	$.ajax({
		url: '/modGisMeta/selectDownList.do',
		data: {
			type: visibleType,
			code: code
		},
		success: function(data) {
			var html = "";
			var bodyHtml = "";
			
			html += "<option value='0'>전체</option>";
			
			if(visibleType == 0) {
				selectHeaderHtml(visibleType);
				for (var i = 0; i < data.list.length; i++) {
					
					var gugunCode = data.list[i].guguncode;
					var gugunNm = data.list[i].gugunnm;
					var emdCode = data.list[i].emdcode;
					var emdNm = data.list[i].emdnm;
					
					html += "<option value='" + emdCode + "'>" + emdNm + "</option>";
					//bodyHtml += "<tr><td>" + gugunNm + "</td><td>" + emdNm + "</td><td><button type='button' onclick=\"highlightFeatureByCode(emdLayer, 'EMD_CD', '" + emdCode + "')\">이동</button></td></tr>";
					bodyHtml += "<tr><td>" + gugunNm + "</td><td>" + emdNm + "</td><td><button type='button' onclick=\"selectMoveCoordinate(" + visibleType + ", '" + emdCode + "'); highlightFeatureByCode(emdLayer, 'EMD_CD', '" + emdCode + "')\">이동</button></td></tr>";
				}
				$('#emdSelect').html(html);
			}else if(visibleType == 1) {
				selectHeaderHtml(visibleType);
				for (var i = 0; i < data.list.length; i++) {
					
					var mbCode = data.list[i].mbcode;
					var mbNm = data.list[i].mbnm;
					var sbCode = data.list[i].sbcode;
					var sbNm = data.list[i].sbnm;
					
					html += "<option value='" + sbCode + "'>" + sbNm + "</option>";
					//bodyHtml += "<tr><td>" + mbNm + "</td><td>" + sbNm + "</td><td><button type='button' onclick=\"highlightFeatureByCode(smBasinLayer, 'SBSNCD', '" + sbCode + "')\">이동</button></td></tr>";
					bodyHtml += "<tr><td>" + mbNm + "</td><td>" + sbNm + "</td><td><button type='button' onclick=\"selectMoveCoordinate(" + visibleType + ", '" + sbCode + "'); highlightFeatureByCode(smBasinLayer, 'SBSNCD', '" + sbCode + "')\">이동</button></td></tr>";
				}
				$('#standardSelect').html(html);
			}else if(visibleType == 2) {
				selectHeaderHtml(visibleType);
				for (var i = 0; i < data.list.length; i++) {
					
					var wrssmCode = data.list[i].wrssmcode;
					var wrssmNm = data.list[i].wrssmnm;
					var riverCode = data.list[i].rivercode;
					var riverNm = data.list[i].rivernm;
					
					html += "<option value='" + riverCode + "'>" + riverNm + "</option>";
					//bodyHtml += "<tr><td>" + wrssmNm + "</td><td>" + riverNm + "</td><td><button type='button' onclick=\"highlightFeatureByCode(regionLayer, 'RV_CD', '" + riverCode + "')\">이동</button></td></tr>";
					bodyHtml += "<tr><td>" + wrssmNm + "</td><td>" + riverNm + "</td><td><button type='button' onclick=\"selectMoveCoordinate(" + visibleType + ", '" + riverCode + "'); highlightFeatureByCode(regionLayer, 'RV_CD', '" + riverCode + "')\">이동</button></td></tr>";
				}
				$('#riverSelect').html(html);
			}
			if (!skipRender) $('#body_target').html(bodyHtml);
			//if (callback) callback();
		}
	});
	
}

function selectData(val) {
	
	map.removeLayer(sidoLayer);
	map.removeLayer(sggLayer);
	map.removeLayer(emdLayer);
	map.removeLayer(bgBasinLayer);
	map.removeLayer(mdBasinLayer);
	map.removeLayer(smBasinLayer);
	map.removeLayer(nationLayer);
	map.removeLayer(regionLayer);
	
	if(val == 0) {
		<%-- 시도 레이어 --%>
		sidoLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_adm_sido.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'sidoLayer',
	        visible: false
	    });

		<%-- 시군구 레이어 --%>
		sggLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_adm_sgg.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'sggLayer',
	        visible: false
	    });
		
		<%-- 읍면동 레이어 --%>
		emdLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_adm_emd.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'emdLayer',
	        visible: true
	    });
		
		map.addLayer(sidoLayer);
		map.addLayer(sggLayer);
		map.addLayer(emdLayer);
		
		sidoLayer.setZIndex(3);
		sggLayer.setZIndex(2);
		emdLayer.setZIndex(1);
		
	}else if(val == 1) {
		<%-- 대권역 레이어 --%>
		bgBasinLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_basin_bg.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'bgBasinLayer',
	        visible: false
	    });
		
		<%-- 중권역 레이어 --%>
		mdBasinLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_basin_md.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'mdBasinLayer',
	        visible: false
	    });
		
		<%-- 표준유역 레이어 --%>
		smBasinLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_basin_sm.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'smBasinLayer',
	        visible: true
	    });
		
		map.addLayer(bgBasinLayer);
		map.addLayer(mdBasinLayer);
		map.addLayer(smBasinLayer);
		
		bgBasinLayer.setZIndex(3);
		mdBasinLayer.setZIndex(2);
		smBasinLayer.setZIndex(1);
		
		
	}else if(val == 2) {
		<%-- 국가하천 레이어 --%>
		nationLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_nation_river.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'nationLayer',
	        visible: false
	    });
		
		<%-- 지방하천 레이어 --%>
		regionLayer = new ol.layer.Vector({
	        source: new ol.source.Vector({
	            url: '/resources/floodmap_region_river.kml',
	            format: new ol.format.KML()
	        }),
	        name: 'regionLayer',
	        visible: true
	    });
		
		map.addLayer(nationLayer);
		map.addLayer(regionLayer);
		
		nationLayer.setZIndex(2);
		regionLayer.setZIndex(1);
		
	}
}

function selectFludInfoByEmdCode(type, code) {
	$.ajax({
		url: '/modGisMeta/selectFludInfoByEmdCode.do',
		data: { type: type, code: code },
		success: function (data) {
			
			if(type == 0) {
				for(var i=0; i<data.list.length; i++) {
					var siCode = data.list[i].sicode;
					var gugunCode = data.list[i].guguncode;
					var emdCode = data.list[i].emdcode;
					
					$('#sidoSelect').val(siCode).trigger('change');
					$('#sggSelect').val(gugunCode).trigger('change');
					
					selectDownList(gugunCode, function () {
						$('#emdSelect').val(emdCode);
					});
				}
			} else if(type == 1) {
				for(var i=0; i<data.list.length; i++) {
					var bbCode = data.list[i].bbcode;
					var mbCode = data.list[i].mbcode;
					var sbCode = data.list[i].sbcode;
					
					$('#bbsnSelect').val(bbCode).trigger('change');
					$('#sbsnSelect').val(mbCode).trigger('change');
						
					selectDownList(mbCode, function () {
						$('#standardSelect').val(sbCode);
					});
				}
			} else if(type == 2) {
				for(var i=0; i<data.list.length; i++) {
					var dstrctCode = data.list[i].dstrctcode;
					var wrssmCode = data.list[i].wrssmcode;
					var riverCode = data.list[i].rivercode;
					
					$('#regionSelect').val(dstrctCode).trigger('change');
					$('#watershedSelect').val(wrssmCode).trigger('change');

					selectDownList(wrssmCode, function () {
						$('#riverSelect').val(riverCode);
					});
					
				}
				
			}
		}
	});
}

function setSelectValues(type, bdepth, mdepth, sdepth) {
	if (type == 0) {
		$('#sidoSelect').val(bdepth);

		var gugunList = window.topData.gubunListGroupByGroupId[bdepth];
		if (gugunList) {
			var gugunHtml = "";
			for (var i = 0; i < gugunList.length; i++) {
				var gugunCode = gugunList[i].gugunCode;
				var gugunNm = gugunList[i].gugunNm;
				gugunHtml += "<option value='" + gugunCode + "'>" + gugunNm + "</option>";
			}
			$('#sggSelect').html(gugunHtml);
			$('#sggSelect').val(mdepth);
		}
	}
	else if (type == 1) {
	    $('#bbsnSelect').val(bdepth);

	    var mbList = window.topData.gubunListGroupByGroupId[bdepth];

	    if (mbList) {
	        var mbHtml = "";
	        for (var i = 0; i < mbList.length; i++) {
	            var mbCode = mbList[i].mbCode;
	            var mbNm = mbList[i].mbNm;
	            mbHtml += "<option value='" + mbCode + "'>" + mbNm + "</option>";
	        }
	        $('#sbsnSelect').html(mbHtml);
	        $('#sbsnSelect').val(mdepth);
	    }
	}
	else if (type == 2) {
	    $('#regionSelect').val(bdepth);

	    var wrssmList = window.topData.gubunListGroupByGroupId[bdepth];

	    if (wrssmList) {
	        var wrssmHtml = "";
	        for (var i = 0; i < wrssmList.length; i++) {
	            var wrssmCode = wrssmList[i].wrssmCode;
	            var wrssmNm = wrssmList[i].wrssmNm;
	            wrssmHtml += "<option value='" + wrssmCode + "'>" + wrssmNm + "</option>";
	        }
	        $('#watershedSelect').html(wrssmHtml);
	        $('#watershedSelect').val(mdepth);
	    }
	}
}

function selectSearchList(val, type) {
	
	$('#head_target').empty();
	
	$.ajax({
		url: '/modGisMeta/selectSearchList.do',
		data: { val: val, type: type },
		success: function (data) {
			var headHtml = "";
			var bodyHtml = "";
			
			if(type == 0) {
				selectHeaderHtml(type);
				for(var i=0; i<data.list.length; i++) {
					var siCode = data.list[i].sicode;
					var siNm = data.list[i].sinm;
					var gugunCode = data.list[i].guguncode;
					var gugunNm = data.list[i].gugunnm;
					var emdCode = data.list[i].emdcode;
					var emdNm = data.list[i].emdnm;
					
					bodyHtml += "<tr><td>" + gugunNm + "</td><td>" + emdNm + "</td><td><button type='button' onclick=\"setSelectValues(" + type + ", '" + siCode + "', '" + gugunCode + "', '" + emdCode + "'); selectMoveCoordinate(" + type + ", '" + emdCode + "'); highlightFeatureByCode(emdLayer, 'EMD_CD', '" + emdCode + "')\">이동</button></td></tr>";
				}
			} else if (type == 1) {
				selectHeaderHtml(type);
				for(var i=0; i<data.list.length; i++) {
					var bbCode = data.list[i].bbcode;
					var bbNm = data.list[i].bbnm;
					var mbCode = data.list[i].mbcode;
					var mbNm = data.list[i].mbnm;
					var sbCode = data.list[i].sbcode;
					var sbNm = data.list[i].sbnm;
					
					bodyHtml += "<tr><td>" + mbNm + "</td><td>" + sbNm + "</td><td><button type='button' onclick=\"setSelectValues(" + type + ", '" + bbCode + "', '" + mbCode + "', '" + sbCode + "'); selectMoveCoordinate(" + type + ", '" + sbCode + "'); highlightFeatureByCode(smBasinLayer, 'SBSNCD', '" + sbCode + "')\">이동</button></td></tr>";
				}
			} else if (type == 2) {
				selectHeaderHtml(type);
				for(var i=0; i<data.list.length; i++) {
					var dstrctCode = data.list[i].dstrctcode;
					var dstrctNm = data.list[i].dstrctnm;
					var wrssmCode = data.list[i].wrssmcode;
					var wrssmNm = data.list[i].wrssmnm;
					var riverCode = data.list[i].rivercode;
					var riverNm = data.list[i].rivernm;
					
					bodyHtml += "<tr><td>" + wrssmNm + "</td><td>" + riverNm + "</td><td><button type='button' onclick=\"setSelectValues(" + type + ", '" + dstrctCode + "', '" + wrssmCode + "', '" + riverCode + "'); selectMoveCoordinate(" + type + ", '" + riverCode + "'); highlightFeatureByCode(regionLayer, 'RV_CD', '" + riverCode + "')\">이동</button></td></tr>";
				}
			}
			$('#body_target').html(bodyHtml);
			
		}
	});
	
}

function selectMoveCoordinate(type, code) {
	
	$.ajax({
		url: '/modGisMeta/selectMoveCoordinate.do',
		data: { type: type, code: code },
		success: function (data) {
			for(var i=0; i<data.list.length; i++) {
				var lat = data.list[i].lat;
				var lon = data.list[i].lon;
				
				moveToCoordinate(lat, lon);
				
			}
		}
	});
}

function moveToCoordinate(lat, lon) {
	const view = map.getView();
	const center = ol.proj.fromLonLat([lon, lat]);
	view.setCenter(center);
	view.setZoom(12); 
}



function highlightFeatureByCode(layer, propertyName, code) {
	
    if (previouslyHighlightedFeature) {
        var prevLayerName = previouslyHighlightedFeature.get('layerName');
        var styleToRestore = defaultStyles[prevLayerName] || new ol.style.Style({});
        previouslyHighlightedFeature.setStyle(styleToRestore);
        previouslyHighlightedFeature = null;
    }
    
    var matchedFeature = layer.getSource().getFeatures().find(function(feature) {
        return feature.get(propertyName) == code;
    });

    if (matchedFeature) {
        matchedFeature.set('layerName', layer.get('name'));

        matchedFeature.setStyle(new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: 'red',
                width: 3
            })
        }));

        previouslyHighlightedFeature = matchedFeature;
        
        var visibleType = $('.selector-group:visible').data('type');
        var props = matchedFeature.getProperties();

        if (visibleType === 0) {
            var emd = props['EMD_KOR_NM'] || '';
            var emdCode = props['EMD_CD'];
            var gugunCode = props['SIG_CD'] || emdCode?.substring(0, 5) || '';
            var sidoCode = gugunCode?.substring(0, 2) || '';

            var sggNm = '';
            var sidoNm = '';

            var gugunList = window.topData.gubunListGroupByGroupId[sidoCode];
            if (gugunList) {
                var sgg = gugunList.find(item => item.gugunCode == gugunCode);
                sggNm = sgg?.gugunNm || '';
            }

            var sidoList = window.topData.groupList;
            if (sidoList) {
                var sido = sidoList.find(item => item.siCode == sidoCode);
                sidoNm = sido?.siNm || '';
            }

            showHighlightedName(sidoNm + ' ' + sggNm + ' ' + emd);
        } else if (visibleType === 1) {
            var sbNm = props['SBSNNM'] || '';
            var sbCode = props['SBSNCD'];
            var mbCode = sbCode?.substring(0, 4) || '';
            var bbCode = sbCode?.substring(0, 2) || '';

            var mbNm = '', bbNm = '';

            var mbList = window.topData.gubunListGroupByGroupId[bbCode];
            if (mbList) {
                var mb = mbList.find(item => item.mbCode == mbCode);
                mbNm = mb?.mbNm || '';
            }

            var bbList = window.topData.groupList;
            if (bbList) {
                var bb = bbList.find(item => item.bbCode == bbCode);
                bbNm = bb?.bbNm || '';
            }

            showHighlightedName(bbNm + ' ' + mbNm + ' ' + sbNm);
        } else if (visibleType === 2) {
            var riverNm = props['RV_NM'] || '';
            var rvCode = props['RV_CD'];
            var wrssmCode = rvCode?.substring(0, 2) || '';
            var dstrctCode = wrssmCode?.substring(0, 1) || '';

            var wrssmNm = '', dstrctNm = '';

            var wrssmList = window.topData.gubunListGroupByGroupId[dstrctCode];
            if (wrssmList) {
                var wrssm = wrssmList.find(item => item.wrssmCode == wrssmCode);
                wrssmNm = wrssm?.wrssmNm || '';
            }

            var dstrctList = window.topData.groupList;
            if (dstrctList) {
                var dstrct = dstrctList.find(item => item.dstrctCode == dstrctCode);
                dstrctNm = dstrct?.dstrctNm || '';
            }

            showHighlightedName(wrssmNm + ' ' + riverNm);
        }
    }
}

function highlightCenterFeatureByPriority() {
    var center = map.getView().getCenter();
    var zoom = map.getView().getZoom();
    if (zoom < 7) return;

    var layers = [
        { layer: sidoLayer, name: '시도' },
        { layer: sggLayer, name: '시군구' },
        { layer: emdLayer, name: '읍면동' },
        { layer: bgBasinLayer, name: '대권역' },
        { layer: mdBasinLayer, name: '중권역' },
        { layer: smBasinLayer, name: '표준유역' },
        { layer: nationLayer, name: '국가하천' },
        { layer: regionLayer, name: '지방하천' }
    ];

    for (var i = 0; i < layers.length; i++) {
        var entry = layers[i];
        var layer = entry.layer;
        if (!layer || !layer.getVisible()) continue;

        var features = layer.getSource().getFeatures();
        if (!features || features.length === 0) continue;

        var selectedFeature = features.find(function (f) {
            return f.getGeometry().intersectsCoordinate(center);
        });

        if (!selectedFeature) {
            var minDistance = Infinity;
            for (var j = 0; j < features.length; j++) {
                var geom = features[j].getGeometry();
                var closest = geom.getClosestPoint(center);
                var dist = Math.sqrt(Math.pow(center[0] - closest[0], 2) + Math.pow(center[1] - closest[1], 2));
                if (dist < minDistance) {
                    minDistance = dist;
                    selectedFeature = features[j];
                }
            }
        }

        if (selectedFeature) {
            if (previouslyHighlightedFeature && previouslyHighlightedFeature !== selectedFeature) {
                var prevLayerName = previouslyHighlightedFeature.get('layerName');
                var styleToRestore = defaultStyles[prevLayerName] || new ol.style.Style({});
                previouslyHighlightedFeature.setStyle(styleToRestore);
            }

            selectedFeature.set('layerName', entry.layer.get('name'));
            selectedFeature.setStyle(new ol.style.Style({
                stroke: new ol.style.Stroke({
                    color: 'red',
                    width: 3
                })
            }));
            previouslyHighlightedFeature = selectedFeature;

            var props = selectedFeature.getProperties();
            var visibleType = $('.selector-group:visible').data('type');

            if (entry.name === '읍면동') {
                var emd = props['EMD_KOR_NM'] || '';
                var emdCode = props['EMD_CD'];
                var gugunCode = props['SIG_CD'] || emdCode.substring(0, 5);
                var sidoCode = gugunCode.substring(0, 2);

                var sggNm = '', sidoNm = '';
                var gugunList = window.topData.gubunListGroupByGroupId[sidoCode];
                if (gugunList) {
                    var sgg = gugunList.find(item => item.gugunCode == gugunCode);
                    sggNm = sgg?.gugunNm || '';
                }

                var sidoList = window.topData.groupList;
                if (sidoList) {
                    var sido = sidoList.find(item => item.siCode == sidoCode);
                    sidoNm = sido?.siNm || '';
                }

                setSelectValues(visibleType, sidoCode, gugunCode, emdCode);
                selectDownList(gugunCode, 'EMD_CD', true);
                showHighlightedName(sidoNm + ' ' + sggNm + ' ' + emd);

            } else if (entry.name === '시군구') {
                var gugunCode = props['SIG_CD'];
                var sidoCode = gugunCode.substring(0, 2);

                var sggNm = '', sidoNm = '';
                var gugunList = window.topData.gubunListGroupByGroupId[sidoCode];
                if (gugunList) {
                    var sgg = gugunList.find(item => item.gugunCode == gugunCode);
                    sggNm = sgg?.gugunNm || '';
                }

                var sidoList = window.topData.groupList;
                if (sidoList) {
                    var sido = sidoList.find(item => item.siCode == sidoCode);
                    sidoNm = sido?.siNm || '';
                }

                setSelectValues(visibleType, sidoCode, gugunCode, '');
                selectDownList(gugunCode, 'SIG_CD', true);
                showHighlightedName(sidoNm + ' ' + sggNm);

            } else if (entry.name === '시도') {
                var sidoCode = props['CTPRVN_CD'];
                var sidoNm = '';
                var sidoList = window.topData.groupList;
                if (sidoList) {
                    var sido = sidoList.find(item => item.siCode == sidoCode);
                    sidoNm = sido?.siNm || '';
                }

                var gugunList = window.topData.gubunListGroupByGroupId[sidoCode];
                var gugunCode = (gugunList && gugunList.length > 0) ? gugunList[0].gugunCode : '';

                setSelectValues(visibleType, sidoCode, gugunCode, '');
                if (gugunCode) selectDownList(gugunCode, 'CTPRVN_CD', true);
                showHighlightedName(sidoNm);

            } else if (entry.name === '대권역') {
                var bbCode = props['BBSNCD'];
                var bbNm = '';
                var bbList = window.topData.groupList;
                if (bbList) {
                    var bb = bbList.find(item => item.bbCode == bbCode);
                    bbNm = bb?.bbNm || '';
                }

                var mbList = window.topData.gubunListGroupByGroupId[bbCode];
                var mbCode = (mbList && mbList.length > 0) ? mbList[0].mbCode : '';

                setSelectValues(visibleType, bbCode, mbCode, '');
                if (mbCode) selectDownList(mbCode, 'BBSNCD', true);
                showHighlightedName(bbNm);

            } else if (entry.name === '중권역') {
                var mbCode = props['MBSNCD'];
                var bbCode = mbCode.substring(0, 2);
                var mbNm = '', bbNm = '';

                var mbList = window.topData.gubunListGroupByGroupId[bbCode];
                if (mbList) {
                    var mb = mbList.find(item => item.mbCode == mbCode);
                    mbNm = mb?.mbNm || '';
                }

                var bbList = window.topData.groupList;
                if (bbList) {
                    var bb = bbList.find(item => item.bbCode == bbCode);
                    bbNm = bb?.bbNm || '';
                }

                setSelectValues(visibleType, bbCode, mbCode, '');
                selectDownList(mbCode, 'MBSNCD', true);
                showHighlightedName(bbNm + ' ' + mbNm);

            } else if (entry.name === '표준유역') {
                var sbCode = props['SBSNCD'];
                var mbCode = sbCode.substring(0, 4);
                var bbCode = mbCode.substring(0, 2);
                var sbNm = props['SBSNNM'] || '';
                var mbNm = '', bbNm = '';

                var mbList = window.topData.gubunListGroupByGroupId[bbCode];
                if (mbList) {
                    var mb = mbList.find(item => item.mbCode == mbCode);
                    mbNm = mb?.mbNm || '';
                }

                var bbList = window.topData.groupList;
                if (bbList) {
                    var bb = bbList.find(item => item.bbCode == bbCode);
                    bbNm = bb?.bbNm || '';
                }

                setSelectValues(visibleType, bbCode, mbCode, sbCode);
                selectDownList(mbCode, 'SBSNCD', true);
                showHighlightedName(bbNm + ' ' + mbNm + ' ' + sbNm);

            } else if (entry.name === '국가하천' || entry.name === '지방하천') {
                var rvCode = props['RV_CD'];
                var riverNm = props['RV_NM'] || '';
                var wrssmCode = rvCode.substring(0, 2);
                var dstrctCode = wrssmCode.substring(0, 1);

                var wrssmNm = '', dstrctNm = '';
                var wrssmList = window.topData.gubunListGroupByGroupId[dstrctCode];
                if (wrssmList) {
                    var wrssm = wrssmList.find(item => item.wrssmCode == wrssmCode);
                    wrssmNm = wrssm?.wrssmNm || '';
                }

                var dstrctList = window.topData.groupList;
                if (dstrctList) {
                    var dstrct = dstrctList.find(item => item.dstrctCode == dstrctCode);
                    dstrctNm = dstrct?.dstrctNm || '';
                }

                setSelectValues(visibleType, dstrctCode, wrssmCode, rvCode);
                selectDownList(wrssmCode, 'RV_CD', true);
                showHighlightedName(wrssmNm + ' ' + riverNm);
            }

            break;
        }
    }
}

var setChange = function(_this) {
	$.each(base_layer, function(idx, layer) {
		layer.set('visible', false);
	});
	
	if(_this.value != 'hybrid' ) {
		$.each(base_layer, function(idx, layer) {
			if(layer.get('name') === _this.value) layer.set('visible', true);
		});
		
	} else {
		$.each(base_layer, function(idx, layer) {
			if(layer.get('name') === 'satellite') layer.set('visible', true);
			if(layer.get('name') === 'hybrid') layer.set('visible', true);
		});
	}
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
	
	selectData(0);
	selectTop(0);
	selectDownList(11680);
	
	$('.tab_menu li').click(function () {
	    $('.tab_menu li').removeClass('active');
	    $('#highlightedNameBox').hide();
	    $(this).addClass('active');

	    var selectedIndex = $(this).index();

	    selectData(selectedIndex);

	    $('.selector-group').hide();
	    $('.selector-group[data-type="' + selectedIndex + '"]').show();

	    selectTop(selectedIndex);

	    if (selectedIndex == 0) selectDownList(11680);
	    if (selectedIndex == 1) selectDownList(1016);
	    if (selectedIndex == 2) selectDownList(10);

	    $('#chk_sido, #chk_sgg, #chk_emd').prop('checked', false);
	    $('#chk_bbsn, #chk_mbsn, #chk_sbsn').prop('checked', false);
	    $('#chk_nation, #chk_region').prop('checked', false);
	    
	    if (sidoLayer && typeof sidoLayer.setVisible === 'function') sidoLayer.setVisible(false);
	    if (sggLayer && typeof sggLayer.setVisible === 'function') sggLayer.setVisible(false);
	    if (emdLayer && typeof emdLayer.setVisible === 'function') emdLayer.setVisible(false);
	    if (bgBasinLayer && typeof bgBasinLayer.setVisible === 'function') bgBasinLayer.setVisible(false);
	    if (mdBasinLayer && typeof mdBasinLayer.setVisible === 'function') mdBasinLayer.setVisible(false);
	    if (smBasinLayer && typeof smBasinLayer.setVisible === 'function') smBasinLayer.setVisible(false);
	    if (nationLayer && typeof nationLayer.setVisible === 'function') nationLayer.setVisible(false);
	    if (regionLayer && typeof regionLayer.setVisible === 'function') regionLayer.setVisible(false);
	    
	    $('#chk_group_admin, #chk_group_basin, #chk_group_river').hide();

	    if (selectedIndex == 0) {
	        $('#chk_group_admin').show();
	        $('#chk_emd').prop('checked', true);
	        emdLayer.setVisible(true);
	    }
	    if (selectedIndex == 1) {
	        $('#chk_group_basin').show();
	        $('#chk_sbsn').prop('checked', true);
	        smBasinLayer.setVisible(true);
	    }
	    if (selectedIndex == 2) {
	        $('#chk_group_river').show();
	        $('#chk_region').prop('checked', true);
	        regionLayer.setVisible(true);
	    }
	});
	
	$('#sggSelect').off('change').on('change', function() {
		var gugunCode = $(this).val();
		selectDownList(gugunCode);
	});
	
	$('#sbsnSelect').off('change').on('change', function() {
		var sbsnCode = $(this).val();
		selectDownList(sbsnCode);
	});
	
	$('#watershedSelect').off('change').on('change', function() {
		var riverCode = $(this).val();
		selectDownList(riverCode);
	});
	
	$('#emdSelect').off('change').on('change', function() {
		var visibleType = $('.selector-group:visible').data('type');
		var emdCode = $(this).val();
		selectFludInfoByEmdCode(visibleType, emdCode);
		//selectMoveCoordinate(visibleType, emdCode);
		
		highlightFeatureByCode(emdLayer, 'EMD_CD', emdCode);
	});
	
	$('#standardSelect').off('change').on('change', function() {
		var visibleType = $('.selector-group:visible').data('type');
		var sbCode = $(this).val();
		selectFludInfoByEmdCode(visibleType, sbCode);
		//selectMoveCoordinate(visibleType, sbCode);
		
		highlightFeatureByCode(smBasinLayer, 'SBSNCD', sbCode);
	});
	
	$('#riverSelect').off('change').on('change', function() {
		var visibleType = $('.selector-group:visible').data('type');
		var riverCode = $(this).val();
		selectFludInfoByEmdCode(visibleType, riverCode);
		//selectMoveCoordinate(visibleType, riverCode);
		
		highlightFeatureByCode(regionLayer, 'RV_CD', riverCode);
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
	
	$('#searchBtn').on('click', function() {
		var val = $('#input_text').val().trim();
		var visibleType = $('.selector-group:visible').data('type');

		if (val == '') {
			
			var code = '';
			if (visibleType == 0) code = $('#sggSelect').val();
			else if (visibleType == 1) code = $('#sbsnSelect').val();
			else if (visibleType == 2) code = $('#watershedSelect').val();

			if (code) selectDownList(code);
			return;
		}

		selectSearchList(val, visibleType);
	});
	
	$('#input_text').on('keypress', function(e) {
	    if (e.which === 13) {
	        $('#searchBtn').click();
	    }
	});
	
	$(document).keydown(function(event) {
        if (event.which == 27 || event.keyCode === 27) {
			$('#highlightedNameBox').hide();        
        	
			if (previouslyHighlightedFeature) {
	            var prevLayerName = previouslyHighlightedFeature.get('layerName');
	            var styleToRestore = defaultStyles[prevLayerName] || new ol.style.Style({});
	            previouslyHighlightedFeature.setStyle(styleToRestore);
	            previouslyHighlightedFeature = null;
	        }
			
        }
    });
	
	document.getElementById('chk_emd').checked = true;
	
	$('#chk_sido').on('change', function () {
		sidoLayer.setVisible($(this).is(':checked'));
	});
	$('#chk_sgg').on('change', function () {
		sggLayer.setVisible($(this).is(':checked'));
	});
	$('#chk_emd').on('change', function () {
		emdLayer.setVisible($(this).is(':checked'));
	});
	
	$('#chk_bbsn').on('change', function () {
		bgBasinLayer.setVisible($(this).is(':checked'));
	});
	$('#chk_mbsn').on('change', function () {
		mdBasinLayer.setVisible($(this).is(':checked'));
	});
	$('#chk_sbsn').on('change', function () {
		smBasinLayer.setVisible($(this).is(':checked'));
	});
	
	$('#chk_nation').on('change', function () {
		nationLayer.setVisible($(this).is(':checked'));
	});
	$('#chk_region').on('change', function () {
		regionLayer.setVisible($(this).is(':checked'));
	});
	
	map.on('singleclick', function (evt) {
		var visibleType = $('.selector-group:visible').data('type');
		
	    map.forEachFeatureAtPixel(evt.pixel, function (feature, layer) {
			if (layer.get('name') == 'sidoLayer') {
	            var props = feature.getProperties();
	        	
	        	var sidoCode = props['CTPRVN_CD'];
                var gugunList = window.topData.gubunListGroupByGroupId[sidoCode];
                var gugunCode = (gugunList && gugunList.length > 0) ? gugunList[0].gugunCode : '';
                setSelectValues(visibleType, sidoCode, gugunCode, '');
                if (gugunCode) selectDownList(gugunCode);
	        	
	        	//selectFludInfoByEmdCode(visibleType, ctprvnCd);
	        	//selectMoveCoordinate(visibleType, sbsnCode);
	        	
	        	highlightFeatureByCode(sidoLayer, 'CTPRVN_CD', sidoCode);
	            
	        } else if(layer.get('name') == 'sggLayer') {
	        	var props = feature.getProperties();
	        	
	        	var gugunCode = props['SIG_CD'];
                var sidoCode = gugunCode.substring(0, 2);
                setSelectValues(visibleType, sidoCode, gugunCode, '');
                selectDownList(gugunCode);
	        	
	        	//selectFludInfoByEmdCode(visibleType, ctprvnCd);
	        	//selectMoveCoordinate(visibleType, sbsnCode);
	        	
	        	highlightFeatureByCode(sggLayer, 'SIG_CD', gugunCode);
	        	
	        } else if(layer.get('name') == 'emdLayer') {
	        	var props = feature.getProperties();
	            
	            var emdNm = props['EMD_KOR_NM'];
	            var emdCode = props['EMD_CD'];

	            selectFludInfoByEmdCode(visibleType, emdCode);
	            //selectMoveCoordinate(visibleType, emdCode);
	            
	            highlightFeatureByCode(emdLayer, 'EMD_CD', emdCode);
	        	
	        } else if(layer.get('name') == 'bgBasinLayer') {
	        	var props = feature.getProperties();
	        	
	        	var bbCode = props['BBSNCD'];
                var mbList = window.topData.gubunListGroupByGroupId[bbCode];
                var mbCode = (mbList && mbList.length > 0) ? mbList[0].mbCode : '';
                setSelectValues(visibleType, bbCode, mbCode, '');
                if (mbCode) selectDownList(mbCode);
	        	
	        	//selectFludInfoByEmdCode(visibleType, sbsnCode);
	        	//selectMoveCoordinate(visibleType, sbsnCode);
	        	
	        	highlightFeatureByCode(bgBasinLayer, 'BBSNCD', bbCode);
	        	
	        } else if(layer.get('name') == 'mdBasinLayer') {
	        	var props = feature.getProperties();
	        	
	        	var mbCode = props['MBSNCD'];
                var bbCode = mbCode.substring(0, 2);
                setSelectValues(visibleType, bbCode, mbCode, '');
                selectDownList(mbCode);
	        	
	        	//selectFludInfoByEmdCode(visibleType, sbsnCode);
	        	//selectMoveCoordinate(visibleType, sbsnCode);
	        	
	        	highlightFeatureByCode(mdBasinLayer, 'MBSNCD', mbCode);
	        	
	        } else if(layer.get('name') == 'smBasinLayer') {
	        	var props = feature.getProperties();
	        	
	        	var sbsnNm = props['SBSNNM'];
	        	var sbsnCode = props['SBSNCD'];
	        	
	        	selectFludInfoByEmdCode(visibleType, sbsnCode);
	        	//selectMoveCoordinate(visibleType, sbsnCode);
	        	
	        	highlightFeatureByCode(smBasinLayer, 'SBSNCD', sbsnCode);
	        	
	        } else if(layer.get('name') == 'nationLayer') {
				var props = feature.getProperties();
	        	
				var riverCode = props['RV_CD'];
                var wrssmCode = riverCode.substring(0, 2);
                var dstrctCode = wrssmCode.substring(0, 1);
                setSelectValues(visibleType, dstrctCode, wrssmCode, riverCode);
                selectDownList(wrssmCode);
	        	
	        	//selectFludInfoByEmdCode(visibleType, riverCode);
	        	//selectMoveCoordinate(visibleType, riverCode);
	        	
	        	highlightFeatureByCode(nationLayer, 'RV_CD', riverCode);
	        	
	        } else if(layer.get('name') == 'regionLayer') {
				var props = feature.getProperties();
	        	
	        	var riverNm = props['RV_NM'];
	        	var riverCode = props['RV_CD'];
	        	
	        	selectFludInfoByEmdCode(visibleType, riverCode);
	        	//selectMoveCoordinate(visibleType, riverCode);
	        	
	        	highlightFeatureByCode(regionLayer, 'RV_CD', riverCode);
	        	
	        }
	    });
	});

	map.on('pointermove', function(evt) {
	    if (evt.dragging) return;

	    var targetLayer = ['sidoLayer', 'sggLayer', 'emdLayer','bgBasinLayer', 'mdBasinLayer', 'smBasinLayer','nationLayer', 'regionLayer'];

	    var hit = map.hasFeatureAtPixel(evt.pixel, {
	        layerFilter: function(layer) {
	            return targetLayer.indexOf(layer.get('name')) !== -1;
	        }
	    });

	    if (hit) {
	        map.getTargetElement().style.cursor = 'pointer';
	    } else {
	        map.getTargetElement().style.cursor = '';
	    }
	});
	
	map.on('moveend', function () {
		highlightCenterFeatureByPriority();

		// 인풋텍스트가 비어있을 때만 목록 새로 그림
		var inputVal = $('#input_text').val().trim();
		if (inputVal === '') {
			var visibleType = $('.selector-group:visible').data('type');
			var code = '';

			if (visibleType == 0) code = $('#sggSelect').val();
			else if (visibleType == 1) code = $('#sbsnSelect').val();
			else if (visibleType == 2) code = $('#watershedSelect').val();

			if (code) selectDownList(code); 
		}
	});
	
});

function showHighlightedName(name) {
    var nameBox = document.getElementById('highlightedNameBox');
    nameBox.innerText = name;
    nameBox.style.display = 'block';
}

</script>

<div class="map_wrap" id="map_wrap">
  <div style="position: absolute; top: 135px; left: 30px; z-index: 1000; background: white; border: 1px solid #ccc; padding: 10px; border-radius: 4px;">
  <div id="highlightedNameBox" style="position: absolute; width: 200px; heigh: 40px; top: 450px; left: 400px; z-index: 9999; background-color: rgba(255,255,255,0.8); padding: 5px 10px; border: 1px solid #aaa; border-radius: 4px; font-size: 14px; font-weight: bold; display: none; pointer-events: none;"></div>
    
    <!-- 탭 메뉴 -->
    <ul class="tab_menu" style="display: flex; list-style: none; padding: 0; margin: 0 0 10px 0;">
      <li class="active" style="margin-right: 20px; cursor: pointer;">
        <p>행정구역</p>
      </li>
      <li style="margin-right: 20px; cursor: pointer;">
        <p>유역</p>
      </li>
      <li style="margin-right: 20px; cursor: pointer;">
        <p>하천</p>
      </li>
    </ul>

    <!-- 셀렉트 박스 그룹 -->
    <div id="locationSelectors">
      
      <!-- 행정구역 -->
      <div class="selector-group" data-type="0">
        <label>시도:
          <select id="sidoSelect">
            <option value="">선택</option>
          </select>
        </label>
        <label>시군구:
          <select id="sggSelect">
            <option value="">선택</option>
          </select>
        </label>
        <!--  
        <label>읍면동:
          <select id="emdSelect">
            <option value="">선택</option>
          </select>
        </label>
        -->
      </div>

      <!-- 유역 -->
      <div class="selector-group" data-type="1" style="display: none;">
        <label>대권역:
          <select id="bbsnSelect">
            <option value="">선택</option>
          </select>
        </label>
        <label>중권역:
          <select id="sbsnSelect">
            <option value="">선택</option>
          </select>
        </label>
        <!--  
        <label>표준유역:
          <select id="standardSelect">
            <option value="">선택</option>
          </select>
        </label>
        -->
      </div>

      <!-- 하천 -->
      <div class="selector-group" data-type="2" style="display: none;">
        <label>권역:
          <select id="regionSelect">
            <option value="">선택</option>
          </select>
        </label>
        <label>수계:
          <select id="watershedSelect">
            <option value="">선택</option>
          </select>
        </label>
        <!--  
        <label>하천:
          <select id="riverSelect">
            <option value="">선택</option>
          </select>
        </label>
        -->
      </div>

      <div id="chk_group_admin">
        <input type="checkbox" id="chk_sido" />시도
        <input type="checkbox" id="chk_sgg" />시군구
        <input type="checkbox" id="chk_emd" />읍면동
      </div>

      <div id="chk_group_basin" style="display: none;">
        <input type="checkbox" id="chk_bbsn" />대권역
        <input type="checkbox" id="chk_mbsn" />중권역
        <input type="checkbox" id="chk_sbsn" />표준유역
      </div>

      <div id="chk_group_river" style="display: none;">
        <input type="checkbox" id="chk_nation" />국가하천
        <input type="checkbox" id="chk_region" />지방하천
      </div>

      <div class="srcharea">
        <label for="input_text">검색어 입력</label>
        <div class="input-group">
          <input type="text" id="input_text" />
          <a class="lokup" id="searchBtn">조회</a>
        </div>
      </div>

      <!-- tbl wrap -->
      <div class="tbl-wrap" style="height: 400px; overflow-y: auto; border: 1px solid #ccc;">
        <table class="tbl-list" style="width: 100%; border-collapse: collapse;">
          <colgroup>
            <col>
            <col>
            <col>
          </colgroup>
          <thead id="head_target">
            <!-- 
            <tr>
              <th>시군구</th>
              <th>읍면동</th>
              <th>선택</th>
            </tr>
            -->
          </thead>
          <tbody id="body_target">
            <!-- 데이터 삽입 -->
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
    
<jsp:include page="../include/include_footer.jsp" />