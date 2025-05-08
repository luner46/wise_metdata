<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../include/include_header.jsp" />

<style>
.tab_menu li {padding: 6px 12px; border: 1px solid #ccc; border-radius: 4px; background: #f9f9f9; transition: background 0.3s;}
.tab_menu li.active {background: #007bff; color: white;}
.tab_menu li:not(.active):hover {background: #e0e0e0;}
</style>

<script>

function selectTop(val) {
	$.ajax({
		url: "/modGisMeta/selectTop.do",
		data: {
			val : val
		}, 
		success: function(data) {
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
				});
				
			}
			
		}
	});
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
	
	selectTop(0);
	
	$('.tab_menu li').click(function (){
		$('.tab_menu li').removeClass('active');
		$(this).addClass('active');
		
		var selectedIndex = $(this).index();
		
		$('.selector-group').hide();
		$('.selector-group[data-type="' + selectedIndex + '"]').show();
		
		selectTop(selectedIndex);
		
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
	
});
</script>

    <div class="map_wrap" id="map_wrap">
	  <div style="position: absolute; top: 10px; left: 10px; z-index: 1000; background: white; border: 1px solid #ccc; padding: 10px; border-radius: 4px;">
	    
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
  </div>

</div>
	
	  </div>
	</div>
    
    
<jsp:include page="../include/include_footer.jsp" />