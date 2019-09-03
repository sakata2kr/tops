<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="modal-dialog dialog-style01">
    <div class="modal-content">
        <div class="modal-header">
            <a data-dismiss="modal" href="#none" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
            <h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">리소스 정보 수정</c:when><c:otherwise>새 리소스 정보 등록</c:otherwise></c:choose></h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">
                <c:if test="${'modify' eq mode}">
                    <div class="form-no-line">
                        <span>리소스 ID</span>
                        <div class="showcase-select col-lg-2 w76">
                            <label for="form5" style="margin-top:5px">${resourceInfo.resource_id}</label>
                            <input type="hidden" id="resourceId" value="${resourceInfo.resource_id}" />
                        </div>
                    </div>
                </c:if>
                <div class="form-no-line">
                    <span>리소스명</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="resourceName" class="form-control02 w100" maxlength="50" value="${resourceInfo.resource_name}" />
                    </div>
                </div>
                <div class="form-no-line">
                    <span>리소스경로</span>
                    <div class="showcase-select col-lg-2 w76">
                        <label for="form5" id="resourcePathLabel" style="margin-top:5px">${resourceInfo.resource_path}</label>
                        <input type="hidden" id="resourcePath" value="${resourceInfo.resource_path}" />
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search w25 btn_operation" onclick="saveResourceInfo();">
                저장
            </button>
            <c:if test="${'modify' eq mode}">
                <button type="button" class="btn btn-search w25 btn_operation" onclick="removeResourceInfo();">
                    삭제
                </button>
            </c:if>
            <button type="button" class="btn btn-search w25" data-dismiss="modal">
                닫기
            </button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->

<script>
    $(document).ready(function()
    {
        if( "${mode}" != "modify" )
        {
            $("#resourceName").focus();
            $("#resourcePathLabel").text("${resourcePath}");
            $("#resourcePath").val("${resourcePath}");
        }

        $("body").on("hidden.bs.modal","#formModal",function() { $(this).removeData("bs.modal")}); // modal에 넘겼던 데이터 지움

        setOperationBtn();
    });

    //checkValidation : 유효성 검사
    function checkValidation()
    {
    	var regExp = /[가-힣0-9a-zA-Z]$/;
        var tmpResName = $('#resourceName').val().trim();
        $('#resourceName').val(tmpResName);

        if ( tmpResName == "" )
        {
            alert("리소스명을 입력해 주세요.");
            $('#resourceName').focus();
            return false;
        }
        else if ( tmpResName.length > 50 || !regExp.test(tmpResName) )
        {
            alert('리소스명은 한글 또는 영문 또는 숫자 조합으로 최대 50자리까지 생성 가능합니다.');
            $('#resourceName').focus();
            return false;
        }

        return true;
    }

    // 저장
    function saveResourceInfo()
    {
        //유효성 검사.
        if( !checkValidation() || !confirm("저장하시겠습니까?"))
        {
            return;
        }

        var obj = {};
        obj.resource_name = $("#resourceName").val();
        obj.resource_path = $("#resourcePath").val();

        var url = "";

        if( "${mode}" === "modify" )
        {
            obj.old_resource_id = "${resourceInfo.resource_id}";
            url = "<c:url value='/auth/modifyResourceInfo' />";
        }
        else
        {
            url = "<c:url value='/auth/registerResourceInfo' />";
        }

        var json_data = JSON.stringify(obj);

        // 저장
        $.ajax({ url : url
               , type : "POST"
               , dataType : "json"
               , data : json_data
               , contentType: 'application/json'
               , cache: false
               , success : function(data, status)
                 {
                     if ( data.result == true)
                     {
                         alert("저장되었습니다.");

                         // 부모창 목록화면 reload
                         parent.postMessage("reloadResourceInfoList", location.protocol + "//" + location.host);
                     }
                     else
                     {
                         alert("저장 중 오류가 발생하였습니다.");
                     }

                     // 이 모달 창 숨기기
                     $("#formModal").modal('hide');
                 }
              , error : function()
                {
                    //showModal("저장 중 오류가 발생했습니다.");
                    alert("저장 중 오류가 발생했습니다.")

                    // 이 모달 창 숨기기
                    $("#formModal").modal('hide');
                }
              });
    }

    //삭제
    function removeResourceInfo()
    {
        if ( !confirm('삭제하시겠습니까?') )
        {
            return;
        }

        var obj = {};
        obj.resource_id = $("#resourceId").val().trim();
        var json_data = JSON.stringify(obj);

        // 삭제
        $.ajax({ url : "<c:url value='/auth/removeResourceInfo' />"
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
                         parent.postMessage("reloadResourceInfoList", location.protocol + "//" + location.host);
                     }
                     else
                     {
                         if ( data.menu_exist == true)
                         {
                             alert('메뉴에 등록된 리소스가 존재합니다. 삭제할 수 없습니다.');
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
                     alert("리소스 삭제 중 오류가 발생했습니다.");

                     // 이 모달 창 숨기기
                     $("#formModal").modal('hide');
                 }
               });
    }
</script>
