package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("GroupBackupPolicyInfo")
public class GroupBackupPolicyInfo extends BaseObject
{
    private String system_id;
    private String group_id;
    private String primary_system_id;
    private String backup_system_id;

    public String getSystem_id()
    {
        return system_id;
    }

    public void setSystem_id(String system_id)
    {
        this.system_id = system_id;
    }

    public String getGroup_id()
    {
        return group_id;
    }

    public void setGroup_id(String group_id)
    {
        this.group_id = group_id;
    }

    public String getPrimary_system_id()
    {
        return primary_system_id;
    }

    public void setPrimary_system_id(String primary_system_id)
    {
        this.primary_system_id = primary_system_id;
    }

    public String getBackup_system_id()
    {
        return backup_system_id;
    }

    public void setBackup_system_id(String backup_system_id)
    {
        this.backup_system_id = backup_system_id;
    }
}