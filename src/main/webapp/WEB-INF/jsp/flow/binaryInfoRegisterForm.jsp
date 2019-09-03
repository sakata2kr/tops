<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<style type="text/css">

.left-box-binaryinfo {
	min-width: 209px;
	background: #FFF;
	overflow: hidden;
	float: left;
	width: 50%;
	height: 30px;
	display: block;
	border: 0;
	border-radius: 0;
	margin-right: 6px;
}


.right-box-binaryinfo {
	min-width: 250px;
	float: left;
	width: 48%;
	height: 30px;
	overflow: hidden;
}


.form-no-line-binaryinfo > span.t1 {
	width: 100px !important;
}

.form-no-line-binaryinfo > span {
	float: left;
	margin-top: 3px;
	display: inline-block;
	width: 71px;
}

.online-pro-binaryinfo {
	min-width: 500px;
	position: relative;
	padding: 10px 0;
}

.showcase-select-binaryinfo {
	float: left;
	margin-top: 3px;
}

.form-no-line-binaryinfo {
	margin-bottom: 0;
	clear: both;
}

.panel-rn-binaryinfo {
	padding: 0 10px 10px 10px !important;
}

.btn-normal-binaryinfo {
	/* float: left; */
	margin-right: 4px;
	padding: 1.5px 1px;
	color: #333333;
	background-image: -webkit-gradient(linear, left 0%, left 100%, from(#f2f2f2), to(#f2f2f2));
	background-image: -webkit-linear-gradient(top, #f2f2f2 0%, #f2f2f2 100%);
	background-image: -moz-linear-gradient(top, #f2f2f2 0%, #f2f2f2 100%);
	background-image: linear-gradient(to bottom, #f2f2f2 0%, #f2f2f2 100%);
	background-repeat: repeat-x;
	border-color: #bdbdbd;
	filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f2f2f2', endColorstr='#f2f2f2', GradientType=0);
	border-radius: 2px;
}

#binaryLocationInfoGrid td > select {
	width:100%;
	height:100%;
}
</style>

<script>

var SYSTEM_INFO_ARR = [
<c:if test="${not empty psystemInfoList}">
<c:forEach var="systemInfo" items="${psystemInfoList}" varStatus="i">
{ 
	"system_id" : "${systemInfo.system_id}"
	, "system_name" : "${systemInfo.system_name}"
},
</c:forEach>
</c:if>
];

// 저장
function saveBinaryInfo(){

    var binaryId   = $("#bi_binaryId");
    var binaryName = $("#bi_binaryName");

	if(binaryId.val().trim() == '') {
		alert('BINARY ID를 입력해주세요.');
        binaryId.focus();
		return;
	}
	
	if(binaryName.val().trim() == '') {
		alert('BINARY NAME을 입력해주세요.');
        binaryName.focus();
		return;
	}
    
    if (!confirm('저장하시겠습니까?')){
        return;
    }
    
    //binary location 정보
    var binaryLocationInfoArr = [];
    var ids = $("#binaryLocationInfoGrid").jqGrid('getDataIDs');
    for(var i = 0; i < ids.length; i++){
    	var obj = {};
    	obj.psystemId = $("#"+ids[i]+"_psystemId").val();
    	obj.binaryLoc = $("#"+ids[i]+"_binaryLoc").val();
    	obj.binaryId = binaryId.val();
    	binaryLocationInfoArr.push(obj);
    }
	
	var binaryInfoObj = {};
	binaryInfoObj.binary_id = binaryId.val();
	binaryInfoObj.binary_name = binaryName.val().trim();
	binaryInfoObj.description = $("#bi_description").val().trim();
	binaryInfoObj.binaryLocationList = binaryLocationInfoArr;
	var json_data = JSON.stringify(binaryInfoObj);
	
	var url = '';
	<c:choose>
	<c:when test="${'modify' eq mode}">
	//obj.old_binary_id = "${binaryInfo.binary_id}";
	url = "<c:url value='/flow/modifyBinaryInfo' />";
	</c:when>
	<c:otherwise>
	url = "<c:url value='/flow/registerBinaryInfo' />";
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
				parent.postMessage("selectBinaryInfoList",location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#binaryInfoRegisterFormModal").modal('hide');

			} else {
				alert("저장 중 오류가 발생하였습니다.");
			}
		}
		, error : function(){						
			//showModal("통신중 오류가 발생했습니다.");
			alert("저장중 오류가 발생했습니다.")
		}
	});
}


// 삭제
function removeBinaryInfo(){
    
    if (!confirm('삭제하시겠습니까?')){
        return;
    }
	
	var obj = {};
	obj.binary_id = "${binaryInfo.binary_id}";
	var json_data = JSON.stringify(obj);
	
	// 삭제
	$.ajax({
		url : "<c:url value='/flow/removeBinaryInfo' />"
		, type : "POST"
		, dataType : "json"
		, data : json_data
		, contentType: 'application/json'
		, cache: false
		, success : function(data, status) {

			if(data.result==true) {

				alert("삭제되었습니다.");
				
				// 부모창 목록화면 reload
				parent.postMessage("selectBinaryInfoList",location.protocol+'//'+location.host);

				// 이 모달 창 숨기기
				$("#binaryInfoRegisterFormModal").modal('hide');

			} else {
				alert("삭제 중 오류가 발생하였습니다.");
			}
		}
		, error : function(){						
			//showModal("통신중 오류가 발생했습니다.");
			alert("삭제중 오류가 발생했습니다.")
		}
	});
}

/*
//논리시스템 ID 변경이벤트 발생시 처리
function bi_dataEventLsytemIdChangeHandler(id, val) {
	//중복여부를 체크할것인가...
	return;
	
	var rowIndex = id.split('_')[0];
	var primarySystemOptionTag = "";
	
	SYSTEM_INFO_ARR.forEach(function(d) {
		primarySystemOptionTag += "<option value='"+d.system_id+"'>"+d.system_id+"</option>";
	});
	
	$("#"+rowIndex+"_psystemId").empty().append(primarySystemOptionTag);
}
*/

//백업정책추가
function addRowBinaryLocationInfo() {

    var binaryLocationInfoGrid = $("#binaryLocationInfoGrid");

    binaryLocationInfoGrid.jqGrid('addRow', "new");

	//var selRowId = $("#binaryLocationInfoGrid").getGridParam('selrow');
	
	//bi_dataEventLsytemIdChangeHandler(selRowId, $("#"+selRowId+"_psystemId").val());
	
	// 체크박스 해제
    binaryLocationInfoGrid.resetSelection();
}

//백업정책삭제
function delRowBinaryLocationInfo() {

    var binaryLocationInfoGrid = $("#binaryLocationInfoGrid");
	var selectedArray = binaryLocationInfoGrid.getGridParam('selarrrow');

	//console.log(selectedArray);

	if(selectedArray.length == 0)
	{
		alert("삭제항목을 선택해주세요.");
		return;
	}

	var cnt = selectedArray.length;
	for(var i = 0; i < cnt; i++)
	{
		//var selRowId = $("#binaryLocationInfoGrid").getGridParam('selrow');
		//console.log(selectedArray[0]);
        binaryLocationInfoGrid.delRowData(selectedArray[0]);
	}
}

$(document).ready(function()
{
    var binaryId   = $("#bi_binaryId");
    var binaryName = $("#bi_binaryName");
    var descrption = $("#bi_description");

    binaryId.prop('disabled', false);
	<c:if test="${'modify' eq mode}">
    binaryId.val('${binaryInfo.binary_id}');
    binaryName.val('${binaryInfo.binary_name}');
    descrption.val('${binaryInfo.description}');
    binaryId.prop('disabled', true);
	</c:if>
	
	var logicalIdOptionStr = "";
	SYSTEM_INFO_ARR.forEach(function(d) {
			logicalIdOptionStr += ""+d.system_id+":"+d.system_name+";";
	});
	logicalIdOptionStr = logicalIdOptionStr.replace(/;$/,"");
	var datatype = '';
	var url = '';
	var obj = {};
	<c:choose>
    <c:when test="${'modify' eq mode}">
		obj.binary_id = "${binaryInfo.binary_id}";
		url = "<c:url value='/flow/binaryLocationInfoList'/>";
		datatype= "json";
    </c:when>
    <c:otherwise>
	    datatype= "local";
    </c:otherwise>
	</c:choose>
	
	$("#binaryLocationInfoGrid").jqGrid({
        url : url,
        postData: obj, // json_data,
        datatype : datatype,
        mtype : "post",
        contentType: 'application/json',
        loadtext:"Loading...",
        autowidth: true,
        //width: '300px',
        height: '150px',
        shrinkToFit : false,
        loadonce: false,
        rowNum: 10000,
       // viewrecords: true,
        //scroll:1,
        jsonReader : {
             root : "binaryLocationInfoList" // 데이터의 시작을 설정
        },
        colNames : [
                    'BINARY ID',
                    'PSYSTEM ID',
                    'BYNARY LOCATION'
                   ],
        colModel : [
					{ name : 'binaryId',  index:'binaryId', hidden:true},
					{ name : 'psystemId',  index:'psystemId', width: 170, sortable: false, editable: true, edittype: "select", editoptions: {value: logicalIdOptionStr, dataEvents: [{type: 'change', fn: function(e){bi_dataEventLsytemIdChangeHandler(e.currentTarget.id,$(this).val());}}]}},
					{ name : 'binaryLoc',  index:'binaryLoc', width: 320, sortable: false, editable: true}
          ],
        multiselect : true,
        addedrow: "last",
        beforeSelectRow: function(rowid, e) {	// 체크박스 선택시에만 체크되게
        	return $(e.target).is('input[type=checkbox]');
        },
        onSelectRow: function(id, status){

        },
        onSelectAll: function(ids, status) {

        },
        loadComplete: function(){
        	
        	var ids = $(this).jqGrid('getDataIDs');

        	for(var i = 0; i < ids.length; i++) {

        		var psystemId = $(this).jqGrid('getCell',ids[i],'psystemId');
        		
        		$(this).jqGrid('editRow',ids[i],true);
        		//bi_dataEventLsytemIdChangeHandler(ids[i], $("#"+ids[i]+"_psystemId").val());
        		
        		//console.log(psystemId);
        		$("#"+ids[i]+"_psystemId").val(psystemId);
        	}
        }
	});
	
	$('#bianryInfoFormModal').on('hidden.bs.modal', function(e){
		$(this).find("input,select").val('').end();
	});
	
	setOperationBtn();
});

</script>
<div class="modal-dialog">
	<div class="modal-content">
		<div class="modal-header">
			 <a data-dismiss="modal" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
			<h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">Binary정보수정</c:when><c:otherwise>Binary정보등록</c:otherwise></c:choose></h4>
		</div>
		<div class="modal-body">
			<div class="modal-cust-con02">
						
			<div class="showcase panel-con panel-rn-binaryinfo">
				<div class="showcase-content">
					<div class="online-pro-binaryinfo oper-table panel-con">
					

						<div class="left-box-binaryinfo">
							<div class="showcase w100" >
							
								<div class="form-no-line-binaryinfo">
									<span class="t1">BINARY ID</span>
									<div class="showcase-select-binaryinfo">
										<input type="text" id="bi_binaryId" maxlength="30" class="form-control" style="width:140px;" value="" />
									</div>
								</div>
																	
							</div>
						</div>
							
						<div class="right-box-binaryinfo">
							<div class="showcase w100" >
						
								<div class="form-no-line-binaryinfo">
									<span class="t1">BINARY NAME</span>
									<div class="showcase-select-binaryinfo">
										<input type="text" id="bi_binaryName" maxlength="60" class="form-control" style="width:140px;" value="" />
									</div>
								</div>
							</div>
															
						</div>
					</div>
						
					<div class="form-no-line-binaryinfo" style="margin-bottom:30px;">
							<span class="t1">DESCRIPTION</span>
							<div class="showcase-select-binaryinfo">
								<input type="text" id="bi_description" maxlength="127" class="form-control" style="width:410px;" value="" />
							</div>
					</div>
																	
					<span class="showcase-title-sub">
						<h5>LOCATION</h5>
						<div align="right" style="margin-top: 0.4em;">
							<button type="button" class="btn btn-normal-binaryinfo btn_operation" onclick="addRowBinaryLocationInfo();">추가</button>
							<button type="button" class="btn btn-normal-binaryinfo btn_operation" onclick="delRowBinaryLocationInfo();">삭제</button>
						</div>
					</span>
						
						<div class="table-responsive">
							<table id="binaryLocationInfoGrid" class="grid"></table>
						</div>
	
					</div>
				</div>
				
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-search btn_operation" onclick="saveBinaryInfo();">
				저장
			</button>

 			<c:if test="${'modify' eq mode}">
				<button type="button" class="btn btn-search btn_operation" onclick="removeBinaryInfo();">
					삭제
				</button>
			</c:if>
					
			<button type="button" class="btn btn-search" data-dismiss="modal">
				닫기
			</button>
		</div>
	</div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->