package kr.co.wisesys.modStnRn.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.wisesys.modStnRn.service.ModStnRnService;

@Controller
@RequestMapping(value={"/modStnRn/*"})
public class ModStnRnController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModStnRnService service;
	
	@RequestMapping(value = "/modStnRn.do")
	public String selectMeStnData() throws Exception {
	    return "modStnRn/modStnRn";
	}
	
}
