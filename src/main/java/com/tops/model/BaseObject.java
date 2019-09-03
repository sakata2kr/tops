package com.tops.model;

import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;

/**
 * 이 클래스는 모든 Concrete Model 클래스의 Base 클래스이다.
 * 모든 Model 클래스는 이 클래스를 extend하여 생성한다.
 */
public abstract class BaseObject
{
    @Override
    public String toString()
    {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.MULTI_LINE_STYLE);
    }

    @Override
    public boolean equals(Object o)
    {
        return EqualsBuilder.reflectionEquals(this, o);
    }

    @Override
    public int hashCode()
    {
        return HashCodeBuilder.reflectionHashCode(this);
    }
}