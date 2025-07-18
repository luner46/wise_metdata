package kr.co.wisesys.modFloodQc.dao;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.WeakHashMap;

import javax.persistence.PersistenceException;

import org.apache.log4j.Logger;
import org.mybatis.spring.MyBatisSystemException;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * <pre>
 * @ClassName   : ModFloodQcDao.java
 * @Description : 홍수위험지도 정보시스템 검수프로그램 모듈 DAO
 * @Modification
 * 
 * -----------------------------------------------------
 * 2025.07.02, 김민수, 최초 생성
 * </pre>
 * 
 * @author 김민수
 * @since 2025.07.02
 * @version 1.0
 */

@Repository
public class ModFloodQcDao{
	
	@Autowired
	@Qualifier("sqlSessionPostgre")
	private SqlSessionTemplate sqlSession;
	
	private final Logger log = Logger.getLogger(getClass());
	
	/**
     * 전달받은 코드(type, code/freq)의 유효성 여부를 DB에서 조회하여 반환
     * 
     * @param type 코드 유형 (SGG, SAREA, SBSN, ALL)
     * @param type이 ALL일때 code = 빈도(freq) 그 외 code = code
     * @return 유효하면 true, 유효하지 않으면 false
     */
	public boolean checkShpCodeValid(String type, String code) {
	    try {
	        Map<String, Object> param = new HashMap<>();
	        param.put("type", type);
	        
	        if ("ALL".equals(type)) {
	            param.put("freq", code);
	        } else {
	            param.put("code", code);
	        }

	        Object result = sqlSession.selectOne("modFloodQc.checkShpCodeValid", param);
	        return result != null && ((Number) result).intValue() > 0;
	    } catch (PersistenceException | DataAccessException e) {
	        log.error("코드 검증 중 오류 발생: type=" + type + ", code=" + code + " - " + e.getMessage(), e);
	        return false;
	    } catch (ClassCastException ce) {
	        log.error("형변환 실패: " + ce.getMessage(), ce);
	        return false;
	    }
	}
	
	/**
     * 모니터링 상태 등록
     *
     * @param param 상태 정보(Map 구조)
     * @throws DataAccessException insert 실패 시 발생
     */
	public void insertMonitorStatus(Map<String, Object> param) throws DataAccessException {
	    sqlSession.insert("modFloodQc.insertMonitorStatus", param);
	}
	
	/**
     * group_no 기준 모니터링 상태 조회
     *
     * @param param {"group_no": 값}
     * @return 상태 리스트
     * @throws DataAccessException select 실패 시 발생
     */
	public List<Map<String, Object>> selectMonitorStatus(Map<String, Object> param) throws DataAccessException {
	    return sqlSession.selectList("modFloodQc.selectMonitorStatus", param);
	}
	
	/**
     * 현재 DB의 group_no 중 가장 큰 값 조회
     *
     * @return 최대 group_no
     * @throws DataAccessException select 실패 시 발생
     */
	public int selectMaxGroupNo() throws DataAccessException {
		return sqlSession.selectOne("modFloodQc.selectMaxGroupNo");
	}
	
	/**
     * 특정 파일의 진행 상태 업데이트
     *
     * @param param {"group_no": 값, "data_id": 값, "progress": 퍼센트, "status_msg": 메시지, "complete_yn": 완료 여부}
     * @throws DataAccessException update 실패 시 발생
     */
	public void updateMonitorComplete(Map<String, Object> param) throws DataAccessException {
	    sqlSession.update("modFloodQc.updateMonitorComplete", param);
	}
	
	/**
     * 특정 group_no에 해당하는 data_id 목록 조회
     *
     * @param groupNo 그룹 번호
     * @return data_id 문자열 리스트
     * @throws DataAccessException select 실패 시 발생
     */
	public List<String> selectDataIdsByGroupNo(int groupNo) throws DataAccessException {
	    return sqlSession.selectList("modFloodQc.selectDataIdsByGroupNo", groupNo);
	}
	
}
