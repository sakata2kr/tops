<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.tops.model.*" %>
<%@ page import="java.util.List" %>
<style type="text/css">

    .com-02-systemInfo {
padding: 10px 15px 10px 5px;
border-bottom-left-radius: 2px;
border-bottom-right-radius: 2px;
}


div.showcase-select > label {
float: left;
margin-right: 4px;
font-weight: normal;
}

</style>
<script>
mSelect('th_ms');

//시스템정보 등록창
function popupSystemInfoRegisterForm(){

    $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

    $("#formModal").modal({
        backdrop : 'static',
        remote: '/operation/systemInfoRegisterForm'
    });
}


//시스템정보 수정창
function popupSystemInfoModifyForm(bizDomain, systemId){

    $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

    $("#formModal").modal({
        backdrop : 'static',
        remote: '/operation/systemInfoModifyForm?biz_domain='+bizDomain+'&system_id='+systemId
    });
}

function returnHyperLink(cellValue, options, rowdata, action){

    return "<a onclick=\"popupSystemInfoModifyForm('"+rowdata.biz_domain+"','"+rowdata.system_id+"');\" style='color:#0094C8;' >"+cellValue+"</a>";
}

//모달창으로 부터데이터를 받기위한 부분
window.onmessage = function(e) {
    if(e.data=="systemInfoListReload") {
        systemInfoList();
    }
};

// 시스템정보 조회
function systemInfoList(){

    $("#systemInfoGrid").clearGridData();

    var obj = {};
    obj.system_groups = JSON.stringify($("#COMBO_UI13").val()).replace(/"|\]|\[/gi,""); // 시스템그룹

    $("#systemInfoGrid").jqGrid('setGridParam', {'postData' : obj}).trigger('reloadGrid');

}


$(document).ready(function(){

    $(window).bind('resize',function(){
        $("#systemInfoGrid").setGridWidth($("#systemInfoListDiv").width()-20);
    }).trigger('resize');

    var lastsel = '';
    var obj = {};
    obj.system_groups = JSON.stringify($("#COMBO_UI13").val()).replace(/"|\]|\[/gi,""); // 시스템그룹

    //console.log(obj);

    $("#systemInfoGrid").jqGrid({
        url : "<c:url value='/operation/systemInfoList'/>",
        postData: obj, // json_data,
        datatype : "json",
        mtype : "post",
        contentType: 'application/json',
        loadtext:"Loading...",
        autowidth: true,
        height: 'auto',
        shrinkToFit : true,
        loadonce: false,
        viewrecords: true,
        rowNum: 10000,
        //scroll:1,
        jsonReader : {
             root : "systemInfoList" // 데이터의 시작을 설정
        },
        colNames : [
                    '도메인',
                    '시스템ID',
                    'system_group',
                    '시스템그룹',
                    '시스템명',
                    '설명',
                    '일련번호'
                    ],
        colModel : [
                    { name : 'biz_domain',  index:'biz_domain', width:100,  align:'center'},
                    { name : 'system_id',  index:'system_id',  width:100,  align:'center', classes:'thisHyperLink_sys', formatter:returnHyperLink},
                    { name : 'system_group',  index:'system_group',  hidden:true},
                    { name : 'system_group_name',  index:'system_group_name',  width:100,  align:'center'},
                    { name : 'system_name',  index:'system_name',  width:100,  align:'center'},
                    { name : 'description',  index:'description',  width:100,  align:'center'},
                    { name : 'sequence',  index:'sequence',  sorttype:'int', width:100,  align:'center'}
          ],
        onSortCol : function(index, iCol, sortOrder){

            $("#systemInfoGrid").setGridParam({datatype:'local', loadonce : true});
            var obj =$("#systemInfoGrid").jqGrid('getRowData');

            // a 태그 텍스트만 추출
            var pattern = /<[^>]+>/g;
            for(var i = 0 ; i < obj.length; i++)
                obj[i].system_id = obj[i].system_id.replace(pattern,'');

            obj = sortByKey(obj, index);

            $("#systemInfoGrid").clearGridData();
            $("#systemInfoGrid").setGridParam({data : obj}).trigger('reloadGrid');
            $("#systemInfoGrid").setGridParam({datatype: 'json', loadonce: false});

            return 'stop';
        }//,
        //onSelectRow: function(id, status){
            //$(this).checked();
        //  console.log(id);


        //}
    });

    //scrollCust();
    setOperationBtn();
});

</script>

<!-- 프로세스 처리 현황  load 시작 -->
<div id="${operationInfo.pageID}" class="showcase panel-con ${operationInfo.pageID}">
    <c:set var="COMBO_UI13"  scope="page" />
    <div class="showcase-content" id="systemInfoListDiv">

        <div class="com-02-systemInfo">
                        <div>
                                <div class="showcase-select mR5">
                                    <%--@declare id="form5"--%><label for="form5">시스템그룹</label>
                                </div>
                                <div class="showcase-select mR5" style="width:150px;">
                                    <select id="COMBO_UI13" class="th_ms" multiple="multiple">
                                        <c:forEach var="code" items="${COMBO_UI13}" varStatus="status">
                                            <c:if test="${code.code != 'ALL'}">
                                                <option value="<c:out value="${code.code}"/>" selected><c:out value="${code.code_name}"/></option>
                                            </c:if>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="showcase-select">
                                    <button id="btnSearch" type="button" class="btn btn-search" onclick="systemInfoList()" style="width:50px;">조회</button>
                                </div>
                                    <div class="btn-r">
                                        <button type="button" class="btn btn-search btn_operation" onclick="popupSystemInfoRegisterForm();">시스템등록</button>
                                    </div>
                            </div>
        </div>

        <div  class="form-container">
            <div class="com-01 mT5">
            <!-- grid -->

                <div class="">
                    <table id="systemInfoGrid" class="gridH8"></table>
                    <!-- div id="pager"></div -->
                </div><!--// grid -->
            </div>
        </div>
    </div>
</div>
