package com.tops.common.WebSocket;

import java.io.IOException;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tops.controller.BaseController;
import com.tops.model.common.InMemoryRepository;
import com.tops.model.user.UserInfo;
import com.tops.service.operation.SendCommandService;
import com.tops.service.operation.StatusCheckService;

@Controller
public class WebSocketController extends BaseController
{
    @Autowired
    private SendCommandService processService;

    @Autowired
    private StatusCheckService statusCheckService;

    @MessageMapping("/reqTree")
    @SendToUser(destinations="/stomp/resTree", broadcast=false)
    public String sendTreeMessage(SimpMessageHeaderAccessor headerAccessor, String message) throws Exception
    {
        ObjectMapper om = new ObjectMapper();
        Map<String, String> paramJson = om.readValue(message, new TypeReference<Map<String, String>>(){});

        UserInfo userInfo = ((UserInfo)headerAccessor.getSessionAttributes().get("sessUserInfo"));

        logger.debug("{} {} {} {}", paramJson.get("viewType"), paramJson.get("procType"), userInfo.getUser_id(), message);

        switch(paramJson.get("procType"))
        {
            // Process Control 전문 처리 요청

            case "reqProcessCommand" :
                if ( processService.requestProcessCommand(userInfo, paramJson.get("viewType"), paramJson.get("nodeKey"), paramJson.get("nodeType"), paramJson.get("cmdCode"), paramJson.get("cmdInfo"), paramJson.get("cmdInfoSub")) )
                {
                    return makeMessage("reqProcessCommand", true, "{\"result\":\"S\"}");
                }
                else
                {
                    return makeMessage("reqProcessCommand", true, "{\"result\":\"F\"}");
                }

            // Tree Data 조회 요청
            case "reqTreeData" :
                return makeMessage(paramJson.get("procType"), true, om.writeValueAsString(InMemoryRepository.processTreeDataMap.get(paramJson.get("viewType")).getChildren()));

            // Server List 조회 요청
            case "reqServerList" :
                return makeMessage(paramJson.get("procType"), true, om.writeValueAsString(InMemoryRepository.processServerList));

            // Server status 조회 요청
            case "reqNodeStatus" :
                return makeMessage(paramJson.get("procType"), true, statusCheckService.getStatusInfo(paramJson.get("grp_ctg1"), paramJson.get("grp_ctg2"), paramJson.get("group_id"), paramJson.get("system_id")));

            default :
                return makeMessage(paramJson.get("procType"), true, "{\"result\":\"NOT MATCHED PROC TYPE\"}");
        }
    }

    @MessageMapping("/reqDash")
    @SendToUser(destinations="/stomp/resDash", broadcast=false)
    public String sendDashMessage(SimpMessageHeaderAccessor headerAccessor, String message) throws Exception
    {
        ObjectMapper om = new ObjectMapper();
        Map<String, String> paramJson = om.readValue(message, new TypeReference<Map<String, String>>(){});

        UserInfo userInfo = ((UserInfo)headerAccessor.getSessionAttributes().get("sessUserInfo"));

        logger.debug("{} {} {} {}", paramJson.get("viewType"), paramJson.get("procType"), userInfo.getUser_id(), message);

        switch(paramJson.get("procType"))
        {
            // 대시보드 정보 조회 요청
            case "reqDashBoardData" :
                return makeMessage(paramJson.get("procType"), true, om.writeValueAsString(InMemoryRepository.dashBoardInfo));

            // Tree Data 조회 요청
            case "reqTreeData" :
                return makeMessage(paramJson.get("procType"), true, om.writeValueAsString(InMemoryRepository.processTreeDataMap.get(paramJson.get("viewType")).getChildren()));

            default :
                return makeMessage(paramJson.get("procType"), true, "{\"result\":\"NOT MATCHED PROC TYPE\"}");
        }
    }

    // 전문 처리 데이터를 json 형태로 reform
    public String makeMessage (String procType, boolean dataRefresh, String sendData) throws IOException
    {
        StringBuilder jsonStringBuilder = new StringBuilder();

        jsonStringBuilder.append("{\"procType\":\"").append(procType).append("\"");
        jsonStringBuilder.append(",\"dataRefresh\":\"").append(dataRefresh).append("\"");
        jsonStringBuilder.append(",\"jsonData\":").append(sendData).append("}");

        return jsonStringBuilder.toString();
    }
}