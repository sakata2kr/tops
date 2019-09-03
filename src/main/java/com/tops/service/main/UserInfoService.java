package com.tops.service.main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.UserInfoMapper;
import com.tops.model.common.SearchParam;
import com.tops.model.user.UserInfo;
import com.tops.service.BaseService;

/**
 * 사용자정보 관리를 위한 Service class
 */
@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class UserInfoService extends BaseService
{
    @Autowired
    private UserInfoMapper userInfoMapper;

    // 사용자정보 조회 목록
    public List<UserInfo> retrieveUserInfoList(SearchParam search)
    {
        return userInfoMapper.selectUserInfoList(search);
    }

    // 사용자정보 조회(단건)
    public UserInfo getUserInfo(UserInfo userInfo)
    {
        return userInfoMapper.selectUserInfo(userInfo);
    }

    // 사용자 정보 수정
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean modifyUserInfo(UserInfo userInfo)
    {
        return userInfoMapper.updateUserInfo(userInfo);
    }

    // 사용자 정보 등록
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean registerUserInfo(UserInfo userInfo)
    {
        return userInfoMapper.insertUserInfo(userInfo);
    }

    // 사용자 정보 삭제
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean removeUserInfo(UserInfo userInfo)
    {
        return userInfoMapper.deleteUserInfo(userInfo);
    }

    // 로그인 접속일시 UPDATE
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean updateLatestLoginDt (String userId)
    {
        return userInfoMapper.updateLatestLoginDt(userId);
    }

    // 사용자ID 중복체크
    public boolean checkDupUserId(String userId)
    {
        if ( userInfoMapper.selectDupUserId(userId) != 0 )
        {
            return false;
        }
        else
        {
            return true;
        }
    }

    // 내 정보 수정 : 보안취약점 - 권한그룹 업데이트 가능성
    @Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
    public boolean modifyMyInfo(UserInfo userInfo)
    {
        return userInfoMapper.updateMyInfo(userInfo);
    }
}