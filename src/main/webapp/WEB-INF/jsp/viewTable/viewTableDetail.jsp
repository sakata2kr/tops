<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.tops.model.*"%>

<style type="text/css">

    .style-buttonInfoList {
        padding: 10px 15px 10px 5px;
        border-bottom-left-radius: 2px;
        border-bottom-right-radius: 2px;
    }
    
    .style-tableInfoList {
    	margin-right: 15px;
    }
 

</style>

<script>


var PANEL_PAGE_ID = "${pageID}";
var workingMode = "";
var startRow = "${startRow}";
var endRow = "${endRow}";
var pageNum;
var colModels;
var colName;
var beforeRowData;
var beforeJsonData;
var updateResult = false;
var columnList = [];
var columnListSize;


$(document).ready(function()
{
	 $(window).bind('resize',function()
     {
         $("#viewTableGrid").setGridWidth($("#tableInfoListDiv").width() -20);
	 }).trigger('resize');
	scrollCust();
	getTableInfoList(1, 100, 1);
	
});

function getTableInfoList(startRow, endRow, pageNum){

	var obj = {};
    obj.tableName = '${tableName}';
    obj.db = '${db}'; 
    obj.ownerId = '${ownerId}';
    obj.startRow = startRow;
    obj.endRow = endRow;
    
    var json_data = JSON.stringify(obj);
    $.ajax({
        type: "POST",
        url: "<c:url value='/viewTable/viewTableInfo' />",
        data: json_data,
        dataType:'json',
        contentType: 'application/json',
        loadtext:"Retrieve...",
        cache: false,
        success: function(data){
          	$("#viewTableGrid").clearGridData();
            $("#viewTableGrid").setGridParam({  page : pageNum}).trigger("reloadGrid");
            makeGrid(data);
        },
        error: function(){
            showModal("테이블 조회 중 오류가 발생했습니다.");
        },
        timeout : 3000
    });
}

function makeGrid(data)
{
	
    columnList = data.columnList;
    columnListSize = data.columnListSize;
    var columnNames = [];
    columnNames.push("선택");
    for(var i = 0; i <= data.columnListSize - 1; i++){
        columnNames.push(data.columnList[i].columnName);
    }
    var columnModels = [];
    columnModels.push({ name : 'id',  width:40,  align:'center',   formatter: viewTableRadioButton ,  key:true , sortable:false});
    for(var i = 0; i <= data.columnList.length - 1; i++){
    	columnModels.push({ name : data.columnList[i].columnName  ,  index: data.columnList[i].columnName , align:'center', sortable:false, width:40});
    }
    
    $("#viewTableGrid").jqGrid({
	  
      datatype : "local",
      shrinkToFit : true,
      height: 250,
      localReader : {
    	  total : function(){
    		  return data.total;
    		  
    	  }
      },

  	  pager : "#pager",
	  rowNum : -1,
	  loadonce : false,
	  pagination : true,
      cellEdit : true,
      cellsubmit : "clientArray",
      colNames : columnNames,
      colModel : columnModels,
      footerrow : false,
      autowidth : true,
      onCellSelect : function(rowId, iCol, val, e){
    	  
    	  colModels = $(this).getGridParam('colModel');
          colName = colModels[iCol].name;
          var checkedRowId = $(":input:radio[name=viewTableGridRowId]:checked").val();
    	  
    	  if ( workingMode == "Insert" ||  workingMode == "Update")
    	  {
    	      if ( checkedRowId == rowId && colName != "id" )
    	      {
    	    	  $("#viewTableGrid").setColProp(colName, { editable: true });
    	      }
    	      else 
    	      {
    	    	  $("#viewTableGrid").setColProp(colName, { editable: false });
    	      }
    	  }
          else
          {
              $("input:radio[name=viewTableGridRowId]:radio[value="+rowId+"]").prop("checked", true);
              $("#viewTableGrid").setColProp(colName, { editable: false });
          }
      },
      afterEditCell : function(rowId, cellName, value, iRow, iCol){
    	  $("#" + iRow + "_" + cellName).blur(function(){
    	  $("#viewTableGrid").saveCell(iRow, iCol); 
    	  });
      },
      gridview : true,
      userDataOnFooter : false,
      onPaging : function(action){
        pageNum = $("#viewTableGrid").getGridParam("page") ;
		var lastPage = $("#viewTableGrid").getGridParam("lastpage");

        if(action == "next_pager"){
        	++pageNum;
        	endRow = pageNum + '00' ;
        	startRow = endRow - 99;
			getTableInfoList(startRow, endRow, pageNum);        	
    	}
        
    	if(action == "last_pager"){
    		pageNum = lastPage;
    		endRow = pageNum + '00';
    		startRow = endRow - 99;
			getTableInfoList(startRow, endRow, lastPage); 
    	}
    	
    	if(action == "prev_pager"){
    		--pageNum;
    		endRow = pageNum + '00' ;
    		startRow = endRow - 99;
			getTableInfoList(startRow, endRow, pageNum);
        }
    	
    	if(action == "first_pager"){
    		pageNum = 1;
    		endRow = pageNum + '00' ;
    		startRow = endRow - 99;
			getTableInfoList(startRow, endRow, pageNum);
        }
    	
    	if(action == "user"){
    		pageNum = $('.ui-pg-input').val();
    		
    		if(pageNum > data.total){
    		alert('페이지 범위가 올바르지 않습니다.');
    		pageNum = $("#viewTableGrid").getGridParam('page');
    		endRow = pageNum + '00' ;
    		startRow = endRow - 99;
			getTableInfoList(startRow, endRow, pageNum);
    	       return;
    		}

    		endRow = pageNum + '00' ;
    		startRow = endRow - 99;
			getTableInfoList(startRow, endRow, pageNum);
    	}
    	beforeButton();

      }
  });

  $.each(data.grid, function(i, entity)
  {
      $("#viewTableGrid").jqGrid('addRowData', 'ASG'+(i + 1), entity);
  });

}


