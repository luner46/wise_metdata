package kr.co.wisesys.modStnRn.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modStnRn.service.ModStnRnService;

/**
 * <pre>
 * @ClassName   : ModStnRnController.java
 * @Description : GIS 관측소 강우 표출 모듈 Controller
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

@Controller
@RequestMapping(value={"/modStnRn/*"})
public class ModStnRnController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModStnRnService service;

	/**
	 * 관측소 강우 표출 페이지
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HttpServletRequest req
	 * @param Model model
	 * @return GIS 관측소 강우 표출 main view
	 */
	
	@RequestMapping(value = "/modStnRn.do")
	public String selectMeStnData(HttpServletRequest req, Model model) {
		try {
			String agcType = req.getParameter("agcType") == null ? "" : req.getParameter("agcType");
			String stnType = req.getParameter("stnType") == null ? "" : req.getParameter("stnType");
			String issueDt = req.getParameter("issueDt") == null ? "" : req.getParameter("issueDt");
			String endObsCheck = req.getParameter("endObsCheck");
			Calendar initDt = Calendar.getInstance();
			initDt.set(Calendar.YEAR, 2024);
			initDt.set(Calendar.MONTH, 1);
			initDt.set(Calendar.DATE, 1);
			initDt.set(Calendar.HOUR, 0);
			
			// 초기값 설정
			agcType = agcType == "" ? "me" : agcType;
			stnType = stnType == "" ? "rnStn" : stnType;
			issueDt = String.format("%04d%02d%02d%02d",initDt.get(Calendar.YEAR),initDt.get(Calendar.MONTH),initDt.get(Calendar.DAY_OF_MONTH),initDt.get(Calendar.HOUR));
			endObsCheck = endObsCheck == null ? "true" : endObsCheck;

			model.addAttribute("agcType",agcType);
			model.addAttribute("stnType",stnType);
			model.addAttribute("issueDt",issueDt);
			model.addAttribute("endObsCheck",endObsCheck);
			
		    return "modStnRn/modStnRn";
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
			return "../../error/error";
		} catch (NullPointerException e) {
			log.error(e.toString());
			return "../../error/error";
		}
	}

	/**
	 * 환경부 강우 표출 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param String issueDt
	 * @param String endObsCheck
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectMeRn1hr.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectMeRn1hr(@RequestParam String issueDt, @RequestParam boolean endObsCheck){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			param.put("issueDt", issueDt);
			param.put("endObsCheck", endObsCheck);
			
			dataList = service.selectMeRn1hr(param);
		} catch (IllegalArgumentException e) {
            log.error(e.toString());
        } catch (NullPointerException e) {
            log.error(e.toString());
        }
		return dataList;
	}
}
