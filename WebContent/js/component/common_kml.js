/**
 * 
 */
// 관측소 별 KML 헤더 이름 통합
function standardHeader(feature){
	var stnType = $('.stnType').val();
	var obsCd = '';
	var obsNm = '';
	
	// 특정 관측소 코드 및 종료 관측소 목록 구분
	if (stnType == 'aws') {obsCd = feature.get('stnId'); obsNm = feature.get('stnNm'); endObsList = endAwsObsList;}
	else if (stnType == 'asos') {obsCd = feature.get('stnId'); obsNm = feature.get('stnNm'); endObsList = endAsosObsList;}
	else if (stnType == 'rnStn') {obsCd = feature.get('rfobscd'); obsNm = feature.get('obsnm'); endObsList = endRnObsList;}
	else if (stnType == 'wlStn') {obsCd = feature.get('wlobscd'); obsNm = feature.get('obsnm'); endObsList = endWlObsList;}
	else if (stnType == 'dam') {obsCd = feature.get('dmobscd'); obsNm = feature.get('obsnm'); endObsList = endDamObsList;}

	return [obsCd, obsNm, endObsList]
}

// 종료된 관측소를 구분하기 위한 배열 참조 함수
function arrayContains(array, value) {
	for (var i = 0; i < array.length; i++) {
		if (array[i] == value) {return true;}
	}
	return false;
}

// 우측 테이블 행 클릭 시, 해당 레이어 포인트에 색상 부여
function tblRowClckCntrl(layer, targetTbl, targetObsCd){
	$(document).on('click', '.' + targetTbl + ' tbody tr', function(){
		var obsCd = $(this).data(targetObsCd);
		var feature = layer.getSource().getFeatureById(obsCd);

		$('.' + targetTbl + ' tbody tr').removeClass('active');
		$(this).addClass('active');
		
		setMarkerStyleAsSelect(layer, feature);
	});
}

// 레이어 포인트 클릭 시, 우측 테이블 행에 색상 부여
function lyrClckCntrl(feature, layer, targetTbl, targetObsCd){
	var obsCd = feature.get(targetObsCd);
	
	$('.' + targetTbl + ' tbody tr').removeClass('active');
	$('.' + targetObsCd + '_' + obsCd).addClass('active');
	
	setMarkerStyleAsSelect(layer, feature);
}

// 관측소의 종류, 상태에 따라 색상 부여
function setMarkerStyleAsStnType(layer) {
	var source = layer.getSource();
	var endObsCheck = $('.endObsCheck').val();

	source.getFeatures().forEach(function(feature) {
		// 관측소 코드가 있을 경우에만 부여
		var [obsCd, obsNm, endObsList] = standardHeader(feature);
		
		if (obsCd) {
			feature.setId(obsCd);
			// 종료 관측소 목록에 있을 경우, 회색으로 설정
			if(arrayContains(endObsList, obsCd) && endObsCheck == 'false') {
				feature.setStyle(setMarkerStyleEndObs());
			} else {
				feature.setStyle(setMarkerStyleAsFlag(feature.get('flag'), obsNm));
			}
		}
	});
}

// 강우량에 따라 색상 부여
function setMarkerStyleAsRnmm(layer) {
	var source = layer.getSource();
	var endObsCheck = $('.endObsCheck').val();
	
	source.getFeatures().forEach(function(feature) {
		// 특정 관측소 코드 및 종료 관측소 목록 구분
		var [obsCd, obsNm, endObsList] = standardHeader(feature);
		
		// 관측소 코드가 있을 경우에만 부여
		if (obsCd) {
			feature.setId(obsCd);
			// 종료 관측소 목록에 있을 경우, 회색으로 설정
			if(arrayContains(endObsList, obsCd) && endObsCheck == 'false') {
				feature.setStyle(setMarkerStyleEndObs());
			} else {
				feature.setStyle(setMarkerStyleAsVal(feature.get('val'), obsNm));
			}
		}
	});
}

