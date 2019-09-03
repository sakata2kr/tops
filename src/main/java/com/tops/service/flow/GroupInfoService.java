package com.tops.service.flow;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.urt.GroupInfoMapper;
import com.tops.model.flow.GroupBackupPolicyInfo;
import com.tops.model.flow.GroupInfo;
import com.tops.service.BaseService;

/**
 * 그룹정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class GroupInfoService extends BaseService
{
    @Autowired
    private GroupInfoMapper groupInfoMapper;

    /** 그룹정보 조회 목록 */
    public List<GroupInfo> retrieveGroupInfoList(GroupInfo groupInfo)
    {
        return groupInfoMapper.selectGroupInfoList(groupInfo);
    }

    /** 그룹정보 조회(단건) */
    public GroupInfo retrieveGroupInfo(GroupInfo groupInfo)
    {
        return groupInfoMapper.selectGroupInfo(groupInfo);
    }

    /** 그룹정보 등록 */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean registerGroupInfo(GroupInfo groupInfo)
    {
        if(!"".equals(groupInfo.getSwitch_type()))
        {
            Integer switchTypeCnt = groupInfoMapper.selectGroupInfoSwitchTypeCnt(groupInfo);

            if(switchTypeCnt != null && switchTypeCnt > 0)
            {
                return false;
            }
        }

        return groupInfoMapper.insertGroupInfo(groupInfo);
    }

    /** 그룹정보 수정 */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean modifyGroupInfo(GroupInfo groupInfo)
    {
        if(!"".equals(groupInfo.getSwitch_type()))
        {
            GroupInfo info = groupInfoMapper.selectGroupInfoSwitchType(groupInfo);

            //switch type정보가 갱신된 경우
            if(!groupInfo.getSwitch_type().equals(info.getSwitch_type()))
            {
                Integer switchTypeCnt = groupInfoMapper.selectGroupInfoSwitchTypeCnt(groupInfo);

                if(switchTypeCnt != null && switchTypeCnt > 0)
                {
                    return false;
                }
            }
        }

        return groupInfoMapper.updateGroupInfo(groupInfo);
    }

    /** 그룹정보 삭제 */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeGroupInfo(GroupInfo groupInfo)
    {
        return groupInfoMapper.deleteGroupInfo(groupInfo);
    }

    /** 그룹백업정책정보 조회*/
    public List<GroupBackupPolicyInfo> retrieveGroupBackupPolicyInfoList(GroupInfo groupInfo)
    {
        return groupInfoMapper.selectGroupBackupPolicyInfoList(groupInfo);
    }

    /** 그룹ID에 대한 그룹백업정책정보 삭제 */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeGroupBackupPolicyInfo (String groupId)
    {
        return groupInfoMapper.deleteGroupBackupPolicyInfo(groupId);
    }

    /** 그룹ID에 대한 그룹상태정보 삭제 */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeGroupStatusInfo (String groupId)
    {
        return groupInfoMapper.deleteGroupStatusInfo(groupId);
    }

    /** 그룹백업정책정보 등록 */
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean registerGroupBackupPolicyInfo(GroupInfo groupInfo)
    {
        boolean isSuccess = false;

        List<GroupBackupPolicyInfo> groupBackupPolicyInfoList = groupInfo.getBackup_policy_list();

        if(groupBackupPolicyInfoList != null)
        {
            // 그룹id로 백업정책정보 및 그룹상태정보 삭제
            if ( removeGroupBackupPolicyInfo(groupInfo.getGroup_id())
              && removeGroupStatusInfo(groupInfo.getGroup_id())
               )
            {
                for ( GroupBackupPolicyInfo groupBackupPolicyInfo : groupBackupPolicyInfoList )
                {
                    // 백업정책정보 insert
                    if ( !groupInfoMapper.insertGroupBackupPolicyInfo(groupBackupPolicyInfo)
                      || !groupInfoMapper.insertGroupStatusInfo(groupBackupPolicyInfo)
                       )
                    {
                        isSuccess = false;
                        break;
                    }
                    else
                    {
                        isSuccess = true;
                    }
                }
            }
        }

        return isSuccess;
    }

    /** 그룹ID 에 대한 FLOW 정보 존재 여부 체크 */
    public boolean checkFlowExistByGroupId(GroupInfo groupInfo)
    {
        if (groupInfoMapper.selectFlowExistByGroupId(groupInfo) == null)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}
