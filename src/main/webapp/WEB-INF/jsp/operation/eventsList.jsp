<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style type = "text/css" >
    /* Override */
    .ui-jqgrid .ui-jqgrid-bdiv
    { width:100%;
      overflow-x:auto;
    }

</style>

<div id="event_" class="showcase-container">
    <!-- <span class="showcase-title">
        <h5>Events List</h5>
    </span> -->
    <div class="showcase-content">
        <div class="form-content fw75">
            <label for="eventMakeDate">발생일자</label>
            <div class="form-group" style="width: 100px">
                <input type="text" id="eventMakeDate" class="form-control event_datepicker" maxlength=10 onchange="checkDateCondition()"/>
            </div>
        </div>

        <div class="form-content fw75">
            <%--@declare id="form5"--%><%--@declare id="form5"--%><label for="form5">발생시간</label>
                <select id="event_st_startTime" class="selectCust"></select>
                <label for="form5">&nbsp;~ </label>
                <select id="event_st_endTime" class="selectCust"></select>
        </div>

        <div class="form-content">
            <%--@declare id="form5"--%><label for="form5">시스템</label>
            <div class="form-group" style="width: 130px">
                <select id="eventSystem" class="eventType_ms" multiple="multiple">
                <c:forEach var="system" items="${systemList}" varStatus="status">
                    <option value="${system.system_id}" selected="selected">${system.system_id}(${system.system_name})</option>
                </c:forEach>
                </select>
            </div>
        </div>

        <div class="form-content fw75" >
            <%--@declare id="form5"--%><label for="form5">Event 유형</label>
            <div class="form-group" style="width: 200px">
                <select id="eventType" class="eventType_ms" multiple="multiple">
                <c:forEach var="event" items="${eventList}" varStatus="status">
                    <option value="${event.eventType}" selected="selected">${event.description}</option>
                </c:forEach>
                </select>
            </div>
        </div>

        <button type="button" class="btn btn-search" onclick="selectEventLogOutputList()">  조회</button>
    </div>
    <div class="table-responsive mT20">
        <table id="eventLogOutputGrid" class="grid gridH8"></table>
    </div><!--// grid -->
</div>

