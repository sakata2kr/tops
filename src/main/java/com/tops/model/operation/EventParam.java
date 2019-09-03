package com.tops.model.operation;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("EventParam")
public class EventParam extends BaseObject
{
    private String userId;
    private String[] eventType;
    private String eventTypeList;
    private String eventTimeStamp;
    private String eventId;
    private String logLevelList;
    private String[] logLevel;
    private String errorCategoryList;
    private String[] errorCategory;
    private String errorCodeList;
    private String[] errorCode;
    private String logDate;
    private String logTime;

    private String eventStartTimeStamp;
    private String eventEndTimeStamp;
    private String[] eventSystems;
    private int      pageNum;

    public String getEventId()
    {
        return eventId;
    }

    public void setEventId(String eventId)
    {
        this.eventId = eventId;
    }

    public String getUserId()
    {
        return userId;
    }

    public void setUserId(String userId)
    {
        this.userId = userId;
    }

    public String[] getEventType()
    {
        return eventType;
    }

    public void setEventType(String[] eventType)
    {
        this.eventType = eventType;
    }

    public String getEventTypeList()
    {
        return eventTypeList;
    }

    public void setEventTypeList(String eventTypeList)
    {
        this.eventTypeList = eventTypeList;
    }

    public String getEventTimeStamp()
    {
        return eventTimeStamp;
    }

    public void setEventTimeStamp(String eventTimeStamp)
    {
        this.eventTimeStamp = eventTimeStamp;
    }

    public String getLogLevelList()
    {
        return logLevelList;
    }

    public void setLogLevelList(String logLevelList)
    {
        this.logLevelList = logLevelList;
    }

    public String[] getLogLevel()
    {
        return logLevel;
    }

    public void setLogLevel(String[] logLevel)
    {
        this.logLevel = logLevel;
    }

    public String getErrorCategoryList()
    {
        return errorCategoryList;
    }

    public void setErrorCategoryList(String errorCategoryList)
    {
        this.errorCategoryList = errorCategoryList;
    }

    public String[] getErrorCategory()
    {
        return errorCategory;
    }

    public void setErrorCategory(String[] errorCategory)
    {
        this.errorCategory = errorCategory;
    }

    public String getErrorCodeList()
    {
        return errorCodeList;
    }

    public void setErrorCodeList(String errorCodeList)
    {
        this.errorCodeList = errorCodeList;
    }

    public String[] getErrorCode()
    {
        return errorCode;
    }

    public void setErrorCode(String[] errorCode)
    {
        this.errorCode = errorCode;
    }

    public String getLogDate()
    {
        return logDate;
    }

    public void setLogDate(String logDate)
    {
        this.logDate = logDate;
    }

    public String getLogTime()
    {
        return logTime;
    }

    public void setLogTime(String logTime)
    {
        this.logTime = logTime;
    }

    public String getEventStartTimeStamp()
    {
        return eventStartTimeStamp;
    }

    public void setEventStartTimeStamp(String eventStartTimeStamp)
    {
        this.eventStartTimeStamp = eventStartTimeStamp;
    }

    public String getEventEndTimeStamp()
    {
        return eventEndTimeStamp;
    }

    public void setEventEndTimeStamp(String eventEndTimeStamp)
    {
        this.eventEndTimeStamp = eventEndTimeStamp;
    }

    public String[] getEventSystems()
    {
        return eventSystems;
    }

    public void setEventSystems(String[] eventSystems)
    {
        this.eventSystems = eventSystems;
    }

    public int getPageNum()
    {
        return pageNum;
    }

    public void setPageNum(int pageNum)
    {
        this.pageNum = pageNum;
    }
}