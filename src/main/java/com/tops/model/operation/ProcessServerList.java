package com.tops.model.operation;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("ProcessServerList")
public class ProcessServerList extends BaseObject
{
    private String system_id;
    private String system_group;
    private String system_name;

    public String getSystem_id()
    {
        return system_id;
    }

    public void setSystem_id(String system_id)
    {
        this.system_id = system_id;
    }

    public String getSystem_group()
    {
        return system_group;
    }

    public void setSystem_group(String system_group)
    {
        this.system_group = system_group;
    }

    public String getSystem_name()
    {
        return system_name;
    }

    public void setSystem_name(String system_name)
    {
        this.system_name = system_name;
    }
}