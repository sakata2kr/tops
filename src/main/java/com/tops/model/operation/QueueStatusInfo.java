package com.tops.model.operation;

import java.math.BigDecimal;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("QueueStatusInfo")
public class QueueStatusInfo extends BaseObject
{
    private String     itm_cd;
    private String     itm_name;
    private BigDecimal tot_file_count;
    private BigDecimal tot_cdr_count;
    private BigDecimal max_avg_duration;

    public String getItm_cd()
    {
        return itm_cd;
    }

    public void setItm_cd(String itm_cd)
    {
        this.itm_cd = itm_cd;
    }

    public String getItm_name()
    {
        return itm_name;
    }

    public void setItm_name(String itm_name)
    {
        this.itm_name = itm_name;}

    public BigDecimal getTot_file_count()
    {
        return tot_file_count;
    }

    public void setTot_file_count(BigDecimal tot_file_count)
    {
        this.tot_file_count = tot_file_count;
    }

    public BigDecimal getTot_cdr_count()
    {
        return tot_cdr_count;
    }

    public void setTot_cdr_count(BigDecimal tot_cdr_count)
    {
        this.tot_cdr_count = tot_cdr_count;
    }

    public BigDecimal getMax_avg_duration()
    {
        return max_avg_duration;
    }

    public void setMax_avg_duration(BigDecimal max_avg_duration)
    {
        this.max_avg_duration = max_avg_duration;
    }
}