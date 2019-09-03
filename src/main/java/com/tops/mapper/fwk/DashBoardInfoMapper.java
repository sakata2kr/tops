package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.tops.model.operation.DashBoardInfo;

@Mapper
public interface DashBoardInfoMapper
{
	// 대시보드 상태 체크
    List<DashBoardInfo> selectDashBoardInfo();
}
