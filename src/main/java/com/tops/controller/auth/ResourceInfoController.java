package com.tops.controller.auth;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.method.RequestMappingInfo;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.tops.controller.BaseController;
import com.tops.model.auth.ResourceInfo;
import com.tops.model.common.SearchParam;
import com.tops.service.auth.ResourceInfoService;

@Controller
@RequestMapping("/auth")
public class ResourceInfoController extends BaseController
{
    @Autowired
    private ResourceInfoService resourceInfoService;

    @Autowired
    private ApplicationContext appContext;

    /**
     * 리소스 정보 목록 화면
     */
    @RequestMapping(value = "/viewResourceInfoList")
    public ModelAndView viewResourceInfoList(ModelMap model) throws Exception
    {
        SearchParam search = new SearchParam();
        ModelAndView mv = new ModelAndView();
        List<ResourceInfo> resourceInfoList = resourceInfoService.retrieveResourceInfoList(search);

        mv.addObject("resourceInfoList", getMergedResourceInfoList(resourceInfoList, search));
        mv.setViewName("auth/resourceInfoList");

        return mv;
    }

    /**
     * 리소스 정보 조회
     */
    @RequestMapping(value = "/resourceInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView resourceInfoList(@RequestBody SearchParam search) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<ResourceInfo> resourceInfoList = resourceInfoService.retrieveResourceInfoList(search);

        resourceInfoList = getMergedResourceInfoList(resourceInfoList, search);

        mv.addObject("resourceInfoList", resourceInfoList);

        return mv;
    }

    // spring class 목록과 db 목록  merge
    private List<ResourceInfo> getMergedResourceInfoList(List<ResourceInfo> list, SearchParam search)
    {
        Map<String, ResourceInfo> regResourceMap = getResourceInfoMap(list);

        list.clear();

        ResourceInfo tmpResourceInfo;

        RequestMappingHandlerMapping handlerMethodsMappings = appContext.getBean(RequestMappingHandlerMapping.class);

        Map<RequestMappingInfo, HandlerMethod> handlerMethods = handlerMethodsMappings.getHandlerMethods();

        for(Entry<RequestMappingInfo, HandlerMethod> item : handlerMethods.entrySet())
        {
            RequestMappingInfo mapping = item.getKey();
            HandlerMethod method = item.getValue();

            for(String urlPattern : mapping.getPatternsCondition().getPatterns())
            {
                // 로그인/로그아웃은 제외
                if(!urlPattern.equals("/login") && !urlPattern.equals("/login/logOut"))
                {
                    tmpResourceInfo = regResourceMap.get(urlPattern);

                    if(tmpResourceInfo == null)
                    {
                        if(search != null && search.getSearchWord() != null && !search.getSearchWord().equals(""))
                        {
                            // 리소스 경로는 서버 등록 class 목록도 조회해본다. 아니면 pass
                            if(!(search.getSearchOption().equals("02") && urlPattern.contains(search.getSearchWord())))
                            {
                                continue;
                            }
                        }

                        tmpResourceInfo = new ResourceInfo();
                        tmpResourceInfo.setResource_name("DB 미등록 Resource입니다.");
                        tmpResourceInfo.setResource_path(urlPattern);
                    }

                    tmpResourceInfo.setResource_bean_name(method.getBeanType().getName() + "." + method.getMethod().getName());

                    list.add(tmpResourceInfo);
                }
            }
        }

        return list;
    }

    private Map<String, ResourceInfo> getResourceInfoMap(List<ResourceInfo> list)
    {
        Map<String, ResourceInfo> map = new HashMap<>();

        for (ResourceInfo resourceInfo : list)
        {
            map.put(resourceInfo.getResource_path(), resourceInfo);
        }

        return map;
    }

    /**
     * 리소스 등록 화면
     */
    @RequestMapping(value = "/resourceInfoRegisterForm")
    public ModelAndView resourceInfoRegisterForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("auth/resourceInfoRegisterForm");

        mv.addObject("resourcePath", request.getParameter("resource_path"));

        return mv;
    }

    /**
     * 리소스 등록
     */
    @RequestMapping(value = "/registerResourceInfo")
    public @ResponseBody ModelAndView registerResourceInfo(@RequestBody ResourceInfo resourceInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = resourceInfoService.registerResourceInfo(resourceInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 리소스 수정 화면
     */
    @RequestMapping(value = "/resourceInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView resourceInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        ResourceInfo resourceInfo = resourceInfoService.retrieveResourceInfo(request.getParameter("resource_id"));
        mv.addObject("resourceInfo", resourceInfo);
        mv.addObject("mode", "modify");

        mv.setViewName("auth/resourceInfoRegisterForm");

        return mv;
    }

    /**
     * 리소스 정보 수정
     */
    @RequestMapping(value = "/modifyResourceInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView modifyResourceInfo(@RequestBody ResourceInfo resourceInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = resourceInfoService.modifyResourceInfo(resourceInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 리소스 정보 삭제
     */
    @RequestMapping(value = "/removeResourceInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView removeResourceInfo(@RequestBody ResourceInfo resourceInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 삭제할 리소스가 메뉴에 등록되어 있으면 true
        boolean isSuccess = resourceInfoService.checkResourceInfoBind(resourceInfo);

        mv.addObject("menu_exist", isSuccess);        

        if(!isSuccess)
        {
            // 리소스 정보 삭제
        	isSuccess = resourceInfoService.removeResourceInfo(resourceInfo);

        	if (isSuccess)
        	{
                // 접근권한정보에서 해당 리소스와 매핑된 데이터 삭제
                resourceInfoService.removeResourceAccessInfoByResourceId(resourceInfo);
        	}

            mv.addObject("result", isSuccess);
        }

        return mv;
    }
}