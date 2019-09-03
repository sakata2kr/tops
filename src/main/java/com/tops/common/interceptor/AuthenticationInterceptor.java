package com.tops.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.tops.model.user.UserInfo;
import com.tops.service.auth.ResourceAccessInfoService;

public class AuthenticationInterceptor extends HandlerInterceptorAdapter
{
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ResourceAccessInfoService resourceAccessInfoService;

	//Handler 처리 시작 시간 추가 및 권한 확인
    @Override
	public boolean preHandle( HttpServletRequest request, HttpServletResponse response, Object handler ) throws Exception
    {
        HttpSession session = request.getSession();

        if (session.getAttribute("sessUserInfo") == null)
        {
            response.sendRedirect("/login");
            return false;
        }

        /** 접속계정의 권한 별 URL 접속 여부 확인
         *  1. 계정의 권한이 ADMIN인 경우 무조건 PASS
         *  2. 접속 URI가 /main으로 시작하는 경우 무조건 PASS
         *  3. 계정에 매핑한 권한의 context Path가 등록된 context Path인 경우 PASS
         *  그 외의 경우 reject 처리
         **/
        UserInfo userInfo = ((UserInfo)session.getAttribute("sessUserInfo"));

        if ( !userInfo.getUser_group_id().equals("ADMIN")
          && !request.getRequestURI().equals("/error")
          && !request.getRequestURI().substring(0, 5).equals("/main")
          && !resourceAccessInfoService.validUserResourceAccess(userInfo.getUser_id(), request.getRequestURI()) )
        {
            logger.warn("{} {} {}", userInfo.getUser_id(), userInfo.getUser_group_id(), request.getRequestURI());
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "URL 접속 권한이 없습니다.");
            return false;
        }

        return true;
	}
}