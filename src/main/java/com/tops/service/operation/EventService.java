package com.tops.service.operation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.EventMapper;
import com.tops.model.operation.EventMessage;
import com.tops.model.operation.EventParam;
import com.tops.model.operation.EventType;
import com.tops.service.BaseService;

/**
 * 이벤트 로그 조회를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class EventService extends BaseService
{
    @Autowired
    private EventMapper eventMapper;

    // 현재 시간의 TimeStamp 조회
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public String selectCurrentTimeStamp()
	{
        return eventMapper.selectCurrentTimeStamp();
    }

    // event Type 목록
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public List<EventType> selectEventType()
	{
        return eventMapper.selectEventType();
    }

    // 최근 eventLog 단건 조회 - Alert 처리용
    public List<EventMessage> selectEventMessage (String selTimeStamp)
    {
        return eventMapper.selectEventMessage(selTimeStamp);
    }

    // 사용자별 event 목록 조회
    public List<EventMessage> selectUserEventLog(EventParam param)
	{
        return eventMapper.selectUserEventLog(param);
    }
}