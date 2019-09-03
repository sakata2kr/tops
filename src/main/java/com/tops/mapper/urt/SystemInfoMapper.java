package com.tops.mapper.urt;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.SystemInfo;

@Mapper
public interface SystemInfoMapper
{
	// 시스템정보 조회
    List<SystemInfo> selectSystemInfoList(@Param("systemInfo") SystemInfo systemInfo);

	// 시스템정보 조회(단건)
    SystemInfo selectSystemInfo(@Param("systemInfo") SystemInfo systemInfo);

	// 시스템정보 등록
    int insertSystemInfo(@Param("systemInfo") SystemInfo systemInfo);

	// 시스템정보 수정
    int updateSystemInfo(@Param("systemInfo") SystemInfo systemInfo);

	// 시스템정보 삭제
    int deleteSystemInfo(@Param("systemInfo") SystemInfo systemInfo);

	// 백업정책대상시스템정보 조회
    List<SystemInfo> selectBackupPolicySystemInfoList();

	// LOGICAL GROUP 정보 조회
    List<SystemInfo> selectLogicalGroupInfoList();
}
