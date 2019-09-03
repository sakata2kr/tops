<%@ page language="java" contentType="text/html; charset=utf8"    pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="ko">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>SKT OSS 로그인</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link href="<c:url value="/resources/css/bootstrap.css"/>" rel="stylesheet" media="screen">
    <link href="<c:url value="/resources/css/style.css"/>" rel="stylesheet" media="screen">
    <link href="<c:url value="/resources/css/jsPanel.css"/>" rel="stylesheet">

    <script src="<c:url value="/resources/js/vendor/jquery-1.11.3.min.js"/>"></script>
    <style>
    html, body{height:100%}
    .bg{position:absolute;left:0;top:0;width:100%;height:100%; z-index:10;}
    .bg img{width:100%;height:100%;}
    </style>
</head>
<body onLoad="getId(document.mainform)">
        <div class="bg"><img src="<c:url value="/resources/img/login_bg.jpg"/>" /></div>
        <div class="login">
            <div class="login_box">
                    <h2>
                        <img src="<c:url value="/resources/img/tops.png"/>" />
                        <span class="splash_txt">Total Operating Process &#38; System</span>
                    </h2>
                    <img src="<c:url value="/resources/img/ceems_login_icon.png"/>" />
                    <form name="mainform" action="/login" method="post">
                        <div class="login_form">
                            <input type="text" id="user_id" name="userId" class="inText" placeholder="ID" />
                            <input type="password" id="password" name="passWord" class="inText mT16" placeholder="Password" onkeypress="hitEnterKey(event);"/>
                        </div>

                        <div class="login_check">
                            <input type="checkbox" name="checksaveid" id="checksaveid"/><label for="user_id">Save ID</label>
                        </div>

                        <div class="login_form_b">
                            <button id="btnLogin" type="button" class="btn btn_login">LOGIN</button>
                        </div>
                    </form>
                    <p class="login_f">Copyright(c) 2014 SKC&#38;C All rights reserved</p>
                </div>
        </div>

</body>
<script>
    $(document).ready(function() {

        $('.bg').css('display','none');
        $('.login').css('display','none');

        // 세션 타임 아웃 또는 세션 정보가 없을 경우
        // 패널에 로그인 화면을 전체 페이지로 변경
        var loginPanelIdInPanel = $('.panel-body').parents('.jsPanel:eq(0)').attr('id');

        if (loginPanelIdInPanel != undefined){

            //var _panel = g_pannelMap.get(loginPanelIdInPanel);
            //_panel.content.css('display', 'none');
            //_panel.css('display', 'none');

            alert("로그인 세션이 종료되었습니다.\n로그인 페이지로 이동합니다.");
            $(location).attr('href','<c:url value="/login/logOut"/>');
        } else {
            $('.bg').css('display','');
            $('.login').css('display','');
        }

        <c:if test="${param.error eq '1'}">
            alert("패스워드가 올바르지 않습니다.");
            document.location.href = '/login';
        </c:if>

        $("#user_id").focus();

    });

    function hitEnterKey(e)
    {
        if(e.keyCode == 13)
        {
            checkPassword();
        }
        else
        {
            e.keyCode = 0;
        }
    }

    $("#btnLogin").click(function()
    {
        checkPassword();
    });

    function checkPassword()
    {
        if($("#user_id").val() == "")
        {
            alert("아이디를 입력하세요.");
            return;
        }
        if($("#password").val() == "")
        {
            alert("비밀번호를 입력하세요.");
            return;
        }

        saveid(document.mainform);
        document.mainform.submit();
    }

    function setCookie (name, value, expires)
    {
          document.cookie = name + "=" + (value) + "; path=/; expires=" + expires.toGMTString();
    }

    function getCookie(Name)
    {
        var search = Name + "=";
        var offset;
        var end;

        if (document.cookie.length > 0) // 쿠키가 설정되어 있다면
        {
            offset = document.cookie.indexOf(search);

            if (offset != -1) // 쿠키가 존재하면
            {
                offset += search.length;
                // set index of beginning of value
                end = document.cookie.indexOf(";", offset);
                // 쿠키 값의 마지막 위치 인덱스 번호 설정
                if (end == -1)
                {
                    end = document.cookie.length;
                }

                return (document.cookie.substring(offset, end))
            }
        }
        return "";
    }
    function saveid(form)
    {
        var expdate = new Date();
        // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨

        if (form.checksaveid.checked)
        {
            expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
        }
        else
        {
            expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
        }

        setCookie("saveid", form.user_id.value, expdate);
    }
    function getId(form)
    {
        form.checksaveid.checked = ((form.user_id.value = getCookie("saveid")) != "");
    }

</script>
</html>
