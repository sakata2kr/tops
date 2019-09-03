package com.tops.mapper.urt;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.BusinessModule;
import com.tops.model.flow.BusinessProcess;
import com.tops.model.flow.FlowEntity;
import com.tops.model.flow.FlowidInfo;
import com.tops.model.flow.GroupInfo;

@Mapper
public interface FlowMapper
{
    // Flow 정보 리스트 조회
    List<FlowidInfo> selectFlowInfoList(@Param("groupInfo") GroupInfo groupInfo);

    // BP Group 리스트 조회
    List<String> selectBpNameList();

    // BP Group에 해당하는 BP 리스트 조회
    List<BusinessProcess> selectBpInfoByBpName(@Param("bp_name") String bp_name);

    // BP Group에 해당하는 BM 리스트 조회
    List<BusinessModule> selectBmInfoByBpId(@Param("bp_id") String bp_id);

    // 삭제 대상 Group 내 BP 정보에 대한 tb_prc_bpid 테이블 삭제
    void deleteBpInfo(@Param("system_id") String system_id, @Param("group_id") String group_id);

    // 삭제 대상 Group 내 BP 정보에 대한 tb_prc_bpid_mapping 테이블 삭제
    void deleteBpInfoMapping(@Param("system_id") String system_id, @Param("group_id") String group_id);

    // 삭제 대상 Group 내 BP 정보에 대한 tb_prc_bmid 테이블 삭제
    void deleteBmInfo(@Param("system_id") String system_id, @Param("group_id") String group_id);

    // 삭제 대상 Group 내 BP 정보에 대한 tb_prc_bmid_mapping 테이블 삭제
    void deleteBmInfoMapping(@Param("system_id") String system_id, @Param("group_id") String group_id);

    // Flow ID에 해당하는 Flow Diagram Entity 정보들 삭제
    void deleteFlowInfo(@Param("flow_id") String flow_id, @Param("system_id") String system_id, @Param("group_id") String group_id);

    // 추가 BP에 대한 tb_prc_bpid 테이블 추가
    void insertBpInfo(@Param("flowEntity") FlowEntity flowEntity);

    // 추가 BP에 대한 tb_prc_bpid_mapping 테이블 추가
    void insertBpInfoMapping(@Param("flowEntity") FlowEntity flowEntity);

    // 추가 BM에 대한 tb_prc_bmid 테이블 추가
    void insertBmInfo(@Param("flowEntity") FlowEntity flowEntity);

    // 추가 BM에 대한 tb_prc_bmid_mapping 테이블 추가
    void insertBmInfoMapping(@Param("flowEntity") FlowEntity flowEntity);

    // Flow Diagram Entity 정보 등록
    void insertFlowInfo(@Param("flowEntity") FlowEntity flowEntity);

    // Flow ID에 해당하는 Flow Diagram Entity 리스트 조회
    List<FlowEntity> selectRecursiveFlowList(@Param("flow_id") String flow_id, @Param("group_id") String group_id, @Param("system_id") String system_id, @Param("cloneYn") String cloneYn);

    // Group ID에 해당하는 기동중인 프로세스 개수 조회
    int selectFlowInfoCount(@Param("flow_id") String flow_id);

    // Group ID에 해당하는 기동중인 프로세스 개수 조회
    int selectRunningProcessCountByGroupId(@Param("groupId") String groupId);
}
