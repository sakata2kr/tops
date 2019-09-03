package com.tops.service.main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.tops.mapper.fwk.LoginMapper;
import com.tops.model.auth.BookmarkInfo;
import com.tops.model.user.UserInfo;
import com.tops.service.BaseService;

@Service
@Transactional(readOnly = true, propagation = Propagation.SUPPORTS)
public class LoginService extends BaseService
{
	@Autowired
	private LoginMapper loginMapper;

	//로그인 시 사용자 계정 정보 조회
	public UserInfo getUserInfo(String userInfo)
	{
		return loginMapper.getUserInfo(userInfo);
	}
	
	//사용자 즐겨찾기 등록
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public void registerUserBookmark(List<BookmarkInfo> paramList)
	{
		String userId = paramList.get(0).getUserId();
		
		//북마크 삭제
		loginMapper.deleteUserBookmark(userId);

		//북마크 등록
        for (BookmarkInfo bookMarkInfo : paramList)
		{
            loginMapper.insertUserBookmark(bookMarkInfo);
        }
	}
	
	//사용자 즐겨찾기 삭제
	@Transactional(rollbackFor = { Exception.class }, propagation = Propagation.REQUIRED)
	public void deleteUserBookmark(String userId)
	{
		//북마크 삭제
		loginMapper.deleteUserBookmark(userId);
	}
	
	//사용자 즐겨찾기 조회
	public List<BookmarkInfo> selectUserBookmark(String userId)
	{
		return loginMapper.selectUserBookmark(userId);
	}
}