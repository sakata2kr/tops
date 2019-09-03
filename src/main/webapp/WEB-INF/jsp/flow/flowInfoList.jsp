<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.tops.model.*" %>

<style type="text/css">

    .style-flowInfoList
    { padding: 10px 15px 10px 5px;
      border-bottom-left-radius: 2px;
      border-bottom-right-radius: 2px;
    }

    .modal.fade:not(.in).left .modal-dialog
    { -webkit-transform: translate3d(-50%, 0, 0);
      transform: translate3d(-50%, 0, 0);
    }

</style>

<div class="showcase panel-con">
    <div class="showcase-content" id="flowInfoListDiv">

        <div class="style-flowInfoList">

            <div class="showcase-select mR5">
                <span>그룹명</span>
                <input type="text" id="group_name" class="form-control" value="" style="width:200px;" />
            </div>
            <div class="showcase-select">
                <button type="button" class="btn btn-search" onclick="refreshGrid()" style="width:50px;">검색</button>
            </div>

            <div>
                <div class="btn-r">
<!-- 20180510 Flow 및 GROUP 정보 등록은 일단 막고, 검색 기능을 추가
                    <button type="button" class="btn btn-search btn_operation" onclick="popupGroupInfoRegisterForm();">등록</button>
                    <button type="button" class="btn btn-search btn_operation" onclick="popupGroupInfoModifyForm();">수정</button>
