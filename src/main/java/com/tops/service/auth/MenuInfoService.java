package com.tops.service.auth;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.MenuInfoMapper;
import com.tops.model.auth.MenuInfo;
import com.tops.model.auth.ResourceInfo;
import com.tops.service.BaseService;

/**
 * 메뉴 정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class MenuInfoService extends BaseService
{
    @Autowired
	private MenuInfoMapper menuInfoMapper;

    // 메뉴 정보 조회 목록 
	public List<MenuInfo> retrieveMenuInfoList(String auth_group_id)
	{
		return menuInfoMapper.selectMenuInfoList(auth_group_id);
	}

	// 메뉴 정보 등록 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean registerMenuInfo(MenuInfo menuInfo)
	{
		return menuInfoMapper.insertMenuInfo(menuInfo);
	}
	
	// 메뉴 정보 수정 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean modifyMenuInfo(MenuInfo menuInfo)
	{
		return menuInfoMapper.updateMenuInfo(menuInfo);
	}
	
	// 메뉴 정보 삭제 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean removeMenuInfo(MenuInfo menuInfo)
	{
		return menuInfoMapper.deleteMenuInfo(menuInfo);
	}
	
	// 메뉴 리소스 정보 조회 목록 
	public List<ResourceInfo> retrieveResourceInfoList()
	{
		return menuInfoMapper.selectResourceInfoList();
	}
}