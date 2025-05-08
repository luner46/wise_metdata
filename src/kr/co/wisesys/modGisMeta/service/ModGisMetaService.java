package kr.co.wisesys.modGisMeta.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modGisMeta.dao.ModGisMetaDao;

@Configuration
@Service
public class ModGisMetaService {
	
	@Autowired
	private ModGisMetaDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
	 * 탭 값(val)에 따라 행정구역/유역/하천 데이터 조회
	 */
	public Map<String, Object> selectTop(String val) {
		Map<String, Object> map = new HashMap<>();
		
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String, Object>>();

		if(val.equals("0")) {
			dataList = dao.selectTop(val);
			
			log.info("dataList : " + dataList);
			
			List<Map<String, Object>> groupList = dataList.stream().map(data -> {
	            Map<String, Object> group = new HashMap<>();
	            group.put("siCode", data.get("sicode"));  
	            group.put("siNm", data.get("sinm")); 
	            return group;
	        }).distinct() 
	        .collect(Collectors.toList());
			
			List<Map<String, Object>> gubunList = dataList.stream().map(data -> {
	            Map<String, Object> gubun = new HashMap<>();
	            gubun.put("siCode", data.get("sicode"));
	            gubun.put("siNm", data.get("sinm"));
	            gubun.put("gugunCode", data.get("guguncode"));
	            gubun.put("gugunNm", data.get("gugunnm"));
	            return gubun;
	        }).distinct()
			.collect(Collectors.toList());
			
			Map<Object, List<Map<String, Object>>> gubunListGroupByGroupId = gubunList.stream()
	                .collect(Collectors.groupingBy(gubun -> gubun.get("siCode")));
			
			map.put("groupList", groupList);
			map.put("gubunListGroupByGroupId", gubunListGroupByGroupId);
			
		}else if(val.equals("1")) {
			dataList = dao.selectTop(val);
			
			List<Map<String, Object>> groupList = dataList.stream().map(data -> {
	            Map<String, Object> group = new HashMap<>();
	            group.put("bbCode", data.get("bbcode"));  
	            group.put("bbNm", data.get("bbnm")); 
	            return group;
	        }).distinct() 
	        .collect(Collectors.toList());
			
			List<Map<String, Object>> gubunList = dataList.stream().map(data -> {
			    Map<String, Object> gubun = new HashMap<>();
			    gubun.put("bbCode", data.get("bbcode"));
			    gubun.put("bbNm", data.get("bbnm"));
			    gubun.put("mbCode", data.get("mbcode"));
			    gubun.put("mbNm", data.get("mbnm"));
			    return gubun;
			}).distinct().collect(Collectors.toList());

			Map<Object, List<Map<String, Object>>> gubunListGroupByGroupId =
			    gubunList.stream().collect(Collectors.groupingBy(gubun -> gubun.get("bbCode")));
			
			map.put("groupList", groupList);
			map.put("gubunListGroupByGroupId", gubunListGroupByGroupId);
			
		}else if(val.equals("2")){
			dataList = dao.selectTop(val);
			
			List<Map<String, Object>> groupList = dataList.stream().map(data -> {
	            Map<String, Object> group = new HashMap<>();
	            group.put("dstrctCode", data.get("dstrctcode"));  
	            group.put("dstrctNm", data.get("dstrctnm")); 
	            return group;
	        }).distinct() 
	        .collect(Collectors.toList());
			
			List<Map<String, Object>> gubunList = dataList.stream().map(data -> {
	            Map<String, Object> gubun = new HashMap<>();
	            gubun.put("dstrctCode", data.get("dstrctcode"));  
	            gubun.put("dstrctNm", data.get("dstrctnm"));
	            gubun.put("wrssmCode", data.get("wrssmcode"));
	            gubun.put("wrssmNm", data.get("wrssmnm"));
	            return gubun;
	        }).distinct()
			.collect(Collectors.toList());
			
			Map<Object, List<Map<String, Object>>> gubunListGroupByGroupId = gubunList.stream()
	                .collect(Collectors.groupingBy(gubun -> gubun.get("dstrctCode")));
			
			map.put("groupList", groupList);
			map.put("gubunListGroupByGroupId", gubunListGroupByGroupId);
			
		}
		 
		return map;
	}
	
}
