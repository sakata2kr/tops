<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tops.model.*" %>

<style type="text/css">
    .thisHyperLink_ag {
        text-decoration: underline;
        cursor: pointer;
        color: #0094C8;
    }
</style>

<div class="showcase panel-con panel-rn">
    <div class="showcase-content ">
        <div class="com-02">
            <div>
                <!-- 상단 우측 버튼 -->
                <div class="btn-r">
                    <button id="btn_newAuthGroupInfo" type="button" class="btn btn-search btn_operation" >
                        새 권한그룹 등록
                    </button>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-blue bbs100">
                <thead>
                    <tr>
                        <th scope="col">권한그룹 ID</th>
                        <th scope="col">권한그룹명</th>
                        <th scope="col">OPERATION</th>
                    </tr>
                </thead>
                <tbody id="authGroupInfoList"></tbody>
            </table>
        </div>
    </div>
</div>

<script>

    $(document).ready(function()
    {
        selAuthGroupInfo();
    });

    // 조회
    function selAuthGroupInfo()
    {
        $.ajax({
            type: "post",
            url: "<c:url value='/auth/authGroupInfoList' />",
            dataType:'json',
            contentType: 'application/json',
            cache: false,
            success: function(data, status) {
                // tbody 초기화
                $("#authGroupInfoList").find("tr").remove();

                $(data.authGroupInfoList).each(function(i, authGroupInfo) {
                    var addTag = "<tr>"
                                   +"<td class='thisHyperLink_ag' onclick=\"authGroupInfoModifyForm('" + authGroupInfo.auth_group_id + "');\">" + authGroupInfo.auth_group_id + "</td>"
                                   +"<td>" + authGroupInfo.auth_group_name + "</td>"
                                   +"<td>" + authGroupInfo.operation_yn + "</td>"
                               +"</tr>"
                               ;

                    $("#authGroupInfoList").append(addTag);
                });

                // 총건수가 0이면 '조회된 목록이 없다'는 메시지 표시
                if ( data.authGroupInfoList.length == 0 )
                {
                    $("#authGroupInfoList").append('<tr><td colspan="3">검색 조건에 해당하는 건이 없습니다.</td></tr>');
                }
            },
            error: function(){
                showModal("그룹 권한 추가 시 오류가 발생했습니다.");
            }
        });
    }

    // 수정화면
    function authGroupInfoModifyForm(auth_group_id)
    {
        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/auth/authGroupInfoModifyForm?auth_group_id='+auth_group_id
        });
    }

    // 입력창 열기
    $("#btn_newAuthGroupInfo").click(function() {

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/auth/authGroupInfoRegisterForm'
        });
    });

    // 모달창으로 부터데이터를 받기위한 부분
    window.onmessage = function(e) {
        if(e.data == "authGroupInfoListReload")
        {
            selAuthGroupInfo();
        }
    };

    setOperationBtn();
</script>