-->
                    <button type="button" class="btn btn-search btn_operation" onclick="popupFlowRegisterForm();">FlowDesign</button>
                </div>
            </div>

        </div>

        <div class="form-container">
            <div class="com-01 mT5">
                <div>
                    <table id="flowInfoGrid" class='gridH7'></table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    mSelect('th_ms');

    var PANEL_PAGE_ID = "${pageID}";
    var TARGET_ROW_ID = "";

    $(document).ready(function()
    {
        //$(".panel-body").css("overflow", "hidden");

        // 패널 resize 시 그리드 resize
        $(window).bind('resize',function()
        {
            $("#flowInfoGrid").setGridWidth($("#flowInfoListDiv").width() -20);
        }).trigger('resize');

        scrollCust();
        setOperationBtn();
        getFlowInfoList();
    });

    function getFlowInfoList()
    {
        var obj = {};
        obj.group_name = $("#group_name").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
        $("#group_name").val(obj.group_name);
        json_data = JSON.stringify(obj);

        $.ajax({ type : "POST"
               , url : "<c:url value='/flow/flowInfoList'/>"
               , data : json_data
               , dataType : "json"
               , contentType : 'application/json'
               , loadtext : "로딩 중..."
               , cache : false
               , success : function(data)
                 {
            	     makeFlowGrid(data.flowInfoList);
                 }
               , error: function()
                 {
                     showModal("FLOW 정보 조회 중 오류가 발생했습니다.");
                 }
               });
    }

    function makeFlowGrid(gridList)
    {
        $("#flowInfoGrid").jqGrid({ datatype : "local"
                                  , loadtext:"Loading..."
                                  , autowidth: true
                                  , shrinkToFit : true
                                  , loadonce: false
                                  , scroll : true
                                  , height:200
                                  , rowNum: 10000
                                  , colNames : [ '선택'
                                               , 'Flow ID'
                                               , 'Flow 명'
                                               , '그룹 대분류'
                                               , '그룹 중분류'
                                               , '그룹ID'
                                               , '그룹명'
                                               , '비고'
                                               , '그룹 대분류ID'
                                               , '그룹 중분류ID'
                                               ]
                                  , colModel : [ { name : 'id', width:50,  align:'center', sortable: false, formatter: returnRadioButton}
                                               , { name : 'flow_id',         index:'flow_id',         width:80,  align:'center'}
                                               , { name : 'flow_name',       index:'flow_name',       width:80,  align:'center'}
                                               , { name : 'group_ctg1_name', index:'group_ctg1_name', width:80,  align:'center'}
                                               , { name : 'group_ctg2_name', index:'group_ctg2_name', width:80,  align:'center'}
                                               , { name : 'group_id',        index:'group_id',        width:50,  align:'center'}
                                               , { name : 'group_name',      index:'group_name',      width:100, align:'center'}
                                               , { name : 'description',     index:'description',     width:80,  align:'center', sortable:false}
                                               , { name : 'group_ctg1_cd', hidden:true, index:'group_ctg1_cd', sortable : false }
                                               , { name : 'group_ctg2_cd', hidden:true, index:'group_ctg2_cd', sortable : false }
                                               ]
                                   , loadComplete: function()
                                     {
                                         $("#flowInfoGrid").setGridWidth($("#flowInfoListDiv").width()-20);
                                         $("#flowInfoGrid").setGridHeight("100%");

                                     }
                                   , onSelectRow: function(id, status)
                                     {
                                         $('#flowInfoId'+id).prop('checked', true);
                                         selectFlowInfoUid(id);
                                     }
                                   });

        if ( gridList.length > 0 )
        {
            for ( var i = 0; i < gridList.length; i++ )
            {
                $("#flowInfoGrid").jqGrid('addRowData', 'FIG_'+(i + 1), gridList[i]);
            }
        }
    }

    function refreshGrid()
    {
        $("#flowInfoGrid").clearGridData();
        getFlowInfoList();
    }

    //모달창으로부터 데이터를 받기위한 부분
    window.onmessage = function(e)
    {
        if ( e.data == "groupInfoListReload")
        {
            groupInfoList();
            var _panel = g_pannelMap.get("JP_" + PANEL_PAGE_ID);
            _panel.css('display', '');
        }
        else
        {
            // flowdesign으로 넘기는 값은 flowid입력창에서 가져온다.
            goFlowDesign(e.data);
        }
    };

    //그룹정보 등록창
    function popupGroupInfoRegisterForm()
    {
        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({ backdrop : 'static',remote: '/flow/groupInfoRegisterForm'});
    }

    //그룹정보 수정창
    function popupGroupInfoModifyForm()
    {
        if ( TARGET_ROW_ID == "" )
        {
            alert("수정할 그룹정보를 선택해 주세요.");
            return;
        }

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({ backdrop : 'static'
        	                  , remote: '/flow/groupInfoModifyForm?row_id=' + TARGET_ROW_ID + '&group_id=' + $("#flowInfoGrid").getRowData(TARGET_ROW_ID).group_id
        	                  });
    }

    //FLOW ID 정보 등록창
    function popupFlowRegisterForm()
    {
        if ( TARGET_ROW_ID == "" )
        {
            alert("조회할 그룹정보를 선택해 주세요.");
            return;
        }

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        // 패널 숨기기
        var _panel = g_pannelMap.get("JP_" + PANEL_PAGE_ID);
        _panel.css('display', 'none');

        var flowDesignUrl = "/flow/flowDesign?flow_id=" + $("#flowInfoGrid").getRowData(TARGET_ROW_ID).flow_id
        		          + "&group_id=" + $("#flowInfoGrid").getRowData(TARGET_ROW_ID).group_id
        		          + "&system_id=" +$("#flowInfoGrid").getRowData(TARGET_ROW_ID).system_id
                          ;

        // 패널내에서 url 이동
        var _panel = g_pannelMap.get("JP_" + PANEL_PAGE_ID);
        _panel.content.load(flowDesignUrl,'',function(){ _panel.css('display', ''); });
    }

    // 그룹정보 조회
    function groupInfoList()
    {
        $("#flowInfoGrid").clearGridData();

        var postData = {};

        $("#flowInfoGrid").jqGrid('setGridParam', {'postData' : postData}).trigger('reloadGrid');
    }

    // 선택한 그룹정보 grid row id를 저장(그룹정보 수정창, flow정보 등록창 오픈시 사용)
    function selectFlowInfoUid(rowId, groupId)
    {

        TARGET_ROW_ID = rowId;
    }

    function returnRadioButton(cellValue, options, rowdata, action)
    {

        return "<input type='radio' name='id' id='flowInfoId" + options.rowId + "' onclick=selectFlowInfoUid('" + options.rowId + "') />";
    }
</script>