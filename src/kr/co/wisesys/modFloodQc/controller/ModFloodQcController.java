package kr.co.wisesys.modFloodQc.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.wisesys.modFloodQc.service.ModFloodQcService;

/**
 * <pre>
 * @ClassName   : ModFloodQcController.java
 * @Description : 홍수위험지도 정보시스템 검수프로그램 모듈 컨트롤러
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

@Controller
@RequestMapping(value={"/modFloodQc/*"})
public class ModFloodQcController {
	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ModFloodQcService service;
	
	/**
	 * 메인 뷰 페이지
	 * 
	 * @author 김민수
	 * @return view
	 */
	@RequestMapping(value = "/modFloodQc.do")
	public String selectmodFloodQc() throws IllegalStateException {
        try {
            return "modFloodQc/modFloodQc";
        } catch (IllegalStateException e) {
            log.error("메인 페이지 로딩 실패", e);
            throw e;
        }
    }
	
	/**
     * 모니터링 페이지 진입 시 group_no 파라미터 처리
     *
     * @param groupNo 요청된 group_no (없으면 maxGroupNo로 대체)
     * @param model JSP에 전달할 모델 객체
     * @return 모니터링 JSP 경로
     * @throws RuntimeException group_no 조회 실패 시
     */
	@RequestMapping(value = "/modFloodMonitoring.do")
    public String modFloodMonitoring(@RequestParam(value = "group_no", required = false) Integer groupNo, Model model) {
        try {
            if (groupNo == null) {
                groupNo = service.maxGroupNo();
            }
            model.addAttribute("groupNo", groupNo);
            return "modFloodQc/modFloodMonitoring";
        } catch (NullPointerException | IllegalArgumentException e) {
            log.error("모니터링 페이지 group_no 처리 중 오류", e);
            throw e;
        }
    }
	
	/**
     * shp 코드 유효성 검증
     *
     * @param paramList 요청된 데이터 목록
     * @return 유효성 검증 결과 리스트
     * @throws IllegalArgumentException JSON 구조 문제 등 파라미터 오류
     * @throws DataAccessException DB 조회 중 문제
     */
	@PostMapping(value = "/checkShpCodeValid.do")
	@ResponseBody
	public List<Map<String, Object>> checkShpCodeValid(@RequestBody List<Map<String, Object>> paramList) {
        try {
            return service.checkShpCodeValid(paramList);
        } catch (IllegalArgumentException e) {
            log.error("요청 JSON 구조 오류", e);
            throw e;
        } catch (DataAccessException e) {
            log.error("DB 조회 오류", e);
            throw e;
        }
    }

	/**
     * 검수 상태 조회
     *
     * @param groupNo group_no (없으면 max 사용)
     * @return 상태 리스트
     * @throws DataAccessException DB 접근 중 오류
     */
	@GetMapping("/statusMonitoring.do")
	@ResponseBody
	public List<Map<String, Object>> getMonitoringStatus(@RequestParam(value = "group_no", required = false) Integer groupNo) {
        try {
            if (groupNo == null) {
                groupNo = service.maxGroupNo();
            }
            Map<String, Object> param = new HashMap<>();
            param.put("group_no", groupNo);
            return service.selectMonitorStatus(param);
        } catch (DataAccessException e) {
            log.error("검수 상태 조회 실패", e);
            throw e;
        }
    }
	
	/**
     * 면적 역전 검수 실행
     *
     * @param dataIdList 선택된 data_id 리스트
     * @return group_no와 결과 상태 반환
     * @throws IllegalStateException 검수 시작 또는 실행 중 오류
     */
	@PostMapping("/runAreaReverseCheck.do")
	@ResponseBody
	public Map<String, Object> runAreaReverseCheck(@RequestBody List<String> dataIdList) {
        Map<String, Object> result = new HashMap<>();

        try {
            int groupNo = service.startAreaReverseCheck(dataIdList);

            new Thread(() -> {
                try {
                    service.runAreaReverseCheck(groupNo);
                } catch (RuntimeException e) {
                    log.error("비동기 검수 실행 중 오류", e);
                }
            }).start();

            result.put("success", true);
            result.put("group_no", groupNo);
        } catch (IllegalArgumentException e) {
            log.error("파라미터 오류", e);
            result.put("success", false);
            result.put("message", "요청 데이터 형식 오류");
        } catch (DataAccessException e) {
            log.error("DB 처리 오류", e);
            result.put("success", false);
            result.put("message", "DB 처리 중 오류 발생");
        }

        return result;
    }
	
	/**
	 * 모니터링 프로세스 상태 제어 API (start/stop)
	 *
	 * @param param group_no, action
	 * @return 상태 응답 JSON
	 */
	@PostMapping("/controlProc.do")
	@ResponseBody
	public Map<String, Object> controlProc(@RequestBody Map<String, Object> param) {
	    Map<String, Object> result = new HashMap<>();

	    try {
	        int groupNo = Integer.parseInt(param.get("group_no").toString());
	        String action = param.get("action").toString(); 

	        service.controlStatus(groupNo, action); 

	        result.put("success", true);
	        result.put("message", "프로세스 제어 성공 (" + action + ")");
	    } catch (IllegalArgumentException e) {
	        result.put("success", false);
	        result.put("message", "입력값 오류: " + e.getMessage());
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", "서버 오류: " + e.getMessage());
	    }

	    return result;
	}
	
	/**
	 * 면적 역전 검수 중지 요청
	 *
	 * @param param 중지할 group_no를 포함한 요청 파라미터
	 * @return 중지 요청 결과 응답 (성공 여부 및 메시지)
	 */
	@PostMapping("/stopAreaReverseCheck.do")
	@ResponseBody
	public Map<String, Object> stopAreaReverseCheck(@RequestBody Map<String, Object> param) {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        int groupNo = Integer.parseInt(param.get("group_no").toString());
	        service.requestStop(groupNo);

	        result.put("success", true);
	        result.put("message", "중지 요청 완료");
	    } catch (NumberFormatException e) {
	        result.put("success", false);
	        result.put("message", "group_no는 숫자여야 합니다.");
	    } catch (IllegalArgumentException e) {
	        result.put("success", false);
	        result.put("message", "입력 오류: " + e.getMessage());
	    } catch (DataAccessException e) {
	        result.put("success", false);
	        result.put("message", "DB 처리 중 오류: " + e.getMessage());
	    } catch (Exception e) {
	        result.put("success", false);
	        result.put("message", "알 수 없는 서버 오류: " + e.getMessage());
	    }
	    return result;
	}
	
}
