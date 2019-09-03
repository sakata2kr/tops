<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.tops.model.*" %>
<%@ page import="java.util.List" %>
<script>

// 저장
function saveSystemInfo(){

    if($("#systemId").val().trim() == '') {
        alert('시스템ID를 입력해주세요.');
        $('#systemId').focus();
        return;
    }

    if($("#systemName").val().trim() == '') {
        alert('시스템명을 입력해주세요.');
        $('#systemName').focus();
        return;
    }

    if (!confirm('저장하시겠습니까?')){
        return;
    }


    var obj = {};
    obj.biz_domain = $("#bizDomain").val();
    obj.system_id = $("#systemId").val().trim();
    obj.system_group = $("#SystemGroup").val();
    obj.system_name = $("#systemName").val().trim();
    obj.description = $("#desc").val().trim();
    //obj.sequence = $("#sequence").val().trim();

    var url = '';
    <c:choose>
    <c:when test="${'modify' eq mode}">
    obj.old_biz_domain = "${systemInfo.biz_domain}";
    obj.old_system_id = "${systemInfo.system_id}";
    url = "<c:url value='/operation/modifySystemInfo' />";
    </c:when>
    <c:otherwise>
    url = "<c:url value='/operation/registerSystemInfo' />";
    </c:otherwise>
    </c:choose>

    var json_data = JSON.stringify(obj);


    // 저장
    $.ajax({
        url : url
        , type : "POST"
        , dataType : "json"
        , data : json_data
        , contentType: 'application/json'
        , cache: false
        , success : function(data, status) {

            if(data.result==true) {

                alert("저장되었습니다.");

                // 부모창 목록화면 reload
                parent.postMessage("systemInfoListReload",location.protocol+'//'+location.host);

                // 이 모달 창 숨기기
                $("#systemInfoFormModal").modal('hide');

            } else {
                alert("저장 중 오류가 발생하였습니다.");
            }
        }
        , error : function(){
            //showModal("저장 중 오류가 발생했습니다.");
            alert("저장 중 오류가 발생했습니다.")
        }
    });
}


// 삭제
function removeSystemInfo(){

    if (!confirm('삭제하시겠습니까?')){
        return;
    }

    var obj = {};
    obj.biz_domain = "${systemInfo.biz_domain}";
    obj.system_id = "${systemInfo.system_id}";
    var json_data = JSON.stringify(obj);

    // 삭제
    $.ajax({
        url : "<c:url value='/operation/removeSystemInfo' />"
        , type : "POST"
        , dataType : "json"
        , data : json_data
        , contentType: 'application/json'
        , cache: false
        , success : function(data, status) {

            if(data.result==true) {

                alert("삭제되었습니다.");

                // 부모창 목록화면 reload
                parent.postMessage("systemInfoListReload",location.protocol+'//'+location.host);

                // 이 모달 창 숨기기
                $("#systemInfoFormModal").modal('hide');

            } else {
                alert("저장 중 오류가 발생하였습니다.");
            }
        }
        , error : function(){
            //showModal("저장 중 오류가 발생했습니다.");
            alert("저장 중 오류가 발생했습니다.")
        }
    });
}



$(document).ready(function(){
    <c:if test="${'modify' eq mode}">
    $("#bizDomain").val('${systemInfo.biz_domain}');
    $("#SystemGroup").val('${systemInfo.system_group}');
    </c:if>

    $('#systemInfoFormModal').on('hidden.bs.modal', function(e){
        $(this).find("input,select").val('').end();
    });

    setOperationBtn();

    // 로그인 사용자 의 도메인 또는 시스템그룹으로 고정됨(관리자는 도메인, 시스템그룹 선택 가능)
    <c:choose>
    <c:when test="${'ADMIN' eq sessUserInfo.user_group_id}">
        $("#bizDomain").attr("disabled", false);
        $("#SystemGroup").attr("disabled", false);
    </c:when>
    <c:otherwise>
        if("${mode}" != "modify") {
            $("#bizDomain").val("${sessUserInfo.biz_domain}");
            $("#SystemGroup").val("${sessUserInfo.system_group}");
        }

        $("#bizDomain").attr("disabled", true);
        $("#SystemGroup").attr("disabled", true);
    </c:otherwise>
    </c:choose>
});

</script>
    <c:set var="COMBO_UI12"  scope="page" />
    <c:set var="COMBO_UI13"  scope="page" />
            <div class="modal-dialog dialog-style01">
                <div class="modal-content">
                    <div class="modal-header">
                         <a data-dismiss="modal" href="#none" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
                        <h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">시스템정보 수정</c:when><c:otherwise>시스템정보 등록</c:otherwise></c:choose></h4>
                    </div>
                    <div class="modal-body">
                        <div class="modal-cust-con02" style="height:160px;">

                            <div class="form-no-line">
                                <span>도메인</span>
                                <div>
                                    <select id="bizDomain" class="ms-choice" style="width:220px;">
                                        <c:forEach var="code" items="${COMBO_UI12}" varStatus="status">
                                            <option value="<c:out value="${code.code}"/>"><c:out value="${code.code_name}"/></option>
                                        </c:forEach>
                                    </select>
                                </div>
                            </div>

                            <div class="form-no-line">
                                <span>시스템ID</span>
                                <div>
                                    <input type="text" id="systemId" value="${systemInfo.system_id}" maxlength="8" style="width:220px;">
                                </div>

                            </div>

                            <div class="form-no-line">
                                <span>시스템그룹</span>

                                    <select id="SystemGroup" class="ms-choice" style="width:220px;">
                                        <c:forEach var="code" items="${COMBO_UI13}" varStatus="status">
                                            <option value="<c:out value="${code.code}"/>"><c:out value="${code.code_name}"/></option>
                                        </c:forEach>
                                    </select>

                            </div>

                            <div class="form-no-line">
                                <span>시스템명</span>
                                <div>
                                    <input type="text" id="systemName" value="${systemInfo.system_name}" maxlength="30" style="width:220px;">
                                </div>
                            </div>

                            <div class="form-no-line">
                                <span>설명</span>
                                <div>
                                    <input type="text" id="desc" value="${systemInfo.description}" maxlength="255" style="width:220px;">
                                </div>
                            </div>

<%--                            <div class="form-no-line">
                                <span>일련번호</span>
                                <div>
                                    <input type="text" id="sequence" value="${systemInfo.sequence}" style="width:220px;">
                                </div>
                            </div> --%>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-search w25 btn_operation" onclick="saveSystemInfo();">
                            저장
                        </button>
                        <c:if test="${'modify' eq mode}">
                        <button type="button" class="btn btn-search w25 btn_operation" onclick="removeSystemInfo();">
                            삭제
                        </button>
                        </c:if>
                        <button type="button" class="btn btn-search w25" data-dismiss="modal">
                            닫기
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
