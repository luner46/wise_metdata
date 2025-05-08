package kr.co.wisesys.modStnInfo.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.wisesys.modStnInfo.service.ModStnInfoService;

@Controller
@RequestMapping(value={"/modStnInfo/*"})
public class ModStnInfoController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModStnInfoService service;
	
	@RequestMapping(value = "/modStnInfo.do")
	public String selectMeStnData() throws Exception {
	    return "modStnInfo/modStnInfo";
	}
	
}
