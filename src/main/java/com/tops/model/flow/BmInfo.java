package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("BmInfo")
public class BmInfo extends BaseObject
{
    private String biz_domain;
    private String bmid;
    private String binary_id;
    private String bm_name;
    private String ui_bp_group;
    private String old_bmid;

    public String getBiz_domain()
    {
        return biz_domain;
    }

    public void setBiz_domain(String biz_domain)
    {
        this.biz_domain = biz_domain;
    }

    public String getBmid()
    {
        return bmid;
    }

    public void setBmid(String bmid)
    {
        this.bmid = bmid;
    }

    public String getBinary_id()
    {
        return binary_id;
    }

    public void setBinary_id(String binary_id)
    {
        this.binary_id = binary_id;
    }

    public String getBm_name()
    {
        return bm_name;
    }

    public void setBm_name(String bm_name)
    {
        this.bm_name = bm_name;
    }

    public String getUi_bp_group()
    {
        return ui_bp_group;
    }

    public void setUi_bp_group(String ui_bp_group)
    {
        this.ui_bp_group = ui_bp_group;
    }

    public String getOld_bmid()
    {
        return old_bmid;
    }

    public void setOld_bmid(String old_bmid)
    {
        this.old_bmid = old_bmid;
    }
}