package com.tops.model.auth;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("MenuInfo")
public class MenuInfo extends BaseObject
{
    private String menu_id;
    private String menu_name;
    private String parent_menu_id;
    private String sort_order;
    private String menuindex;
    private String menuindex2;
    private String resource_id;
    private String resource_name;
    private String resource_path;
    private String level;
    private int subcount;

    public String getMenu_id()
    {
        return menu_id;
    }

    public void setMenu_id(String menu_id)
    {
        this.menu_id = menu_id;
    }

    public String getMenu_name()
    {
        return menu_name;
    }

    public void setMenu_name(String menu_name)
    {
        this.menu_name = menu_name;
    }

    public String getParent_menu_id()
    {
        return parent_menu_id;
    }

    public void setParent_menu_id(String parent_menu_id)
    {
        this.parent_menu_id = parent_menu_id;
    }

    public String getResource_id()
    {
        return resource_id;
    }

    public void setResource_id(String resource_id)
    {
        this.resource_id = resource_id;
    }

    public String getSort_order()
    {
        return sort_order;
    }

    public void setSort_order(String sort_order)
    {
        this.sort_order = sort_order;
    }

    public String getMenuindex()
    {
        return menuindex;
    }

    public void setMenuindex(String menuindex)
    {
        this.menuindex = menuindex;
    }

    public String getMenuindex2()
    {
        return menuindex2;
    }

    public void setMenuindex2(String menuindex2)
    {
        this.menuindex2 = menuindex2;
    }

    public String getResource_path()
    {
        return resource_path;
    }

    public void setResource_path(String resource_path)
    {
        this.resource_path = resource_path;
    }

    public String getResource_name()
    {
        return resource_name;
    }

    public void setResource_name(String resource_name)
    {
        this.resource_name = resource_name;
    }

    public String getLevel()
    {
        return level;
    }

    public void setLevel(String level)
    {
        this.level = level;
    }

    public int getSubcount()
    {
        return subcount;
    }

    public void setSubcount(int subcount)
    {
        this.subcount = subcount;
    }
}