package kr.co.wisesys.modGisMeta.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ModGisMetaDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionFactoryPostgre;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
	 * 탭 값(val)에 따라 행정구역/유역/하천 데이터 조회
	 */
	public ArrayList<HashMap<String, Object>> selectTop(String val) {
		ArrayList<HashMap<String, Object>> result = new ArrayList<HashMap<String, Object>>();
		try {
			result.addAll(sqlSessionFactoryPostgre.selectList("modGisMeta.selectTop", val));
		} catch(NullPointerException e) {
			log.error(e.toString());
		}
		
		return result;
	}
	
	
	
}
