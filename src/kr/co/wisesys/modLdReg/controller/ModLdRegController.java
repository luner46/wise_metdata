package kr.co.wisesys.modLdReg.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modLdReg.service.ModLdRegService;

/**
 * <pre>
 * @ClassName   : ModLdRegController.java
 * @Description : 지적도 표출 모듈 Controller
 * @Modification 
 *
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

@Controller
@RequestMapping(value= {"/modLdReg/*"})
public class ModLdRegController {

	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Value("#{config['basePath']}") private String basePath;
	
	@Autowired
	private ModLdRegService service;

	/**
	 * 지적도 표출 페이지
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param HttpServletRequest req
	 * @param Model model
	 * @return 지적도 표출 페이지 main view
	 */
	
	@RequestMapping(value = "/modLdReg.do")
	public String modLdRegView(HttpServletRequest req, Model model) {
		try {
			return "modLdReg/modLdReg";
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
			return "../../error/error";
		} catch (NullPointerException e) {
			log.error(e.toString());
			return "../../error/error";
		}
	}
	
	/**
	 * 지적도 정보 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param String xAxis
	 * @param String yAxis
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectModLdRegInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectModLdRegInfo(@RequestParam String xAxis, @RequestParam String yAxis){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		try {
			dataList = service.selectModLdRegInfo(xAxis, yAxis);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
		return dataList;
	}

	/**
	 * 지번 정보 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param String minX
	 * @param String miny
	 * @param String maxX
	 * @param String maxY
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectAllJibunInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectAllJibunInfo(@RequestParam String minX, @RequestParam String minY, @RequestParam String maxX, @RequestParam String maxY){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		try {
			dataList = service.selectAllJibunInfo(minX, minY, maxX, maxY);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		}
		return dataList;
	}
}