function setMarkerStyleAsSelect(layer, feature){
	// flag 값에 따른 관측소 색상을 유지하기 위해 스타일 저장
	var orgnlStyle = feature.getStyle() || setMarkerStyleAsFlag(feature.get('flag')) || setMarkerStyleAsVal(feature.get('val'));
	var orgnlImage = orgnlStyle.getImage();

	// 관측소가 선택되었을 떄, 레이어에 특정 스타일 적용
	layer.getSource().getFeatures().forEach(function (layerFeature) {
		var [obsCd, obsNm, endObsList] = standardHeader(layerFeature);
		
		if (layerFeature.get('selected')) {
			if (typeof(layerFeature.get('val') != 'undefined')) {
				layerFeature.setStyle(setMarkerStyleAsVal(layerFeature.get('val'), obsNm));
			} else if (typeof(layerFeature.get('flag') != 'undefined')) {
				layerFeature.setStyle(setMarkerStyleAsFlag(layerFeature.get('flag'), obsNm));
			}
			// 선택된 관측소 외, 다른 관측소에 적용된 스타일 제거
			layerFeature.unset('selected');
		}
	});
	
	// 관측소를 선택했을 떄, 스타일
	if (feature) {
		var [obsCd, obsNm, endObsList] = standardHeader(feature);
		feature.set('selected', true);
		feature.setStyle(new ol.style.Style({
			image: new ol.style.Circle({
				radius: 7,
				// 저장되어있는 원래의 스타일 적용
				fill: orgnlImage.getFill(),
				// 선택이 되었다는 것을 표시하기 위한 스타일 적용
				stroke: new ol.style.Stroke({color: '#F41A64', width: 2})
			}),
			text: setMarkerStyleText(obsNm),
			zIndex: 20
		}))
	}
}

// 관측소 마커 위에 표시되는 관측소명
function setMarkerStyleText(obsNm){
	return 	new ol.style.Text({
		text: obsNm,
		offsetY: -15,
		backgroundFill: new ol.style.Fill({color: '#FFFFFF'}),
		padding: [2, 4, 2, 4],
		fill: new ol.style.Fill({color: '#FFFFFF'}),
		stroke: new ol.style.Stroke({color: '#000000', width: 1}),
		font: '15px'
	});
}

// 종료된 관측소 스타일 설정 (회색)
function setMarkerStyleEndObs(){
	return new ol.style.Style({
		image: new ol.style.Circle({
			radius: 7,
			fill: new ol.style.Fill({color: 'rgba(0, 0, 0, 0)'}),
			stroke: new ol.style.Stroke({color: 'rgba(0, 0, 0, 0)', width: 0})
		})
	});
}

function setMarkerStyleAsFlag(flag, obsNm){
	if (typeof(flag) == 'undefined') {
		return new ol.style.Style({
			image: new ol.style.Circle({
				radius: 7,
				fill: new ol.style.Fill({color: 'rgba(0, 0, 0, 0)'}),
				stroke: new ol.style.Stroke({color: 'rgba(0, 0, 0, 0)', width: 0})
			}),
			text: setMarkerStyleText(obsNm)
		});
	} else {
		if (flag == '0') {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#FFFFFF'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			});
		} else if (flag == '1') {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#13E08E'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			});
		} else if (flag == '2') {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#888888'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm),
				zIndex: 10
			});
		} else {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#004BFC'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm),
				zIndex: 11
			});
		}
	}
}

function setMarkerStyleAsVal(val, obsNm){
	if (typeof(val) == 'undefined') {
		return new ol.style.Style({
			image: new ol.style.Circle({
				radius: 7,
				fill: new ol.style.Fill({color: 'rgba(0, 0, 0, 0)'}),
				stroke: new ol.style.Stroke({color: 'rgba(0, 0, 0, 0)', width: 0})
			}),
			text: setMarkerStyleText(obsNm)
		});
	} else {
		if (val >= 700) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#000000'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 500) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#000000'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 400) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#bf0000'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 300) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#d50000'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 200) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#ee0b0b'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 100) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#f63e3e'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 90) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#fa8585'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 80) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#7f00bf'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 70) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#9200e4'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 60) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#ad07ff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 50) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#c23eff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 40) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#e0a9ff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 30) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#000390'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 25) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#1f219d'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 20) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#4c4eb1'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 15) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#8081c7'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 10) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#b3b4de'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 9.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#0077b3'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 8.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#008dde'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 7.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#07abff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 6.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#3ec1ff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 5.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#87d9ff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 4.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#008000'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 3.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#00a400'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 2.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#00d500'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 1.0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#1ef31e'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 0.8) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#69fc69'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 0.6) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#ccaa00'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 0.4) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#e0b900'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 0.2) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#f9cd00'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 0.1) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#ffdc1f'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else if (val >= 0) {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#ffffff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		} else {
			return new ol.style.Style({
				image: new ol.style.Circle({
					radius: 7,
					fill: new ol.style.Fill({color: '#ffffff'}),
					stroke: new ol.style.Stroke({color: '#000000', width: 2})
				}),
				text: setMarkerStyleText(obsNm)
			})
		}
	}
}