package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("SystemInfo")
public class SystemInfo extends BaseObject
{
    private String biz_domain;
    private String system_id;
    private String system_group;
    private String system_group_name;
    private String system_name;
    private String description;
    private int sequence;

    // 수정/삭제시 사용하는 old key
    private String old_biz_domain;
    private String old_system_id;

    // 멀티셀렉트 조회 parameter 배열값 담을 변수
    private String[] system_groups; // 시스템그룹

    public String getBiz_domain()
    {
        return biz_domain;
    }

    public void setBiz_domain(String biz_domain)
    {
        this.biz_domain = biz_domain;
    }

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

    public String getSystem_group_name()
    {
        return system_group_name;
    }

    public void setSystem_group_name(String system_group_name)
    {
        this.system_group_name = system_group_name;
    }

    public String getSystem_name()
    {
        return system_name;
    }

    public void setSystem_name(String system_name)
    {
        this.system_name = system_name;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public int getSequence()
    {
        return sequence;
    }

    public void setSequence(int sequence)
    {
        this.sequence = sequence;
    }

    public String getOld_biz_domain()
    {
        return old_biz_domain;
    }

    public void setOld_biz_domain(String old_biz_domain)
    {
        this.old_biz_domain = old_biz_domain;
    }

    public String getOld_system_id()
    {
        return old_system_id;
    }

    public void setOld_system_id(String old_system_id)
    {
        this.old_system_id = old_system_id;
    }

    public String[] getSystem_groups()
    {
        return system_groups;
    }

    public void setSystem_groups(String[] system_groups)
    {
        this.system_groups = system_groups;
    }
}