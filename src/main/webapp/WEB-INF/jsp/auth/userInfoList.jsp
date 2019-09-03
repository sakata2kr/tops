<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tops.model.*" %>

<style type="text/css">
    .thisHyperLink_ui
    {  text-decoration: underline;
       cursor: pointer;
       color: #0094C8;
    }
</style>

<div class="showcase panel-con panel-rn">
    <div class="showcase-content ">
        <div class="com-02">
            <div>
                <div class="showcase-select mR5">
                    <select id="searchOption" class="form-control">
                        <option value="01">이름</option>
                        <option value="02">계정</option>
                    </select>
                </div>
                <div class="showcase-select mR5">
                    <input type="text" id="searchWord" class="form-control" maxlength="30" value="" />
                </div>
                <div class="showcase-select">
                    <button type="button" id="btn_searchUserInfo" class="btn btn-search" onclick="getUserInfo();" style="width:50px;">
                        조회
                    </button>
                </div>
                <div class="btn-r">
                    <button id="btn_newUser" type="button" class="btn btn-search btn_operation" >
                        신규 사용자 생성
                    </button>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-blue bbs100">
                <thead>
                    <tr>
                        <th scope="col">사용자 계정</th>
                        <th scope="col">이름</th>
                        <th scope="col">권한그룹</th>
                        <th scope="col">Alert수신여부</th>
                        <th scope="col">휴대폰</th>
                        <th scope="col">이메일</th>
                        <th scope="col">최근 접속일</th>
                    </tr>
                </thead>
                <tbody id="userInfoList">
                    <tr></tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    $(document).ready(function()
    {
    	getUserInfo();
        setOperationBtn();
	});

    // 조회 Input 박스 엔터 시 조회 기능 추가
    $("#searchWord").keydown(function(e)
    {
        if(e.keyCode == 13)
        {
        	getUserInfo();
        }
    });

    function getUserInfo()
    {
        var obj = {};
        obj.searchOption = $("#searchOption").val();
        obj.searchWord = $("#searchWord").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
        $("#searchWord").val(obj.searchWord);
        var json_data = JSON.stringify(obj);

        $.ajax({
            type: "post",
            url: "<c:url value='/auth/userInfoList' />",
            data: json_data,
            dataType:'json',
            contentType: 'application/json',
            cache: false,
            success: function(data,status) {
                makeUserInfoList(data.userInfoList);
            },
            error: function() {
                showModal("사용자 정보 조회 중 오류가 발생했습니다.");
            }
        });
    }

    function makeUserInfoList(userInfoList)
    {
        //console.log(data);
        // tbody 초기화
        $("#userInfoList").find("tr").remove();

        if ( userInfoList != null )
        {
            $(userInfoList).each(function(i, userInfo)
            {
                var addTag = "<tr>"
                           + "<td class='thisHyperLink_ui' onclick=userInfoModifyForm('"+userInfo.user_id+"')>"+userInfo.user_id+"</td>"
                           + "<td>" + userInfo.user_name+"</td>"
                           + "<td>" + ( userInfo.user_group_name  == null ? '' : userInfo.user_group_name  ) + "</td>"
                           + "<td>" + ( userInfo.alert_receive_yn == null ? '' : userInfo.alert_receive_yn ) + "</td>"
                           + "<td>" + ( userInfo.phone_no == null ? '' : userInfo.phone_no.replace(/(^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/,"$1-$2-$3") ) + "</td>"
                           + "<td>" + ( userInfo.email == null? '' : userInfo.email ) + "</td>"
                           + "<td>" + ( userInfo.last_login_dt == null? '' : userInfo.last_login_dt ) + "</td>"
                           + "</tr>"
                           ;

                $("#userInfoList").append(addTag);
             });
        }
        else
        {
            $("#userInfoList").append('<tr><td colspan="7">검색 조건에 해당하는 건이 없습니다.</td></tr>');
        }
    }

    //수정화면
    function userInfoModifyForm(user_id)
    {
        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/auth/userInfoModifyForm?user_id='+user_id
        });
    }

    // 신규사용자 생성 버튼 클릭시
    $("#btn_newUser").click(function(){

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/auth/userInfoRegisterForm'
        });
    });

    //모달창으로 부터데이터를 받기위한 부분
    window.onmessage = function(e) {
        if(e.data == "userInfoListReload")
        {
        	getUserInfo();
        }
    };
</script>