<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.tops.model.*" %>

<div class="modal-dialog dialog-style01">
    <div class="modal-content">
        <div class="modal-header">
            <a data-dismiss="modal" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
            <h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">BP GROUP 정보 수정</c:when><c:otherwise>BP GROUP 정보 등록</c:otherwise></c:choose></h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">

                <div class="form-no-line">
                    <span>GROUP ID</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="bpGroupInfoBpGroupId" class="form-control02 w100" maxlength="6" value="${bpGroupInfo.group_id}">
                    </div>
                </div>

                <div class="form-no-line">
                    <span>일련번호</span>
                    <div class="showcase-select col-lg-2 w76">
                        <input type="text" id="bpGroupInfoSequence" class="form-control02 w100" maxlength="2" value="${bpGroupInfo.sequence}" style='ime-mode:disabled;' onkeypress="return onlyNumber(event)">
                    </div>
                </div>

                <div class="form-no-line">
                    <span>Logical ID</span>
                    <div class="showcase-select col-lg-2 w76">
                        <select id="bpGroupInfoLogicalGroupId" class="ms-choice form-control02 w100">
                            <c:forEach var="logicalGroupInfo" items="${logicalGroupInfoList}" varStatus="status">
                                <option value="<c:out value="${logicalGroupInfo.system_group}"/>"><c:out value="${logicalGroupInfo.system_group}"/></option>
                            </c:forEach>
                        </select>
                    </div>
                </div>


            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search btn_operation" onclick="saveBpGroupInfo();">
                저장
            </button>
            <c:if test="${'modify' eq mode}">
            <button type="button" class="btn btn-search btn_operation" onclick="removeBpGroupInfo();">
                삭제
            </button>
            </c:if>
            <button type="button" class="btn btn-search" data-dismiss="modal">
                닫기
            </button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->

<script>

    // 저장
    function saveBpGroupInfo() {

        if ($("#bpGroupInfoBpGroupId").val().trim() == '') {
            alert('BP GROUP ID를 입력해주세요.');
            $('#bpGroupInfoBpGroupId').focus();
            return;
        }

        if ($("#bpGroupInfoSequence").val().trim() == '') {
            alert('일련번호를 입력해주세요.');
            $('#bpGroupInfoSequence').focus();
            return;
        }

        if (!confirm('저장하시겠습니까?')) {
            return;
        }

        var obj = {};
        obj.group_id = $("#bpGroupInfoBpGroupId").val().trim();
        obj.group_name = $("#bpGroupInfoBpGroupId").val().trim();
        obj.sequence = $("#bpGroupInfoSequence").val().trim();
        obj.reference = $("#bpGroupInfoLogicalGroupId").val();
        obj.description = "BP Group 정의";
        var json_data = JSON.stringify(obj);

        var url = '';
        <c:choose>
	<c:when test="${'modify' eq mode}">
	url = "<c:url value='/flow/modifyBpGroupInfo' />";
	</c:when>
	<c:otherwise>
	url = "<c:url value='/flow/registerBpGroupInfo' />";
	</c:otherwise>
	</c:choose>
	
	
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
				parent.postMessage("bpGroupInfoListReload",location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#bpGroupInfoFormModal").modal('hide');

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
function removeBpGroupInfo(){
    
    if (!confirm('삭제하시겠습니까?')){
        return;
    }
	
	var obj = {};
	obj.group_id = $("#bpGroupInfoBpGroupId").val().trim();
	var json_data = JSON.stringify(obj);
	
	// 삭제
	$.ajax({
		url : "<c:url value='/flow/removeBpGroupInfo' />"
		, type : "POST"
		, dataType : "json"
		, data : json_data
		, contentType: 'application/json'
		, cache: false
		, success : function(data, status) {

			if(data.result==true) {

				alert("삭제되었습니다.");
				
				// 부모창 목록화면 reload
				parent.postMessage("bpGroupInfoListReload",location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#bpGroupInfoFormModal").modal('hide');

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
	$("#bpGroupInfoBpGroupId").prop("readonly",true);
	$("#bpGroupInfoLogicalGroupId").val('${bpGroupInfo.reference}');
	</c:if>
	
	$('#bpGroupInfoFormModal').on('hidden.bs.modal', function(e){
		$(this).find("input,select").val('').end();
	});
	
	setOperationBtn();
});

</script>
