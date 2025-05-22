package kr.co.wisesys.modRnCalendar.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.WeakHashMap;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modRnCalendar.service.ModRnCalendarService;

/**
 * <pre>
 * @ClassName   : ModRnCalendarController.java
 * @Description : 강우 캘린더 모듈 컨트롤러
 * @Modification
 * 
 * -----------------------------------------------------
 * 2025.05.21, 김민수, 최초 생성
 * </pre>
 * 
 * @author 김민수
 * @since 2025.05.21
 * @version 1.0
 */

@Controller
@RequestMapping(value={"/modRnCalendar/*"})
public class ModRnCalendarController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModRnCalendarService service;
	
	/**
	 * 메인 뷰 페이지
	 * 
	 * @author 김민수
	 * @return view
	 */
	@RequestMapping(value = "/modRnCalendar.do")
	public String selectMeStnData() throws Exception {
	    return "modRnCalendar/modRnCalendar";
	}
	
	/**
	 * 셀렉트옵션 (관할기관, 자료타입) 에 따른 데이트피커 동적 활성화
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	@ResponseBody
	@RequestMapping(value = "/selectCalenderActiveDate.do")
	public Map<String, Object> selectCalenderActiveDate(HttpServletRequest req) {
		Map<String, Object> result = new HashMap<>();
		try {
			String agency = req.getParameter("agency")==null?"":req.getParameter("agency");
			String dataType = req.getParameter("dataType")==null?"":req.getParameter("dataType");
			String dt = req.getParameter("dt")==null?"":req.getParameter("dt");
			
			WeakHashMap<String, Object> param = new WeakHashMap<>();
			
			param.put("agency", agency);
			param.put("dataType", dataType);
			param.put("dt", dt);
			
			result = service.selectCalenderActiveDate(param);
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
