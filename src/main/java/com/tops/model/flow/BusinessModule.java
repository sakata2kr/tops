package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

/**
 * Business Module 정보
 */
@Alias("BusinessModule")
public class BusinessModule extends BaseObject
{
    private String bm_id;
    private String bm_name;
    private String binary_id;
    private int min_thread_instance;
    private int max_thread_instance;
    private String db_commit_yn;
    private String transaction_end_yn;
    private int unit_cdr_cnt;

    /* 
    public BusinessModule()
    {
        super();
    }

    public BusinessModule(String bm_id, String bm_name)
    {
        super();
        this.bm_id = bm_id;
        this.bm_name = bm_name;
    }
    */

    public String getBm_id()
    {
        return bm_id;
    }

    public void setBm_id(String bm_id)
    {
        this.bm_id = bm_id;
    }

    public String getBm_name()
    {
        return bm_name;
    }

    public void setBm_name(String bm_name)
    {
        this.bm_name = bm_name;
    }

    public String getBinary_id()
    {
        return binary_id;
    }

    public void setBinary_id(String binary_id)
    {
        this.binary_id = binary_id;
    }

    public int getMin_thread_instance()
    {
        return min_thread_instance;
    }

    public void setMin_thread_instance(int min_thread_instance)
    {
        this.min_thread_instance = min_thread_instance;
    }

    public int getMax_thread_instance()
    {
        return max_thread_instance;
    }

    public void setMax_thread_instance(int max_thread_instance)
    {
        this.max_thread_instance = max_thread_instance;
    }

    public String getDb_commit_yn()
    {
        return db_commit_yn;
    }

    public void setDb_commit_yn(String db_commit_yn)
    {
        this.db_commit_yn = db_commit_yn;
    }

    public String getTransaction_end_yn()
    {
        return transaction_end_yn;
    }

    public void setTransaction_end_yn(String transaction_end_yn)
    {
        this.transaction_end_yn = transaction_end_yn;
    }

    public int getUnit_cdr_cnt()
    {
        return unit_cdr_cnt;
    }

    public void setUnit_cdr_cnt(int unit_cdr_cnt)
    {
        this.unit_cdr_cnt = unit_cdr_cnt;
    }
}