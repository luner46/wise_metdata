package kr.co.wisesys.modStnRn.dao;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ModStnRnDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionFactoryPostgre;
	
	private final Logger log = Logger.getLogger(getClass());
	
	
	
	
}
