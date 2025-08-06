package kr.co.wisesys.modShpParser;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

@Repository
public class ModShpParserDao {
	@Autowired
	@Qualifier("sqlSessionPostgre")
	private SqlSessionTemplate sqlSession;
	
	private final Logger log = Logger.getLogger(getClass());

}
