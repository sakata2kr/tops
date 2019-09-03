package com.tops.model.auth;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("ResourceAccessInfo")
public class ResourceAccessInfo extends BaseObject
{
    private String resource_id;
    private String resource_name;
    private String resource_path;
    private String auth_group_id;
    private String access_yn;

    public String getResource_id()
    {
        return resource_id;
    }

    public void setResource_id(String resource_id)
    {
        this.resource_id = resource_id;
    }

    public String getAuth_group_id()
    {
        return auth_group_id;
    }

    public void setAuth_group_id(String auth_group_id)
    {
        this.auth_group_id = auth_group_id;
    }

    public String getAccess_yn()
    {
        return access_yn;
    }

    public void setAccess_yn(String access_yn)
    {
        this.access_yn = access_yn;
    }

    public String getResource_name()
    {
        return resource_name;
    }

    public void setResource_name(String resource_name)
    {
        this.resource_name = resource_name;
    }

    public String getResource_path()
    {
        return resource_path;
    }

    public void setResource_path(String resource_path)
    {
        this.resource_path = resource_path;
    }
}