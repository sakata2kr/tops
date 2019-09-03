package com.tops.controller.flow;

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
import com.tops.model.flow.BpGroupInfo;
import com.tops.model.flow.SystemInfo;
import com.tops.service.flow.BpGroupInfoService;
import com.tops.service.flow.SystemInfoService;

@Controller
@RequestMapping("/flow")
public class BpGroupInfoController extends BaseController
{
    @Autowired
	private BpGroupInfoService bpGroupInfoService;
	
    @Autowired
	private SystemInfoService systemInfoService;

	/**
	 * BP GROUP 정보 조회
	 */
	@RequestMapping(value = "/bpGroupInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView bpGroupInfoList() throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

		List<BpGroupInfo> bpGroupInfoList = bpGroupInfoService.retrieveBpGroupInfoList();
		
		mv.addObject("bpGroupInfoList", bpGroupInfoList);
		
        return mv;
    }
	
	/**
	 *  BP GROUP 정보 등록 화면
	 */
	@RequestMapping(value = "/bpGroupInfoRegisterForm", method=RequestMethod.GET)
    public ModelAndView bpGroupInfoRegisterForm(HttpServletRequest request, ModelMap model) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		// LOGICAL GROUP ID 조회
		List<SystemInfo> logicalGroupInfoList = systemInfoService.retrieveLogicalGroupInfoList();
		mv.addObject("logicalGroupInfoList", logicalGroupInfoList);
		
		mv.setViewName("flow/bpGroupInfoRegisterForm");
		
		return mv;
    }

	/**
	 * BP GROUP 정보 등록
	 */
	@RequestMapping(value = "/registerBpGroupInfo", method=RequestMethod.POST)
	public @ResponseBody ModelAndView registerBpGroupInfo(@RequestBody BpGroupInfo bpGroupInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		// BP GROUP 정보 저장
		boolean isSuccess = bpGroupInfoService.registerBpGroupInfo(bpGroupInfo);

		mv.addObject("result", isSuccess);

		return mv;
	}

	/**
	 *  BP GROUP 정보 수정 화면
	 */
	@RequestMapping(value = "/bpGroupInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView bpGroupInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		// BP GROUP 정보 조회
		String bpGroupId = request.getParameter("bp_group_id");
		BpGroupInfo bpGroupInfo = bpGroupInfoService.retrieveBpGroupInfo(bpGroupId);
		mv.addObject("bpGroupInfo", bpGroupInfo);
		
		mv.addObject("mode", "modify");
		
		// LOGICAL GROUP ID 조회
		List<SystemInfo> logicalGroupInfoList = systemInfoService.retrieveLogicalGroupInfoList();
		mv.addObject("logicalGroupInfoList", logicalGroupInfoList);
		
		mv.setViewName("flow/bpGroupInfoRegisterForm");
		
		return mv;
    }

	/**
	 * BP GROUP 정보 수정
	 */
	@RequestMapping(value = "/modifyBpGroupInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView modifyBpGroupInfo(@RequestBody BpGroupInfo bpGroupInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

		boolean isSuccess = bpGroupInfoService.modifyBpGroupInfo(bpGroupInfo);

		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 * BP GROUP 정보 삭제
	 */
	@RequestMapping(value = "/removeBpGroupInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView removeBpGroupInfo(@RequestBody BpGroupInfo bpGroupInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		boolean isSuccess = bpGroupInfoService.removeBpGroupInfo(bpGroupInfo);
		
		mv.addObject("result", isSuccess);
		
        return mv;
    }
}
