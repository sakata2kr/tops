package com.tops.service.auth;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.ResourceInfoMapper;
import com.tops.model.auth.ResourceInfo;
import com.tops.model.common.SearchParam;
import com.tops.service.BaseService;

/**
 * 리소스 정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class ResourceInfoService extends BaseService
{
    @Autowired
    private ResourceInfoMapper resourceInfoMapper;

    // 리소스 정보 조회 목록
    public List<ResourceInfo> retrieveResourceInfoList(SearchParam search)
    {
        return resourceInfoMapper.selectResourceInfoList(search);
    }

    // 리소스 정보 조회(단건)
    public ResourceInfo retrieveResourceInfo(String resource_id)
    {
        return resourceInfoMapper.selectResourceInfo(resource_id);
    }

    // 리소스 정보 등록
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean registerResourceInfo(ResourceInfo resourceInfo)
    {
        return resourceInfoMapper.insertResourceInfo(resourceInfo);
    }

    // 리소스 정보 수정
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean modifyResourceInfo(ResourceInfo resourceInfo)
    {
        return resourceInfoMapper.updateResourceInfo(resourceInfo);
    }

    // 메뉴에 속한 리소스가 존재하는지 조회
    public boolean checkResourceInfoBind(ResourceInfo resourceInfo)
    {
        if ( resourceInfoMapper.selectMenuResourceInfo(resourceInfo) > 0 )
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // 리소스ID로 리소스 접근 정보 삭제
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeResourceAccessInfoByResourceId(ResourceInfo resourceInfo)
    {
        return resourceInfoMapper.deleteResourceAccessInfoByResourceId(resourceInfo);
    }

    // 리소스 정보 삭제
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeResourceInfo(ResourceInfo resourceInfo)
    {
        return resourceInfoMapper.deleteResourceInfo(resourceInfo);
    }
}