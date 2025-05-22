package kr.co.wisesys.modRnCalendar.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import kr.co.wisesys.modRnCalendar.dao.ModRnCalendarDao;

/**
 * <pre>
 * @ClassName   : ModRnCalendarService.java
 * @Description : 강우 캘린더 모듈 서비스
 * @Modification
 * 
 * -----------------------------------------------------
 * 2025.05.12, 김민수, 최초 생성
 * </pre>
 * 
 * @author 김민수
 * @since 2025.05.21
 * @version 1.0
 */

@Configuration
@Service
public class ModRnCalendarService {
	
	@Autowired
	private ModRnCalendarDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
	 * 셀렉트옵션 (관할기관, 자료타입) 에 따른 데이트피커 동적 활성화
	 * 
	 * @author 김민수
	 * @param HttpServletRequest
	 * @return map
	 */
	public Map<String, Object> selectCalenderActiveDate(WeakHashMap<String, Object> param) {
		Map<String, Object> result = new HashMap<>();
		try {
			result = dao.selectCalenderActiveDate(param);
		} catch (IllegalArgumentException e) {
			log.error(e.toString());
		} catch (DataAccessException e) {
			log.error(e.toString());
		} catch (Exception e) {
			log.error(e.toString());
		}
		return result;
	}
	
}
