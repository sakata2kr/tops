package com.tops.service.operation;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.tops.mapper.fwk.FwkOperationInfoMapper;
import com.tops.mapper.urt.UrtOperationInfoMapper;
import com.tops.model.common.InMemoryRepository;
import com.tops.model.operation.DashBoardInfo;
import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessServerList;
import com.tops.model.operation.QueueStatusInfo;
import com.tops.service.BaseService;

/**
 * Online Process 정보를 관리하기 위한 Service
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class StatusCheckService extends BaseService
{
    @Autowired
    private UrtOperationInfoMapper urtOperationMapper;

    @Autowired
    private FwkOperationInfoMapper fwkOperationMapper;

    // Operation 기준 Process 및 상태 리스트 조회
    public List<ProcessInfoFlatData> getProcessTreeData ()
    {
        return urtOperationMapper.getProcessTreeData();
    }

    // Operation 기준 서버 리스트 조회
    public List<ProcessServerList> getServerList ()
    {
        return urtOperationMapper.getServetList();
    }

    // Framework 기준 Process 특이 사항 조회
    public List<DashBoardInfo> getFwkProcessErrorInfo ()
    {
        return fwkOperationMapper.selectFwkProcessErrorInfo();
    }

    // 각 Node별 상태 조회 및 전체 현황 정보 조회
    // 전체 현황은 TOP 100만 추출
    // 추출후 SockJS 연동으로 데이터 전송
    public String getStatusInfo(String grp_ctg1, String grp_ctg2, String group_id, String op_system_id) throws Exception
    {
        List<QueueStatusInfo> selItemInfoList     = new ArrayList<>();
        List<QueueStatusInfo> queueStatusInfoList = new ArrayList<>();

        ObjectMapper om = new ObjectMapper();
        StringBuilder jsonStringBuilder = new StringBuilder();

        // 조회 대상 SYSTEM이 특정된 경우
        if ( op_system_id != null && op_system_id.length() > 0 )
        {
            // GROUP이 특정된 경우 BP 기준으로 조회
            if ( group_id != null && group_id.length() > 0 )
            {
                selItemInfoList     = urtOperationMapper.getBpInfo(group_id, op_system_id);
                queueStatusInfoList = fwkOperationMapper.selectStatusByBp(group_id, op_system_id);

                for (QueueStatusInfo queueStatusInfo : queueStatusInfoList)
                {
                    Iterator<QueueStatusInfo> selItemInfoIter = selItemInfoList.iterator();

                    while ( selItemInfoIter.hasNext() )
                    {
                        QueueStatusInfo selItemInfo = selItemInfoIter.next();

                        if ( selItemInfo.getItm_cd().equals(queueStatusInfo.getItm_cd()))
                        {
                            queueStatusInfo.setItm_name(selItemInfo.getItm_name());
                            selItemInfoIter.remove();
                        }
                    }
                }
            }
            else
            {
                // GROUP이 특정되지 않은 경우 GROUP 기준으로 조회
                selItemInfoList     = urtOperationMapper.getGroupInfo(grp_ctg1, grp_ctg2, group_id);
                queueStatusInfoList = fwkOperationMapper.selectStatusByGroup(selItemInfoList, op_system_id);

                for (QueueStatusInfo queueStatusInfo : queueStatusInfoList)
                {
                    Iterator<QueueStatusInfo> selItemInfoIter = selItemInfoList.iterator();

                    while ( selItemInfoIter.hasNext() )
                    {
                        QueueStatusInfo selItemInfo = selItemInfoIter.next();

                        if ( selItemInfo.getItm_cd().equals(queueStatusInfo.getItm_cd()))
                        {
                            queueStatusInfo.setItm_name(selItemInfo.getItm_name());
                            selItemInfoIter.remove();
                        }
                    }
                }
            }
        }
        else
        {
            // SYSTEM이 특정되지 않은 경우는 무조건 SYSTEM 기준으로 조회
            selItemInfoList     = urtOperationMapper.getGroupInfo(grp_ctg1, grp_ctg2, group_id);
            queueStatusInfoList = fwkOperationMapper.selectStatusByServer(selItemInfoList);

            // 조회 기준이 SYSTEM 이므로 Server List에서 Name 추출

            for ( QueueStatusInfo queueStatusInfo : queueStatusInfoList)
            {
                for ( ProcessServerList serverInfo : InMemoryRepository.processServerList)
                {
                    if ( serverInfo.getSystem_id().equals(queueStatusInfo.getItm_cd()))
                    {
                        queueStatusInfo.setItm_name(serverInfo.getSystem_name());
                    }
                }
            }
        }

        jsonStringBuilder.append("{\"QueueStatus\":").append(om.writeValueAsString(queueStatusInfoList))
                         .append(",\"TopQueueList\":").append(om.writeValueAsString(fwkOperationMapper.selectTopQueueInfo()))
                         .append("}")
                         ;
        
        return jsonStringBuilder.toString();
    }
}