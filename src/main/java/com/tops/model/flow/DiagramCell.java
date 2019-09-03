package com.tops.model.flow;

import com.fasterxml.jackson.annotation.JsonSubTypes;
import com.fasterxml.jackson.annotation.JsonSubTypes.Type;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.tops.model.BaseObject;

@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, include = JsonTypeInfo.As.PROPERTY, property = "type")
@JsonSubTypes({ @Type(value = FlowEntity.class, name = "entity"), @Type(value = Link.class, name = "link") })
public abstract class DiagramCell extends BaseObject
{
	private String type;
	private String id;

	DiagramCell ()
	{
		setType(getTypeValue());
	}

	protected abstract String getTypeValue();

	public String getType()
    {
		return type;
	}

	public void setType(String type)
    {
		this.type = type;
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
