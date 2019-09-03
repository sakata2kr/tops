<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tops.model.*" %>

<style type="text/css">
    .notRegResource
    {  color: #0094C8;
       background-color: #F0F4F7;
    }
</style>

<div class="showcase panel-con panel-rn">
    <div class="showcase-content ">
        <div class="com-02">
            <div>
                <div class="showcase-select mR5">
                    <select id="resourceInfoSearchOption" class="form-control" style="width:100px;">
                        <option value="01">리소스명</option>
                        <option value="02">리소스경로</option>
                    </select>
                </div>
                <div class="showcase-select mR5">
                    <input type="text" id="resourceInfoSearchWord" class="form-control" maxlength="100" value="" style="width:200px;">
                </div>
                <div class="showcase-select ">
                <button type="button" id="btn_search" class="btn btn-search" onclick="selResourceInfo();" style="width:50px;">
                    조회
                </button>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <table class="table table-blue bbs100">
                <thead>
                    <tr>
                        <th scope="col">순번</th>
                        <th scope="col">리소스 ID</th>
                        <th scope="col">리소스명</th>
                        <th scope="col">리소스경로</th>
                        <th scope="col">리소스Bean/Method명</th>
                        <th scope="col">정렬순번</th>
                    </tr>
                </thead>
                <tbody id="resourceInfoList"></tbody>
            </table>
        </div>
    </div>
</div>

<script>

    $(document).ready(function()
    {
    	selResourceInfo();
    });

    // 조회 Input 박스 엔터 시 조회 기능 추가
    $("#resourceInfoSearchWord").keydown(function(e)
    {
        if(e.keyCode == 13)
        {
        	selResourceInfo();
        }
    });
    
    // 조회
    function selResourceInfo()
    {
        // 버튼 비활성화
        $("#btn_search").attr("disabled", true);

        var obj = {};
        obj.searchOption = $("#resourceInfoSearchOption").val();
        obj.searchWord = $("#resourceInfoSearchWord").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
        $("#resourceInfoSearchWord").val(obj.searchWord);
        var json_data = JSON.stringify(obj);

        $.ajax({
            type: "post",
            url: "<c:url value='/auth/resourceInfoList' />",
            data: json_data,
            dataType:'json',
            contentType: 'application/json',
            cache: false,
            success: function(data,status) {

                // tbody 초기화
                $("#resourceInfoList").find("tr").remove();

                $(data.resourceInfoList).each(function(i, resourceInfo) {

                var addTag = "<tr " + ( resourceInfo.resource_id != null && resourceInfo.resource_id.length != 0 ? resourceInfo.resource_id :"class='notRegResource'" ) + ">"
                               + "<td>" + ( i +1) + "</td>"
                               + "<td>" + ( resourceInfo.resource_id != null && resourceInfo.resource_id.length != 0
                                          ? "<a href='#none' style='color:#0094C8;text-decoration: underline;cursor: pointer;' onclick='resourceInfoModifyForm(\"" + resourceInfo.resource_id + "\");'>" + resourceInfo.resource_id + "</a>"
                                          : "<button id='btn_newResourceInfo' type='button' class='btn btn-search btn_operation' onclick='resourceInfoRegisterForm(\"" + resourceInfo.resource_path + "\");'>등록</button>"
                                        ) + "</td>"
                               + "<td style='text-align:left;'>" + resourceInfo.resource_name + "</td>"
                               + "<td style='text-align:left;'>" + resourceInfo.resource_path + "</td>"
                               + "<td style='text-align:left;word-break:break-all;'>" + resourceInfo.resource_bean_name + "</td>"
                               + "<td>" + ( resourceInfo.resource_id != null && resourceInfo.resource_id.length != 0 ? resourceInfo.sort_order : "") + "&nbsp;</td>"
                           + "</tr>"
                           ;

                $("#resourceInfoList").append(addTag);

            });

            // 총건수가 0이면 '조회된 목록이 없다'는 메시지 표시
            if(data.resourceInfoList.length == 0)
            {
                $("#resourceInfoList").append('<tr><td colspan="6">검색 조건에 해당하는 건이 없습니다.</td></tr>');
            }

            // 버튼 비활성화
            $("#btn_search").attr("disabled", false);

        },
        error: function(){
            showModal("데이터 조회 중 오류가 발생했습니다.");

            // 버튼 비활성화
            $("#btn_search").attr("disabled",false);
        }
    });
}

    // 수정화면
    function resourceInfoModifyForm(resource_id)
    {
        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/auth/resourceInfoModifyForm?resource_id='+resource_id
        });
    }

    // 입력창 열기
    function resourceInfoRegisterForm(resource_path)
    {
        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/auth/resourceInfoRegisterForm?resource_path='+resource_path
        });
    }

    // 모달창으로 부터데이터를 받기위한 부분
    window.onmessage = function(e) {
        if(e.data == "reloadResourceInfoList")
        {
            selResourceInfo();
        }
    };

    setOperationBtn();
</script>
