package com.tops.model.operation;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("EventMessage")
public class EventMessage extends BaseObject
{
    private String event_id;
    private String event_type;
    private String event_name;
    private String system_id;
    private String op_system_id;
    private String group_id;
    private String bp_id;
    private String bm_id;
    private String event_time;
    private String message;

    public String getEvent_id()
    {
        return event_id;
    }

    public void setEvent_id(String event_id)
    {
        this.event_id = event_id;
    }

    public String getEvent_type()
    {
        return event_type;
    }

    public void setEvent_type(String event_type)
    {
        this.event_type = event_type;
    }

    public String getEvent_name()
    {
        return event_name;
    }

    public void setEvent_name(String event_name)
    {
        this.event_name = event_name;
    }

    public String getSystem_id()
    {
        return system_id;
    }

    public void setSystem_id(String system_id)
    {
        this.system_id = system_id;
    }

    public String getOp_system_id()
    {
        return op_system_id;
    }

    public void setOp_system_id(String op_system_id)
    {
        this.op_system_id = op_system_id;
    }

    public String getGroup_id()
    {
        return group_id;
    }

    public void setGroup_id(String group_id)
    {
        this.group_id = group_id;
    }

    public String getBp_id()
    {
        return bp_id;
    }

    public void setBp_id(String bp_id)
    {
        this.bp_id = bp_id;
    }

    public String getBm_id()
    {
        return bm_id;
    }

    public void setBm_id(String bm_id)
    {
        this.bm_id = bm_id;
    }

    public String getEvent_time()
    {
        return event_time;
    }

    public void setEvent_time(String event_time)
    {
        this.event_time = event_time;
    }

    public String getMessage()
    {
        return message;
    }

    public void setMessage(String message)
    {
        this.message = message;
    }
}