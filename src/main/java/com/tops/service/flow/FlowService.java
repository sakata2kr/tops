package com.tops.service.flow;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.FlowMapper;
import com.tops.model.flow.*;
import com.tops.service.BaseService;

/**
 * Flow 정보를 관리하기 위한 Service
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class FlowService extends BaseService
{
    @Autowired
    private FlowMapper flowMapper;

    private String resultCode;

    private String resultMessage;

    // Flow 리스트 조회
    public List<FlowidInfo> retrieveFlowList(GroupInfo groupInfo)
	{
        return flowMapper.selectFlowInfoList(groupInfo);
    }

    // BP GROUPING을 위한 BP Name 조회
    public List<String> retrieveBpNameList()
	{
        return flowMapper.selectBpNameList();
    }

    // BP Group에 해당하는 BP 리스트 조회
    public List<BusinessProcess> retriveBpInfoByBpName(String bp_name)
	{
        return flowMapper.selectBpInfoByBpName(bp_name);
    }

    // BP Group에 해당하는 BM 리스트 조회
    public List<BusinessModule> retriveBmInfoByBpId(String bp_id)
	{
        return flowMapper.selectBmInfoByBpId(bp_id);
    }

    // Flow Diagram 정보 DB 추가
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public void addFlowDiagram(Diagram diagram, String changeType)
	{
        String flow_id = diagram.getFlow_id();
        String system_id = diagram.getSystem_id();
        String group_id = diagram.getGroup_id();

        Map<String, FlowEntity> lookup = new HashMap<>();
        List<Link> links = new ArrayList<>();

        for (DiagramCell cell : diagram.getCells())
        {
            if (DiagramCellType.ENTITY.getCellType().equals(cell.getType()))
            {
                if (!lookup.containsKey(cell.getId()))
                {
                    FlowEntity entity = (FlowEntity) cell;
                    entity.setFlow_id(flow_id);

                    lookup.put(cell.getId(), entity);
                }
            } else {
                links.add((Link) cell);
            }
        }

        // 2: 변경 ~ 변경 발생 시 기존 데이터 삭제 후 추가 형태로 진행
        if ("2".equals(changeType))
        {
            // Flow 외 bp_info / bm_info 및 bp_mapping / bm_mapping 정보 삭제
        	deleteFlowDiagram(system_id, group_id, flow_id);
        }

        List<FlowEntity> entities = new ArrayList<>(lookup.values());
        Collections.sort(entities, new Comparator<FlowEntity>()
		{
            public int compare(FlowEntity entity1, FlowEntity entity2)
			{
                String string1 = entity1.getSystem_id() + entity1.getGroup_id() + entity1.getBp().getBp_id() + entity1.getBm().getBm_id();
                String string2 = entity2.getSystem_id() + entity2.getGroup_id() + entity2.getBp().getBp_id() + entity2.getBm().getBm_id();

                return string1.compareTo(string2);
            }
        });

        // 신규 정보 등록
        String prevBpId = "";

        for (FlowEntity entity : entities)
        {
            if (!prevBpId.equals(entity.getBp().getBp_id()))
            {
                flowMapper.insertBpInfoMapping(entity);
            }

            flowMapper.insertBmInfoMapping(entity);

            prevBpId = entity.getBp().getBp_id();
        }

        FlowEntity prevEntity = new FlowEntity();
        FlowEntity currentity = new FlowEntity();
        for (Link link : links)
        {

            if (lookup.containsKey(link.getSource().getId()))
            {
                prevEntity = lookup.get(link.getSource().getId());
            }
            
            if (lookup.containsKey(link.getTarget().getId()))
            {
                currentity = lookup.get(link.getTarget().getId());
            }

            currentity.setPrevEntity(prevEntity);

            flowMapper.insertFlowInfo(currentity);

            // Target 지정된 Entity 제거
            entities.remove(currentity);
        }

        // Target 지정되지 않은 Entity들을 Self Target으로 등록
        for (FlowEntity entity : entities)
        {
            entity.setPrevEntity(entity);
            flowMapper.insertFlowInfo(entity);
        }
    }

    // Flow Diagram 정보 등록
    public Map<String, String> registerFlowDiagram(Diagram diagram)
    {
        Map<String, String> result = new HashMap<>();
        resultCode = "0";
        resultMessage = "";

        String flow_id = diagram.getFlow_id();
        String changeType = "1"; // Flow Diagram 처리 구분 (1 : 신규, 2 : 변경, 3 : 삭제)

        // Flow Diagram Entity 개수
        Integer flowEntityCount = flowMapper.selectFlowInfoCount(flow_id);

        if (flowEntityCount != null && flowEntityCount > 0)
        {
            changeType = "2"; // 변경
        }

        try
        {
            addFlowDiagram(diagram, changeType);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            resultCode = "1";
            resultMessage += "DB 데이터 저장 시 오류가 발생하였습니다.\n";
        }

        result.put("resultCode", resultCode);
        result.put("resultMessage", resultMessage);
        logger.debug("resultCode ===== {}", result.get("resultCode"));

        return result;
    }

    /**
     * Flow Diagram 정보 조회
     */
    public Diagram retrieveFlowDiagram(String flow_id, String group_id, String system_id, String CloneYn)
	{
        List<FlowEntity> flowEntityList = flowMapper.selectRecursiveFlowList(flow_id, group_id, system_id, CloneYn);

        Map<String, FlowEntity> lookup = new HashMap<>();
        List<Link> links = new ArrayList<>();
        List<FlowEntity> entities = new ArrayList<>();

        Link link;

        for (FlowEntity entity : flowEntityList)
        {
            if (!lookup.containsKey(entity.getKey()))
            {
            	entity.setId(entity.getKey());
                lookup.put(entity.getKey(), entity);
                entities.add(entity);
            }
        }

        for (FlowEntity entity : flowEntityList)
        {
            if (!entity.getPrevEntity().getKey().equals("ROOT"))
            {
                if (lookup.containsKey(entity.getPrevEntity().getKey()) && lookup.containsKey(entity.getKey()))
                {
                	link = new Link();
                    link.setSource(new Point(lookup.get(entity.getPrevEntity().getKey()).getId()));
                    link.setTarget(new Point(lookup.get(entity.getKey()).getId()));
                    links.add(link);
                }
            }
        }

        List<DiagramCell> cells = new ArrayList<>();
        cells.addAll(entities);
        cells.addAll(links);

        Diagram diagram = new Diagram();
        diagram.setGroup_id(group_id);
        diagram.setSystem_id(system_id);
        diagram.setCells(cells);

        return diagram;
    }

    /**
     * Flow Diagram 정보 DB 삭제
     * <p>Flow Diagram 정보를 DB에서 삭제한다.</p>
     */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public void deleteFlowDiagram(String system_id, String group_id, String flow_id)
	{
        // Flow 외 bp_info / bm_info 및 bp_mapping / bm_mapping 정보 삭제
        flowMapper.deleteBpInfo(system_id, group_id);
        flowMapper.deleteBpInfoMapping(system_id, group_id);
        flowMapper.deleteBmInfo(system_id, group_id);
        flowMapper.deleteBmInfoMapping(system_id, group_id);
        flowMapper.deleteFlowInfo(flow_id, system_id, group_id);
    }

    /**
     * Flow Diagram 정보 삭제
     * <p>Flow Diagram 정보를 DB에서 삭제하고, F/W 서버에 전문을 전송한다.</p>
     */
    public Map<String, String> removeFlowDiagram(String system_id, String group_id, String flow_id)
    {
        Map<String, String> result = new HashMap<>();
        resultCode = "0";
        resultMessage = "";

        Integer runningProcessCount = flowMapper.selectRunningProcessCountByGroupId(group_id);

        if (runningProcessCount != null && runningProcessCount > 0)
        {
            result.put("resultCode", "1");
            result.put("resultMessage", "기동중인 프로세스가 존재하여 삭제할 수 없습니다.");

            return result;
        }

        try
        {
            deleteFlowDiagram(system_id, group_id, flow_id);
        }
        catch (Exception e)
        {
            logger.error(e.getMessage());
            resultCode = "1";
            resultMessage += "DB 데이터 삭제 시 오류가 발생하였습니다.\n";
        }

        result.put("resultCode", resultCode);
        result.put("resultMessage", resultMessage);

        return result;
    }
}
