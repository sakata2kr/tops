package com.tops.model.user;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("UserGroupInfo")
public class UserGroupInfo extends BaseObject
{
    private String user_group_id;
    private String gui_src;
    private String operation_yn;
    private String user_group_name;

    public String getUser_group_id()
    {
        return user_group_id;
    }

    public void setUser_group_id(String user_group_id)
    {
        this.user_group_id = user_group_id;
    }

    public String getGui_src()
    {
        return gui_src;
    }

    public void setGui_src(String gui_src)
    {
        this.gui_src = gui_src;
    }

    public String getOperation_yn()
    {
        return operation_yn;
    }

    public void setOperation_yn(String operation_yn)
    {
        this.operation_yn = operation_yn;
    }

    public String getUser_group_name()
    {
        return user_group_name;
    }

    public void setUser_group_name(String user_group_name)
    {
        this.user_group_name = user_group_name;
    }
}