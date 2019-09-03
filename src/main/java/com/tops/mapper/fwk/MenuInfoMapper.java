package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.auth.MenuInfo;
import com.tops.model.auth.ResourceInfo;

@Mapper
public interface MenuInfoMapper
{
	// 메뉴 정보 조회
    List<MenuInfo> selectMenuInfoList(String auth_group_id);

	// 메뉴 정보 등록
    boolean insertMenuInfo(@Param("menuInfo") MenuInfo menuInfo);

	// 메뉴 정보 수정
    boolean updateMenuInfo(@Param("menuInfo") MenuInfo menuInfo);

	// 메뉴 정보 삭제
    boolean deleteMenuInfo(@Param("menuInfo") MenuInfo menuInfo);

	// 메뉴 리소스 정보 조회
    List<ResourceInfo> selectResourceInfoList();
}
