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
import com.tops.model.flow.BinaryInfo;
import com.tops.model.flow.BpGroupInfo;
import com.tops.model.flow.BpInfo;
import com.tops.service.flow.BinaryInfoService;
import com.tops.service.flow.BpGroupInfoService;
import com.tops.service.flow.BpInfoService;

@Controller
@RequestMapping("/flow")
public class BpInfoController extends BaseController
{
    @Autowired
	private BpInfoService bpInfoService;	

    @Autowired
	private BinaryInfoService binaryInfoService;
	
    @Autowired
	private BpGroupInfoService bpGroupInfoService;
	
	/**
	 *  BP 정보 등록 화면
	 */
	@RequestMapping(value = "/bpInfoRegisterForm", method=RequestMethod.GET)
    public ModelAndView bpInfoRegisterForm(HttpServletRequest request, ModelMap model) throws Exception
	{
		ModelAndView mv = new ModelAndView();

		List<BinaryInfo> binaryInfoList = binaryInfoService.retrieveBinaryInfoList();
		List<BpGroupInfo> bpGroupInfoList = bpGroupInfoService.retrieveBpGroupInfoList();
		
		mv.addObject("binaryInfoList", binaryInfoList);
		mv.addObject("bpGroupInfoList", bpGroupInfoList); 
		mv.addObject("ui_bp_group", request.getParameter("ui_bp_group"));
		mv.addObject("switch_type", request.getParameter("switch_type"));
		mv.addObject("biz_domain", request.getParameter("biz_domain"));
		
		mv.setViewName("flow/bpInfoRegisterForm");
		
		return mv;
    }

	/**
	 * BP 정보 등록
	 */
	@RequestMapping(value = "/registerBpInfo")
	public @ResponseBody ModelAndView registerBpInfo(@RequestBody BpInfo bpInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		// BP 정보 저장
		boolean isSuccess = bpInfoService.registerBpInfo(bpInfo);

		mv.addObject("result", isSuccess);

		return mv;
	}

	/**
	 *  BP 정보 수정 화면
	 */
	@RequestMapping(value = "/bpInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView bpInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
	{
		ModelAndView mv = new ModelAndView();
		
		BpInfo paramBpInfo = new BpInfo();
		paramBpInfo.setBiz_domain(request.getParameter("biz_domain"));
		paramBpInfo.setBpid(request.getParameter("bpid"));
		BpInfo bpInfo = bpInfoService.retrieveBpInfo(paramBpInfo);
		mv.addObject("bpInfo", bpInfo);
		mv.addObject("mode", "modify");
		
		List<BinaryInfo> binaryInfoList = binaryInfoService.retrieveBinaryInfoList();
		List<BpGroupInfo> bpGroupInfoList = bpGroupInfoService.retrieveBpGroupInfoList();		
		
		mv.addObject("binaryInfoList", binaryInfoList);
		mv.addObject("bpGroupInfoList", bpGroupInfoList);
		
		mv.setViewName("flow/bpInfoRegisterForm");
		
		return mv;
    }

	/**
	 * BP 정보 수정
	 */
	@RequestMapping(value = "/modifyBpInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView modifyBpInfo(@RequestBody BpInfo bpInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

		boolean isSuccess = bpInfoService.modifyBpInfo(bpInfo);

		mv.addObject("result", isSuccess);
		
        return mv;
    }

	/**
	 * BP 정보 삭제
	 */
	@RequestMapping(value = "/removeBpInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView removeBpInfo(@RequestBody BpInfo bpInfo) throws Exception
	{
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		boolean isSuccess = bpInfoService.removeBpInfo(bpInfo);
		
		mv.addObject("result", isSuccess);
		
        return mv;
    }
}
