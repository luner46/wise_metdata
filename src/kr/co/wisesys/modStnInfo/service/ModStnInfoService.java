package kr.co.wisesys.modStnInfo.service;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modStnInfo.dao.ModStnInfoDao;

/**
 * <pre>
 * @ClassName   : ModStnInfoService.java
 * @Description : GIS 관측소 제원 모듈 Service
 * @Modification int pageSize, String fileUploadPath
 * modify config
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
public class ModStnInfoService {
	
	@Autowired
	private ModStnInfoDao dao;
	
	private final Logger log = Logger.getLogger(getClass());

	/**
	 * 환경부 강우 관측소 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HashMap<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectMeRnStnInfo(HashMap<String, Object> param) {
	    ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String,Object>>();
	    try {
	    	dataList = dao.selectMeRnStnInfo(param);
	    } catch (NullPointerException e) {
			log.error(e.toString());
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		}
	    return dataList;
	}

	/**
	 * 환경부 수위 관측소 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HashMap<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectMeWlStnInfo(HashMap<String, Object> param) {
	    ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String,Object>>();
	    try {
	    	dataList = dao.selectMeWlStnInfo(param);
	    } catch (NullPointerException e) {
			log.error(e.toString());
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		}
	    return dataList;
	}

	/**
	 * 환경부 댐 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HashMap<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectMeDamInfo(HashMap<String, Object> param) {
	    ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String,Object>>();
	    try {
	    	dataList = dao.selectMeDamInfo(param);
	    } catch (NullPointerException e) {
			log.error(e.toString());
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		}
	    return dataList;
	}

	/**
	 * 기상청 AWS 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HashMap<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectKmaAwsStnInfo(HashMap<String, Object> param) {
	    ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String,Object>>();
	    try {
	    	dataList = dao.selectKmaAwsStnInfo(param);
	    } catch (NullPointerException e) {
			log.error(e.toString());
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		}
	    return dataList;
	}

	/**
	 * 기상청 ASOS 리스트 SERVICE
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HashMap<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectKmaAsosStnInfo(HashMap<String, Object> param) {
	    ArrayList<HashMap<String, Object>> dataList = new ArrayList<HashMap<String,Object>>();
	    try {
	    	dataList = dao.selectKmaAsosStnInfo(param);
	    } catch (NullPointerException e) {
			log.error(e.toString());
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		}
	    return dataList;
	}
}
