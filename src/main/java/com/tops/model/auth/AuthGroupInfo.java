package com.tops.model.auth;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("AuthGroupInfo")
public class AuthGroupInfo extends BaseObject
{
	private String auth_group_id;
	private String auth_group_name;
	private String operation_yn;

	public String getAuth_group_id()
	{
		return auth_group_id;
	}

	public void setAuth_group_id(String auth_group_id)
	{
		this.auth_group_id = auth_group_id;
	}

	public String getAuth_group_name()
	{
		return auth_group_name;
	}

	public void setAuth_group_name(String auth_group_name)
	{
		this.auth_group_name = auth_group_name;
	}

	public String getOperation_yn()
	{
		return operation_yn;
	}

	public void setOperation_yn(String operation_yn)
	{
		this.operation_yn = operation_yn;
	}
}
