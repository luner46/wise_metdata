package kr.co.wisesys.modStnRn.service;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modStnInfo.dao.ModStnInfoDao;

@Configuration
@Service
public class ModStnRnService {
	
	@Autowired
	private ModStnInfoDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	
	
}
