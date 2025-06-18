package kr.co.wisesys.modStnInfo.controller;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modStnInfo.service.ModStnInfoService;

/**
 * <pre>
 * @ClassName   : ModStnInfoController.java
 * @Description : GIS 관측소 제원 모듈 Controller
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
@RequestMapping(value={"/modStnInfo/*"})
public class ModStnInfoController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModStnInfoService service;
	
	/**
	 * 관측소 제원 정보 페이지
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param HttpServletRequest req
	 * @param Model model
	 * @return GIS 관측소 제원 정보 main view
	 */
	
	@RequestMapping(value = "/modStnInfo.do")
	public String selectModStnInfo(HttpServletRequest req, Model model) {
		try {
			String agcType = req.getParameter("agcType") == null ? "" : req.getParameter("agcType");
			String stnType = req.getParameter("stnType") == null ? "" : req.getParameter("stnType");
			String issueDt = req.getParameter("issueDt") == null ? "" : req.getParameter("issueDt");
			String endObsCheck = req.getParameter("endObsCheck");
			Calendar initDt = Calendar.getInstance();
			initDt.add(Calendar.DATE, -1);
			
			// 초기값 설정
			agcType = agcType == "" ? "kma" : agcType;
			stnType = stnType == "" ? "aws" : stnType;
			// issueDt = String.format("%04d%02d%02d",initDt.get(Calendar.YEAR),initDt.get(Calendar.MONTH) + 1,initDt.get(Calendar.DAY_OF_MONTH));
			// kma 자료는 200312가 가장 최신이기 때문에 임의로 해당 날짜 부여
			issueDt = issueDt == "" ? "20031231" : issueDt;
			endObsCheck = endObsCheck == null ? "true" : endObsCheck;
	
			model.addAttribute("agcType",agcType);
			model.addAttribute("stnType",stnType);
			model.addAttribute("issueDt",issueDt);
			model.addAttribute("endObsCheck",endObsCheck);
			
		    return "modStnInfo/modStnInfo";
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
			return "../../error/error";
		} catch (NullPointerException e) {
			log.error(e.toString());
			return "../../error/error";
		}
	}

	/**
	 * 환경부 강우 관측소 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param String issueDt
	 * @param String endObsCheck
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectMeRnStnInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectMeRnStnInfo(@RequestParam String issueDt, @RequestParam boolean endObsCheck){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			param.put("issueDt", issueDt);
			param.put("endObsCheck", endObsCheck);
			
			dataList = service.selectMeRnStnInfo(param);
		} catch (IllegalArgumentException e) {
            log.error(e.toString());
        } catch (NullPointerException e) {
            log.error(e.toString());
        }
		return dataList;
	}

	/**
	 * 환경부 수위 관측소 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param String issueDt
	 * @param String endObsCheck
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectMeWlStnInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectMeWlStnInfo(@RequestParam String issueDt, @RequestParam boolean endObsCheck){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			param.put("issueDt", issueDt);
			param.put("endObsCheck", endObsCheck);
			
			dataList = service.selectMeWlStnInfo(param);
		} catch (IllegalArgumentException e) {
            log.error(e.toString());
        } catch (NullPointerException e) {
            log.error(e.toString());
        }
		return dataList;
	}

	/**
	 * 환경부 댐 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param String issueDt
	 * @param String endObsCheck
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectMeDamInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectMeDamInfo(@RequestParam String issueDt, @RequestParam boolean endObsCheck){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			param.put("issueDt", issueDt);
			param.put("endObsCheck", endObsCheck);
			
			dataList = service.selectMeDamInfo(param);
		} catch (IllegalArgumentException e) {
            log.error(e.toString());
        } catch (NullPointerException e) {
            log.error(e.toString());
        }
		return dataList;
	}

	/**
	 * 기상청 AWS 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param String issueDt
	 * @param String endObsCheck
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectKmaAwsStnInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectKmaAwsStnInfo(@RequestParam String issueDt){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			issueDt = issueDt.substring(0, 6);
			param.put("issueDt", issueDt);
			
			dataList = service.selectKmaAwsStnInfo(param);
		} catch (IllegalArgumentException e) {
            log.error(e.toString());
        } catch (NullPointerException e) {
            log.error(e.toString());
        }
		return dataList;
	}

	/**
	 * 기상청 ASOS 리스트 CONTROLLER
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param String issueDt
	 * @param String endObsCheck
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	@RequestMapping(value="/selectKmaAsosStnInfo.do")
	@ResponseBody
	public ArrayList<HashMap<String, Object>> selectKmaAsosStnInfo(@RequestParam String issueDt){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		HashMap<String, Object> param = new HashMap<>();
		try {
			issueDt = issueDt.substring(0, 6);
			param.put("issueDt", issueDt);
			
			dataList = service.selectKmaAsosStnInfo(param);
		} catch (IllegalArgumentException e) {
            log.error(e.toString());
        } catch (NullPointerException e) {
            log.error(e.toString());
        }
		return dataList;
	}
}
