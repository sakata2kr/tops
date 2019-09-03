package com.tops.model.flow;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import com.tops.model.BaseObject;

@JsonIgnoreProperties(ignoreUnknown = true)
public class Text extends BaseObject
{
    private String text;

    public String getText()
    {
        return text;
    }

    public void setText(String text)
    {
        this.text = text;
    }
}