<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<div class="modal-dialog">
    <div class="modal-content">
        <div class="modal-header">
            <a data-dismiss="modal" href="#none" class="close-w"><img src="<c:url value='/resources/img/icon/x_btn.png'/>" /></a>
            <h4 class="modal-title">MENU 리소스 선택</h4>
        </div>
        <div class="modal-body">
            <div class="modal-cust-con02">
                <div class="showcase panel-con panel-rn">
                    <div class="showcase-content">
                        <div class="com-01">
                            <div>
                                <div class="showcase-select mR5">
                                    <select id="searchOption" class="form-control" style="width:100px;">
                                        <option value="01">리소스명</option>
                                        <option value="02">리소스경로</option>
                                    </select>
                                </div>
                                <div class="showcase-select mR5">
                                    <input type="text" id="searchWord" class="form-control" maxlength="100" value="" />
                                </div>
                                <div class="showcase-select">
                                    <button type="button" class="btn btn-search" onclick="menuResourceInfoList();" style="width:50px;">조회</button>
                                </div>
                            </div>
                        </div>
                        <br>
                        <div class="table-responsive mT20">
                            <table id="menuResourceInfoGrid" class="grid"></table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-search w25 btn_operation" onclick="selectMenuInfoResourceInfo();">선택</button>
            <button type="button" class="btn btn-search w25" data-dismiss="modal">닫기</button>
        </div>
    </div><!-- /.modal-content -->
</div><!-- /.modal-dialog -->
<script>
    var obj = null;
    var json_data = null;

    $(document).ready(function()
    {
        scrollCust();
        setOperationBtn();
        getMenuResList();
    });

    // 조회 Input 박스 엔터 시 조회 기능 추가
    $("#searchWord").keydown(function(e)
    {
        if(e.keyCode == 13)
        {
        	getMenuResList();
        }
    });

    function getMenuResList()
    {
    	obj = {};
        obj.searchOption = $("#searchOption").val();
        obj.searchWord   = $("#searchWord").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
        $("#searchWord").val(obj.searchWord);
        json_data = JSON.stringify(obj);

        $.ajax({ type : "POST"
               , url : "<c:url value='/auth/menuResourceInfoList'/>"
               , data : json_data
               , dataType : "json"
               , contentType : 'application/json'
               , loadtext : "로딩 중..."
               , cache : false
               , success : function(data)
                 {
                     makeMenuResGrid(data.menuResourceInfoList);
                 }
               , error: function()
                 {
                     showModal("메뉴 리소스 조회 중 오류가 발생했습니다.");
                 }
               });
    }

    function makeMenuResGrid(gridList)
    {
        $("#menuResourceInfoGrid").jqGrid({ datatype : "local"
                                          , loadtext:"Loading..."
                                          , autowidth: true
                                          , height: '200px'
                                          , shrinkToFit : true
                                          , loadonce: false
                                          , rowNum: 100000
                                          , colNames : [ '선택'
                                                       , '리소스ID'
                                                       , '리소스명'
                                                       , '리소스경로'
                                                       ]
                                          , colModel : [ { name : 'id',            width:20,    formatter: returnMenuResourceInfoRadioButton, align:'center', sortable: false }
                                                       , { name : 'resource_id',   hidden:true, index:'resource_id',   sortable : false }
                                                       , { name : 'resource_name', width:120,   index:'resource_name', sorttype : "string", align:'left' }
                                                       , { name : 'resource_path', width:200,   index:'resource_path', sorttype : "string", align:'left' }
                                                       ]
                                          , onSelectRow: function(id, status)
                                            {
                                                $("input:radio[name='menuResourceGridRowId']:radio[value='"+id+"']").prop('checked',true);
                                            }
                                          , loadComplete: function ()
                                            {
                                                var requestMenuResourceId = '${menuResourceId}';

                                                if ( requestMenuResourceId != '' )
                                                {
                                                    var rowIds = $(this).jqGrid('getDataIDs');
                                                    var rowData;
                                                    for (var i = 1; i <= rowIds.length; i++)
                                                    {
                                                        rowData = $(this).jqGrid('getRowData', i);

                                                        if ( rowData['resource_id'] == requestMenuResourceId )
                                                        {
                                                            $("input:radio[name='menuResourceGridRowId']:radio[value='" + i + "']").prop('checked', true);
                                                            $("input:radio[name='menuResourceGridRowId']:radio[value='" + i + "']").focus();
                                                            $("input:radio[name='menuResourceGridRowId']:radio[value='" + i + "']").blur();
                                                        }
                                                    }
                                                }
                                            }
                                          });

        if ( gridList.length > 0 )
        {
            for ( var i = 0; i < gridList.length; i++ )
            {
                $("#menuResourceInfoGrid").jqGrid('addRowData', 'MRI_'+(i + 1), gridList[i]);
            }
        }
    }

    function menuResourceInfoList()
    {
        $("#menuResourceInfoGrid").clearGridData();
        getMenuResList();
    }

    //메뉴 리소스 선택
    function selectMenuInfoResourceInfo()
    {
        var selectedRowId = $(":radio[name='menuResourceGridRowId']:checked").val();
        if(selectedRowId == undefined)
        {
            alert('리소스를 선택해 주세요.');
            return;
        }

        var postMsgStr = $("#menuResourceInfoGrid").getRowData(selectedRowId).resource_id + "|" + $("#menuResourceInfoGrid").getRowData(selectedRowId).resource_name;

        // 부모창 리소스 정보 send
        parent.postMessage(postMsgStr, location.protocol + '//' + location.host);

        // 이 모달 창 숨기기
        $("#formModal").modal('hide');
    }

    function returnMenuResourceInfoRadioButton(cellValue, options, rowdata, action)
    {
        return "<input type='radio' name='menuResourceGridRowId' value='" + options.rowId + "'/>";
    }
</script>