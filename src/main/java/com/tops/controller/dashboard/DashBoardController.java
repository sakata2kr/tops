package com.tops.controller.dashboard;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.tops.controller.BaseController;

@Controller
@RequestMapping("/dashboard")
public class DashBoardController extends BaseController
{

    /**
     * 대시 보드 처리
     */
    @RequestMapping(value = "/dashboard", method = RequestMethod.GET)
    public String dashBoardControl(ModelMap model) throws Exception
    {
        return "dashboard/dashboard";
    }
}