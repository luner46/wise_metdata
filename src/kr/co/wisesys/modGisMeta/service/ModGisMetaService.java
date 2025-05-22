package kr.co.wisesys.modGisMeta.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;
import java.util.stream.Collectors;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modGisMeta.dao.ModGisMetaDao;

/**
 * <pre>
 * @ClassName   : ModGisMetaService.java
 * @Description : gis 메타정보 추출 모듈 서비스
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

@Configuration
@Service
public class ModGisMetaService {
	
	@Autowired
	private ModGisMetaDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
	 * 탭메뉴 (행정구역, 유역, 하천) 선택 시 셀렉트 옵션 조회
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public Map<String, Object> selectTop(String val) {
		Map<String, Object> map = new HashMap<>();
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();

		try {
			if (val.equals("0")) {
				dataList = dao.selectTop(val);

				List<Map<String, Object>> groupList = dataList.stream().map(data -> {
					Map<String, Object> group = new HashMap<>();
					group.put("siCode", data.get("sicode"));
					group.put("siNm", data.get("sinm"));
					return group;
				}).distinct().collect(Collectors.toList());

				List<Map<String, Object>> gubunList = dataList.stream().map(data -> {
					Map<String, Object> gubun = new HashMap<>();
					gubun.put("siCode", data.get("sicode"));
					gubun.put("siNm", data.get("sinm"));
					gubun.put("gugunCode", data.get("guguncode"));
					gubun.put("gugunNm", data.get("gugunnm"));
					return gubun;
				}).distinct().collect(Collectors.toList());

				Map<Object, List<Map<String, Object>>> gubunListGroupByGroupId =
						gubunList.stream().collect(Collectors.groupingBy(gubun -> gubun.get("siCode")));

				map.put("groupList", groupList);
				map.put("gubunListGroupByGroupId", gubunListGroupByGroupId);

			} else if (val.equals("1")) {
				dataList = dao.selectTop(val);

				List<Map<String, Object>> groupList = dataList.stream().map(data -> {
					Map<String, Object> group = new HashMap<>();
					group.put("bbCode", data.get("bbcode"));
					group.put("bbNm", data.get("bbnm"));
					return group;
				}).distinct().collect(Collectors.toList());

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

			} else if (val.equals("2")) {
				dataList = dao.selectTop(val);

				List<Map<String, Object>> groupList = dataList.stream().map(data -> {
					Map<String, Object> group = new HashMap<>();
					group.put("dstrctCode", data.get("dstrctcode"));
					group.put("dstrctNm", data.get("dstrctnm"));
					return group;
				}).distinct().collect(Collectors.toList());

				List<Map<String, Object>> gubunList = dataList.stream().map(data -> {
					Map<String, Object> gubun = new HashMap<>();
					gubun.put("dstrctCode", data.get("dstrctcode"));
					gubun.put("dstrctNm", data.get("dstrctnm"));
					gubun.put("wrssmCode", data.get("wrssmcode"));
					gubun.put("wrssmNm", data.get("wrssmnm"));
					return gubun;
				}).distinct().collect(Collectors.toList());

				Map<Object, List<Map<String, Object>>> gubunListGroupByGroupId =
						gubunList.stream().collect(Collectors.groupingBy(gubun -> gubun.get("dstrctCode")));

				map.put("groupList", groupList);
				map.put("gubunListGroupByGroupId", gubunListGroupByGroupId);
			}
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}

		return map;
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
			result = dao.selectDownList(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
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
			result = dao.selectFludInfoByEmdCode(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
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
			result = dao.selectSearchList(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
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
			result = dao.selectMoveCoordinate(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
}
