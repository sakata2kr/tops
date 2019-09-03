package com.tops.controller.auth;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
import com.tops.model.auth.MenuInfo;
import com.tops.model.auth.ResourceInfo;
import com.tops.model.common.SearchParam;
import com.tops.model.user.UserInfo;
import com.tops.service.auth.MenuInfoService;
import com.tops.service.auth.ResourceInfoService;

@Controller
@RequestMapping("/auth")
public class MenuInfoController extends BaseController
{
    @Autowired
	private MenuInfoService menuInfoService;

    @Autowired
	private ResourceInfoService resourceInfoService;
	
	/**
	 * 메뉴 정보 목록 화면
	 */
	@RequestMapping(value = "/viewMenuInfoList")
    public ModelAndView viewMenuInfoList(HttpServletRequest request, ModelMap model) throws Exception
	{
		ModelAndView mv = new ModelAndView();

        HttpSession session = request.getSession();
        UserInfo sessionUserInfo = (UserInfo)session.getAttribute("sessUserInfo");

		List<MenuInfo> menuInfoList = menuInfoService.retrieveMenuInfoList(sessionUserInfo.getUser_group_id());

		mv.addObject("menuInfoList", menuInfoList);
		mv.setViewName("auth/menuInfoList");
		
		return mv;
    }

	/**
	 * 메뉴 정보 조회
	 */
	@RequestMapping(value = "/menuInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView menuInfoList(HttpServletRequest request) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        HttpSession session = request.getSession();
        UserInfo sessionUserInfo = (UserInfo)session.getAttribute("sessUserInfo");

		List<MenuInfo> menuInfoList = menuInfoService.retrieveMenuInfoList(sessionUserInfo.getUser_group_id());
		
        mv.addObject("menuInfoList", menuInfoList);
		
        return mv;
    }

	/**
	 * 메뉴정보 등록 화면
	 */
	@RequestMapping(value = "/menuInfoRegisterForm")
    public ModelAndView menuInfoRegisterForm(ModelMap model) throws Exception
	{
		return new ModelAndView();
    }
	
	/**
	 * 메뉴정보 등록
	 */
	@RequestMapping(value = "/registerMenuInfo")
	public @ResponseBody ModelAndView registerMenuInfo(@RequestBody MenuInfo menuInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		boolean isSuccess = menuInfoService.registerMenuInfo(menuInfo);

		mv.addObject("result", isSuccess);

		return mv;
	}

	/**
	 * 메뉴 정보 수정
	 */
	@RequestMapping(value = "/modifyMenuInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView modifyMenuInfo(@RequestBody MenuInfo menuInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		boolean isSuccess = menuInfoService.modifyMenuInfo(menuInfo);
		
		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 * 메뉴 정보 삭제
	 */
	@RequestMapping(value = "/removeMenuInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView removeMenuInfo(@RequestBody MenuInfo menuInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		boolean isSuccess = menuInfoService.removeMenuInfo(menuInfo);
		
		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 *  메뉴 리소스 정보 등록 화면
	 */
	@RequestMapping(value = "/menuInfoResourceInfoList")
    public ModelAndView menuInfoResourceInfoList(HttpServletRequest request, ModelMap model) throws Exception
	{
		ModelAndView mv = new ModelAndView();

		mv.addObject("menuResourceId", request.getParameter("menuResourceId"));
		
		mv.setViewName("auth/menuInfoResourceInfoList");
		
		return mv;
    }

	/**
	 * 메뉴 리소스 정보 조회
	 */
	@RequestMapping(value = "/menuResourceInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView menuResourceInfoList(@RequestBody SearchParam search) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		List<ResourceInfo> resourceInfoList = resourceInfoService.retrieveResourceInfoList(search);
				
        mv.addObject("menuResourceInfoList", resourceInfoList);
        
        return mv;
    }
}