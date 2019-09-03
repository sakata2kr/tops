package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.operation.QueueStatusInfo;
import com.tops.model.operation.DashBoardInfo;

@Mapper
public interface FwkOperationInfoMapper
{
	// Framework 이상 상태 여부 조회
	List<DashBoardInfo> selectFwkProcessErrorInfo();

	// BP 기준 QUEUE 처리 상태 조회
    List<QueueStatusInfo> selectStatusByBp(@Param("group_id") String group_id, @Param("op_system_id") String op_system_id);

    // GROUP 기준 QUEUE 처리 상태 조회
    List<QueueStatusInfo> selectStatusByGroup(@Param("selItemInfoList") List<QueueStatusInfo> selItemInfoList, @Param("op_system_id") String op_system_id);

    // SERVER 기준 QUEUE 처리 상태 조회
    List<QueueStatusInfo> selectStatusByServer(@Param("selItemInfoList") List<QueueStatusInfo> selItemInfoList);

	// Queue 처리 중 비정상 프로세스에 대한 상세 내역 조회
    List<QueueStatusInfo> selectTopQueueInfo();
}
