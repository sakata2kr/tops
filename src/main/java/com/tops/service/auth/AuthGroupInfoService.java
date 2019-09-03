package com.tops.service.auth;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.AuthGroupInfoMapper;
import com.tops.model.auth.AuthGroupInfo;
import com.tops.service.BaseService;

/**
 * 권한그룹정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class AuthGroupInfoService extends BaseService
{
    @Autowired
    private AuthGroupInfoMapper authGroupInfoMapper;

    // 권한그룹 정보 조회 목록
    public List<AuthGroupInfo> retrieveAuthGroupInfoList()
    {
        return authGroupInfoMapper.selectAuthGroupInfoList();
    }

    // 권한그룹 정보 조회(단건)
    public AuthGroupInfo retrieveAuthGroupInfo(String auth_group_id)
    {
        return authGroupInfoMapper.selectAuthGroupInfo(auth_group_id);
    }

    // 권한그룹 정보 등록
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean registerAuthGroupInfo(AuthGroupInfo authGroupInfo)
    {
        return authGroupInfoMapper.insertAuthGroupInfo(authGroupInfo);
    }

    // 권한그룹 정보 수정
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean modifyAuthGroupInfo(AuthGroupInfo authGroupInfo)
    {
        return authGroupInfoMapper.updateAuthGroupInfo(authGroupInfo);
    }

    // 권한그룹 정보 삭제
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeAuthGroupInfo(AuthGroupInfo authGroupInfo)
    {
        return authGroupInfoMapper.deleteAuthGroupInfo(authGroupInfo);
    }

    // 권한그룹 중복 존재 여부 체크
    public boolean checkDupAuthGroupInfo(AuthGroupInfo authGroupInfo)
    {
        if ( authGroupInfoMapper.selectDupAuthGroup(authGroupInfo) != 0 )
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    // 권한그룹에 속한 사용자가 존재하는지 조회
    public boolean retrieveUserNumByAuthGroupId(AuthGroupInfo authGroupInfo)
    {
        if ( authGroupInfoMapper.selectUserNumByAuthGroupId(authGroupInfo) == null )
        {
            return true;
        }
        else
        {
            return false;
        }
    }
}