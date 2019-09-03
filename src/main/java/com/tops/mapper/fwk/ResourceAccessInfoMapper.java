package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.auth.ResourceAccessInfo;
import com.tops.model.common.SearchParam;

@Mapper
public interface ResourceAccessInfoMapper
{
	// 리소스 접근 정보 조회
    List<ResourceAccessInfo> selectResourceAccessInfoList(@Param("search") SearchParam search);

	// 리소스 접근 정보 등록
    boolean insertResourceAccessInfo(@Param("resourceAccessInfo") ResourceAccessInfo resourceAccessInfo);

	// 리소스 접근 정보 수정
    boolean updateResourceAccessInfo(@Param("resourceAccessInfo") ResourceAccessInfo resourceAccessInfo);

	// 리소스 접근 정보 삭제
    boolean deleteResourceAccessInfo(String auth_group_id);

    // 사용자 소속 그룹에 따른 리소스 접근 가능 여부 조회
    Integer validUserResourceAccess(@Param("userId") String userId, @Param("uri") String uri);
}
