package com.tops.model.flow;

import java.util.List;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

/**
 * Business Process 정보
 */
@Alias("BusinessProcess")
public class BusinessProcess extends BaseObject
{
    private String bp_id;
    private String bp_name;
    private String binary_id;
    private int    auto_restart_cnt;
    private String parameter;

    private List<BusinessModule> bmList;

    public String getBp_id()
    {
        return bp_id;
    }

    public void setBp_id(String bp_id)
    {
        this.bp_id = bp_id;
    }

    public String getBp_name()
    {
        return bp_name;
    }

    public void setBp_name(String bp_name)
    {
        this.bp_name = bp_name;
    }

    public String getBinary_id()
    {
        return binary_id;
    }

    public void setBinary_id(String binary_id)
    {
        this.binary_id = binary_id;
    }

    public int getAuto_restart_cnt()
    {
        return auto_restart_cnt;
    }

    public void setAuto_restart_cnt(int auto_restart_cnt)
    {
        this.auto_restart_cnt = auto_restart_cnt;
    }

    public String getParameter()
    {
        return parameter;
    }

    public void setParameter(String parameter)
    {
        this.parameter = parameter;
    }

    public List<BusinessModule> getBmList()
    {
        return bmList;
    }

    public void setBmList(List<BusinessModule> bmList)
    {
        this.bmList = bmList;
    }
}