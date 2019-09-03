package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@Alias("FlowEntity")
@JsonIgnoreProperties(ignoreUnknown = true)
public class FlowEntity extends DiagramCell
{
    private String key;
    private String flow_id;
    private String system_id;
    private String group_id;

    private BusinessProcess bp;
    private BusinessModule bm;

    private FlowEntity prevEntity;

    private FlowInfoDetail flowInfoDetail;  /** Flow 속성 정보 */
    private Position position; /** Flow Diagram에서의 위치 정보 */

    @Override
    public String getTypeValue()
    {
        return DiagramCellType.ENTITY.getCellType();
    }

    public String getKey()
    {
        return key;
    }

    public void setKey(String key)
    {
        this.key = key;
    }

    public String getFlow_id()
    {
        return flow_id;
    }

    public void setFlow_id(String flow_id)
    {
        this.flow_id = flow_id;
    }

    public String getSystem_id()
    {
        return system_id;
    }

    public void setSystem_id(String System_id)
    {
        this.system_id = System_id;
    }

    public String getGroup_id()
    {
        return group_id;
    }

    public void setGroup_id(String group_id)
    {
        this.group_id = group_id;
    }

    public BusinessProcess getBp()
    {
        return bp;
    }

    public void setBp(BusinessProcess bp)
    {
        this.bp = bp;
    }

    public BusinessModule getBm()
    {
        return bm;
    }

    public void setBm(BusinessModule bm)
    {
        this.bm = bm;
    }

    public FlowEntity getPrevEntity()
    {
        return prevEntity;
    }

    public void setPrevEntity(FlowEntity prevEntity)
    {
        this.prevEntity = prevEntity;
    }

    public FlowInfoDetail getFlowInfoDetail()
    {
        return flowInfoDetail;
    }

    public void setFlowInfoDetail(FlowInfoDetail flowInfoDetail)
    {
        this.flowInfoDetail = flowInfoDetail;
    }

    public Position getPosition()
    {
        return position;
    }

    public void setPosition(Position position)
    {
        this.position = position;
    }

    
}