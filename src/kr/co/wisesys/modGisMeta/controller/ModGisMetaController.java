package kr.co.wisesys.modGisMeta.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;
import java.util.WeakHashMap;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modGisMeta.service.ModGisMetaService;

/**
 * <pre>
 * @ClassName   : ModGisMetaController.java
 * @Description : gis 메타정보 추출 모듈 컨트롤러
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

@Controller
@RequestMapping(value={"/modGisMeta/*"})
public class ModGisMetaController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModGisMetaService service;
	
	/**
	 * 메인 뷰 페이지
	 * 
	 * @author 김민수
	 * @return view
	 */
	@RequestMapping(value = "/modGisMeta.do")
	public String selectMeStnData() throws Exception {
	    return "modGisMeta/modGisMeta";
	}
	
	/**
	 * 탭메뉴 (행정구역, 유역, 하천) 선택 시 셀렉트 옵션 조회
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	@ResponseBody
	@RequestMapping(value = "/selectTop.do")
	public Map<String, Object> selectTop(HttpServletRequest req) {
		Map<String, Object> result = new HashMap<>();
		try {
			String val = req.getParameter("val")==null?"":req.getParameter("val");
			
			result = service.selectTop(val);
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
	 * 탭메뉴 (행정구역, 유역, 하천) 선택 시 읍면동,표준유역,하천 리스트 조회
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	@ResponseBody
	@RequestMapping(value = "/selectDownList.do")
	public Map<String, Object> selectDownList(HttpServletRequest req) {
		Map<String, Object> result = new HashMap<>();
		try {
			String type = req.getParameter("type")==null?"":req.getParameter("type");
			String code = req.getParameter("code")==null?"":req.getParameter("code");

			WeakHashMap<String, Object> param = new WeakHashMap<>();
			
			param.put("type", type);
			param.put("code", code);

			result = service.selectDownList(param);
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
	@ResponseBody
	@RequestMapping(value = "/selectFludInfoByEmdCode.do")
	public Map<String, Object> selectFludInfoByEmdCode(HttpServletRequest req) {
		Map<String, Object> result = new HashMap<>();
		try {
			String type = req.getParameter("type")==null?"":req.getParameter("type");
			String code = req.getParameter("code")==null?"":req.getParameter("code");

			WeakHashMap<String, Object> param = new WeakHashMap<>();
			
			param.put("type", type);
			param.put("code", code);

			result = service.selectFludInfoByEmdCode(param);
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
	@ResponseBody
	@RequestMapping(value = "/selectSearchList.do")
	public Map<String, Object> selectSearchList(HttpServletRequest req) {
		Map<String, Object> result = new HashMap<>();
		try {
			String val = req.getParameter("val")==null?"":req.getParameter("val");
			String type = req.getParameter("type")==null?"":req.getParameter("type");

			WeakHashMap<String, Object> param = new WeakHashMap<>();
			
			param.put("val", val);
			param.put("type", type);

			result = service.selectSearchList(param);
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
	@ResponseBody
	@RequestMapping(value = "/selectMoveCoordinate.do")
	public Map<String, Object> selectMoveCoordinate(HttpServletRequest req) {
		Map<String, Object> result = new HashMap<>();
		try {
			String type = req.getParameter("type")==null?"":req.getParameter("type");
			String code = req.getParameter("code")==null?"":req.getParameter("code");

			WeakHashMap<String, Object> param = new WeakHashMap<>();
			
			param.put("type", type);
			param.put("code", code);

			result = service.selectMoveCoordinate(param);
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
