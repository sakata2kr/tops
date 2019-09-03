package com.tops.service.flow;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.BpInfoMapper;
import com.tops.model.flow.BpInfo;
import com.tops.service.BaseService;

/**
 * BP 정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class BpInfoService extends BaseService
{
    @Autowired
	private BpInfoMapper bpInfoMapper;
	
	// BP 정보 조회(단건) 
	public BpInfo retrieveBpInfo(BpInfo bpInfo)
	{
		return bpInfoMapper.selectBpInfo(bpInfo);
	}
	
	// BP 정보 등록 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean registerBpInfo(BpInfo bpInfo)
	{
		return bpInfoMapper.insertBpInfo(bpInfo) > 0;
	}
	
	// BP 정보 수정 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean modifyBpInfo(BpInfo bpInfo)
	{
		return bpInfoMapper.updateBpInfo(bpInfo) > 0;
	}
	
	// BP 정보 삭제 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean removeBpInfo(BpInfo bpInfo)
	{
		return bpInfoMapper.deleteBpInfo(bpInfo) > 0;
	}	
}
