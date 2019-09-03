package com.tops.controller.auth;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

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
import com.tops.service.auth.AuthGroupInfoService;
import com.tops.service.auth.ResourceAccessInfoService;

@Controller
@RequestMapping("/auth")
public class AuthGroupInfoController extends BaseController
{
    @Autowired
    private AuthGroupInfoService authGroupInfoService;

    @Autowired
    private ResourceAccessInfoService resourceAccessInfoService;

    /**
     * 권한그룹 정보 목록 화면
     */

    @RequestMapping(value = "/viewAuthGroupInfoList")
    public ModelAndView viewAuthGroupInfoList(ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();
        List<AuthGroupInfo> authGroupInfoList = authGroupInfoService.retrieveAuthGroupInfoList();

        mv.addObject("authGroupInfoList", authGroupInfoList);
        mv.setViewName("auth/authGroupInfoList");

        return mv;
    }

    /**
     * 권한그룹 정보 조회
     */
    @RequestMapping(value = "/authGroupInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView authGroupInfoList() throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<AuthGroupInfo> authGroupInfoList = authGroupInfoService.retrieveAuthGroupInfoList();

        mv.addObject("authGroupInfoList", authGroupInfoList);

        return mv;
    }

    /**
     * 권한그룹 정보 등록 화면
     */
    @RequestMapping(value = "/authGroupInfoRegisterForm")
    public ModelAndView authGroupInfoRegisterForm(ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("auth/authGroupInfoRegisterForm");

        return mv;
    }

    /**
     * 권한그룹 정보 등록
     */
    @RequestMapping(value = "/registerAuthGroupInfo")
    public @ResponseBody ModelAndView registerAuthGroupInfo(@RequestBody AuthGroupInfo authGroupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 중복 체크
		boolean isSuccess = authGroupInfoService.checkDupAuthGroupInfo(authGroupInfo);

        mv.addObject("dupcheck", isSuccess);

		if (!isSuccess)
		{
            isSuccess = authGroupInfoService.registerAuthGroupInfo(authGroupInfo);
		}

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 권한그룹 정보 수정 화면
     */
    @RequestMapping(value = "/authGroupInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView authGroupInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        AuthGroupInfo authGroupInfo = authGroupInfoService.retrieveAuthGroupInfo(request.getParameter("auth_group_id"));
        mv.addObject("authGroupInfo", authGroupInfo);
        mv.addObject("mode", "modify");

        mv.setViewName("auth/authGroupInfoRegisterForm");

        return mv;
    }

    /**
     * 권한그룹 정보 수정
     */
    @RequestMapping(value = "/modifyAuthGroupInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView modifyAuthGroupInfo(@RequestBody AuthGroupInfo authGroupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

		boolean isSuccess = authGroupInfoService.modifyAuthGroupInfo(authGroupInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 권한그룹 정보 삭제
     */
    @RequestMapping(value = "/removeAuthGroupInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView removeAuthGroupInfo(@RequestBody AuthGroupInfo authGroupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 삭제할 권한그룹에 속하는 사용자가 있으면 error_code = 1
        boolean isSuccess = authGroupInfoService.retrieveUserNumByAuthGroupId(authGroupInfo);

        if(isSuccess)
        {
            // 접근권한정보에서 해당 그룹과 매핑된 데이터 삭제
            resourceAccessInfoService.removeResourceAccessInfo(authGroupInfo.getAuth_group_id());

            isSuccess = authGroupInfoService.removeAuthGroupInfo(authGroupInfo);

        }
        else
        {
            mv.addObject("error_code", "1");
        }

        mv.addObject("result", isSuccess);

        return mv;
    }
}