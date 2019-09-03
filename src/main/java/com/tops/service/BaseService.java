package com.tops.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.tops.controller.BaseController;

/**
 * 이 클래스는 모든 Concrete Service 클래스의 Base 클래스이다.
 * 모든 Service 클래스는 이 클래스를 extend하여 생성한다.
 */
public abstract class BaseService extends BaseController
{
    protected final Logger logger = LoggerFactory.getLogger(this.getClass());
}