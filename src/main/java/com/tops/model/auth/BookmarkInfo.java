package com.tops.model.auth;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseInfo;

@Alias("BookmarkInfo")
public class BookmarkInfo extends BaseInfo
{
    private String userId;
    private String menuId;
    private String screenTop;
    private String screenLeft;
    private String screenRight;
    private String screenHeight;
    private String screenWidth;
    private String screenStatus;
    private String updateDt;
    private String createDt;
    private String resourcePath;

    public String getResourcePath()
    {
        return resourcePath;
    }

    public void setResourcePath(String resourcePath)
    {
        this.resourcePath = resourcePath;
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String getMenuId()
    {
        return menuId;
    }

    public void setMenuId(String menuId)
    {
        this.menuId = menuId;
    }

    public String getScreenTop()
    {
        return screenTop;
    }

    public void setScreenTop(String screenTop)
    {
        this.screenTop = screenTop;
    }

    public String getScreenLeft()
    {
        return screenLeft;
    }

    public void setScreenLeft(String screenLeft)
    {
        this.screenLeft = screenLeft;
    }

    public String getScreenRight()
    {
        return screenRight;
    }

    public void setScreenRight(String screenRight)
    {
        this.screenRight = screenRight;
    }

    public String getScreenHeight()
    {
        return screenHeight;
    }

    public void setScreenHeight(String screenHeight)
    {
        this.screenHeight = screenHeight;
    }

    public String getScreenWidth()
    {
        return screenWidth;
    }

    public void setScreenWidth(String screenWidth)
    {
        this.screenWidth = screenWidth;
    }

    public String getScreenStatus()
    {
        return screenStatus;
    }

    public void setScreenStatus(String screenStatus)
    {
        this.screenStatus = screenStatus;
    }

    public String getUpdateDt()
    {
        return updateDt;
    }

    public void setUpdateDt(String updateDt)
    {
        this.updateDt = updateDt;
    }

    public String getCreateDt()
    {
        return createDt;
    }

    public void setCreateDt(String createDt)
    {
        this.createDt = createDt;
    }
}