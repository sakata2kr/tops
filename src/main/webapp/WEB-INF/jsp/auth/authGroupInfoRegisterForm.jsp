<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="modal-dialog dialog-style01">
    <div class="modal-content">
        <div class="modal-header">
            <a data-dismiss="modal" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
            <h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">권한그룹 정보 수정</c:when><c:otherwise>새 권한그룹 정보 등록</c:otherwise></c:choose></h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">

                <div class="form-no-line">
                    <span>권한그룹 ID</span>
                    <div class="showcase-select col-lg-2 w76">
                    <c:choose>
                        <c:when test="${'modify' ne mode}">
                            <input type="text" id="authGroupId" maxlength="10" class="form-control02 w100" value="${authGroupInfo.auth_group_id}" />
                        </c:when>
                        <c:otherwise>
                            <label for="form5" style="margin-top:5px">${authGroupInfo.auth_group_id}</label>
                            <input type="hidden" id="authGroupId" value="${authGroupInfo.auth_group_id}"/>
                        </c:otherwise>
                    </c:choose>
                    </div>
                </div>

                <div class="form-no-line">
                    <span>권한그룹명</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="authGroupName" maxlength="50" class="form-control02 w100" value="${authGroupInfo.auth_group_name}" />
                    </div>
                </div>

                <div class="form-no-line">
                    <span>OPERATION</span>
                    <div class="showcase-select col-lg-2 w76">
                        <select id="auth_operationYN" class="form-control" style="width:100px;">
                            <option value='N'>N</option>
                            <option value='Y'>Y</option>
                        </select>
                    </div>
                </div>

            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search w25 btn_operation" onclick="saveAuthGroupInfo();">저장</button>
            <c:if test="${'modify' eq mode}">
                <button type="button" class="btn btn-search w25 btn_operation" onclick="removeAuthGroupInfo();">삭제</button>
            </c:if>
            <button type="button" class="btn btn-search w25" data-dismiss="modal">닫기</button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->

<script>
    $(document).ready(function()
    {
        if ( "${authGroupInfo.operation_yn}" == "Y" )
        {
            $("#auth_operationYN").val("Y");
        }

        $("body").on("hidden.bs.modal","#formModal",function() { $(this).removeData("bs.modal")}); // modal에 넘겼던 데이터 지움

        setOperationBtn();
    });

    //checkValidation : 유효성 검사
    function checkValidation()
    {
        var regExp = /[0-9a-zA-Z]$/; // 정규식 사용을 위한 임시 변수
        var authGroupId   = $('#authGroupId').val().trim();
        var authGroupName = $('#authGroupName').val().trim();

        $('#authGroupId').val(authGroupId);
        $('#authGroupName').val(authGroupName);

        if ( authGroupId == "")
        {
            alert('권한그룹 ID를 입력해 주세요.');
            $('#authGroupId').focus();
            return false;
        }
        else if ( authGroupId.length > 10 || !regExp.test(authGroupId) )
        {
            alert('권한그룹 ID는 영문 또는 숫자로 10자리까지 생성 가능합니다.');
            $('#authGroupId').focus();
            return false;
        }

        regExp = /[가-힣0-9a-zA-Z]$/;

        if( authGroupName == "")
        {
            alert('권한그룹명을 입력해 주세요.');
            $('#authGroupName').focus();
            return false;
        }
        else if ( authGroupName.length > 50 || !regExp.test(authGroupName) )
        {
            alert('권한그룹명은 한글 또는 영문 또는 숫자 조합으로 최대 50자리까지 생성 가능합니다.');
            $('#authGroupName').focus();
            return false;
        }

        return true;
    }

    // 저장
    function saveAuthGroupInfo()
    {
        //유효성 검사.
        if( !checkValidation() || !confirm('저장하시겠습니까?'))
        {
            return;
        }

        var obj = {};
        obj.auth_group_id = $("#authGroupId").val();
        obj.auth_group_name = $("#authGroupName").val();
        obj.operation_yn = $("#auth_operationYN").val();
        var json_data = JSON.stringify(obj);

        var url = "";

        if( "${mode}" === "modify" )
        {
            url = "<c:url value='/auth/modifyAuthGroupInfo' />";
        }
        else
        {
            url = "<c:url value='/auth/registerAuthGroupInfo' />";
        }

        // 저장
        $.ajax({ url : url
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: 'application/json'
               , cache: false
               , success : function(data, status)
                 {
                     if (data.dupcheck == true)    // 중복되는 ID가 존재
                     {
                         alert("사용중인 권한그룹ID입니다. 다른 ID를 입력해주세요.");
                         $('#authGroupId').focus();
                     }
                     else
                     {
                         if ( data.result == true )
                         {
                             alert("저장되었습니다.");

                             // 부모창 목록화면 reload
                             parent.postMessage("authGroupInfoListReload",location.protocol+'//'+location.host);


                         }
                         else
                         {
                             alert("저장 중 오류가 발생하였습니다.");
                         }
                     }

                     // 이 모달 창 숨기기
                     $("#formModal").modal('hide');
                 }
               , error : function()
                 {
                     alert("권한그룹 정보 저장 중 오류가 발생했습니다.");

                     // 이 모달 창 숨기기
                     $("#formModal").modal('hide');
                 }
               });
    }

    //삭제
    function removeAuthGroupInfo()
    {
        if ( !confirm('삭제하시겠습니까?') )
        {
            return;
        }

        var obj = {};
        obj.auth_group_id = $("#authGroupId").val().trim();
        var json_data = JSON.stringify(obj);

        // 삭제
        $.ajax({ url : "<c:url value='/auth/removeAuthGroupInfo' />"
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: 'application/json'
               , cache: false
               , success : function(data, status)
                 {
                     if ( data.result == true )
                     {
                         alert("삭제되었습니다.");

                         // 부모창 목록화면 reload
                         parent.postMessage("authGroupInfoListReload",location.protocol+'//'+location.host);
                     }
                     else
                     {
                         if ( data.error_code == "1" )
                         {
                             alert("삭제 대상 권한을 가진 사용자가 존재합니다. 삭제할 수 없습니다.");
                         }
                         else
                         {
                             alert("삭제 중 오류가 발생하였습니다.");
                         }
                     }

                     // 이 모달 창 숨기기
                     $("#formModal").modal('hide');
                 }
               , error : function()
                 {
                     alert("삭제 중 오류가 발생했습니다.");

                     // 이 모달 창 숨기기
                     $("#formModal").modal('hide');
                 }
               });
    }
</script>
