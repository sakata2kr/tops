package com.tops.model.auth;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("ResourceInfo")
public class ResourceInfo extends BaseObject
{
    private String resource_id;
    private String resource_name;
    private String resource_path;
    private String sort_order;
    private String old_resource_id;

    private String resource_bean_name;

    public void setResource_id(String resource_id)
    {
        this.resource_id = resource_id;
    }

    public String getOld_resource_id()
    {
        return old_resource_id;
    }

    public void setOld_resource_id(String old_resource_id)
    {
        this.old_resource_id = old_resource_id;
    }

    public String getSort_order()
    {
        return sort_order;
    }

    public void setSort_order(String sort_order)
    {
        this.sort_order = sort_order;
    }

    public String getResource_id()
    {
        return resource_id;
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

    public String getResource_bean_name()
    {
        return resource_bean_name;
    }

    public void setResource_bean_name(String resource_bean_name)
    {
        this.resource_bean_name = resource_bean_name;
    }
}