function tableInsert()
{
  workingMode = "Insert";

  var rowids = jQuery("#viewTableGrid").jqGrid('getDataIDs');
  var newRowId = 'ASG'+(rowids.length + 1);
  var newRows = [];
  for(var i = 0; i <= columnListSize -1 ; i++){
	  newRows.push(columnList[i].columnName);
  }
  var newRowe = new Map();
 	  for(var i = 0; i <= newRows.length -1; i++){
	  newRowe.put(newRows[i], "");
  };  

  $("#viewTableGrid").jqGrid("addRowData",newRowId, newRowe.map ,'first');

  $("input:radio[name=viewTableGridRowId]:radio[value="+newRowId+"]").prop("checked", true);
  $("input:radio[name=viewTableGridRowId]:radio[value="+newRowId+"]").attr("disabled", true);
  $("input[name=viewTableGridRowId]").attr("disabled", true);

  afterButton();
}

function tableUpdate()
{
  
  var rowId = $(":input:radio[name=viewTableGridRowId]:checked").val();
  beforeRowData = $("#viewTableGrid").jqGrid('getRowData', rowId); 
  beforeJsonData = JSON.stringify(beforeRowData); 
  if(rowId)
  {	
	workingMode = "Update";
    $("input[name=viewTableGridRowId]").attr("disabled", true);
    afterButton();
  }
  else
  {
	workingMode = "";
    alert("수정대상을 선택하세요.");
  }

}

function tableSave()
{
  var updateRowData = $("#viewTableGrid").getChangedCells("all");
  
  var updateJsonData = JSON.stringify(updateRowData);
  
  regExp(updateJsonData);
  if(updateResult == false){
	  return;
  }
  
  var sobj = {};

  sobj.tableName = '${tableName}';
  sobj.db   = '${db}';
  sobj.ownerId = '${ownerId}';
  sobj.updateJsonData  = updateJsonData;
  sobj.beforeJsonData  = beforeJsonData; 
  
    var sjson_data = JSON.stringify(sobj);

    if(workingMode == "Insert")
    {
      var url = "<c:url value='/viewTable/viewTableInsert' />";
    }
    else
    {
      var url = "<c:url value='/viewTable/viewTableUpdate' />";
    }
    $.ajax({
        type: "POST",
        url: url,
        data: sjson_data,
        dataType:'json',
        contentType: 'application/json',
        loadtext:"Retrieve...",
        cache: false,
        success: function(data, status){

          if(data.result == true)
          {
              showModal("저장되었습니다.");
              $("#viewTableGrid").clearGridData();
              workingMode = "";
              getTableInfoList(1, 100, 1);
              beforeButton();
          }
          else
          {
            showModal(data.errorMsg);
            $("#viewTableGrid").clearGridData();
            workingMode = "";
            getTableInfoList(1, 100, 1);
            beforeButton();
          }
        },
        error: function(data){
        	
            showModal(data.errorMsg);
            $("#viewTableGrid").clearGridData();
            workingMode = "";
            getTableInfoList(1, 100, 1);
            beforeButton();
        },
        timeout : 3000
    });

}

