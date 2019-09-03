package com.tops.mapper.urt;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.operation.ProcessInfoFlatData;
import com.tops.model.operation.ProcessServerList;
import com.tops.model.operation.QueueStatusInfo;

@Mapper
public interface UrtOperationInfoMapper
{
    // 서버 리스트 조회
    List<ProcessServerList> getServetList();

	// Process Tree 리스트 조회
    List<ProcessInfoFlatData> getProcessTreeData();

    // STATUS 조회를 위한 GROUP 정보 조회
    List<QueueStatusInfo> getGroupInfo(@Param("grp_ctg1") String grp_ctg1, @Param("grp_ctg2") String grp_ctg2, @Param("group_id") String group_id);

    // STATUS 조회를 위한 BP 리스트 조회
    List<QueueStatusInfo> getBpInfo(@Param("group_id") String group_id, @Param("op_system_id") String op_system_id);
}
