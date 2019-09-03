package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("FlowidInfo")
public class FlowidInfo extends BaseObject
{
    private String flow_id;
    private String flow_name;
    private String description;
    private String group_ctg1_cd;
    private String group_ctg1_name;
    private String group_ctg2_cd;
    private String group_ctg2_name;
    private String group_id;
    private String group_name;

    public String getFlow_id()
    {
        return flow_id;
    }

    public void setFlow_id(String flow_id)
    {
        this.flow_id = flow_id;
    }

    public String getGroup_ctg1_cd()
    {
        return group_ctg1_cd;
    }

    public String getFlow_name()
    {
        return flow_name;
    }

    public void setFlow_name(String flow_name)
    {
        this.flow_name = flow_name;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public void setGroup_ctg1_cd(String group_ctg1_cd)
    {
        this.group_ctg1_cd = group_ctg1_cd;
    }

    public String getGroup_ctg1_name()
    {
        return group_ctg1_name;
    }

    public void setGroup_ctg1_name(String group_ctg1_name)
    {
        this.group_ctg1_name = group_ctg1_name;
    }

    public String getGroup_ctg2_cd()
    {
        return group_ctg2_cd;
    }

    public void setGroup_ctg2_cd(String group_ctg2_cd)
    {
        this.group_ctg2_cd = group_ctg2_cd;
    }

    public String getGroup_ctg2_name()
    {
        return group_ctg2_name;
    }

    public void setGroup_ctg2_name(String group_ctg2_name)
    {
        this.group_ctg2_name = group_ctg2_name;
    }

    public String getGroup_id()
    {
        return group_id;
    }

    public void setGroup_id(String group_id)
    {
        this.group_id = group_id;
    }

    public String getGroup_name()
    {
        return group_name;
    }

    public void setGroup_name(String group_name)
    {
        this.group_name = group_name;
    }
}