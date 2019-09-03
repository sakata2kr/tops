<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.tops.model.*" %>
<%@ page import="java.util.List" %>
<style type="text/css">
.form-no-line > span.title {
float: left;
margin-top: 6px;
display: inline-block;
width: 80px;
}

</style>
<script>

// 저장
function saveBpInfo(){
	
	if($("#bpInfoBpId").val().trim() == '') {
		alert('BP ID를 입력해주세요.');
		$('#bpInfoBpId').focus();
		return;
	}
	
	if($("#bpInfoBpName").val().trim() == '') {
		alert('BP NAME을 입력해주세요.');
		$('#bpInfoBpName').focus();
		return;
	}
	
	
	if($("#bpInfoAutoRestartCnt").val().trim() == '') {
		alert('비정상 종료시 최대 재기동 횟수를 입력해주세요.');
		$('#bpInfoAutoRestartCnt').focus();
		return;
	}
	
    var retExpDigit = /^[0-9]/g;
    if ( !retExpDigit.test($("#bpInfoAutoRestartCnt").val().trim()) ) {
    	
    	alert('비정상 종료시 최대 재기동 횟수는 숫자로 입력해주세요.');
		$('#bpInfoAutoRestartCnt').focus();
		$('#bpInfoAutoRestartCnt').select();
		return;
    }
    
    if (!confirm('저장하시겠습니까?')){
        return;
    }
	
	var obj = {};
	obj.biz_domain = $("#bpInfoBizDomain").val();
	obj.bpid = $("#bpInfoBpId").val().trim();
	obj.bp_name = $("#bpInfoBpName").val();
	//obj.binary_id = $("#bpInfoBinaryId").val().trim();
	obj.auto_restart_cnt = $("#bpInfoAutoRestartCnt").val().trim();
	obj.ui_bp_group = $("#bpInfoUiBpGroup").val().trim();

	var url = '';
	<c:choose>
	<c:when test="${'modify' eq mode}">
	obj.old_bpid = "${bpInfo.bpid}";
	url = "<c:url value='/flow/modifyBpInfo' />";
	</c:when>
	<c:otherwise>
	url = "<c:url value='/flow/registerBpInfo' />";
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
				parent.postMessage('bpInfoListReload|'+obj.ui_bp_group,location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#bpInfoFormModal").modal('hide');

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
function removeBpInfo(){
    
    if (!confirm('삭제하시겠습니까?')){
        return;
    }
	
	var obj = {};
	obj.biz_domain = $("#bpInfoBizDomain").val();
	obj.bpid = $("#bpInfoBpId").val().trim();
	var json_data = JSON.stringify(obj);
	
	// 삭제
	$.ajax({
		url : "<c:url value='/flow/removeBpInfo' />"
		, type : "POST"
		, dataType : "json"
		, data : json_data
		, contentType: 'application/json'
		, cache: false
		, success : function(data, status) {

			if(data.result==true) {

				alert("삭제되었습니다.");
				
				// 부모창 목록화면 reload
				parent.postMessage('bpInfoListReload|'+$("#bpInfoUiBpGroup").val(),location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#bpInfoFormModal").modal('hide');

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
	
	<c:choose>
	<c:when test="${'modify' eq mode}">
	
	$("#bpInfoBizDomain").prop("disabled",true).val("${bpInfo.biz_domain}");
	$("#bpInfoUiBpGroup").prop("disabled",true).val("${bpInfo.ui_bp_group}");

	</c:when>
	<c:otherwise>
	
	$("#bpInfoBizDomain").prop("disabled",true).val("${biz_domain}");
	$("#bpInfoBpId").val("${ui_bp_group}${switch_type}").focus();
	$("#bpInfoBpName").val("${ui_bp_group}_${switch_type}_");
	$("#bpInfoUiBpGroup").prop("disabled",true).val("${ui_bp_group}");
	$("#bpInfoAutoRestartCnt").val("99");
	
	</c:otherwise>
	</c:choose>
	
	//$('#bpInfoFormModal').on('hidden.bs.modal', function(e){
	//	$(this).find("input,select").val('').end();
	//});
	
	setOperationBtn();
	
});

</script>
	<c:set var="BPINFO_BIZ_DOMAIN"  scope="page" />
			<div class="modal-dialog dialog-style01">
				<div class="modal-content">
					<div class="modal-header">
						 <a data-dismiss="modal" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
						<h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">BP정보 수정</c:when><c:otherwise>BP정보 등록</c:otherwise></c:choose></h4>
					</div>
					<div class="modal-body">
						<div class="modal-cust-con02">

							<div class="form-no-line">
								<span>도메인</span>
								<div class="showcase-select col-lg-2 w76">
									<select id="bpInfoBizDomain" class="ms-choice form-control02 w100">
										<c:forEach var="code" items="${BPINFO_BIZ_DOMAIN}" varStatus="status">
											<option value="<c:out value="${code.code}"/>"><c:out value="${code.code_name}"/></option>
										</c:forEach>
									</select>
								</div>
							</div>
							    
    
							<div class="form-no-line">
								<span>BP ID</span>
								<div class="showcase-select col-lg-2 w76">
									<input type="text" id="bpInfoBpId" class="form-control02 w100" value="${bpInfo.bpid}" maxlength="6">
								</div>
							</div>

							<div class="form-no-line">
								<span></span>
								<div class="showcase-select col-lg-2 w76 ui_jqgrid_specialfontcolor_c" style="font-size: 10px;">
									▶ IF 일 경우 IF + Switch Type + Switch No
								</div>
							</div>
							
							<div class="form-no-line">
								<span>BP NAME</span>
								<div class="showcase-select col-lg-2 w76">
									<input type="text" id="bpInfoBpName" class="form-control02 w100" value="${bpInfo.bp_name}" maxlength="20">
								</div>
							</div>
							
							<div class="form-no-line">
								<span style="font-size: 0.9em;height:17px;">최대재기동횟수</span>
								<div class="showcase-select col-lg-2 w76">
									<input type="text" id="bpInfoAutoRestartCnt" class="form-control02" maxlength="2" value="${bpInfo.auto_restart_cnt}" style="width:130px;ime-mode:disabled;" onkeypress="return onlyNumber(event)">(비정상종료시)
								</div>
							</div>
 
							<div class="form-no-line">
								<span>BP GROUP</span>
								<div class="showcase-select col-lg-2 w76">
									<select id="bpInfoUiBpGroup" class="ms-choice form-control02 w100">
										<c:forEach var="bpGroupInfo" items="${bpGroupInfoList}" varStatus="status">
											<option value="<c:out value="${bpGroupInfo.group_id}"/>"><c:out value="${bpGroupInfo.group_id}"/></option>
										</c:forEach>
									</select>
								</div>
							</div>
							
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-search btn_operation" onclick="saveBpInfo();">
							저장
						</button>
						<c:if test="${'modify' eq mode}">
						<button type="button" class="btn btn-search btn_operation" onclick="removeBpInfo();">
							삭제
						</button>
						</c:if>
						<button type="button" class="btn btn-search" data-dismiss="modal">
							닫기
						</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->