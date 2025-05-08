package kr.co.wisesys.modRnCalendar.service;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modRnCalendar.dao.ModRnCalendarDao;

@Configuration
@Service
public class ModRnCalendarService {
	
	@Autowired
	private ModRnCalendarDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	
	
}
