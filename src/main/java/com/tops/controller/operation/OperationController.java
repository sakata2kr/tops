package com.tops.controller.operation;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.tops.controller.BaseController;
import com.tops.model.operation.EventMessage;
import com.tops.model.operation.EventParam;
import com.tops.model.operation.EventType;
import com.tops.model.operation.ProcessServerList;
import com.tops.model.user.UserInfo;
import com.tops.service.operation.EventService;
import com.tops.service.operation.StatusCheckService;

@Controller
@RequestMapping("/operation")
public class OperationController extends BaseController
{
    @Autowired
    private EventService eventTypeService;

    @Autowired
    private StatusCheckService statusCheckService;

    /**
     * Application Operation 화면 구성
     */
    @RequestMapping(value = "/processControl", method = RequestMethod.GET)
    public String processControl(ModelMap model) throws Exception
    {
        return "operation/processControl";
    }

    /**
     * eventLog 조회 전 기준 정보 조회
     */
    @RequestMapping(value = "/eventsList", method = RequestMethod.GET)
    public String eventsList(ModelMap model) throws Exception
    {
        List<EventType> eventList = eventTypeService.selectEventType();
        model.addAttribute("eventList", eventList);

        List<ProcessServerList> systemList = statusCheckService.getServerList();
        model.addAttribute("systemList", systemList);

        return "operation/eventsList";
    }

    /**
     * eventLog 조회
     */
    @RequestMapping(value = "/retrieveEventsLog", method = RequestMethod.POST)
    public @ResponseBody ModelAndView  retrieveEventsLog(HttpServletRequest request, @RequestBody EventParam eventParam) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
        eventParam.setUserId(((UserInfo)request.getSession().getAttribute("sessUserInfo")).getUser_id());
        List<EventMessage> gridList = eventTypeService.selectUserEventLog(eventParam);
        mv.addObject("grid", gridList);

        return mv;
    }
}