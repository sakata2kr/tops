package com.tops.model.flow;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Flow Diagram에서 각 Element 간 연결 정보
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class Link extends DiagramCell
{
	private Point source;
	private Point target;

	@Override
	public String getTypeValue()
    {
		return "link";
	}

	/**
	 * @return the source
	 */
	public Point getSource()
    {
		return source;
	}

	/**
	 * @param source the source to set
	 */
	public void setSource(Point source)
    {
		this.source = source;
	}

	/**
	 * @return the target
	 */
	public Point getTarget()
    {
		return target;
	}

	/**
	 * @param target the target to set
	 */
	public void setTarget(Point target)
    {
		this.target = target;
	}
}