<script>
    $(document).ready(function()
    {
        mSelect('eventType_ms');
        dateP('event_datepicker');

        initEventLogForm();
        selectEventLogOutputList();
        selectCust();

        setOperationBtn();
    });

    function initEventLogForm()
    {
        var currDate   = new Date();
        //var dayOfMonth = currDate.getDate();
        //currDate.setDate(dayOfMonth -1);  // 전일자 기준으로 날짜를 구성

        var baseYear   = currDate.getFullYear();
        var baseMonth  = pad(currDate.getMonth() +1, 2);
        var baseDay    = pad(currDate.getDate(), 2);

        $('#eventMakeDate').val(baseYear + '-' + baseMonth + '-' + baseDay);

        var selStaHour = "";
        var selEndHour = "";
        var stHtml = "";
        var edHtml = "";

        for(var i = 0; i < 24; i++)
        {
            // 발생시간 조회의 기본 설정은 현재 시간 기준 부터
            if(pad(currDate.getHours(), 2) == pad(i, 2))
            {
                selStaHour = "selected";
            }
            else
            {
                selStaHour = "";
            }

            // 발생시간 조회의 기본 설정은 현재 일자의 마지막 시간 까지 (23시)
            if (i == 23 )
            {
                endStaHour = "selected";
            }
            else
            {
                endStaHour = "";
            }

            stHtml += "<option value='" + pad(i, 2) + "' " + selStaHour + ">" + pad(i, 2) + "시</option>";
            edHtml += "<option value='" + pad(i, 2) + "' " + endStaHour + ">" + pad(i, 2) + "시</option>";
        }

        $('#event_st_startTime').html(stHtml);
        $('#event_st_endTime').html(edHtml);
        $("#event_st_endTime option:eq(23)").attr("selected", "selected");
    }

    function pad(n, width, z)
    {
        z = z || '0';
        n = n+'';
        return n.length >= width ? n : new Array(width - n.length + 1).join(z) + n;
    }

    function checkDateCondition()
    {
        if($("#eventMakeDate").val() == "")
        {
            alert("조회 일자를 입력하세요.");
            return false;
        }
        else if ( !jsDayCheck($("#eventMakeDate")) )
        {
            return false;
        }
        return true;
    }

    function selectEventLogOutputList()
    {
        if ( !checkDateCondition() ) return false;

        var st_time  = parseInt($('#event_st_startTime').val(), 10);
        var end_time = parseInt($('#event_st_endTime').val(), 10);

        if(st_time > end_time)
        {
            alert("조회 시작 시간은 조회 종료 시간보다 작거나 같아야 합니다.");
            return false;
        }

        var obj = {};
        obj.eventType = $('#eventType').val();
        obj.eventSystems = $("#eventSystem").val();
        obj.eventStartTimeStamp = replaceAll($('#eventMakeDate').val(), '-', '') + $('#event_st_startTime').val() + '0000';
        obj.eventEndTimeStamp = replaceAll($('#eventMakeDate').val(), '-', '') + $('#event_st_endTime').val() + '5959';
        var json_data = JSON.stringify(obj);

        var spinObj = startSpin('event_');
        $.ajax({ type: "POST"
        	   , url: "<c:url value='/operation/retrieveEventsLog' />"
        	   , data: json_data
        	   , dataType:'json'
        	   , contentType: 'application/json'
        	   , loadtext:"로딩 중..."
        	   , cache: false
        	   , success: function(data)
        	     {
                     makeEventLogOutputGrid(data.grid);
                     stopSpin(spinObj);
                 }
        	   , error: function()
        	     {
                     stopSpin(spinObj);
                     showModal("이벤트 조회 중 오류가 발생했습니다.");
                 }
               , timeout : 3000
               });
    }

    function makeEventLogOutputGrid(gridList)
    {
        $("#eventLogOutputGrid").jqGrid({ datatype : "local"
        	                            , autowidth: true
        	                            , shrinkToFit : false
        	                            , height: 250
        	                            , rowNum : 100000000
        	                            , colNames : [ '이벤트ID'
        	                            	         , '이벤트 유형'
        	                            	         , '이벤트 내역'
        	                            	         , '대상 시스템'
        	                            	         , '실제 시스템'
        	                            	         , 'Group ID'
        	                            	         , 'BP ID'
        	                            	         , 'BM ID'
        	                            	         , '발생시간'
                                                     ]
                                        , colModel : [ { name : 'event_id',     width:71,  sorttype : "int",    align:'center' }
                                                     , { name : 'event_name',   width:121, sorttype : "string", align:'left'   }
                                                     , { name : 'message',      width:251, sorttype : "string", align:'left'   }
                                                     , { name : 'op_system_id', width:90,  sorttype : "string", align:'center' }
                                                     , { name : 'system_id',    width:90,  sorttype : "string", align:'center' }
                                                     , { name : 'group_id',     width:61,  sorttype : "string", align:'center' }
                                                     , { name : 'bp_id',        width:61,  sorttype : "string", align:'center' }
                                                     , { name : 'bm_id',        width:61,  sorttype : "string", align:'center' }
                                                     , { name : 'event_time',   width:100, sorttype : "string", align:'center' }
                                                     ]
                                        });

        $("#eventLogOutputGrid").clearGridData();

        if ( gridList != null && gridList.length > 0 )
        {
            for(var i = 0; i < gridList.length; i++ )
            {
                $("#eventLogOutputGrid").jqGrid('addRowData', 'EVTLOGOUTPUT_'+(i + 1), gridList[i]);
            }
        }
        else
        {
            $("#eventLogOutputGrid").jqGrid('addRowData', 'EVTLOGOUTPUT_0', {event_id:"조회 내용이 없습니다."});

            for(var i = 0; i < $('#EVTLOGOUTPUT_0 td').length; i++)
            {
                if(i == 0)
                {
                    $('#EVTLOGOUTPUT_0 td:eq(' + i + ')').attr('colspan', $('#EVTLOGOUTPUT_0 td').length);
                }
                else
                {
                    $('#EVTLOGOUTPUT_0 td:eq(' + i + ')').hide();
                }
            }
        }
    }
</script>