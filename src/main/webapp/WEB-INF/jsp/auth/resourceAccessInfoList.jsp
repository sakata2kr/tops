<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tops.model.*" %>
<style type="text/css">
    .thisHyperLink_ra {
        /* text-decoration: underline;
        cursor: pointer; */
        color: #0094C8;
        background-color: #F0F4F7;
    }

    input[type="checkbox"] {
        margin: 3px 0.5ex;
        padding: initial;
        background-color: initial;
        border: initial;
    }
</style>
<script>

    // 목록 조회
    function resourceAccessInfoList() {

        var obj = {};
        obj.searchWord = $("#resourceAccessAuthGroupId").val();
        var json_data = JSON.stringify(obj);

        $.ajax({
            type: "post",
            url: "<c:url value='/auth/resourceAccessInfoList' />",
		data: json_data,
		dataType:'json',
		contentType: 'application/json',
		cache: false,
		success: function(data,status) {

			// tbody 초기화
			$("#resourceAccessInfoList").find("tr").remove();
				
			$(data.resourceAccessInfoList).each(function(i) {
				var addTag = "<tr " + (this.access_yn == "Y" ? "class='thisHyperLink_ra'" : "")+">"
						   + "<td>" + this.resource_id + "</td>"
						   + "<td style='text-align:left;'>" + this.resource_name + "</td>"
						   + "<td><input type='checkbox' name='accessYn' value='" + this.resource_id + "' " + (this.access_yn == "Y" ? "checked='checked'" : "") + " onchange='checkAllorNot()' /></td>"
						   + "</tr>"
						   ;

				$("#resourceAccessInfoList").append(addTag);

			});

			checkAllorNot();

			// 총건수가 0이면 '조회된 목록이 없다'는 메시지 표시
			//if(data.list.length==0) 
			//	noList();
		},
		error: function(){						
			showModal("리소스 목록 조회 중 오류가 발생했습니다.");
		}
	});
}

    function checkAllorNot()
    {
        var allChecked = 0;

        $("input:checkbox[name=accessYn]").each(function()
        {
        	if ( $(this).is(":checked") == true )
        	{
        		allChecked++;
        	}
        });

        if ( $("input:checkbox[name=accessYn]").size() == allChecked )
        {
        	$("#allCheck").prop("checked", true);
        }
        else
        {
            $("#allCheck").prop("checked", false);
        }
    }

//저장
function saveResourceAccessInfos(){
    
    if (!confirm('저장하시겠습니까?')){
        return;
    }
	
    var accessInfoArr = [];
    $("input:checkbox[name=accessYn]").each(function() {
    	var accessInfo = $(this).val()+"|"+$("#resourceAccessAuthGroupId").val()+"|"+($(this).is(":checked") == true ? "Y" : "N");
    	accessInfoArr.push(accessInfo);
    });
    
    
	var json_data = JSON.stringify(accessInfoArr);
	
//	alert(json_data);

	// 저장
	$.ajax({
		url : "<c:url value='/auth/registerResourceAccessInfo' />"
		, type : "POST"
		, dataType : "json"
		, data : json_data
		, contentType: 'application/json'
		, cache: false
		, success : function(data, status) {

			if(data.result==true) {

				showModal("저장되었습니다.");
				
				resourceAccessInfoList();

			} else {
				
				showModal("저장 중 오류가 발생하였습니다.");
				
			}
		}
		, error : function(){						
			showModal("저장 중 오류가 발생했습니다.");
		}
	});
}


//조회된 목록이 없을 경우 표시하는 태그
function noList() {
	$("#resourceAccessInfoList").append('<tr><td colspan="7">검색 조건에 해당하는 건이 없습니다.</td></tr>');
}


// 권한그룹 selectbox 선택시
$("#resourceAccessAuthGroupId").bind("change", function() {
	
	// 목록 조회
	resourceAccessInfoList();
	
	// selectbox focus 제거
	$(this).blur();
	
});

// 체크박스 체크 또는 체크해제 시
$("input:checkbox[name=accessYn]").bind("change", function() {
	console.log("!!!!");
	$("#allCheck").prop("checked", false);
});

// 저장 버튼 클릭시
$("#btn_saveResourceAccessInfos").click(function(){
	saveResourceAccessInfos();
});

//checkAll : 전체선택/해제 함수
function checkAll(obj, name){
	var chk = $(":input:checkbox[name="+name+"]");
	chk.each(function(){
			$(this).prop('checked',obj.checked);
	});	 
}

    $(document).ready(function()
    {
	    setOperationBtn();
	    resourceAccessInfoList();
	});


</script>

			<div class="showcase panel-con panel-rn">
				<div class="showcase-content ">

					<div class="com-02">
						
								<div class="showcase-select mR5">
									<div class="showcase-select mR5">
										권한그룹
									</div>
									<select id="resourceAccessAuthGroupId" class="form-control" style="width:100px;">
										<c:if test="${not empty resourceAccessInfoAuthGroupInfoList}">
											<c:forEach var="authGroupInfo" items="${resourceAccessInfoAuthGroupInfoList}" varStatus="i">
													<option value='${authGroupInfo.auth_group_id}'>${authGroupInfo.auth_group_name}</option>
											</c:forEach>
										</c:if>
									</select>
								</div>
								
								<!-- 버튼 -->
								<div class="btn-r">
									<button id="btn_saveResourceAccessInfos" type="button" class="btn btn-search btn_operation" >
									 저장
									</button>
		
								</div>
						
					</div>
 
					<div class="table-responsive">
						<table class="table table-blue bbs100">
							<thead>
								<tr>
									<th scope="col">리소스 ID</th>
									<th scope="col">리소스명</th>
									<th scope="col"><input type="checkbox" name="allCheck" id="allCheck" onclick="checkAll(this, 'accessYn');"/></th>
								</tr>
							</thead>
							<tbody id="resourceAccessInfoList"></tbody>
						</table>

					</div>

				</div>
			</div>
