package com.tops.mapper.urt;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.BpInfo;

@Mapper
public interface BpInfoMapper
{
	// BP 정보 조회(단건)
    BpInfo selectBpInfo(@Param("bpInfo") BpInfo bpInfo);

	// BP 정보 등록
    int insertBpInfo(@Param("bpInfo") BpInfo bpInfo);

	// BP 정보 수정
    int updateBpInfo(@Param("bpInfo") BpInfo bpInfo);

	// BP 정보 삭제
    int deleteBpInfo(@Param("bpInfo") BpInfo bpInfo);
}
