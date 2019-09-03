package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

@Alias("FlowProcessInfo")
public class FlowProcessInfo
{
    private String system_id;
    private String group_id;
    private String bp_id;
    private String bm_id;
    private int    file_count;
    private int    cdr_count;
    private int    avg_duration;
    private String nsystem_id;
    private String ngroup_id;
    private String nbp_id;
    private String nbm_id;
    private int    nfile_count;
    private int    ncdr_count;
    private int    navg_duration;

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


    public int getFile_count()
    {
        return file_count;
    }

    public void setFile_count(int file_count)
    {
        this.file_count = file_count;
    }

    public int getCdr_count()
    {
        return cdr_count;
    }

    public void setCdr_count(int cdr_count)
    {
        this.cdr_count = cdr_count;
    }

    public int getAvg_duration()
    {
        return avg_duration;
    }

    public void setAvg_duration(int avg_duration)
    {
        this.avg_duration = avg_duration;
    }

    public String getNsystem_id()
    {
        return nsystem_id;
    }

    public void setNsystem_id(String nsystem_id)
    {
        this.nsystem_id = nsystem_id;
    }

    public String getNgroup_id()
    {
        return ngroup_id;
    }

    public void setNgroup_id(String ngroup_id)
    {
        this.ngroup_id = ngroup_id;
    }

    public String getNbp_id()
    {
        return nbp_id;
    }

    public void setNbp_id(String nbp_id)
    {
        this.nbp_id = nbp_id;
    }

    public String getNbm_id()
    {
        return nbm_id;
    }

    public void setNbm_id(String nbm_id)
    {
        this.nbm_id = nbm_id;
    }

    public int getNfile_count()
    {
        return nfile_count;
    }

    public void setNfile_count(int nfile_count)
    {
        this.nfile_count = nfile_count;
    }

    public int getNcdr_count()
    {
        return ncdr_count;
    }

    public void setNcdr_count(int ncdr_count)
    {
        this.ncdr_count = ncdr_count;
    }

    public int getNavg_duration()
    {
        return navg_duration;
    }

    public void setNavg_duration(int navg_duration)
    {
        this.navg_duration = navg_duration;
    }
}