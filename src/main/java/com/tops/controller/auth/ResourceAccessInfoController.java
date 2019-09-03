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
import com.tops.model.auth.ResourceAccessInfo;
import com.tops.model.common.SearchParam;
import com.tops.model.user.UserInfo;
import com.tops.service.auth.AuthGroupInfoService;
import com.tops.service.auth.ResourceAccessInfoService;

@Controller
@RequestMapping("/auth")
public class ResourceAccessInfoController extends BaseController
{
    @Autowired
    private ResourceAccessInfoService resourceAccessInfoService;

    @Autowired
    private AuthGroupInfoService authGroupInfoService;

    /**
     * 리소스 접근 정보 목록 화면
     */
    @RequestMapping(value = "/viewResourceAccessInfoList")
    public ModelAndView viewResourceAccessInfoList(HttpServletRequest request, ModelMap model) throws Exception
    {
        SearchParam search = new SearchParam();
        ModelAndView mv = new ModelAndView();

        UserInfo sessionUserInfo = (UserInfo)request.getSession().getAttribute("sessUserInfo");

        logger.debug("viewResourceAccessInfoList sessionUserInfo : {}", sessionUserInfo.getUser_group_id());
        search.setSearchWord(sessionUserInfo.getUser_group_id());

        List<ResourceAccessInfo> resourceAccessInfoList = resourceAccessInfoService.retrieveResourceAccessInfoList(search);

        // 권한그룹 목록(select box)
        List<AuthGroupInfo> authGroupInfoList = authGroupInfoService.retrieveAuthGroupInfoList();

        mv.addObject("resourceAccessInfoList", resourceAccessInfoList);
        mv.addObject("resourceAccessInfoAuthGroupInfoList", authGroupInfoList);

        mv.setViewName("auth/resourceAccessInfoList");

        return mv;
    }

    /**
     * 리소스 접근 정보 조회
     */
    @RequestMapping(value = "/resourceAccessInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView resourceAccessInfoList(@RequestBody SearchParam search) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<ResourceAccessInfo> resourceAccessInfoList = resourceAccessInfoService.retrieveResourceAccessInfoList(search);

        mv.addObject("resourceAccessInfoList", resourceAccessInfoList);

        return mv;
    }

    /**
     * 리소스접근정보 등록
     */
    @RequestMapping(value = "/registerResourceAccessInfo")
    public @ResponseBody ModelAndView registerResourceAccessInfo(@RequestBody List<String> resourceAccessInfoList) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = false;
        int successCount = 0;
        ResourceAccessInfo resourceAccessInfo;

        // ADMIN 권한 이외의 권한에 대해서는 기존 권한정보 삭제 및 추가 구성 처리
        if(resourceAccessInfoList != null && !resourceAccessInfoList.get(0).split("\\|")[1].toUpperCase().equals("ADMIN"))
        {
            // 권한그룹id로 접근정보 삭제
            resourceAccessInfoService.removeResourceAccessInfo(resourceAccessInfoList.get(0).split("\\|")[1]);

            for (String resourceAccessInfoListStr : resourceAccessInfoList)
            {
                String[] tmpArr = resourceAccessInfoListStr.split("\\|");

                resourceAccessInfo = new ResourceAccessInfo();
                resourceAccessInfo.setResource_id(tmpArr[0]);
                resourceAccessInfo.setAuth_group_id(tmpArr[1]);
                resourceAccessInfo.setAccess_yn(tmpArr[2]);

                //insert
                if (resourceAccessInfoService.registerResourceAccessInfo(resourceAccessInfo))
                {
                    successCount++;
                }
            }
        }

        if (resourceAccessInfoList != null && successCount == resourceAccessInfoList.size())
        {
            isSuccess = true;
        }

        mv.addObject("result", isSuccess);

        return mv;
    }
}