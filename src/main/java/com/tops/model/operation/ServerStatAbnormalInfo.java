package com.tops.model.operation;

import java.math.BigDecimal;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("ServerStatAbnormalInfo")
public class ServerStatAbnormalInfo extends BaseObject
{
    private String     system_id;
    private String     group_id;
    private String     bp_id;
    private String     bm_id;
    private BigDecimal file_count;
    private BigDecimal cdr_count;
    private BigDecimal avg_duration;

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

    public String getBp_id()
    {
        return bp_id;
    }
    public void setBp_id(String bp_id)
    {
        this.bp_id = bp_id;
    }

    public String getBm_id()
    {
        return bm_id;
    }
    public void setBm_id(String bm_id)
    {
        this.bm_id = bm_id;
    }

    public BigDecimal getFile_count()
    {
        return file_count;
    }
    public void setFile_count(BigDecimal file_count)
    {
        this.file_count = file_count;
    }

    public BigDecimal getCdr_count()
    {
        return cdr_count;
    }
    public void setCdr_count(BigDecimal cdr_count)
    {
        this.cdr_count = cdr_count;
    }

    public BigDecimal getAvg_duration()
    {
        return avg_duration;
    }
    public void setAvg_duration(BigDecimal avg_duration)
    {
        this.avg_duration = avg_duration;
    }
}