function tableRemove()
{
  var rowId = $(":input:radio[name=viewTableGridRowId]:checked").val();

  if(rowId)
  {
    if (confirm("정말 삭제하시겠습니까??") == true)
    {
      var rowData = $("#viewTableGrid").jqGrid('getRowData', rowId);  // 선택한 열 정보
      var jsonData = JSON.stringify(rowData);
      var dobj = {};
      dobj.tableName = '${tableName}';
      dobj.db   = '${db}';
      dobj.ownerId   = '${ownerId}';
      dobj.jsonData  = jsonData;

      var djson_data = JSON.stringify(dobj);

      $("input[name=viewTableGridRowId]").attr("disabled", true);
    }
    else
    {
        return;
    }
  }
  else
  {
    alert("삭제대상을 선택하세요.");
    return;
  }

  $.ajax({
        type: "POST",
        url: "<c:url value='/viewTable/viewTableRemove' />",
        data: djson_data,
        dataType:'json',
        contentType: 'application/json',
        loadtext:"Retrieve...",
        cache: false,
        success: function(data, status){
          if(data.result==true)
          {
                     showModal("삭제되었습니다.");
                     $("#viewTableGrid").clearGridData();
                     workingMode = "";
                     getTableInfoList(1, 100, 1);

                 }
          else
          {
            showModal("삭제 중 오류가 발생하였습니다.");
          }
        },
        error: function(){
            showModal("테이블삭제 중 오류가 발생했습니다.");
        },
        timeout : 3000
    });
}

function viewTableRadioButton (cellValue, options, rowdata)
{
    return "<input type='radio' name='viewTableGridRowId' value='"+options.rowId+"' disabled=true />";
}


function tableList() {
    if (confirm("목록 화면으로 이동하시겠습니까?") == false) {
        return;
    }
    goTableList();
}

function goTableList() {
    var _panel = g_pannelMap.get("JP_"+PANEL_PAGE_ID);
    _panel.content.load( "/viewTable/viewTableList?pageID="+PANEL_PAGE_ID);
}

function beforeButton(){
    $("#btn_remove").show();
    $("#btn_update").show();
    $("#btn_add").show();
    $("#btn_save").hide();
}

function afterButton(){
    $("#btn_remove").hide();
    $("#btn_update").hide();
    $("#btn_add").hide();
    $("#btn_save").show();
}

function regExp(inputStr){
	var firstRegExp = /[\:\{\}\[\]\,]/gi;
	var lastRegExp = /[\{\}\[\]\/?.,;:|\)*~`!^\-+<>@\#$%&\\\=\(]/gi;
	var firstStr = inputStr.replace(firstRegExp, "");
	var lastStr = firstStr.replace(lastRegExp, "");
	
	
	if(firstStr != lastStr){
		alert("특수문자는 입력 할 수 없습니다.");
		updateResult = false;
		return updateResult;
	}
	else{
		updateResult = true;
		return updateResult;
	}
}


</script>

<input type="hidden" id="sortColumnId" value=""/>
<input type="hidden" id="sortOrder" value=""/>

<div class="showcase panel-con">
    <div class="showcase-content" id="tableInfoListDiv">
        <div class="style-buttonInfoList">
            <div>
                <div class="btn-r">
					<button type="button" id="btn_add" class="btn btn-search btn_operation" onclick="tableInsert();">추가</button>
					<button type="button" id="btn_update" class="btn btn-search btn_operation" onclick="tableUpdate();">수정</button>
					<button type="button" id="btn_remove" class="btn btn-search btn_operation" onclick="tableRemove();">삭제</button>
					<button type="button" id="btn_save" class="btn btn-search btn_operation" onclick="tableSave();" style="display: none;">저장</button>
					<button type="button" id="btn_close" class="btn btn-search btn_operation" onclick="tableList();">목록</button>
                </div>
            </div>
        </div>
        
        <div class="form-container">
            <div class="style-tableInfoList">
            <!-- grid -->
                <div class="">
                    <table id="viewTableGrid" class="grid"></table>
                </div><!--// grid -->
                    <div id="pager"></div>
            </div>
        </div>
    </div>
</div>
