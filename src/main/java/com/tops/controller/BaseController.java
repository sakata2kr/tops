package com.tops.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * 이 클래스는 모든 Concrete Controller 클래스의 Base 클래스이다.
 * 모든 Controller 클래스는 이 클래스를 extend하여 생성한다.
 */
public class BaseController
{
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());
}
