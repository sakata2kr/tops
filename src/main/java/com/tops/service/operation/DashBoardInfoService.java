package com.tops.service.operation;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.DashBoardInfoMapper;
import com.tops.model.operation.DashBoardInfo;
import com.tops.service.BaseService;

/**
 * 대시보드용 정보 조회를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class DashBoardInfoService extends BaseService
{
    @Autowired
    private DashBoardInfoMapper dashBoardMapper;

    // 대시보드 정보 조회
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public List<DashBoardInfo> getDashBoardInfo()
	{
        return dashBoardMapper.selectDashBoardInfo();
    }

}