package com.tops.controller.main;

import com.tops.controller.BaseController;
import com.tops.model.user.UserInfo;
import com.tops.service.main.LoginService;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.digest.DigestUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class LoginController extends BaseController
{
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private LoginService loginService;

    @RequestMapping("/")
    public String index()
    {
        return "main/login";
    }

	/**
	 * 로그인페이지로 이동
	 */
	@RequestMapping(value="/login", method = RequestMethod.GET)
    public String loginGet(HttpServletRequest request) throws Exception
    {
		return "main/login";
    }
	
	/**
	 * 비밀번호 체크및 세션생성
	 */
	@RequestMapping(value = "/login", method = RequestMethod.POST)
    public String loginCheck(HttpServletRequest request) throws Exception
    {
        HttpSession session = request.getSession();

	    if ( session.getAttribute("sessUserInfo") != null )
	    {
	        session.removeAttribute("sessUserInfo");
	    }

		UserInfo rtnUserInfo = loginService.getUserInfo(request.getParameter("userId"));

        if ( rtnUserInfo != null && rtnUserInfo.getPassword().equals(DigestUtils.sha256Hex(request.getParameter("passWord") + "{" + request.getParameter("userId") + "}")) )
        {
            rtnUserInfo.setIpAddr(request.getRemoteAddr());       // 조회 정보에 IP 정보 추가
            session.setAttribute("sessUserInfo", rtnUserInfo);    // 로그인 접속 정보 저장

            return "redirect:/main/mainPage";
		}
        else
        {
            logger.warn("Login Fail : {} {}", request.getParameter("userId"), DigestUtils.sha256Hex(request.getParameter("passWord") + "{" + request.getParameter("userId") + "}"));

            return "redirect:/login?error=1";
        }
	}
	
	/**
	 * 로그아웃
	 */
	@RequestMapping(value="/login/logOut", method=RequestMethod.GET)
    public String logOut(HttpSession httpsession)
    {
	    httpsession.invalidate();
	    return "redirect:/login";
	}
}