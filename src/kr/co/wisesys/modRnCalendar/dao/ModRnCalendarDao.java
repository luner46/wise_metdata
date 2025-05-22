package kr.co.wisesys.modRnCalendar.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import org.apache.log4j.Logger;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

@Repository
public class ModRnCalendarDao{
	
	@Autowired
	@Qualifier("sqlSessionMysql")
	private SqlSessionTemplate sqlSession;
	
	private final Logger log = Logger.getLogger(getClass());
	
	public Map<String, Object> selectCalenderActiveDate(WeakHashMap<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			List<HashMap<String, Object>> list = sqlSession.selectList("modRnCalendar.selectCalenderActiveDate", param);
			result.put("list", list);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (NullPointerException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
}
