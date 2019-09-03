package com.tops.service.auth;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.ResourceAccessInfoMapper;
import com.tops.model.auth.ResourceAccessInfo;
import com.tops.model.common.SearchParam;
import com.tops.service.BaseService;

/**
 * 리소스접근권한정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class ResourceAccessInfoService extends BaseService
{
    @Autowired
	private ResourceAccessInfoMapper resourceAccessInfoMapper;

    // 리소스 접근 정보 조회 목록
	public List<ResourceAccessInfo> retrieveResourceAccessInfoList(SearchParam search)
	{
		return resourceAccessInfoMapper.selectResourceAccessInfoList(search);
	}
	
	// 리소스 접근 정보 등록
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean registerResourceAccessInfo(ResourceAccessInfo resourceAccessInfo)
	{
		return resourceAccessInfoMapper.insertResourceAccessInfo(resourceAccessInfo);
	}

	// 리소스 접근 정보 권한그룹ID로 삭제
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean removeResourceAccessInfo(String authGroupId)
	{
		return resourceAccessInfoMapper.deleteResourceAccessInfo(authGroupId);
	}

	// 계정에 할당된 그룹과 관련 리소스 접근 여부 확인
	public boolean validUserResourceAccess(String userid, String uri)
	{
        if ( resourceAccessInfoMapper.validUserResourceAccess(userid, uri) == null )
        {
            return false;
        }
        else
        {
            return true;
        }
	}
}