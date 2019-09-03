package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.tops.model.auth.AuthGroupInfo;

@Mapper
public interface AuthGroupInfoMapper
{
    // 권한그룹 정보 조회
    List<AuthGroupInfo> selectAuthGroupInfoList();
	
    // 권한그룹 정보 조회(단건)
    AuthGroupInfo selectAuthGroupInfo(String auth_group_id);

    // 권한그룹 정보 등록
    boolean insertAuthGroupInfo(@Param("authGroupInfo") AuthGroupInfo authGroupInfo);

    // 권한그룹 정보 수정
    boolean updateAuthGroupInfo(@Param("authGroupInfo") AuthGroupInfo authGroupInfo);

    // 권한그룹 정보 삭제
    boolean deleteAuthGroupInfo(@Param("authGroupInfo") AuthGroupInfo authGroupInfo);

    // 권한그룹 중복 존재 여부 체크
    Integer selectDupAuthGroup(@Param("authGroupInfo") AuthGroupInfo authGroupInfo);

    // 권한그룹에 속한 사용자가 존재하는지 조회
    Integer selectUserNumByAuthGroupId(@Param("authGroupInfo") AuthGroupInfo authGroupInfo);
}