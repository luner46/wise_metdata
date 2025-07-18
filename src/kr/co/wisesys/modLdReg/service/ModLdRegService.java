package kr.co.wisesys.modLdReg.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modLdReg.dao.ModLdRegDao;

/**
 * <pre>
 * @ClassName   : ModLdRegService.java
 * @Description : 지적도 표출 모듈 Service
 * -----------------------------------------------------
 * 2025.07.08, 최준규, 최초 생성
 *
 * </pre>
 * @author 최준규
 * @since 2025.07.08
 * @version 1.0
 * @see reference
 *
 * @Copyright (c) 2025 by wiseplus All right reserved.
 */

@Configuration
@Service
public class ModLdRegService {
	
	@Autowired
	private ModLdRegDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
	 * 지적도 정보 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param String xAxis
	 * @param String yAxis
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectModLdRegInfo(String xAxis, String yAxis){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			param.put("xAxis", xAxis);
			param.put("yAxis", yAxis);
			
			dataList = dao.selectModLdRegInfo(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
		return dataList;
	}
	
	/**
	 * 지번 정보 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param String minX
	 * @param String miny
	 * @param String maxX
	 * @param String maxY
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectAllJibunInfo(String minX, String minY, String maxX, String maxY){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			double dblMinX = Double.parseDouble(minX);
			double dblMinY = Double.parseDouble(minY);
			double dblMaxX = Double.parseDouble(maxX);
			double dblMaxY = Double.parseDouble(maxY);
			
			String polygon = String.format(
			    "POLYGON((%f %f, %f %f, %f %f, %f %f, %f %f))",
			    dblMinX, dblMinY, dblMaxX, dblMinY, dblMaxX, dblMaxY, dblMinX, dblMaxY, dblMinX, dblMinY
			);
			param.put("polygon", polygon);
			
			dataList = dao.selectAllJibunInfo(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
		return dataList;
	}
}
