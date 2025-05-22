package kr.co.wisesys.modGisMeta.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * <pre>
 * @ClassName   : ModGisMetaDao.java
 * @Description : gis 메타정보 추출 모듈 DAO
 * @Modification
 * 
 * -----------------------------------------------------
 * 2025.05.12, 김민수, 최초 생성
 * </pre>
 * 
 * @author 김민수
 * @since 2025.05.12
 * @version 1.0
 */

@Repository
public class ModGisMetaDao{
	
	@Autowired
	@Qualifier("sqlSessionPostgre")
	private SqlSessionTemplate sqlSession;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
	 * 탭메뉴 (행정구역, 유역, 하천) 선택 시 셀렉트 옵션 조회
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public ArrayList<HashMap<String, Object>> selectTop(String val) {
		ArrayList<HashMap<String, Object>> result = new ArrayList<>();
		try {
			result.addAll(sqlSession.selectList("modGisMeta.selectTop", val));
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
	/**
	 * 탭메뉴 (행정구역, 유역, 하천) 선택 시 읍면동,표준유역,하천 리스트 조회
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public Map<String, Object> selectDownList(WeakHashMap<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> list = sqlSession.selectList("modGisMeta.selectDownList", param);
			result.put("list", list);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
	/**
	 * 행정구역의 읍면동, 유역의 표준유역, 하천의 하천 셀렉트옵션에 따른 침수심 정보 데이터
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public Map<String, Object> selectFludInfoByEmdCode(WeakHashMap<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> list = sqlSession.selectList("modGisMeta.selectFludInfoByEmdCode", param);
			result.put("list", list);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
	/**
	 * 행정구역, 유역, 하천 검색어 입력 조회 리스트
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public Map<String, Object> selectSearchList(WeakHashMap<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> list = sqlSession.selectList("modGisMeta.selectSearchList", param);
			result.put("list", list);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
	/**
	 * 행정구역, 유역, 하천 셀렉트옵션에 따른 좌표이동
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public Map<String, Object> selectMoveCoordinate(WeakHashMap<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> list = sqlSession.selectList("modGisMeta.selectMoveCoordinate", param);
			result.put("list", list);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
}
