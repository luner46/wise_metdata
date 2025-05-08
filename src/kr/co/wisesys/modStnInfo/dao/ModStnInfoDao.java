package kr.co.wisesys.modStnInfo.dao;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ModStnInfoDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionFactoryPostgre;
	
	private final Logger log = Logger.getLogger(getClass());
	
	
	
	
}
