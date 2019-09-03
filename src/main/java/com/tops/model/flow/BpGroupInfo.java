package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("BpGroupInfo")
public class BpGroupInfo extends BaseObject
{
    private String group_id;
    private String group_name;
    private String sequence;
    private String reference;
    private String description;

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

    public String getSequence()
    {
        return sequence;
    }

    public void setSequence(String sequence)
    {
        this.sequence = sequence;
    }

    public String getReference()
    {
        return reference;
    }

    public void setReference(String reference)
    {
        this.reference = reference;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }
}