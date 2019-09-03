package com.tops.model.flow;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.tops.model.BaseObject;

@JsonIgnoreProperties(ignoreUnknown = true)
public class FlowInfoDetail extends BaseObject
{
    private String branch_op;
    private String branch_value;
    private String next_app_type;
    private String prev_exit_status;
    private String flow_condition;
    private int    port;

    public String getBranch_op()
    {
        return branch_op;
    }

    public void setBranch_op(String branch_op)
    {
        this.branch_op = branch_op;
    }

    public String getBranch_value()
    {
        return branch_value;
    }

    public void setBranch_value(String branch_value)
    {
        this.branch_value = branch_value;
    }

    public String getNext_app_type()
    {
        return next_app_type;
    }

    public void setNext_app_type(String next_app_type)
    {
        this.next_app_type = next_app_type;
    }

    public String getPrev_exit_status()
    {
        return prev_exit_status;
    }

    public void setPrev_exit_status(String prev_exit_status)
    {
        this.prev_exit_status = prev_exit_status;
    }

    public String getFlow_condition()
    {
        return flow_condition;
    }

    public void setFlow_condition(String flow_condition)
    {
        this.flow_condition = flow_condition;
    }

    public int getPort()
    {
        return port;
    }

    public void setPort(int port)
    {
        this.port = port;
    }
}
