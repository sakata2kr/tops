package com.tops.controller.main;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.tops.controller.BaseController;

@Controller
public class CustomErrorController extends BaseController implements ErrorController
{
    private static final String ERROR_PATH = "/error";
    
    @Override
    public String getErrorPath()
    {
        return ERROR_PATH;
    }

    @RequestMapping(value = ERROR_PATH)
    public String handleError(HttpServletRequest request, Model model)
    {
        model.addAttribute("errCode", request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE));

        return "main/errorPage";
    }
}