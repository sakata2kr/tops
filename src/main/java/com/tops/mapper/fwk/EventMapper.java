package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.operation.EventMessage;
import com.tops.model.operation.EventParam;
import com.tops.model.operation.EventType;

@Mapper
public interface EventMapper
{
	// EventType 목록
    List<EventType> selectEventType();

	// 사용자별 EventLog 목록
	List<EventMessage> selectUserEventLog(@Param("eventParam") EventParam eventParam);

	// 사용자별 eventLog 조회 - 대시보드용
	List<EventMessage> selectEventMessage (@Param("selTimeStamp") String selTimeStamp);
	
	// 현재 시간의 TimeStamp 조회
	String selectCurrentTimeStamp();
}
