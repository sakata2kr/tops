package com.tops.controller.main;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.codec.digest.DigestUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.tops.controller.BaseController;
import com.tops.model.auth.BookmarkInfo;
import com.tops.model.auth.MenuInfo;
import com.tops.model.user.UserInfo;
import com.tops.service.auth.MenuInfoService;
import com.tops.service.main.LoginService;
import com.tops.service.main.UserInfoService;

@Controller
@RequestMapping("/main")
public class MainController extends BaseController
{
    @Autowired
    private LoginService loginService;

    @Autowired
	private UserInfoService userInfoService;

    @Autowired
    private MenuInfoService menuInfoService;

    /**
     * 메인페이지로 이동
     */
    @RequestMapping(value="/mainPage", method = RequestMethod.GET)
    public ModelAndView mainPage(HttpServletRequest request) throws Exception
    {
        ModelAndView mv = new ModelAndView();

        try
        {
            HttpSession session = request.getSession();
            UserInfo userInfo = ((UserInfo)session.getAttribute("sessUserInfo"));

            mv.addObject("alert_receive_yn", userInfo.getAlert_receive_yn());   //Alert Message 사용여부
            mv.addObject("operationYn",      userInfo.getOperation_yn());       //operation 가능여부

            List<BookmarkInfo> bookmarkList = loginService.selectUserBookmark(userInfo.getUser_id());
            mv.addObject("bookmarkList", bookmarkList);
        
            //SearchParam search = new SearchParam();
            //List<ResourceInfo> resourceInfoList = resourceInfoService.retrieveResourceInfoList(null);
            //mv.addObject("mainResourceInfoList", resourceInfoList);
        
            mv.setViewName("main/mainPage");

            return mv;
        }
        catch (Exception e)
        {
            mv.setViewName("redirect:/login");
            
            return mv;
        }
    }

    /**
     *  메뉴 화면 배치
     */
    @RequestMapping(value = "/setMenuOnScreen")
    public ModelAndView setMenuOnScreen(HttpServletRequest request, ModelMap model) throws Exception
    {
        ModelAndView mv = new ModelAndView();
        
        HttpSession session = request.getSession();
        UserInfo sessionUserInfo = (UserInfo)session.getAttribute("sessUserInfo");
        
        List<MenuInfo> menuInfoList = menuInfoService.retrieveMenuInfoList(sessionUserInfo.getUser_group_id());

        mv.addObject("menuInfoList", menuInfoList);
        mv.setViewName("main/navigator");
        
        return mv;
    }

    /**
     * 즐겨찾기 조회
     */
    @RequestMapping(value="/registerUserBookmark", method=RequestMethod.GET)
    public @ResponseBody ModelAndView registerUserBookmark(BookmarkInfo info, HttpServletRequest request) throws Exception
    {
        ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
        mv.addObject("result", true);
        
        String[] userId = info.getUserId().split(",");
        String[] menuId = info.getMenuId().split(",");
        String[] screenTop = info.getScreenTop().split(",");
        String[] screenLeft = info.getScreenLeft().split(",");
        String[] screenRight = info.getScreenRight().split(",");
        String[] screenHeight = info.getScreenHeight().split(",");
        String[] screenWidth = info.getScreenWidth().split(",");
        String[] screenStatus = info.getScreenStatus().split(",");
        
        List<BookmarkInfo> paramList = new ArrayList<>();
        BookmarkInfo tmpInfo;
        
        if(userId.length > 0 && !"".equals(info.getUserId()))
        {
            for(int i = 0; i < userId.length; i++)
            {
                tmpInfo = new BookmarkInfo();
                tmpInfo.setUserId(userId[i]);
                tmpInfo.setMenuId(menuId[i]);
                tmpInfo.setScreenTop(screenTop[i]);
                tmpInfo.setScreenLeft(screenLeft[i]);
                tmpInfo.setScreenRight(screenRight[i]);
                tmpInfo.setScreenHeight(screenHeight[i]);
                tmpInfo.setScreenWidth(screenWidth[i]);
                tmpInfo.setScreenStatus(screenStatus[i]);
                
                paramList.add(tmpInfo);
            }
            
            loginService.registerUserBookmark(paramList);
        }
        else
        {
            HttpSession session = request.getSession();

            try
            {
                String suserId = ((UserInfo)session.getAttribute("sessUserInfo")).getUser_id();
                
                loginService.deleteUserBookmark(suserId);
            }
            catch(Exception e)
            {
                mv.addObject("result", false);
            }
        }
        
        return mv;
    }

	/**
	 * 사용자 정보 수정 화면
	 */
	@RequestMapping(value = "/myInfoModifyForm" , method=RequestMethod.GET)
    public ModelAndView myInfoModifyForm(HttpServletRequest request, ModelMap model) throws Exception
    {
		ModelAndView mv = new ModelAndView();
		
		HttpSession session = request.getSession();
		UserInfo sessionUserInfo = (UserInfo)session.getAttribute("sessUserInfo");
		
		UserInfo returnUserInfo = userInfoService.getUserInfo(sessionUserInfo);

		mv.addObject("userInfo", returnUserInfo);

		mv.setViewName("main/myInfoRegisterForm");
		
		return mv;
    }

	/**
	 * 사용자 정보 수정
	 */
	@RequestMapping(value = "/modifyMyInfo", method=RequestMethod.POST)
	public@ResponseBody ModelAndView modifyMyInfo(@RequestBody UserInfo userInfo, HttpServletRequest request) throws Exception
    {
		ModelAndView mv = new ModelAndView(new MappingJackson2JsonView());
		
		if(userInfo.getNew_password() != null)
		{
		    // 기존 비밀번호가 DB저장된 비밀번호와 동일한지 여부 체크
	        UserInfo rtnUserInfo = loginService.getUserInfo(userInfo.getUser_id());

	        if ( rtnUserInfo != null && rtnUserInfo.getPassword().equals(DigestUtils.sha256Hex(userInfo.getPassword())) )
	        {
	            // 비밀번호 동일 시 신규 비밀번호로 재저장
	            userInfo.setPassword(DigestUtils.sha256Hex(userInfo.getNew_password()));
	        }
	        else
	        {
				mv.addObject("result", "2");	// 비밀번호 불일치 '2'

				return mv;
			}
		}

		// 사용자 정보 수정 시 AUTH GROUP 정보는 유지
		userInfo.setUser_group_id(null);
		boolean isSuccess = userInfoService.modifyMyInfo(userInfo);
		if(isSuccess)
		{
			// session 정보 업데이트
			HttpSession session = request.getSession();
			UserInfo sessionUserInfo = (UserInfo)session.getAttribute("sessUserInfo");

			// session 변경정보 set
			sessionUserInfo.setUser_name(userInfo.getUser_name());
			sessionUserInfo.setPhone_no(userInfo.getPhone_no());
			sessionUserInfo.setEmail(userInfo.getEmail());
			
			session.setAttribute("sessUserInfo", sessionUserInfo);
			mv.addObject("userInfo", sessionUserInfo);
			mv.addObject("result", "1");	// 수정성공 '1'
		}
		
        return mv;
    }
}