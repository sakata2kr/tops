package com.tops.service.flow;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.BmInfoMapper;
import com.tops.model.flow.BmInfo;
import com.tops.service.BaseService;

/**
 * BM 정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class BmInfoService extends BaseService
{
    @Autowired
	private BmInfoMapper bmInfoMapper;

    // BM 정보 조회(단건) 
	public BmInfo retrieveBmInfo(BmInfo bmInfo)
	{
		return bmInfoMapper.selectBmInfo(bmInfo);
	}
	
	// BM 정보 등록 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean registerBmInfo(BmInfo bmInfo)
	{
		return bmInfoMapper.insertBmInfo(bmInfo) > 0;
	}
	
	// BM 정보 수정 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean modifyBmInfo(BmInfo bmInfo)
	{
		return bmInfoMapper.updateBmInfo(bmInfo) > 0;
	}
	
	// BM 정보 삭제 
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean removeBmInfo(BmInfo bmInfo)
	{
		return bmInfoMapper.deleteBmInfo(bmInfo) > 0;
	}
}