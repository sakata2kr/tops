package com.tops.controller.flow;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.tops.controller.BaseController;
import com.tops.model.flow.BusinessModule;
import com.tops.model.flow.BusinessProcess;
import com.tops.model.flow.Diagram;
import com.tops.model.flow.FlowidInfo;
import com.tops.model.flow.GroupBackupPolicyInfo;
import com.tops.model.flow.GroupInfo;
import com.tops.model.flow.SystemInfo;
import com.tops.service.flow.FlowService;
import com.tops.service.flow.GroupInfoService;
import com.tops.service.flow.SystemInfoService;

/**
 * Flow Design 기능을 관리하기 위한 Controller
 */
@Controller
@RequestMapping("/flow")
public class FlowDesignController extends BaseController
{
    @Autowired
    private GroupInfoService groupInfoService;

    @Autowired
    private SystemInfoService systemInfoService;

    @Autowired
    private FlowService flowService;

    /**
     * 그룹정보 목록 화면
     */
    @RequestMapping(value = "/viewFlowInfoList")
    public ModelAndView viewFlowInfoList(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        mv.addObject("pageID", request.getParameter("pageID"));

        mv.setViewName("flow/flowInfoList");

        return mv;
    }

    /**
     * 그룹정보 조회
     */
    @RequestMapping(value = "/flowInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView flowInfoList(@RequestBody GroupInfo groupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<FlowidInfo> flowInfoList = flowService.retrieveFlowList(groupInfo);

        mv.addObject("flowInfoList", flowInfoList);

        return mv;
    }

    /**
     *  그룹정보 등록 화면
     */
    @RequestMapping(value = "/groupInfoRegisterForm", method=RequestMethod.GET)
    public ModelAndView groupInfoRegisterForm(ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        // 백업정책 기준데이터 조회
        List<SystemInfo> backupPolicySystemInfoList = systemInfoService.retrieveBackupPolicySystemInfoList();
        mv.addObject("backupPolicySystemInfoList", backupPolicySystemInfoList);

        mv.setViewName("flow/groupInfoRegisterForm");

        return mv;
    }

    /**
     * 그룹정보 등록
     */
    @RequestMapping(value = "/registerGroupInfo")
    public @ResponseBody ModelAndView registerGroupInfo(@RequestBody GroupInfo groupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        // 그룹정보 저장
        boolean isSuccess = groupInfoService.registerGroupInfo(groupInfo);

        if(isSuccess)
        {
            isSuccess = groupInfoService.registerGroupBackupPolicyInfo(groupInfo);
        }

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 그룹정보 수정 화면
     */
    @RequestMapping(value = "/groupInfoModifyForm", method=RequestMethod.GET)
    public ModelAndView groupInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        // 백업정책 기준데이터 조회
        List<SystemInfo> backupPolicySystemInfoList = systemInfoService.retrieveBackupPolicySystemInfoList();
        mv.addObject("backupPolicySystemInfoList", backupPolicySystemInfoList);

        // jqGrid 선택한 row id
        mv.addObject("row_id", request.getParameter("row_id"));
        mv.addObject("mode", "modify");

        mv.setViewName("flow/groupInfoRegisterForm");

        return mv;
    }

    /**
     * 그룹정보 수정
     */
    @RequestMapping(value = "/modifyGroupInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView modifyGroupInfo(@RequestBody GroupInfo groupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = groupInfoService.modifyGroupInfo(groupInfo);

        if(isSuccess)
        {
            isSuccess = groupInfoService.registerGroupBackupPolicyInfo(groupInfo);
        }

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 그룹정보 삭제
     */
    @RequestMapping(value = "/removeGroupInfo", method=RequestMethod.POST)
    public@ResponseBody ModelAndView removeGroupInfo(@RequestBody GroupInfo groupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = false;

        if ( groupInfoService.removeGroupBackupPolicyInfo(groupInfo.getGroup_id())
          && groupInfoService.removeGroupStatusInfo(groupInfo.getGroup_id())
          && groupInfoService.removeGroupInfo(groupInfo)
           )
        {
            isSuccess = true;
        }

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * 그룹백업정책정보 조회
     */
    @RequestMapping(value = "/groupBackupPolicyInfoList", method=RequestMethod.POST)
    public@ResponseBody ModelAndView groupBackupPolicyInfoList(GroupInfo groupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        List<GroupBackupPolicyInfo> groupBackupPolicyInfoList = groupInfoService.retrieveGroupBackupPolicyInfoList(groupInfo);

        mv.addObject("groupBackupPolicyInfoList", groupBackupPolicyInfoList);

        return mv;
    }

    /**
     * 그룹ID 에 대한 FLOW 정보 존재 여부 체크
     */
    @RequestMapping(value = "/checkFlowExistByGroupId", method=RequestMethod.POST)
    public@ResponseBody ModelAndView checkFlowExistByGroupId(@RequestBody GroupInfo groupInfo) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());

        boolean isSuccess = groupInfoService.checkFlowExistByGroupId(groupInfo);

        mv.addObject("result", isSuccess);

        return mv;
    }

    /**
     * Flow Design
     */
    @RequestMapping(value = "/flowDesign", method = RequestMethod.GET)
    public String flowDesign( @RequestParam(value = "flow_id")   String flow_id
                            , @RequestParam(value = "system_id") String system_id
                            , @RequestParam(value = "group_id")  String group_id
                            , ModelMap model
                            ) throws Exception
    {
        model.addAttribute("flow_id",   flow_id);
        model.addAttribute("system_id", system_id);
        model.addAttribute("group_id",  group_id);

        return "flow/flowDesign";
    }

    /**
     * BP Group에 해당하는 BP 리스트 조회
     */
    @RequestMapping(value = "/getBpList", method = RequestMethod.GET)
    @ResponseBody
    public List<BusinessProcess> getBpList( @RequestParam(value = "bp_name") String bp_name) throws Exception
    {
        return flowService.retriveBpInfoByBpName(bp_name);
    }

    /**
     * BP Group에 해당하는 BM 리스트 조회
     */
    @RequestMapping(value = "/getBmList", method = RequestMethod.GET)
    @ResponseBody
    public List<BusinessModule> getBmList( @RequestParam(value = "bp_id") String bp_id) throws Exception
    {

        return flowService.retriveBmInfoByBpId(bp_id);
    }

    /**
     * Flow Diagram 정보 조회
     */
    @RequestMapping(value = "/getDiagram", method = RequestMethod.GET)
    @ResponseBody
    public Diagram getDiagram(@RequestParam(value = "flow_id")   String flow_id
                            , @RequestParam(value = "group_id")  String group_id
                            , @RequestParam(value = "system_id") String system_id
                            , @RequestParam(value = "cloneYn")   String cloneYn) throws Exception
    {
        return flowService.retrieveFlowDiagram(flow_id, group_id, system_id, cloneYn);
    }

    /**
     * Flow Diagram 등록
     */
    @RequestMapping(value = "/saveFlow", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> saveFlow(@RequestBody Diagram diagram) throws Exception
    {
        return flowService.registerFlowDiagram(diagram);
    }

    /**
     * Flow Diagram 삭제
     */
    @RequestMapping(value = "/removeFlow", method = RequestMethod.POST)
    @ResponseBody
    public Map<String, String> removeFlow( @RequestParam(value = "system_id") String system_id
                                         , @RequestParam(value = "group_id") String group_id
                                         , @RequestParam(value = "flow_id")  String flow_id
                                         ) throws Exception
    {
        return flowService.removeFlowDiagram(system_id, group_id, flow_id);
    }
}
