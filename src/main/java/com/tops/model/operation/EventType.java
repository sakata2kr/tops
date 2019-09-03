package com.tops.model.operation;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("EventType")
public class EventType extends BaseObject
{
    private String eventType;
    private String description;

    public String getEventType()
    {
        return eventType;
    }

    public void setEventType(String eventType)
    {
        this.eventType = eventType;
    }

    public String getDescription()
    {
        return description;
    }

    public void setDescription(String description)
    {
        this.description = description;
    }
}