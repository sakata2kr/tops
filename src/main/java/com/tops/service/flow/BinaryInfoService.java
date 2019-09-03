package com.tops.service.flow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.BinaryInfoMapper;
import com.tops.model.flow.BinaryInfo;
import com.tops.model.flow.BinaryLocation;
import com.tops.service.BaseService;

/**
 * BINARY 정보 관리를 위한 Service class
 * 
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class BinaryInfoService extends BaseService
{
    @Autowired
	private BinaryInfoMapper binaryInfoMapper;

	/** BINARY 정보 조회 목록 */
	public List<BinaryInfo> retrieveBinaryInfoList()
	{
		return binaryInfoMapper.selectBinaryInfoList();
	}
	
	/** BINARY 정보 조회 목록(전체) */
	public List<BinaryInfo> retrieveBinaryInfoAllList()
	{
		return binaryInfoMapper.selectBinaryInfoAllList();
	}
	
	/** BINARY 정보 조회*/
	public BinaryInfo retrieveBinaryInfo(String binaryId)
	{
		return binaryInfoMapper.selectBinaryInfo(binaryId);
	}
	
	/** BINARY Loc정보 조회 목록(전체) */
	public List<BinaryLocation> retrieveBinaryLocationInfoList(BinaryInfo binaryInfo)
	{
		return binaryInfoMapper.selectBinaryLocationInfoList(binaryInfo);
	}
	
	/** BINARY, BINARY Loc 등록 */
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean registerBinaryInfo(BinaryInfo binaryInfo)
	{
		boolean result = true;

		//binaryInfo 저장
		int cnt = binaryInfoMapper.insertBinaryInfo(binaryInfo);
		
		if(cnt > 0)
		{
			//binary location 저장
			List<BinaryLocation> list = binaryInfo.getBinaryLocationList();

			if(list != null)
			{
				for(BinaryLocation param : list)
				{
					binaryInfoMapper.insertBinaryLocationInfo(param);
				}
			}
		}
		else
		{
			result = false;
		}

		return result;
	}
	
	/** BINARY, BINARY Loc 수정 */
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean modifyBinaryInfo(BinaryInfo binaryInfo)
	{
		boolean result = true;

		//binaryInfo 저장
		int cnt = binaryInfoMapper.updateBinaryInfo(binaryInfo);
		
		if(cnt > 0)
		{
			//binary location 삭제
			binaryInfoMapper.deleteBinaryLocationInfo(binaryInfo.getBinary_id());
			
			//binary location 저장
			List<BinaryLocation> list = binaryInfo.getBinaryLocationList();

			if(list != null)
			{
				for(BinaryLocation param : list)
				{
					binaryInfoMapper.insertBinaryLocationInfo(param);
				}
			}
		}
		else
		{
			result = false;
		}
		
		return result;
	}
	
	/** BINARY, BINARY Loc 삭제 */
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public boolean removeBinaryInfo(BinaryInfo binaryInfo)
	{
		boolean result = true;

		//binaryInfo 저장
		int cnt = binaryInfoMapper.deleteBinaryInfo(binaryInfo.getBinary_id());
		
		if(cnt > 0)
		{
			//binary location 삭제
			binaryInfoMapper.deleteBinaryLocationInfo(binaryInfo.getBinary_id());
		}
		else
		{
			result = false;
		}
		
		return result;
	}
}
