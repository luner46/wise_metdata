package kr.co.wisesys.modLdReg.dao;

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
 * @ClassName   : ModLdRegDao.java
 * @Description : 지적도 표출 모듈 Dao
 * -----------------------------------------------------
 * 2025.07.08, 최준규, 최초 생성
 *
 * </pre>
 * @author 최준규
 * @since 2025.07.08
 * @version 1.0
 * @see reference
 *
 * @Copyright (c) 2025 by wiseplus All right reserved.
 */

@Repository
public class ModLdRegDao {
	
	@Autowired
	@Qualifier("sqlSessionPostgre")
	private SqlSessionTemplate sqlSession;
	
	private final Logger log = Logger.getLogger(getClass());

	/**
	 * 지적도 정보 리스트 DAO
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param Map<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectModLdRegInfo(HashMap<String, Object> param){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		try {
			dataList.addAll(sqlSession.selectList("modLdReg.selectModLdRegInfo", param));
		} catch (MyBatisSystemException e) {
            throw new RuntimeException(e.toString());
        } catch (PersistenceException e) {
            throw new RuntimeException(e.toString());
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException(e.toString());
        }
		return dataList;
	}

	/**
	 * 지번 정보 리스트 DAO
	 * 
	 * @author 최준규
	 * @since 2025.07.08
	 * @param Map<String, Object> param
	 * @return ArrayList<HashMap<String, Object>> dataList
	 */
	
	public ArrayList<HashMap<String, Object>> selectAllJibunInfo(HashMap<String, Object> param){
		ArrayList<HashMap<String, Object>> dataList = new ArrayList<>();
		try {
			dataList.addAll(sqlSession.selectList("modLdReg.selectAllJibunInfo", param));
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
