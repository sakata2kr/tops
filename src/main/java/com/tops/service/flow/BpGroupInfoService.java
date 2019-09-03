package com.tops.service.flow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.BpGroupInfoMapper;
import com.tops.model.flow.BpGroupInfo;
import com.tops.service.BaseService;

/**
 * BP GROUP 정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class BpGroupInfoService extends BaseService
{
    @Autowired
	private BpGroupInfoMapper bpGroupInfoMapper;

    /** BP GROUP 정보 조회 목록 */
	public List<BpGroupInfo> retrieveBpGroupInfoList()
	{
		return bpGroupInfoMapper.selectBpGroupInfoList();
	}
	
	/** BP GROUP 정보 조회(단건) */
	public BpGroupInfo retrieveBpGroupInfo(String bpGroupId)
	{
		return bpGroupInfoMapper.selectBpGroupInfo(bpGroupId);
	}
	
	/** BP GROUP 정보 등록 */
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean registerBpGroupInfo(BpGroupInfo bpGroupInfo)
	{
		return bpGroupInfoMapper.insertBpGroupInfo(bpGroupInfo) > 0;
	}
	
	/** BP GROUP 정보 수정 */
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean modifyBpGroupInfo(BpGroupInfo bpGroupInfo)
	{
		return bpGroupInfoMapper.updateBpGroupInfo(bpGroupInfo) > 0;
	}
	
	/** BP GROUP 정보 삭제 */
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean removeBpGroupInfo(BpGroupInfo bpGroupInfo)
	{
		return bpGroupInfoMapper.deleteBpGroupInfo(bpGroupInfo) > 0;
	}
}
