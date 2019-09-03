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
import com.tops.model.flow.BinaryLocation;
import com.tops.model.flow.BmInfo;
import com.tops.model.flow.BpGroupInfo;
import com.tops.model.flow.SystemInfo;
import com.tops.service.flow.BinaryInfoService;
import com.tops.service.flow.BmInfoService;
import com.tops.service.flow.BpGroupInfoService;
import com.tops.service.flow.SystemInfoService;

@Controller
@RequestMapping("/flow")
public class BmInfoController extends BaseController
{
    @Autowired
    private BmInfoService bmInfoService;

    @Autowired
    private BinaryInfoService binaryInfoService;

    @Autowired
    private BpGroupInfoService bpGroupInfoService;

    /**
     *  BM 정보 등록 화면
     */
    @RequestMapping(value = "/bmInfoRegisterForm", method=RequestMethod.GET)
    public ModelAndView bmInfoRegisterForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        List<BinaryInfo> binaryInfoList = binaryInfoService.retrieveBinaryInfoList();
        List<BpGroupInfo> bpGroupInfoList = bpGroupInfoService.retrieveBpGroupInfoList();

        mv.addObject("binaryInfoList", binaryInfoList);
        mv.addObject("bpGroupInfoList", bpGroupInfoList);

        mv.addObject("ui_bp_group", request.getParameter("ui_bp_group"));
        mv.addObject("biz_domain", request.getParameter("biz_domain"));

        mv.setViewName("flow/bmInfoRegisterForm");

        return mv;
    }

    /**
     * BM 정보 등록
     */
    @RequestMapping(value = "/registerBmInfo")
    public @ResponseBody ModelAndView registerBmInfo(@RequestBody BmInfo bmInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // BM 정보 저장
        boolean isSuccess = bmInfoService.registerBmInfo(bmInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     *  BM 정보 수정 화면
     */
    @RequestMapping(value = "/bmInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView bmInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        // BP 정보 조회
        BmInfo paramBmInfo = new BmInfo();
        paramBmInfo.setBiz_domain(request.getParameter("biz_domain"));
        paramBmInfo.setBmid(request.getParameter("bmid"));
        BmInfo bmInfo = bmInfoService.retrieveBmInfo(paramBmInfo);
        mv.addObject("bmInfo", bmInfo);

        List<BinaryInfo>  binaryInfoList  = binaryInfoService.retrieveBinaryInfoList();
        List<BpGroupInfo> bpGroupInfoList = bpGroupInfoService.retrieveBpGroupInfoList();

        mv.addObject("binaryInfoList", binaryInfoList);
        mv.addObject("bpGroupInfoList", bpGroupInfoList);

        mv.addObject("mode", "modify");

        mv.setViewName("flow/bmInfoRegisterForm");

        return mv;
    }

    /**
     * BM 정보 수정
     */
    @RequestMapping(value = "/modifyBmInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView modifyBmInfo(@RequestBody BmInfo bmInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = bmInfoService.modifyBmInfo(bmInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * BM 정보 삭제
     */
    @RequestMapping(value = "/removeBmInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView removeBmInfo(@RequestBody BmInfo bmInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = bmInfoService.removeBmInfo(bmInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     *  binary 정보 관리
     */
    @RequestMapping(value = "/viewBinaryInfoList", method=RequestMethod.GET)
    public ModelAndView viewBinaryInfoList(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        mv.setViewName("flow/binaryInfoList");

        return mv;
    }

    /**
     *  binary 정보 조회
     */
    @RequestMapping(value="/selectBinaryInfoList", method=RequestMethod.GET)
    public @ResponseBody ModelAndView selectBinaryInfoList(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<BinaryInfo> binaryInfoList = binaryInfoService.retrieveBinaryInfoAllList();

        mv.addObject("grid", binaryInfoList);

        return mv;
    }

    /**
     *  binary 정보 등록 화면
     */
    @RequestMapping(value = "/binaryInfoRegisterForm", method=RequestMethod.GET)
    public ModelAndView binaryInfoRegisterForm(ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        // 물리시스템 목록
        SystemInfoService systemInfoService = new SystemInfoService();
        List<SystemInfo> psystemInfoList = systemInfoService.retrieveSystemInfoList(null);
        mv.addObject("psystemInfoList", psystemInfoList);

        mv.setViewName("flow/binaryInfoRegisterForm");

        return mv;
    }

    /**
     * 시스템정보 수정 화면
     */
    @RequestMapping(value = "/binaryInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView binaryInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        String binaryId = request.getParameter("binaryId");
        BinaryInfo binaryInfo = binaryInfoService.retrieveBinaryInfo(binaryId);

        // 물리시스템 목록
        SystemInfoService systemInfoService = new SystemInfoService();
        List<SystemInfo> psystemInfoList = systemInfoService.retrieveSystemInfoList(null);
        mv.addObject("psystemInfoList", psystemInfoList);

        mv.addObject("binaryInfo", binaryInfo);
        mv.addObject("mode", "modify");

        mv.setViewName("flow/binaryInfoRegisterForm");

        return mv;
    }

    /**
     * binary location정보 조회
     */
    @RequestMapping(value = "/binaryLocationInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView binaryLocationInfoList(BinaryInfo binaryInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<BinaryLocation> binaryLocationInfoList = binaryInfoService.retrieveBinaryLocationInfoList(binaryInfo);

        mv.addObject("binaryLocationInfoList", binaryLocationInfoList);

        return mv;
    }

    /**
     * binary정보 등록,binary location정보 등록
     */
    @RequestMapping(value = "/registerBinaryInfo")
    public @ResponseBody ModelAndView registerBinaryInfo(@RequestBody BinaryInfo binaryInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 그룹정보 저장
        boolean isSuccess = binaryInfoService.registerBinaryInfo(binaryInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * binary정보 수정,binary location정보 수정
     */
    @RequestMapping(value = "/modifyBinaryInfo")
    public @ResponseBody ModelAndView modifyBinaryInfo(@RequestBody BinaryInfo binaryInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 그룹정보 저장
        boolean isSuccess = binaryInfoService.modifyBinaryInfo(binaryInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * binary정보 수정,binary location정보 삭제
     */
    @RequestMapping(value = "/removeBinaryInfo")
    public @ResponseBody ModelAndView removeBinaryInfo(@RequestBody BinaryInfo binaryInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 그룹정보 저장
        boolean isSuccess = binaryInfoService.removeBinaryInfo(binaryInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }
}
