package kr.co.wisesys.modStnRn.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.exceptions.PersistenceException;
import org.apache.log4j.Logger;
import org.mybatis.spring.MyBatisSystemException;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Repository;

/**
 * <pre>
 * @ClassName   : ModStnRnDao.java
 * @Description : GIS 관측소 강우 표출 모듈 DAO
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

@Repository
public class ModStnRnDao{
	
	@Autowired
	@Qualifier("sqlSessionMysql")
	private SqlSessionTemplate sqlSession;
	
	private final Logger log = Logger.getLogger(getClass());

	/**
	 * 환경부 강우 표출 DAO
	 * 
	 * @author 최준규
	 * @since 2025.06.03
	 * @param Map<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectMeRn1hr(HashMap<String, Object> param) {
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		try {
			dataList.addAll(sqlSession.selectList("modStnRn.selectMeRn1hr", param));
		} catch (MyBatisSystemException e) {
            throw new RuntimeException(e.toString());
        } catch (PersistenceException e) {
            throw new RuntimeException(e.toString());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(e.toString());
        }

		return dataList;
	}
}
