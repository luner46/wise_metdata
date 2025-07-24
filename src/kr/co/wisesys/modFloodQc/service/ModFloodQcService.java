package kr.co.wisesys.modFloodQc.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.jcraft.jsch.ChannelExec;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;

import kr.co.wisesys.modFloodQc.dao.ModFloodQcDao;

/**
 * <pre>
 * @ClassName   : ModFloodQcService.java
 * @Description : 홍수위험지도 정보시스템 검수프로그램 모듈 서비스
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

@Configuration
@Service
public class ModFloodQcService {
	
	@Autowired
	private ModFloodQcDao dao;
	
	private final Logger log = Logger.getLogger(getClass());
	private final Map<Integer, Boolean> stopSignalMap = new ConcurrentHashMap<>();
	
	@Value("#{config['host']}") private String host;
	@Value("#{config['port']}") private int port;
	@Value("#{config['user']}") private String user;
	@Value("#{config['password']}") private String password;
	
	/**
     * 전달받은 데이터 리스트를 기반으로 코드 유효성 검증 수행
     *
     * @param dataList JSON으로부터 매핑된 데이터 리스트
     * @return 검증 결과 리스트
     */
	public List<Map<String, Object>> checkShpCodeValid(List<Map<String, Object>> dataList) {
        List<Map<String, Object>> results = new ArrayList<>();
        int groupNo;

        try {
            groupNo = dao.selectMaxGroupNo() + 1;
        } catch (DataAccessException e) {
            log.error("DB에서 max group_no 조회 중 오류", e);
            return results;
        }

        for (Map<String, Object> data : dataList) {
            try {
                String type = (String) data.get("type");
                String data_id = (String) data.get("data_id");
                String freq = (String) data.get("freq");
                String code = (String) data.get("code");

                boolean isValid = false;

                switch (type) {
                    case "SGG":
                    case "SAREA":
                    case "SBSN":
                        isValid = dao.checkShpCodeValid(type, code);
                        break;
                    case "ALL":
                        isValid = dao.checkShpCodeValid("ALL", freq);
                        break;
                    default:
                        log.warn("알 수 없는 타입: " + type);
                        break;
                }

                Map<String, Object> resultMap = new HashMap<>();
                resultMap.put("data_id", data_id);
                resultMap.put("type", type);
                resultMap.put("freq", freq);
                resultMap.put("code", code);
                resultMap.put("valid", isValid);
                results.add(resultMap);

                if (isValid) {
                    Map<String, Object> procResult = new HashMap<>();
                    procResult.put("group_no", groupNo);
                    procResult.put("data_id", data_id);
                    procResult.put("complete_yn", "y");
                    procResult.put("type", type);
                    procResult.put("freq", freq);
                    procResult.put("code", code);
                    procResult.put("status_msg", "완료");
                }

            } catch (ClassCastException | NullPointerException e) {
                log.error("데이터 매핑 오류", e);
            } catch (DataAccessException e) {
                log.error("DB insert 중 오류", e);
            }
        }

        return results;
    }
    
	/**
     * 모니터링 테이블에서 최신 group_no 기준 상태 리스트 조회
     * @return 상태 리스트
     */
	public List<Map<String, Object>> selectMonitorStatus(Map<String, Object> param) {
        try {
            return dao.selectMonitorStatus(param);
        } catch (DataAccessException e) {
            log.error("모니터링 상태 조회 중 DB 오류", e);
            return new ArrayList<>();
        }
    }
    
    /**
     * 면적 역전 검수 시작 전 상태 초기화 및 group_no 생성
     * @param dataIdList 검수 대상 data_id 목록
     * @return 생성된 group_no
     */
	public int startAreaReverseCheck(List<String> dataIdList) {
        int groupNo;

        try {
            groupNo = dao.selectMaxGroupNo() + 1;

            for (String dataId : dataIdList) {
                Map<String, Object> proc = new HashMap<>();
                proc.put("data_id", dataId);
                proc.put("group_no", groupNo);
                proc.put("complete_yn", "n");
                proc.put("status_msg", "대기중");
                proc.put("progress", 0);
                proc.put("elapsed_sec", 0);
                dao.insertMonitorStatus(proc);
            }
        } catch (DataAccessException e) {
            log.error("면적 역전 초기 상태 저장 중 DB 오류", e);
            throw e;
        }

        return groupNo;
    }
    
	/**
	 * 검수 상태 기준으로 가장 큰 group_no 값을 반환
	 *
	 * @return 최신 group_no 값, 오류 시 -1 반환
	 */
    public int maxGroupNo() {
        try {
            return dao.selectMaxGroupNo();
        } catch (DataAccessException e) {
            log.error("max group_no 조회 중 오류", e);
            return -1;
        }
    }
    
    /**
     * 면적 역전 검수 실행 (비동기)
     */
    public void runAreaReverseCheck(int groupNo) {
        List<String> dataIdList;

        try {
            dataIdList = dao.selectDataIdsByGroupNo(groupNo);
        } catch (DataAccessException e) {
            log.error("group_no에 따른 data_id 조회 오류", e);
            return;
        }

        for (String dataId : dataIdList) {
            for (int p = 10; p <= 100; p += 10) {

                if (stopSignalMap.getOrDefault(groupNo, false)) {
                    //log.info("검수 중지 요청됨 (중간 중단). groupNo: " + groupNo + ", dataId: " + dataId + ", progress: " + p + "%");
                    return;
                }

                try {
                    String statusMsg = (p < 100) ? "진행중 (" + p + "%)" : "완료";

                    Map<String, Object> updateMap = new HashMap<>();
                    updateMap.put("group_no", groupNo);
                    updateMap.put("data_id", dataId);
                    updateMap.put("complete_yn", (p < 100) ? "n" : "y");
                    updateMap.put("status_msg", statusMsg);
                    updateMap.put("progress", p);

                    dao.updateMonitorComplete(updateMap);

                    Thread.sleep(1000);

                } catch (DataAccessException e) {
                    log.error("검수 상태 업데이트 중 DB 오류", e);
                } catch (InterruptedException e) {
                    log.warn("검수 실행 중 인터럽트 발생", e);
                    Thread.currentThread().interrupt();
                    return;
                }
            }
        }
    }
    
    /**
     * 주어진 groupNo에 대한 검수 중지 요청 플래그 설정
     *
     * @param groupNo 중지 요청할 group 번호
     */
    public void requestStop(int groupNo) {
        stopSignalMap.put(groupNo, true);
    }
    
    /**
     * 셸 스크립트를 통해 검수 프로세스를 제어 (start 또는 stop)
     *
     * @param groupNo 대상 그룹 번호
     * @param action 실행할 작업 (예: "start" 또는 "stop")
     * @throws RuntimeException 셸스크립트 실행 중 오류 발생 시
     */
    public void controlStatus(int groupNo, String action) {
        String cmd = "/bin/sh /data1/_wisesys_utils/test_monitoring_status/select_system_status.sh " + groupNo + " " + action;

        Session session = null;
        ChannelExec channel = null;
        BufferedReader reader = null;

        try {
            JSch jsch = new JSch();
            session = jsch.getSession(user, host, port);
            session.setPassword(password);
            session.setConfig("StrictHostKeyChecking", "no");
            session.connect();

            channel = (ChannelExec) session.openChannel("exec");
            channel.setCommand(cmd);
            channel.setInputStream(null);
            channel.setErrStream(System.err);
            reader = new BufferedReader(new InputStreamReader(channel.getInputStream(), "EUC-KR"));
            channel.connect();

            String line;
            while ((line = reader.readLine()) != null) {
                //log.info("[Shell Output] " + line);
            }

        } catch (Exception e) {
            throw new RuntimeException("셸스크립트 실행 오류", e);
        } finally {
            try {
                if (reader != null) reader.close();
                if (channel != null) channel.disconnect();
                if (session != null) session.disconnect();
            } catch (IOException e) {
                log.error("리소스 정리 오류", e);
            }
        }

        if ("stop".equalsIgnoreCase(action)) {
            requestStop(groupNo);
        } else if ("start".equalsIgnoreCase(action)) {
            stopSignalMap.put(groupNo, false);
            
            new Thread(() -> runAreaReverseCheck(groupNo)).start();
        }
    }
    
}
