package kr.co.wisesys.modRnCalendar.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.wisesys.modRnCalendar.service.ModRnCalendarService;

@Controller
@RequestMapping(value={"/modRnCalendar/*"})
public class ModRnCalendarController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModRnCalendarService service;
	
	@RequestMapping(value = "/modRnCalendar.do")
	public String selectMeStnData() throws Exception {
	    return "modRnCalendar/modRnCalendar";
	}
	
}
