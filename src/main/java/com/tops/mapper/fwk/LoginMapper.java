package com.tops.mapper.fwk;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Mapper;

import com.tops.model.auth.BookmarkInfo;
import com.tops.model.user.UserInfo;

@Mapper
public interface LoginMapper
{
	// 사용자정보 조회
    UserInfo getUserInfo(String userInfo);

	
	// 즐겨찾기 삭제
    void deleteUserBookmark(String userId);
	
	// 즐겨찾기 등록
    void insertUserBookmark(@Param("bookmarkInfo") BookmarkInfo bookmarkInfo);
	
	// 즐겨찾기 조회
    List<BookmarkInfo> selectUserBookmark(String userId);
}
