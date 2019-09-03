package com.tops.model.flow;

import java.util.List;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("BinaryInfo")
public class BinaryInfo extends BaseObject
{
    private String binary_id;
    private String binary_name;
    private String description;

    private List<BinaryLocation> binaryLocationList;

    public List<BinaryLocation> getBinaryLocationList()
    {
        return binaryLocationList;
    }

    public void setBinaryLocationList(List<BinaryLocation> binaryLocationList)
    {
        this.binaryLocationList = binaryLocationList;
    }

    public String getBinary_id()
    {
        return binary_id;
    }

    public void setBinary_id(String binary_id)
    {
        this.binary_id = binary_id;
    }

    public String getBinary_name()
    {
        return binary_name;
    }

    public void setBinary_name(String binary_name)
    {
        this.binary_name = binary_name;
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