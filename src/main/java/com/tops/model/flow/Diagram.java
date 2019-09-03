package com.tops.model.flow;

import java.util.List;

import com.tops.model.BaseObject;

/**
 * Flow Diagram 정보
 */
public class Diagram extends BaseObject
{
	private String flow_id;     /** FLOW ID */
	private String group_id;	/** 그룹 ID */
	private String system_id;   /** 시스템 ID */

	private List<DiagramCell> cells;

	public String getFlow_id()
    {
		return flow_id;
	}

	public void setFlow_id(String flow_id)
    {
		this.flow_id = flow_id;
	}

	public String getGroup_id()
    {
		return group_id;
	}

	public void setGroup_id(String group_id)
    {
		this.group_id = group_id;
	}

	public String getSystem_id()
    {
		return system_id;
	}

	public void setSystem_id(String system_id)
    {
		this.system_id = system_id;
	}

	public List<DiagramCell> getCells()
    {
		return cells;
	}

	public void setCells(List<DiagramCell> cells)
    {
		this.cells = cells;
	}
}
