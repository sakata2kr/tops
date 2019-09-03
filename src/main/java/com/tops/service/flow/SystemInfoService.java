package com.tops.service.flow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.SystemInfoMapper;
import com.tops.model.flow.SystemInfo;
import com.tops.service.BaseService;

/**
 * 시스템정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class SystemInfoService extends BaseService
{
    @Autowired
    private SystemInfoMapper systemInfoMapper;

    // 시스템정보 조회 목록 
    public List<SystemInfo> retrieveSystemInfoList(SystemInfo systemInfo)
	{
        return systemInfoMapper.selectSystemInfoList(systemInfo);
    }

    // 시스템정보 조회(단건) 
    public SystemInfo retrieveSystemInfo(SystemInfo systemInfo)
	{
        return systemInfoMapper.selectSystemInfo(systemInfo);
    }

    // 시스템정보 등록 
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean registerSystemInfo(SystemInfo systemInfo)
	{
        return systemInfoMapper.insertSystemInfo(systemInfo) > 0;
    }

    // 시스템정보 수정 
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean modifySystemInfo(SystemInfo systemInfo)
	{
        return systemInfoMapper.updateSystemInfo(systemInfo) > 0;
    }

    // 시스템정보 삭제 
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeSystemInfo(SystemInfo systemInfo)
	{
        return systemInfoMapper.deleteSystemInfo(systemInfo) > 0;
    }

    // 백업정책 대상 시스템정보 조회 목록 
    public List<SystemInfo> retrieveBackupPolicySystemInfoList()
	{
        return systemInfoMapper.selectBackupPolicySystemInfoList();
    }

    // LOGICAL GROUP 정보 조회 목록 
    public List<SystemInfo> retrieveLogicalGroupInfoList()
	{
        return systemInfoMapper.selectLogicalGroupInfoList();
    }
}