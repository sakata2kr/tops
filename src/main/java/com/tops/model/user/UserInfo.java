package com.tops.model.user;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import com.tops.model.BaseObject;

@Alias("UserInfo")
public class UserInfo extends BaseObject implements Serializable
{
    /* Web/WAS 서버 이중화 구성을 위한 사용자 계정 정보 Serial구성 */
    private static final long serialVersionUID = 1L;

    private String user_id;
    private String password;
    private String user_group_id;
    private String user_group_name;
    private String user_name;
    private String phone_no;
    private String tel_no;
    private String email;
    private String last_login_dt;

    private String new_password;
    private String alert_receive_yn;
    private String operation_yn;

    private String ipAddr;  // 로그인 시 해당 세션의 IP 정보를 받아 저장

    public String getUser_id()
    {
        return user_id;
    }

    public void setUser_id(String user_id)
    {
        this.user_id = user_id;
    }

    public String getPassword()
    {
        return password;
    }

    public void setPassword(String password)
    {
        this.password = password;
    }

    public String getUser_group_id()
    {
        return user_group_id;
    }

    public void setUser_group_id(String user_group_id)
    {
        this.user_group_id = user_group_id;
    }

    public String getUser_group_name()
    {
        return user_group_name;
    }

    public void setUser_group_name(String user_group_name)
    {
        this.user_group_name = user_group_name;
    }

    public String getUser_name()
    {
        return user_name;
    }

    public void setUser_name(String user_name)
    {
        this.user_name = user_name;
    }

    public String getPhone_no()
    {
        return phone_no;
    }

    public void setPhone_no(String phone_no)
    {
        this.phone_no = phone_no;
    }

    public String getTel_no()
    {
        return tel_no;
    }

    public void setTel_no(String tel_no)
    {
        this.tel_no = tel_no;
    }

    public String getEmail()
    {
        return email;
    }

    public void setEmail(String email)
    {
        this.email = email;
    }

    public String getLast_login_dt()
    {
        return last_login_dt;
    }

    public void setLast_login_dt(String last_login_dt)
    {
        this.last_login_dt = last_login_dt;
    }

    public String getNew_password()
    {
        return new_password;
    }

    public void setNew_password(String new_password)
    {
        this.new_password = new_password;
    }

    public String getAlert_receive_yn()
    {
        return alert_receive_yn;
    }

    public void setAlert_receive_yn(String alert_receive_yn)
    {
        this.alert_receive_yn = alert_receive_yn;
    }

    public String getOperation_yn()
    {
        return operation_yn;
    }

    public void setOperation_yn(String operation_yn)
    {
        this.operation_yn = operation_yn;
    }

    public String getIpAddr()
    {
        return ipAddr;
    }

    public void setIpAddr(String ipAddr)
    {
        this.ipAddr = ipAddr;
    }
}