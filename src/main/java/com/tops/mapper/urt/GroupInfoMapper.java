package com.tops.mapper.urt;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.flow.GroupBackupPolicyInfo;
import com.tops.model.flow.GroupInfo;

@Mapper
public interface GroupInfoMapper
{
	// 그룹정보 조회
    List<GroupInfo> selectGroupInfoList(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹정보 조회(단건)
    GroupInfo selectGroupInfo(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹정보 등록
    boolean insertGroupInfo(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹정보 수정
    boolean updateGroupInfo(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹정보 삭제
    boolean deleteGroupInfo(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹백업정책정보 조회
    List<GroupBackupPolicyInfo> selectGroupBackupPolicyInfoList(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹ID에 대한 그룹백업정책정보 삭제
    boolean deleteGroupBackupPolicyInfo(String group_id);

	// 그룹ID에 대한 그룹상태정보 삭제
    boolean deleteGroupStatusInfo(String group_id);

	// 그룹백업정책정보 등록
    boolean insertGroupBackupPolicyInfo(@Param("groupBackupPolicyInfo") GroupBackupPolicyInfo groupBackupPolicyInfo);

	// 그룹상태정보 등록
    boolean insertGroupStatusInfo(@Param("groupBackupPolicyInfo") GroupBackupPolicyInfo groupBackupPolicyInfo);

	// 그룹ID 에 대한 FLOW 정보 존재 여부 체크
    Integer selectFlowExistByGroupId(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹정보에 대한 switch type 존재 여부 체크
    Integer selectGroupInfoSwitchTypeCnt(@Param("groupInfo") GroupInfo groupInfo);

	// 그룹정보에 대한 switch type 단건조회
    GroupInfo selectGroupInfoSwitchType(@Param("groupInfo") GroupInfo groupInfo);
}
