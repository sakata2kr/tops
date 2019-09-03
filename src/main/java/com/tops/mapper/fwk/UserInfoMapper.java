package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.common.SearchParam;
import com.tops.model.user.UserGroupInfo;
import com.tops.model.user.UserInfo;

@Mapper
public interface UserInfoMapper
{
	// 사용자정보 조회 목록
    List<UserInfo> selectUserInfoList(@Param("search") SearchParam search);

	// 사용자그룹정보 조회
    List<UserGroupInfo> getUserGroupInfoList(String user_group);

	// 사용자정보 조회(단건)
    UserInfo selectUserInfo(@Param("userInfo") UserInfo userInfo);

	// 사용자정보 수정
    boolean updateUserInfo(@Param("userInfo") UserInfo userInfo);

	// 사용자정보 등록
    boolean insertUserInfo(@Param("userInfo") UserInfo userInfo);

	// 사용자정보 삭제
    boolean deleteUserInfo(@Param("userInfo") UserInfo userInfo);

	// 사용자 접속일시 UPDATE
    boolean updateLatestLoginDt(@Param("userId") String userId);

	// 사용자ID 중복체크
    Integer selectDupUserId(@Param("userId") String userId);

	// 내 정보 수정
    boolean updateMyInfo(@Param("userInfo") UserInfo userInfo);
}
