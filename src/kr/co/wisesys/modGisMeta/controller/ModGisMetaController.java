package kr.co.wisesys.modGisMeta.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modGisMeta.service.ModGisMetaService;

@Controller
@RequestMapping(value={"/modGisMeta/*"})
public class ModGisMetaController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModGisMetaService service;
	
	@RequestMapping(value = "/modGisMeta.do")
	public String selectMeStnData() throws Exception {
	    return "modGisMeta/modGisMeta";
	}
	
	/**
	 * 탭메뉴 (행정구역, 유역, 하천) 선택 시 셀렉트 옵션 조회
	 */
	@ResponseBody
	@RequestMapping(value = "/selectTop.do")
	public Map<String, Object> selectTop(HttpServletRequest req) {
		
		String val = req.getParameter("val") == null ? "" : req.getParameter("val");

		return service.selectTop(val);
	}
	
	
}
