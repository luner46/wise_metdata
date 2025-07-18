package kr.co.wisesys.common.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;


public class Interceptor implements HandlerInterceptor {

	
	private final Logger log = LoggerFactory.getLogger(getClass());
	
	@Value("#{config['ipWhiteList']}") private String configIpList;
	
	// preHandle
	// : 컨트롤러로 request 들어가기 전에 수행
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
	    String ip = request.getRemoteAddr();

	    for (String prefix : configIpList.split(",")) {
	        if (ip.startsWith(prefix.trim())) {
	            return true;
	        }
	    }

	    response.sendError(HttpServletResponse.SC_FORBIDDEN, "허용되지 않은 IP: " + ip);
	    return false;
	}
	
	// postHandle
	// : 컨트롤러 실행 후, 뷰 실행 전
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
		//log.info("[postHandle]");
	}
	
	// afterCompletion
	// : 뷰(화면) response 끝난 후 실행
	@Override
	public void afterCompletion (HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
		
		
		//log.info("[afterCompletion]");
	}
	
}
