package com.tops.common.ScheduledService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.SortedMap;
import java.util.TreeMap;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.util.StopWatch;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tops.model.common.InMemoryRepository;
import com.tops.model.operation.DashBoardInfo;
import com.tops.model.operation.EventMessage;
import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessInfoTreeNode;
import com.tops.model.operation.ProcessServerList;
import com.tops.service.BaseService;
import com.tops.service.operation.EventService;
import com.tops.service.operation.StatusCheckService;

/**
 * Online Process Cache 정보 갱신 반복
 */
@Service
@EnableScheduling
public class ScheduledStatusCheckService extends BaseService
{
    @Autowired
    private SimpMessagingTemplate simpMessagingTemplate;

    @Autowired
    private StatusCheckService   statusCheckService;

    @Autowired
    private EventService         eventService;

    /*
    @Autowired
    private DashBoardInfoService dashBoardInfoService;
    */

    @Scheduled(fixedDelay = 2000)
    protected void executeInternal ()
    {
        try
        {
            logger.debug("[Scheduled JOB] Start Process");

            // Tree 상태 변경 여부 확인
            TreeDataModCheck();

            // Framework 상태 이상 여부 확인
            FwkStatusCheck();

            // EVENT 처리 정보 발생 여부 확인
            EventCheck();

            // ServerList 처리 정보 갱신 여부 확인
            ServerListCheck();

            // DashBoard 표시 정보 존재 여부 확인
            //DashboardCheck();
        }
        catch ( Exception e )
        {
            logger.error("JOB RUNNING FAIL : ", e);
        }

        logger.debug("[Scheduled JOB] Finish Process");
    }

