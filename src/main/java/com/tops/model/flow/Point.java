package com.tops.model.flow;

import com.tops.model.BaseObject;

public class Point extends BaseObject
{
	private String id;

	public Point(String id)
    {
		super();
		this.id = id;
	}

	public String getId()
    {
		return id;
	}

	public void setId(String id)
    {
		this.id = id;
	}
}
