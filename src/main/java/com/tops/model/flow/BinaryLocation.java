package com.tops.model.flow;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseInfo;

@Alias("BinaryLocation")
public class BinaryLocation extends BaseInfo
{
    private String psystemId;
    private String binaryId;
    private String binaryLoc;

    public String getPsystemId()
    {
        return psystemId;
    }

    public void setPsystemId(String psystemId)
    {
        this.psystemId = psystemId;
    }

    public String getBinaryId()
    {
        return binaryId;
    }

    public void setBinaryId(String binaryId)
    {
        this.binaryId = binaryId;
    }

    public String getBinaryLoc()
    {
        return binaryLoc;
    }

    public void setBinaryLoc(String binaryLoc)
    {
        this.binaryLoc = binaryLoc;
    }
}