    private void TreeDataModCheck () throws Exception
    {
        StopWatch stopWatch = new StopWatch("Update Process Cache Stopwatch");

        boolean treeRefresh   = false; // Tree Refresh 여부

        List< ProcessInfoFlatData > changedNodeList = new ArrayList<>();

        Map<String, ArrayList<ProcessInfoTreeNode>> changedTreeNodesList = new HashMap<>();

        stopWatch.start("DB 내 구성 정보 추출");

        List< ProcessInfoFlatData > oldOnlineProcessFlatList = InMemoryRepository.processFlatDataList;
        List< ProcessInfoFlatData > newOnlineProcessFlatList = statusCheckService.getProcessTreeData();

        // 비교를 위한 정렬 처리
        Collections.sort(newOnlineProcessFlatList, ProcessInfoFlatData.ServerTypeComparator);

        stopWatch.stop();
        stopWatch.start("메모리 정보와 추출 정보 비교 처리");

        if ( !oldOnlineProcessFlatList.equals(newOnlineProcessFlatList) )
        {
            if (oldOnlineProcessFlatList.size() != newOnlineProcessFlatList.size())
            {
                treeRefresh = true;
            }
            else
            {
                Iterator< ProcessInfoFlatData > olditer = oldOnlineProcessFlatList.iterator();
                Iterator< ProcessInfoFlatData > newiter = newOnlineProcessFlatList.iterator();

                while ( newiter.hasNext() )
                {
                    if ( !olditer.hasNext() )
                    {
                        treeRefresh = true;
                        break;
                    }

                    ProcessInfoFlatData oldOnlineProcessFlatData = olditer.next();
                    ProcessInfoFlatData newOnlineProcessFlatData = newiter.next();

                    if ( oldOnlineProcessFlatData.getGrp_ctg_cd1().equals(newOnlineProcessFlatData.getGrp_ctg_cd1())
                      && oldOnlineProcessFlatData.getGrp_ctg_cd2().equals(newOnlineProcessFlatData.getGrp_ctg_cd2())
                      && oldOnlineProcessFlatData.getGroup_id().equals(newOnlineProcessFlatData.getGroup_id())
                      && oldOnlineProcessFlatData.getPsystem_id().equals(newOnlineProcessFlatData.getPsystem_id())
                      && oldOnlineProcessFlatData.getSystem_id().equals(newOnlineProcessFlatData.getSystem_id())
                      && oldOnlineProcessFlatData.getBp_group().equals(newOnlineProcessFlatData.getBp_group())
                      && oldOnlineProcessFlatData.getBp_id().equals(newOnlineProcessFlatData.getBp_id())
                      && oldOnlineProcessFlatData.getBm_id().equals(newOnlineProcessFlatData.getBm_id())
                       )
                    {
                        if ( !oldOnlineProcessFlatData.getSystem_name().equals(newOnlineProcessFlatData.getSystem_name())
                          || !oldOnlineProcessFlatData.getGrp_ctg_name1().equals(newOnlineProcessFlatData.getGrp_ctg_name1())
                          || !oldOnlineProcessFlatData.getGrp_ctg_name2().equals(newOnlineProcessFlatData.getGrp_ctg_name2())
                          || !oldOnlineProcessFlatData.getGroup_name().equals(newOnlineProcessFlatData.getGroup_name())
                          || !oldOnlineProcessFlatData.getBp_name().equals(newOnlineProcessFlatData.getBp_name())
                          || !oldOnlineProcessFlatData.getBm_name().equals(newOnlineProcessFlatData.getBm_name())
                          || oldOnlineProcessFlatData.getRunning_thread()  != newOnlineProcessFlatData.getRunning_thread()
                          || oldOnlineProcessFlatData.getStatus_priority() != newOnlineProcessFlatData.getStatus_priority()
                          || !oldOnlineProcessFlatData.getStatus().equals(newOnlineProcessFlatData.getStatus())
                           )
                        {
                            changedNodeList.add(newOnlineProcessFlatData);
                        }
                    }
                    else
                    {
                        treeRefresh = true;
                        break;
                    }
                }

                if ( olditer.hasNext() )
                {
                    treeRefresh = true;
                }
            }
        }

        stopWatch.stop();

        if ( treeRefresh || (changedNodeList != null && changedNodeList.size() > 0) )
        {
            // 변경 데이터가 존재하는 경우 Tree 갱신을 위한 기준 트리 정보 생성
            stopWatch.start("신규 Tree 데이터 생성");
            Map<String, ProcessInfoTreeNode> newOnlineProcessTreeMap = FlatToTreeBuilder.buildTree(newOnlineProcessFlatList);
            stopWatch.stop();

            // 트리 전체를 재구성 해야 하는 경우
            if (treeRefresh)
            {
                stopWatch.start("Tree 정보 재생성");

                // JSON 데이터 전송
                Set<String> viewTypes = newOnlineProcessTreeMap.keySet();

                // viewType별로 전문 BroadCasting 처리
                for (String viewType : viewTypes)
                {
                    broadCastMessage("/stomp/treeView/" + viewType, "reqTreeData", treeRefresh, newOnlineProcessTreeMap.get(viewType).getChildren());
                    broadCastMessage("/stomp/dashView/" + viewType, "reqTreeData", treeRefresh, newOnlineProcessTreeMap.get(viewType).getChildren());
                }

                stopWatch.stop();
            }
            else if (changedNodeList != null && changedNodeList.size() > 0)
            {
                // Look up changed trees ===========================================================
                stopWatch.start("Tree 데이터 내 갱신 대상 Node 정보 추출");

                SortedMap<String, ProcessInfoTreeNode> groupTypeTreeNodeLookup   = new TreeMap<String, ProcessInfoTreeNode>();
                SortedMap<String, ProcessInfoTreeNode> ServerTypeTreeNodeLookup  = new TreeMap<String, ProcessInfoTreeNode>();
                SortedMap<String, ProcessInfoTreeNode> processTypeTreeNodeLookup = new TreeMap<String, ProcessInfoTreeNode>();

                List<String> groupTreeKeysList = new ArrayList<String>();
                List<String> serverTreeKeysList = new ArrayList<String>();
                List<String> processTreeKeysList = new ArrayList<String>();

                StringBuilder tmpStrBuilder = new StringBuilder();

                for (ProcessInfoFlatData dataInfo : changedNodeList)
                {
                    groupTreeKeysList.clear();
                    tmpStrBuilder.delete(0, tmpStrBuilder.length());

                    groupTreeKeysList.add(tmpStrBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1()).toString());
                    groupTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2()).toString());
                    groupTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id()).toString());
                    groupTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id())
                                                       .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id()).toString());
                    groupTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group()).toString());
                    groupTreeKeysList.add(tmpStrBuilder.append("|").append(dataInfo.getBp_id()).toString());
                    groupTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id()).toString());


                    serverTreeKeysList.clear();
                    tmpStrBuilder.delete(0, tmpStrBuilder.length());

                    serverTreeKeysList.add(tmpStrBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id()).toString());
                    serverTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1()).toString());
                    serverTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2()).toString());
                    serverTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id()).toString());
                    serverTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
                                                        .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group()).toString());
                    serverTreeKeysList.add(tmpStrBuilder.append("|").append(dataInfo.getBp_id()).toString());
                    serverTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id()).toString());

                    processTreeKeysList.clear();
                    tmpStrBuilder.delete(0, tmpStrBuilder.length());

                    processTreeKeysList.add(tmpStrBuilder.append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getPsystem_id_seq()), 3, '0')).append("|").append(dataInfo.getPsystem_id()).toString());
                    processTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getSystem_id_seq()),  3, '0')).append("|").append(dataInfo.getSystem_id())
                                                         .append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBp_group_seq()),   3, '0')).append("|").append(dataInfo.getBp_group()).toString());
                    processTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq1()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd1()).toString());
                    processTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGrp_ctg_seq2()),   3, '0')).append("|").append(dataInfo.getGrp_ctg_cd2()).toString());
                    processTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getGroup_id_seq()),   3, '0')).append("|").append(dataInfo.getGroup_id()).toString());
                    processTreeKeysList.add(tmpStrBuilder.append("|").append(dataInfo.getBp_id()).toString());
                    processTreeKeysList.add(tmpStrBuilder.append("|").append(StringUtils.leftPad(StringUtils.defaultString(dataInfo.getBm_id_seq()), 3, '0')).append("|").append(dataInfo.getBm_id()).toString());

                    groupTypeTreeNodeLookup   = FlatToTreeHelper.updateTreeNodeLookup(InMemoryRepository.processTreeDataMap.get("GROUP"),   groupTreeKeysList,   dataInfo, groupTypeTreeNodeLookup);
                    ServerTypeTreeNodeLookup  = FlatToTreeHelper.updateTreeNodeLookup(InMemoryRepository.processTreeDataMap.get("SERVER"),  serverTreeKeysList,  dataInfo, ServerTypeTreeNodeLookup);
                    processTypeTreeNodeLookup = FlatToTreeHelper.updateTreeNodeLookup(InMemoryRepository.processTreeDataMap.get("PROCESS"), processTreeKeysList, dataInfo, processTypeTreeNodeLookup);
                }

                changedTreeNodesList.put("GROUP",   new ArrayList<ProcessInfoTreeNode>());
                changedTreeNodesList.put("SERVER",  new ArrayList<ProcessInfoTreeNode>());
                changedTreeNodesList.put("PROCESS", new ArrayList<ProcessInfoTreeNode>());

                ProcessInfoTreeNode treeNode = new ProcessInfoTreeNode();

                for (Map.Entry<String, ProcessInfoTreeNode> entry : groupTypeTreeNodeLookup.entrySet())
                {
                    treeNode = entry.getValue();
                    treeNode.setChildren(null);                 // UI 성능 개선을 위해 불필요한 데이터 Null 처리
                    changedTreeNodesList.get("GROUP").add(treeNode);
                }

                for (Map.Entry<String, ProcessInfoTreeNode> entry : ServerTypeTreeNodeLookup.entrySet())
                {
                    treeNode = entry.getValue();
                    treeNode.setChildren(null);                 // UI 성능 개선을 위해 불필요한 데이터 Null 처리
                    changedTreeNodesList.get("SERVER").add(treeNode);
                }

                for (Map.Entry<String, ProcessInfoTreeNode> entry : processTypeTreeNodeLookup.entrySet())
                {
                    treeNode = entry.getValue();
                    treeNode.setChildren(null);                 // UI 성능 개선을 위해 불필요한 데이터 Null 처리
                    changedTreeNodesList.get("PROCESS").add(treeNode);
                }

                // JSON 데이터 생성
                for (String viewType :  changedTreeNodesList.keySet())
                {
                    // 변경 대상 정보가 20건이 넘을 경우 전체 Tree 갱신으로 전달
                    if (changedTreeNodesList.get(viewType).size() >= 20)
                    {
                        broadCastMessage("/stomp/treeView/" + viewType, "reqTreeData", true, newOnlineProcessTreeMap.get(viewType).getChildren());
                        broadCastMessage("/stomp/dashView/" + viewType, "reqTreeData", true, newOnlineProcessTreeMap.get(viewType).getChildren());
                    }
                    else
                    {
                        broadCastMessage("/stomp/treeView/" + viewType, "reqTreeData", treeRefresh, changedTreeNodesList.get(viewType));
                        broadCastMessage("/stomp/dashView/" + viewType, "reqTreeData", treeRefresh, changedTreeNodesList.get(viewType));
                    }
                }

                stopWatch.stop();
            }

            // 처리 결과를 내부 캐시에 저장하기 위하여 다시 재정렬 처리
            // 로직 선행부에서 처리 시 내부 구조체가 변경되므로 다른 로직에서 ConcurrentModificationException이 발생
            Collections.sort(newOnlineProcessFlatList, ProcessInfoFlatData.ServerTypeComparator);

            // 처리 후 내부 캐시에 저장
            InMemoryRepository.processFlatDataList = newOnlineProcessFlatList;
            InMemoryRepository.processTreeDataMap.put("GROUP",   newOnlineProcessTreeMap.get("GROUP")  );
            InMemoryRepository.processTreeDataMap.put("SERVER",  newOnlineProcessTreeMap.get("SERVER") );
            InMemoryRepository.processTreeDataMap.put("PROCESS", newOnlineProcessTreeMap.get("PROCESS"));
        }

        logger.debug("\n{}", stopWatch.prettyPrint());
    }

    private void FwkStatusCheck() throws Exception
    {
        List <DashBoardInfo> fwkErrorInfoList = statusCheckService.getFwkProcessErrorInfo();

        if (fwkErrorInfoList.size() > 0)
        {
        	InMemoryRepository.fwkAllGreen = false;

        }
        else if (fwkErrorInfoList.size() <= 0 && !InMemoryRepository.fwkAllGreen) 
        {
        	InMemoryRepository.fwkAllGreen = true;

        	// 전체 정상 정보 전송을 위한 임시 구조체
        	DashBoardInfo tmpInfo = new DashBoardInfo();
        	tmpInfo.setComp_type("ALL");
        	tmpInfo.setComp_id("ALL");
        	tmpInfo.setStatus("0");

        	fwkErrorInfoList.add(tmpInfo);
        }

        // 전체 BroadCasting 처리
        for (Map.Entry<String, ProcessInfoTreeNode> entry : InMemoryRepository.processTreeDataMap.entrySet())
        {
            broadCastMessage("/stomp/treeView/" + entry.getKey(), "reqFwkInfo", true, fwkErrorInfoList);
            broadCastMessage("/stomp/dashView/" + entry.getKey(), "reqFwkInfo", true, fwkErrorInfoList);
        }
    }

    private void ServerListCheck() throws Exception
    {
        List< ProcessServerList > tmpServerList = statusCheckService.getServerList();

        if (InMemoryRepository.processServerList.size() <= 0 || !InMemoryRepository.processServerList.equals(tmpServerList))
        {
            InMemoryRepository.processServerList = tmpServerList;

            for (Map.Entry<String, ProcessInfoTreeNode> entry : InMemoryRepository.processTreeDataMap.entrySet())
            {
                broadCastMessage("/stomp/treeView/" + entry.getKey(), "reqServerList", true, InMemoryRepository.processServerList);
            }
        }
    }

    private void EventCheck() throws Exception
    {
        String selTimeStamp = null;

        if ( InMemoryRepository.eventMessage != null
          && InMemoryRepository.eventMessage.getEvent_time() != null
          && !InMemoryRepository.eventMessage.getEvent_time().equals("")
           )
        {
            selTimeStamp = InMemoryRepository.eventMessage.getEvent_time();
        }
        else
        {
            selTimeStamp = eventService.selectCurrentTimeStamp();
        }

        List<EventMessage> eventMessageList = eventService.selectEventMessage(selTimeStamp);

        if (eventMessageList != null && eventMessageList.size() > 0)
        {
            InMemoryRepository.eventMessage = eventMessageList.get(eventMessageList.size() -1);

            broadCastMessage("/stomp/alarm", "pushEventAlert", true, InMemoryRepository.eventMessage);

            // DashView 사용자에도 연동
            for (Map.Entry<String, ProcessInfoTreeNode> entry : InMemoryRepository.processTreeDataMap.entrySet())
            {
                broadCastMessage("/stomp/dashView/" + entry.getKey(), "pushEventAlert", true, InMemoryRepository.eventMessage);
            }
            
        }
    }
