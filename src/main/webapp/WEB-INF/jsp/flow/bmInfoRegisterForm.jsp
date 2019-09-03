<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.tops.model.*" %>
<%@ page import="java.util.List" %>
<script>

// 저장
function saveBmInfo(){

    var bmId   = $("#bmInfoBmId");
    var bmName = $("#bmInfoBmName");

	if(bmId.val().trim() == '') {
		alert('BM ID를 입력해주세요.');
        bmId.focus();
		return;
	}
	
	if(bmName.val().trim() == '') {
		alert('BM NAME을 입력해주세요.');
        bmName.focus();
		return;
	}
    
    if (!confirm('저장하시겠습니까?')){
        return;
    }
	
	var obj = {};
	obj.biz_domain  = $("#bmInfoBizDomain").val();
	obj.bmid        = bmId.val().trim();
	obj.bm_name     = bmName.val();
	obj.binary_id   = $("#bmInfoBinaryId").val().trim();
	obj.ui_bp_group = $("#bmInfoUiBpGroup").val().trim();

	var url = '';
	<c:choose>
	<c:when test="${'modify' eq mode}">
	obj.old_bmid = bmId.val().trim();
	url = "<c:url value='/flow/modifyBmInfo' />";
	</c:when>
	<c:otherwise>
	url = "<c:url value='/flow/registerBmInfo' />";
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
				parent.postMessage('bmInfoListReload|'+$("#bpInfoUiBpGroup").val(),location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#bmInfoFormModal").modal('hide');

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
function removeBmInfo(){
    
    if (!confirm('삭제하시겠습니까?')){
        return;
    }
	
	var obj = {};
	obj.biz_domain = $("#bmInfoBizDomain").val();
	obj.bmid = $("#bmInfoBmId").val().trim();
	var json_data = JSON.stringify(obj);
	
	// 삭제
	$.ajax({
		url : "<c:url value='/flow/removeBmInfo' />"
		, type : "POST"
		, dataType : "json"
		, data : json_data
		, contentType: 'application/json'
		, cache: false
		, success : function(data, status) {

			if(data.result==true) {

				alert("삭제되었습니다.");
				
				// 부모창 목록화면 reload
				parent.postMessage('bmInfoListReload|'+$("#bpInfoUiBpGroup").val(),location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#bmInfoFormModal").modal('hide');

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

//바이너리정보관리 팝업
function popupBinaryInfoList(){
	$('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움
	
	$("#formModal").modal({
		backdrop : 'static',
		remote: '/flow/viewBinaryInfoList'
	});  
}

$(document).ready(function(){
	<c:choose>
	<c:when test="${'modify' eq mode}">

	var bmInfoBizDomain = $("#bmInfoBizDomain");
    var bmInfoUiBpGroup = $("#bmInfoUiBpGroup");

    bmInfoBizDomain.prop("disabled",true).val("${bmInfo.biz_domain}");
    bmInfoUiBpGroup.prop("disabled",true).val("${bmInfo.ui_bp_group}");
	
	</c:when>
	<c:otherwise>

    bmInfoBizDomain.prop("disabled",true).val("${biz_domain}");
    bmInfoUiBpGroup.prop("disabled",true).val("${ui_bp_group}");
	$("#bmInfoBmId").val("").focus();

	</c:otherwise>
	</c:choose>
	
	
	$('#bmInfoFormModal').on('hidden.bs.modal', function(e){
		$(this).find("input,select").val('').end();
	});
	
	setOperationBtn();
});

</script>
	<c:set var="BMINFO_BIZ_DOMAIN"  scope="page" />
			<div class="modal-dialog dialog-style01">
				<div class="modal-content">
					<div class="modal-header">
						 <a data-dismiss="modal" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
						<h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">BM정보 수정</c:when><c:otherwise>BM정보 등록</c:otherwise></c:choose></h4>
					</div>
					<div class="modal-body">
						<div class="modal-cust-con02">

							<div class="form-no-line">
								<span>도메인</span>
								<div class="showcase-select col-lg-2 w76">
									<select id="bmInfoBizDomain" class="ms-choice form-control02 w100">
										<c:forEach var="code" items="${BMINFO_BIZ_DOMAIN}" varStatus="status">
											<option value="<c:out value="${code.code}"/>"><c:out value="${code.code_name}"/></option>
										</c:forEach>
									</select>
								</div>
							</div>
							
							<div class="form-no-line">
								<span>BM ID</span>
								<div class="showcase-select col-lg-2 w76">
									<input type="text" id="bmInfoBmId" class="form-control02 w100" value="${bmInfo.bmid}" maxlength="6">
								</div>
							</div>

							<div class="form-no-line">
								<span>BM NAME</span>
								<div class="showcase-select col-lg-2 w76">
									<input type="text" id="bmInfoBmName" class="form-control02 w100" value="${bmInfo.bm_name}" maxlength="20" style="width:100px;">
								</div>
							</div>
							
							<div class="form-no-line">
								<span>바이너리</span>
								<div class="showcase-select col-lg-2 w76">
									<select id="bmInfoBinaryId" class="ms-choice form-control02 w100">
										<c:forEach var="binaryInfo" items="${binaryInfoList}" varStatus="status">
											<option value="<c:out value="${binaryInfo.binary_id}"/>"><c:out value="${binaryInfo.binary_name}"/></option>
										</c:forEach>
									</select>
								</div>
							</div>
 
							<div class="form-no-line">
								<span>BP GROUP</span>
								<div class="showcase-select col-lg-2 w76">
									<select id="bmInfoUiBpGroup" class="ms-choice form-control02 w100">
										<c:forEach var="bpGroupInfo" items="${bpGroupInfoList}" varStatus="status">
											<option value="<c:out value="${bpGroupInfo.group_id}"/>"><c:out value="${bpGroupInfo.group_id}"/></option>
										</c:forEach>
									</select>
								</div>
							</div>
							
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-search btn_operation" onclick="popupBinaryInfoList();">
							바이너리관리
						</button>
						<button type="button" class="btn btn-search btn_operation" onclick="saveBmInfo();">
							저장
						</button>
						<c:if test="${'modify' eq mode}">
						<button type="button" class="btn btn-search btn_operation" onclick="removeBmInfo();">
							삭제
						</button>
						</c:if>
						<button type="button" class="btn btn-search" data-dismiss="modal">
							닫기
						</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->