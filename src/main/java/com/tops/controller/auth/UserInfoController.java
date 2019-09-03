package com.tops.controller.auth;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.tops.controller.BaseController;
import com.tops.model.auth.AuthGroupInfo;
import com.tops.model.common.SearchParam;
import com.tops.model.user.UserInfo;
import com.tops.service.auth.AuthGroupInfoService;
import com.tops.service.main.UserInfoService;

@Controller
@RequestMapping("/auth")
public class UserInfoController extends BaseController
{
    @Autowired
	private UserInfoService userInfoService;

    @Autowired
	private AuthGroupInfoService authGroupInfoService;

	/**
	 * 사용자 목록 화면
	 */
	@RequestMapping(value = "/viewUserInfoList")
    public ModelAndView viewUserInfoList(ModelMap model) throws Exception
    {
		SearchParam search = new SearchParam();
		ModelAndView mv = new ModelAndView();	
		List<UserInfo> userInfoList = userInfoService.retrieveUserInfoList(search);
		mv.addObject("userInfoList", userInfoList);
		mv.setViewName("auth/userInfoList");
		
		return mv;
    }

	/**
	 * 사용자 조회 목록
	 */
	@RequestMapping(value = "/userInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView userInfoList(@RequestBody SearchParam search) throws Exception
    {
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		List<UserInfo> userInfoList = userInfoService.retrieveUserInfoList(search);

        mv.addObject("userInfoList", userInfoList);
		
        return mv;
    }

	/**
	 * 신규 사용자 등록 화면
	 */
	@RequestMapping(value = "/userInfoRegisterForm")
    public ModelAndView userInfoRegisterForm(ModelMap model) throws Exception
    {
		ModelAndView mv = new ModelAndView();

		List<AuthGroupInfo> authGroupInfoList = authGroupInfoService.retrieveAuthGroupInfoList();
		
        mv.addObject("userInfoRegisterFormAuthGroupInfoList", authGroupInfoList);

		mv.setViewName("auth/userInfoRegisterForm");
		
		return mv;
    }

	/**
	 * 신규 사용자 등록
	 */
	@RequestMapping(value = "/registerUserInfo")
	public @ResponseBody ModelAndView registerUserInfo(@RequestBody UserInfo userInfo) throws Exception
    {
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
	
		// sha-256 + salt(user id) 암호화 
		String hashedPassword = DigestUtils.sha256Hex(userInfo.getUser_id() + userInfo.getPassword());
		userInfo.setPassword(hashedPassword);

        boolean isSuccess = userInfoService.registerUserInfo(userInfo);

		mv.addObject("result", isSuccess);	

		return mv;
	}

	/**
	 * 사용자 정보 수정 화면
	 */
	@RequestMapping(value = "/userInfoModifyForm")
    public ModelAndView userInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
		ModelAndView mv = new ModelAndView();
	
		// 권한그룹조회
		List<AuthGroupInfo> authGroupInfoList = authGroupInfoService.retrieveAuthGroupInfoList();
        mv.addObject("userInfoRegisterFormAuthGroupInfoList", authGroupInfoList);
        
        // 사용자정보 조회
		UserInfo paramUserInfo = new UserInfo();
		paramUserInfo.setUser_id(request.getParameter("user_id"));
		UserInfo userInfo = userInfoService.getUserInfo(paramUserInfo);
		
		mv.addObject("userInfo", userInfo);
		mv.addObject("mode", "modify");

		mv.setViewName("auth/userInfoRegisterForm");
		
		return mv;
    }

	/**
	 * 사용자 정보 수정
	 */
	@RequestMapping(value = "/modifyUserInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView modifyUserInfo(@RequestBody UserInfo userInfo, HttpServletRequest request) throws Exception
    {
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		if(userInfo.getPassword() != null)
		{
			// sha-256 + salt(user id) 암호화 
	        String hashedPassword = DigestUtils.sha256Hex(userInfo.getUser_id() + userInfo.getPassword());
			userInfo.setPassword(hashedPassword);
		}

		boolean isSuccess = userInfoService.modifyUserInfo(userInfo);
		
		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 * 사용자 정보 삭제
	 */
	@RequestMapping(value = "/removeUserInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView removeUserInfo(@RequestBody UserInfo userInfo) throws Exception
    {
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = userInfoService.removeUserInfo(userInfo);
		
		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 * 사용자ID 중복체크
	 */
	@RequestMapping(value = "/checkUserId", method=RequestMethod.POST)
	public@ResponseBody ModelAndView checkUserId(@RequestBody UserInfo userInfo) throws Exception
    {
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

		boolean isSuccess = userInfoService.checkDupUserId(userInfo.getUser_id());

		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 * 사용자 비밀번호 sha-256 + userId 암호화
	 */
	@RequestMapping(value = "/convertPassword")
	public void modifyUserInfo(HttpServletRequest request) throws Exception
    {
		List<UserInfo> userInfoList = userInfoService.retrieveUserInfoList(null);

        for (UserInfo userInfo : userInfoList)
        {
            // 암호화 되지 않은 비밀번호만 암호화
            if (userInfo.getPassword().length() < 64)
            {
                userInfo.setPassword(DigestUtils.sha256Hex(userInfo.getUser_id() + userInfo.getPassword()));

                userInfoService.modifyUserInfo(userInfo);
            }
        }
    }
}