/*
    private void DashboardCheck() throws Exception
    {
        List <DashBoardInfo> tmpDashBoardInfoList = new ArrayList<>();

        DashBoardInfo tmpDashBoardInfo;

        for ( ProcessInfoFlatData tmpFlatData : InMemoryRepository.processFlatDataList )
        {
        	// NODATA는 skip
        	if ( tmpFlatData.getGrp_ctg_cd1().equals("NODATA") )
        	{
        		continue;
        	}
        	else if ( tmpDashBoardInfoList.size() > 0
              && tmpDashBoardInfoList.get(tmpDashBoardInfoList.size() -1).getComp_id().equals(tmpFlatData.getPsystem_id())
              && tmpDashBoardInfoList.get(tmpDashBoardInfoList.size() -1).getSub_comp_id().equals(tmpFlatData.getGrp_ctg_cd1())
               )
            {
            	if ( tmpDashBoardInfoList.get(tmpDashBoardInfoList.size() -1).getStat_value() <= tmpFlatData.getStatus_priority())
                {
                	tmpDashBoardInfoList.get(tmpDashBoardInfoList.size() -1).setStat_value(tmpFlatData.getStatus_priority());
                	tmpDashBoardInfoList.get(tmpDashBoardInfoList.size() -1).setStatus(tmpFlatData.getStatus());
                }
            }
            else
            {
            	tmpDashBoardInfo = new DashBoardInfo();

                tmpDashBoardInfo.setComp_type("PROCESS");
                tmpDashBoardInfo.setComp_id(tmpFlatData.getPsystem_id());
                tmpDashBoardInfo.setSub_comp_seq( StringUtils.leftPad(StringUtils.defaultString(tmpFlatData.getGrp_ctg_seq1()), 3, '0') );
                tmpDashBoardInfo.setSub_comp_id(tmpFlatData.getGrp_ctg_cd1());
                tmpDashBoardInfo.setSub_comp_name(tmpFlatData.getGrp_ctg_name1());
                tmpDashBoardInfo.setStatus(tmpFlatData.getStatus());

                tmpDashBoardInfoList.add(tmpDashBoardInfo);
            } 
        }

        // 기타 상태 조회
        tmpDashBoardInfoList.addAll(dashBoardInfoService.getDashBoardInfo());

        if (InMemoryRepository.dashBoardInfo.size() <= 0 || InMemoryRepository.dashBoardInfo != tmpDashBoardInfoList)
        {
            InMemoryRepository.dashBoardInfo.clear();
            InMemoryRepository.dashBoardInfo.addAll(tmpDashBoardInfoList);
        }

        if (InMemoryRepository.dashBoardInfo.size() > 0)
        {
            for (Map.Entry<String, ProcessInfoTreeNode> entry : InMemoryRepository.processTreeDataMap.entrySet())
            {
                broadCastMessage("/stomp/dashView/" + entry.getKey(), "reqDashBoard", true, InMemoryRepository.dashBoardInfo);
            }
        }
    }
*/
    public void broadCastMessage(String uri, String procType, boolean dataRefresh, Object sendData) throws IOException
    {
        ObjectMapper om = new ObjectMapper();
        StringBuilder jsonStringBuilder = new StringBuilder();

        jsonStringBuilder.append("{\"procType\":\"").append(procType).append("\"");
        jsonStringBuilder.append(",\"dataRefresh\":\"").append(dataRefresh).append("\"");
        jsonStringBuilder.append(",\"jsonData\":").append(om.writeValueAsString(sendData)).append("}");

        simpMessagingTemplate.convertAndSend(uri, jsonStringBuilder.toString());
    }
}