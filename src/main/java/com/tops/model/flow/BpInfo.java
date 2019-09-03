package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("BpInfo")
public class BpInfo extends BaseObject
{
    private String biz_domain;
    private String bpid;
    private String binary_id;
    private String bp_name;
    private String auto_restart_cnt;
    private String ui_bp_group;
    private String old_bpid;

    public String getBiz_domain()
    {
        return biz_domain;
    }

    public void setBiz_domain(String biz_domain)
    {
        this.biz_domain = biz_domain;
    }

    public String getBpid()
    {
        return bpid;
    }

    public void setBpid(String bpid)
    {
        this.bpid = bpid;
    }

    public String getBinary_id()
    {
        return binary_id;
    }

    public void setBinary_id(String binary_id)
    {
        this.binary_id = binary_id;
    }

    public String getBp_name()
    {
        return bp_name;
    }

    public void setBp_name(String bp_name)
    {
        this.bp_name = bp_name;
    }

    public String getAuto_restart_cnt()
    {
        return auto_restart_cnt;
    }

    public void setAuto_restart_cnt(String auto_restart_cnt)
    {
        this.auto_restart_cnt = auto_restart_cnt;
    }

    public String getUi_bp_group()
    {
        return ui_bp_group;
    }

    public void setUi_bp_group(String ui_bp_group)
    {
        this.ui_bp_group = ui_bp_group;
    }

    public String getOld_bpid()
    {
        return old_bpid;
    }

    public void setOld_bpid(String old_bpid)
    {
        this.old_bpid = old_bpid;
    }
}