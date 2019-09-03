<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="com.tops.model.*" %>
<%@ page import="java.util.List" %>

<style type="text/css">

    .left-box-groupinfo
    { min-width: 209px;
      background: #FFF;
      overflow: hidden;
      float: left;
      width: 50%;
      /*height: 120px;*/
      display: block;
      border: 0;
      border-radius: 0;
      margin-right: 6px;
    }

    .right-box-groupinfo
    { min-width: 250px;
      float: left;
      width: 48%;
      /*height: 120px;*/
      overflow: hidden;
    }

    .form-no-line-groupinfo > span.t1
    { width: 100px !important; }

    .form-no-line-groupinfo > span
    { float: left;
      margin-top: 3px;
      display: inline-block;
      width: 71px;
    }

    .online-pro-groupinfo
    { min-width: 500px;
      position: relative;
      padding: 10px 0;
    }

    .showcase-select-groupinfo
    { float: left;
      margin-top: 3px;
    }

    .form-no-line-groupinfo
    { margin-bottom: 0;
      clear: both;
    }

    .panel-rn-groupinfo
    { padding: 0 10px 10px 10px !important; }

    .btn-normal-groupinfo
    { margin-right: 4px;
      padding: 1.5px 1px;
      color: #333333;
      background-image: -webkit-gradient(linear, left 0%, left 100%, from(#f2f2f2), to(#f2f2f2));
      background-image: -webkit-linear-gradient(top, #f2f2f2, 0%, #f2f2f2, 100%);
      background-image: -moz-linear-gradient(top, #f2f2f2 0%, #f2f2f2 100%);
      background-image: linear-gradient(to bottom, #f2f2f2 0%, #f2f2f2 100%);
      background-repeat: repeat-x;
      border-color: #bdbdbd;
      filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#f2f2f2', endColorstr='#f2f2f2', GradientType=0);
      border-radius: 2px;
    }

    #groupBackupPolicyInfoGrid td > select
    { width:100%;
      height:100%;
    }
</style>

<input type="hidden" id="groupInfoFlowId" value="" />
<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <a data-dismiss="modal" href="#none" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
            <h4 class="modal-title"><c:choose><c:when test="${'modify' eq mode}">그룹정보수정</c:when><c:otherwise>그룹정보등록</c:otherwise></c:choose></h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">

                <div class="showcase panel-con panel-rn-groupinfo">
                    <div class="showcase-content">
                        <div class="online-pro-groupinfo oper-table panel-con">


                            <div class="left-box-groupinfo">
                                <div class="showcase w100" >

                                    <div class="form-no-line-groupinfo">
                                        <span class="t1">그룹 대분류</span>
                                        <div class="showcase-select-groupinfo">
                                            <select id="groupCtg1" class="form-control" style="width:140px;">
                                                <c:forEach var="code" items="${GROUP_CTG1}" varStatus="status">
                                                    <option value="<c:out value="${itm_cd}"/>"><c:out value="${itm_name}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-no-line-groupinfo">
                                        <span class="t1">그룹ID</span>
                                        <div class="showcase-select-groupinfo">
                                            <input type="text" id="groupInfoGroupId" maxlength="6" class="form-control" style="width:140px;" value="" />
                                        </div>
                                    </div>

                                    <div class="form-no-line-groupinfo">
                                        <span class="t1">일련번호</span>
                                        <div class="showcase-select-groupinfo">
                                            <input type="text" id="groupInfoArrayIndex" maxlength="3" class="form-control" style="width:140px;" readonly />
                                        </div>
                                    </div>

                                </div>
                            </div>

                            <div class="right-box-groupinfo">
                                <div class="showcase w100" >

                                    <div class="form-no-line-groupinfo">
                                        <span class="t1">그룹 중분류</span>
                                        <div class="showcase-select-groupinfo">
                                            <select id="groupCtg2" class="form-control" style="width:140px;">
                                                <c:forEach var="code" items="${GROUP_CTG2}" varStatus="status">
                                                    <option value="<c:out value="${itm_cd}"/>"><c:out value="${itm_name}"/></option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="form-no-line-groupinfo">
                                        <span class="t1">그룹명</span>
                                        <div class="showcase-select-groupinfo">
                                            <input type="text" id="groupInfoGroupName" maxlength="30" class="form-control" style="width:140px;" value="" />
                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                        <div class="form-no-line-groupinfo" style="margin-bottom:30px;">
                                <span class="t1">FLOW 설명</span>
                                <div class="showcase-select-groupinfo">
                                    <input type="text" id="groupInfoDesc" maxlength="100" class="form-control" maxlength="100" style="width:270px;" value="" />
                                </div>
                        </div>

                        <span class="showcase-title-sub">
                            <h5>백업정책</h5>
                            <div align="right" style="margin-top: 0.4em;">
                                <button type="button" class="btn btn-normal-groupinfo btn_operation" onclick="addRowBackupPolicyInfo();">정책추가</button>
                                <button type="button" class="btn btn-normal-groupinfo btn_operation" onclick="delRowBackupPolicyInfo();">정책삭제</button>
                            </div>
                        </span>

                        <div class="table-responsive">
                            <table id="groupBackupPolicyInfoGrid" class="grid"></table>
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search btn_operation" onclick="saveGroupInfo();">저장</button>
            <c:if test="${'modify' eq mode}">
                <button type="button" class="btn btn-search btn_operation" onclick="removeGroupInfo();">삭제</button>
            </c:if>
            <button type="button" class="btn btn-search" data-dismiss="modal">닫기</button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->

<script>

    var SYSTEM_INFO_ARR = [
    <c:if test="${not empty backupPolicySystemInfoList}">
    <c:forEach var="systemInfo" items="${backupPolicySystemInfoList}" varStatus="i">
    {
        "system_id" : "${systemInfo.system_id}"
        , "system_group" : "${systemInfo.system_group}"
    },
    </c:forEach>
    </c:if>
    ];

    // 백업정책추가
    function addRowBackupPolicyInfo() {

        $("#groupBackupPolicyInfoGrid").jqGrid('addRow', "new");

        var selRowId = $("#groupBackupPolicyInfoGrid").getGridParam('selrow');

        dataEventLsytemIdChangeHandler(selRowId, $("#"+selRowId+"_system_id").val());

        dataEventPrimarySytemIdChangeHandler(selRowId, $("#"+selRowId+"_primary_system_id").val());

        // 체크박스 해제
        $("#groupBackupPolicyInfoGrid").resetSelection();
    }


    //백업정책삭제
    function delRowBackupPolicyInfo() {

        var selectedArray = $("#groupBackupPolicyInfoGrid").getGridParam('selarrrow');

        if(selectedArray.length==0){
            alert("삭제항목을 선택해주세요.");
            return;
        }

        //console.log(selectedArray.length);
        var cnt = selectedArray.length;
        for(var i = 0; i < cnt; i++) {
            //var selRowId = $("#groupBackupPolicyInfoGrid").getGridParam('selrow');
            $("#groupBackupPolicyInfoGrid").delRowData(selectedArray[0]);
        }
    }


    //checkValidation : 유효성 검사
    function checkValidation() {

        if($('#groupInfoGroupId').val().trim() == '') {
            alert('그룹 ID를 입력해 주세요.');
            $('#groupInfoGroupId').focus();
            return false;
        }

        if($('#groupInfoGroupName').val().trim() == '') {
            alert('그룹명을 입력해 주세요.');
            $('#groupInfoGroupName').focus();
            return false;
        }

        if($('#groupInfoServiceType').val().trim() != 'ETC') {
            if($('#groupInfoSwitchType').val().trim() == '') {
                alert('Switch Type을 입력해 주세요.');
                $('#groupInfoSwitchType').focus();
                return false;
            }
        }

        if($("#groupBackupPolicyInfoGrid").jqGrid('getDataIDs').length==0){
            alert("백업정책을 등록해주세요.");
            return false;
        }

        return true;
    }

    // 저장
    function saveGroupInfo(){

        //유효성 검사.
        if(!checkValidation()){
            return;
        }

        if (!confirm('저장하시겠습니까?')){
            return;
        }

        // 저장할 백업정책 데이터
        var groupBackupPolicyInfoArr = [];
        var ids = $("#groupBackupPolicyInfoGrid").jqGrid('getDataIDs');
        for(var i = 0; i < ids.length; i++) {
            var obj = {};
            obj.system_id = $("#"+ids[i]+"_system_id").val();
            obj.group_id = $('#groupInfoGroupId').val().trim();
            obj.primary_system_id = $("#"+ids[i]+"_primary_system_id").val();
            obj.backup_system_id = $("#"+ids[i]+"_backup_system_id").val();
            groupBackupPolicyInfoArr.push(obj);
        }

        // 그룹정보
        var groupInfoObj = {};
        groupInfoObj.biz_domain = $('#groupInfoBizDomain').val();
        groupInfoObj.group_id = $('#groupInfoGroupId').val().trim();
        groupInfoObj.group_name = $('#groupInfoGroupName').val().trim();
        groupInfoObj.ui_lcl_cd = $('#groupInfoService').val();
        groupInfoObj.ui_mcl_cd = $('#groupInfoServiceType').val();
        groupInfoObj.ui_scl_cd = $('#groupInfoNwEquipment').val();
        //groupInfoObj.ui_ref_cd = $('#groupInfoBizDomain').val();
        groupInfoObj.description = $('#groupInfoDesc').val();
        groupInfoObj.switch_type = $('#groupInfoSwitchType').val().trim();
        groupInfoObj.backup_policy_list = groupBackupPolicyInfoArr;
        var json_data = JSON.stringify(groupInfoObj);

        var url = '';
        <c:choose>
        <c:when test="${'modify' eq mode}">
        url = "<c:url value='/flow/modifyGroupInfo' />";
        </c:when>
        <c:otherwise>
        url = "<c:url value='/flow/registerGroupInfo' />";
        </c:otherwise>
        </c:choose>

        //console.log(json_data);
        //return;

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
                    parent.postMessage("groupInfoListReload",location.protocol+'//'+location.host);

                    // 이 모달 창 숨기기
                    $("#groupInfoFormModal").modal('hide');

                } else {
                    alert("저장 중 오류가 발생하였습니다. 도메인/그룹ID/Switch Type 을 확인하세요.");
                }
            }
            , error : function(){
                //showModal("저장 중 오류가 발생했습니다.");
                alert("저장 중 오류가 발생했습니다.")
            }
        });
    }


    //그룹삭제 전 확인
    function checkFlowExistByGroupId() {

        var ret = true;

        // 그룹정보
        var obj = {};
        obj.group_id = $('#groupInfoGroupId').val().trim();
        obj.flow_id = $("#groupInfoFlowId").val().trim();
        var json_data = JSON.stringify(obj);

        // 체크
        $.ajax({
            url : "<c:url value='/flow/checkFlowExistByGroupId' />"
            , type : "POST"
            , dataType : "json"
            , data : json_data
            , contentType: 'application/json'
            , cache: false
            , async: false
            , success : function(data, status) {

                if (!data.result) { // flow 정보가 있으면 먼저 삭제 요청
                    ret = false;
                    alert("FLOW 정보를 삭제 후 그룹 삭제가 가능합니다.");
                }
            }
            , error : function(){
                //showModal("FLOW 정보 삭제 중 오류가 발생했습니다.");
                alert("FLOW 정보 삭제 중 오류가 발생했습니다.");

            }
        });

        return ret;
    }

    //삭제
    function removeGroupInfo(){

        // flow 정보 등록되었는지 체크
        if (!checkFlowExistByGroupId()){
            return;
        }


        if (!confirm('그룹정보 및 그룹백업정책, FLOW ID정보를 삭제하시겠습니까?')){
            return;
        }

        // 그룹정보
        var groupInfoObj = {};
        groupInfoObj.biz_domain = $('#groupInfoBizDomain').val();
        groupInfoObj.group_id = $('#groupInfoGroupId').val().trim();
        groupInfoObj.switch_type = $('#groupInfoSwitchType').val().trim();
        var json_data = JSON.stringify(groupInfoObj);

        // 삭제
        $.ajax({
            url : "<c:url value='/flow/removeGroupInfo' />"
            , type : "POST"
            , dataType : "json"
            , data : json_data
            , contentType: 'application/json'
            , cache: false
            , success : function(data, status) {

                if(data.result==true) {

                    alert("삭제되었습니다.");

                    // 부모창 목록화면 reload
                    parent.postMessage("groupInfoListReload",location.protocol+'//'+location.host);

                    // 이 모달 창 숨기기
                    $("#groupInfoFormModal").modal('hide');

                } else {
                    alert("삭제 중 오류가 발생하였습니다.");
                }
            }
            , error : function(){
                //showModal("삭제 중 오류가 발생했습니다.");
                alert("삭제 중 오류가 발생했습니다.")
            }
        });
    }


    // 논리시스템 ID 변경이벤트 발생시 처리
    function dataEventLsytemIdChangeHandler(id, val, pv) {

        var rowIndex = id.split('_')[0];
        var primarySystemOptionTag = "";
        var backSystemOptionTag = "";

        SYSTEM_INFO_ARR.forEach(function(d) {
            if(d.system_group == val) {
                primarySystemOptionTag += "<option value='"+d.system_id+"'>"+d.system_id+"</option>";

                if(d.system_id != pv)
                    backSystemOptionTag += "<option value='"+d.system_id+"'>"+d.system_id+"</option>";
            }
        });

        //console.log(primarySystemOptionTag);
        //console.log(backSystemOptionTag);

        $("#"+rowIndex+"_primary_system_id").empty().append(primarySystemOptionTag);
        $("#"+rowIndex+"_backup_system_id").empty().append(backSystemOptionTag);

        //$("#"+rowIndex+"_backup_system_id").val('IPMDAP02');

        dataEventPrimarySytemIdChangeHandler(id, val);
    }

    // Primary system id 변경이벤트 발생시 처리
    function dataEventPrimarySytemIdChangeHandler(id, val) {
        var rowIndex = id.split('_')[0];

        var backSystemOptionTag = "";
        var lSystemId = $("#"+rowIndex+"_system_id").val();
        var primarySystemId = $("#"+rowIndex+"_primary_system_id").val();

        SYSTEM_INFO_ARR.forEach(function(d) {
            if(d.system_group == lSystemId) {
                if(d.system_id != primarySystemId)
                    backSystemOptionTag += "<option value='"+d.system_id+"'>"+d.system_id+"</option>";
            }
        });

        $("#"+rowIndex+"_backup_system_id").empty().append(backSystemOptionTag);
    }


    $(document).ready(function(){

        <c:if test="${'modify' eq mode}">
        var parentGroupInfoGridRowData = $("#groupInfoGrid").getRowData('${row_id}');

        $("#groupInfoFlowId").val(parentGroupInfoGridRowData.flow_id);
        $("#groupInfoBizDomain").val(parentGroupInfoGridRowData.biz_domain);
        $("#groupInfoBizDomain").prop('disabled',true);
        $("#groupInfoGroupId").val(parentGroupInfoGridRowData.group_id);
        $("#groupInfoGroupId").prop('readonly',true);
        $("#groupInfoGroupName").val(parentGroupInfoGridRowData.group_name);
        $("#groupInfoGroupName").prop('readonly',true);
        $("#groupInfoService").val(parentGroupInfoGridRowData.ui_lcl_cd);
        $("#groupInfoServiceType").val(parentGroupInfoGridRowData.ui_mcl_cd);
        $("#groupInfoNwEquipment").val(parentGroupInfoGridRowData.ui_scl_cd);
        $("#groupInfoSwitchType").val(parentGroupInfoGridRowData.switch_type);
        $("#groupInfoDesc").val(parentGroupInfoGridRowData.description);
        $("#groupInfoArrayIndex").val(parentGroupInfoGridRowData.array_index);
        </c:if>

        var logicalIdOptionStr = "";
        var oldStr = "";
        SYSTEM_INFO_ARR.forEach(function(d) {

            if(d.system_group!=oldStr)
                logicalIdOptionStr += ""+d.system_group+":"+d.system_group+";";

            oldStr = d.system_group;
        });
        logicalIdOptionStr = logicalIdOptionStr.replace(/;$/,"");

        var datatype = '';
        var url = '';
        var obj = {};
        <c:choose>
        <c:when test="${'modify' eq mode}">
            obj.group_id = parentGroupInfoGridRowData.group_id;
            url = "<c:url value='/flow/groupBackupPolicyInfoList'/>";
            datatype= "json";
        </c:when>
        <c:otherwise>
            datatype= "local";
        </c:otherwise>
        </c:choose>

        //console.log(obj);

        $("#groupBackupPolicyInfoGrid").jqGrid({
            url : url,
            postData: obj, // json_data,
            datatype : datatype,
            mtype : "post",
            contentType: 'application/json',
            loadtext:"Loading...",
            autowidth: true,
            //width: '300px',
            height: '70px',
            shrinkToFit : false,
            loadonce: false,
            rowNum: 10000,
           // viewrecords: true,
            //scroll:1,
            jsonReader : {
                 root : "groupBackupPolicyInfoList" // 데이터의 시작을 설정
            },
            colNames : [
                        '기본 시스템 ID',
                        'Group ID',
                        'Primary System ID',
                        'Backup System ID'
                       ],
            colModel : [
                        { name : 'system_id',   index:'system_id', width: 150, sortable: false, editable: true, edittype: "select", editoptions: {value: logicalIdOptionStr, dataEvents: [{type: 'change', fn: function(e){dataEventLsytemIdChangeHandler(e.currentTarget.id,$(this).val());}}]}},
                        { name : 'group_id',  index:'group_id',  hidden:true},
                        { name : 'primary_system_id',  index:'primary_system_id', width: 170, sortable: false, editable: true, edittype: "select", editoptions: {value:"1:1;2:2", dataEvents: [{type: 'change', fn: function(e){dataEventPrimarySytemIdChangeHandler(e.currentTarget.id,$(this).val());}}]}},
                        { name : 'backup_system_id',  index:'backup_system_id', width: 170, sortable: false, editable: true, edittype: "select", editoptions: {value:"1:1;2:2"}}
              ],
            multiselect : true,
            addedrow: "last",
            beforeSelectRow: function(rowid, e) {   // 체크박스 선택시에만 체크되게
                return $(e.target).is('input[type=checkbox]');
            },
            onSelectRow: function(id, status){

            },
            onSelectAll: function(ids, status) {

            },
            loadComplete: function(){

                var ids = $(this).jqGrid('getDataIDs');

                // 백업정책 변경건 비교를 위해 배열을 복사해 둠
                //LOADED_BACKUP_POLICY_INFO_ARR = $(this).getGridParam('data');

                for(var i = 0; i < ids.length; i++) {

                    var lsytemId = $(this).jqGrid('getCell',ids[i],'system_id');
                    var primarySystemId = $(this).jqGrid('getCell',ids[i],'primary_system_id');
                    var backupSystemId = $(this).jqGrid('getCell',ids[i],'backup_system_id');


                    $(this).jqGrid('editRow',ids[i],true);
                    dataEventLsytemIdChangeHandler(ids[i], $("#"+ids[i]+"_system_id").val(), primarySystemId);

                    $("#"+ids[i]+"_system_id").val(lsytemId);
                    $("#"+ids[i]+"_primary_system_id").val(primarySystemId);

                    dataEventPrimarySytemIdChangeHandler(ids[i], primarySystemId);

                    $("#"+ids[i]+"_backup_system_id").val(backupSystemId);
                }
            }
        });

        scrollCust();

        $('#groupInfoFormModal').on('hidden.bs.modal', function(e){
            $(this).find("input,select").val('').end();
        });

        setOperationBtn();

        // 로그인 사용자 의 도메인으로 고정됨(관리자는 도메인 선택 가능)
        <c:choose>
        <c:when test="${'ADMIN' eq sessUserInfo.user_group_id}">
            $("#groupInfoBizDomain").attr("disabled", false);
        </c:when>
        <c:otherwise>
            if("${mode}" != "modify")
                $("#groupInfoBizDomain").val("${sessUserInfo.biz_domain}");
            $("#groupInfoBizDomain").attr("disabled", true);
        </c:otherwise>
        </c:choose>

    });
</script>