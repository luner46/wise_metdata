package kr.co.wisesys.modStnRn.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modStnRn.dao.ModStnRnDao;

/**
 * <pre>
 * @ClassName   : ModStnRnService.java
 * @Description : GIS 관측소 강우 표출 모듈 Service
 * @Modification
 * 
 * -----------------------------------------------------
 * 2025.06.03, 최준규, 최초 생성
 *
 * </pre>
 * @author 최준규
 * @since 2025.06.03
 * @version 1.0
 * @see reference
 *
 * @Copyright (c) 2025 by wiseplus All right reserved.
 */

@Configuration
@Service
public class ModStnRnService {
	
	@Autowired
	private ModStnRnDao dao;
	
	private final Logger log = Logger.getLogger(getClass());

	/**
	 * 환경부 강우 표출 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HashMap<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectMeRn1hr(HashMap<String, Object> param){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String, Object>>();
		try {
			dataList = dao.selectMeRn1hr(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
		return dataList;
	}
}
