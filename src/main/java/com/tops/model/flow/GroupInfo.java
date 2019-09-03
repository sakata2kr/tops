package com.tops.model.flow;

import java.util.List;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("GroupInfo")
public class GroupInfo extends BaseObject
{
    private String biz_domain;
    private String group_id;
    private String group_name;
    private String ui_lcl_cd;
    private String ui_lcl_nm;
    private String ui_mcl_cd;
    private String ui_mcl_nm;
    private String ui_scl_cd;
    private String ui_scl_nm;
    private String ui_ref_cd;
    private String description;
    private String switch_type;
    private int array_index;
    private String flow_id;
    private List<GroupBackupPolicyInfo> backup_policy_list;

    public String getBiz_domain()
    {
        return biz_domain;
    }

    public void setBiz_domain(String biz_domain)
    {
        this.biz_domain = biz_domain;
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

    public String getUi_lcl_cd()
    {
        return ui_lcl_cd;
    }

    public void setUi_lcl_cd(String ui_lcl_cd)
    {
        this.ui_lcl_cd = ui_lcl_cd;
    }

    public String getUi_lcl_nm()
    {
        return ui_lcl_nm;
    }

    public void setUi_lcl_nm(String ui_lcl_nm)
    {
        this.ui_lcl_nm = ui_lcl_nm;
    }

    public String getUi_mcl_cd()
    {
        return ui_mcl_cd;
    }

    public void setUi_mcl_cd(String ui_mcl_cd)
    {
        this.ui_mcl_cd = ui_mcl_cd;
    }

    public String getUi_mcl_nm()
    {
        return ui_mcl_nm;
    }

    public void setUi_mcl_nm(String ui_mcl_nm)
    {
        this.ui_mcl_nm = ui_mcl_nm;
    }

    public String getUi_scl_cd()
    {
        return ui_scl_cd;
    }

    public void setUi_scl_cd(String ui_scl_cd)
    {
        this.ui_scl_cd = ui_scl_cd;
    }

    public String getUi_scl_nm()
    {
        return ui_scl_nm;
    }

    public void setUi_scl_nm(String ui_scl_nm)
    {
        this.ui_scl_nm = ui_scl_nm;
    }

    public String getUi_ref_cd()
    {
        return ui_ref_cd;
    }

    public void setUi_ref_cd(String ui_ref_cd)
    {
        this.ui_ref_cd = ui_ref_cd;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }

    public String getSwitch_type()
    {
        return switch_type;
    }

    public void setSwitch_type(String switch_type)
    {
        this.switch_type = switch_type;
    }

    public int getArray_index()
    {
        return array_index;
    }

    public void setArray_index(int array_index)
    {
        this.array_index = array_index;
    }

    public String getFlow_id()
    {
        return flow_id;
    }

    public void setFlow_id(String flow_id)
    {
        this.flow_id = flow_id;
    }

    public List<GroupBackupPolicyInfo> getBackup_policy_list()
    {
        return backup_policy_list;
    }

    public void setBackup_policy_list(List<GroupBackupPolicyInfo> backup_policy_list)
    {
        this.backup_policy_list = backup_policy_list;
    }
}