package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.auth.ResourceInfo;
import com.tops.model.common.SearchParam;

@Mapper
public interface ResourceInfoMapper
{
    // 리소스 정보 조회
    List<ResourceInfo> selectResourceInfoList(@Param("search") SearchParam search);

    // 리소스 정보 조회(단건)
    ResourceInfo selectResourceInfo(String resource_id);

    // 리소스 정보 등록
    boolean insertResourceInfo(@Param("resourceInfo") ResourceInfo resourceInfo);

    // 리소스 정보 수정
    boolean updateResourceInfo(@Param("resourceInfo") ResourceInfo resourceInfo);

    // 메뉴에 속한 리소스가 존재하는지 조회
    Integer selectMenuResourceInfo(@Param("resourceInfo") ResourceInfo resourceInfo);

    // 리소스 접근 정보 삭제
    boolean deleteResourceAccessInfoByResourceId(@Param("resourceInfo") ResourceInfo resourceInfo);

    // 리소스 정보 삭제
    boolean deleteResourceInfo(@Param("resourceInfo") ResourceInfo resourceInfo);
}
