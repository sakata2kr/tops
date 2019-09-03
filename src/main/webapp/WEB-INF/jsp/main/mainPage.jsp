<%@ page pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<script>

var tempData = [];          // 패널 타이틀 배열
var menuLinkInfoObj = null; // 메뉴연결정보(패널link url, 패널 title)를 저장할 object
var g_operationYn = "${operationYn}";
var g_alert_receive_yn  = "${alert_receive_yn}";
var g_pannelMap = new Map();

var eventCnt = 0;
var eventRecvData = null;
var alertInterval = null;

var socket = null;
var stompClient  = null;
var stompConn = {};

$(document).ready(function()
{
    checkSession();
    connect();
    <c:if test="${not empty bookmarkList}">
        setTimeout(function()
        {
            loadBookmark();
        }, 1000);
    </c:if>

    // 메뉴정보를 이용 패널 타이틀 배열 생성
    for(var i = 0; i < userMenuArr.length; i++)
    {
        if(userMenuArr[i]['resource_path'] !== '')
        {
            menuLinkInfoObj = {};
            menuLinkInfoObj.nm = userMenuArr[i]['resource_path'];
            menuLinkInfoObj.tit = userMenuArr[i]['menu_name'];
            tempData.push(menuLinkInfoObj);
        }
    }

    $( ".event-msg-area" ).on( "click", function()
    {
        $('.noti span').remove();

        $('.event-msg').hide();
    });
});

Dashboard.prototype.length = 0;
Dashboard.prototype =
    { panel :1
    , set : function(mode, action){ }
    , add : function(info, param) {
        //최대8개로 제한
        if(g_pannelMap.keys().length === 8)
        {
            alert('최대갯수 8개를 초과할수없습니다.');
            return;
        }
        var obj = this.objSet(info, param);
        this.call(obj, param);
    }
    , objSet : function(info, param) {
        var _tit;
        var _left = null;
        var _right = null;

        for (var p = 0; p < tempData.length; p++)
        {
            if (tempData[p].nm === info)
            {
                _tit = tempData[p].tit;
                tempData[p].id =param.pageID;
            }
        }

        if((g_pannelMap.keys().length +1) % 2 === 0)
        {
            _right = 30;
        }
        else
        {
            _left = 30;
        }

        var _top = 55;
        _top += Math.floor(g_pannelMap.keys().length / 2) * 350;

        if (typeof info === 'string')
        {
            var obj =
                    { id : param.pageID
                    , nm : info
                    , tit : _tit
                    , url : info
                    , top : _top
                    , left : _left
                    , right : _right
                    };
        }

        this.panel++;
        return obj;
    }
    , call : function(info, paramObj) {

        var param = "pageID=" + paramObj.pageID;

        var win_with = $(window).width();

        // 스크롤바가 나타난 이후 창 배치 및 크기가 일정하지 않게 되는 문제 해결을 위한 창가로길이보정 변수값 초기화
        var correctionWindowWidth = ($(document).height() > $(window).height()) ? 17 : 0;

        if(win_with <= 1024)
        {
            if(info.left !== null)
            {
                info.left = info.left /5;
            }

            // Work around for rendering bug in IE
            if(info.right !== null)
            {
                info.right = info.right;
            }

            var _panel = $( 'body' ).jsPanel({
                title : info.tit
              , resizable : { disabled: false }
              , overflow : { horizontal: 'scroll', vertical: 'scroll' }
              , size : { width:  490, height: 305 }
              , position : { top: info.top, left: info.left, right:info.right - correctionWindowWidth }
              , ajax : {
                    url : "<c:url value='/"+info.nm+"' />?"+param
                  , cache : false
                }
                , id : "JP_"+paramObj.pageID
              });

            g_pannelMap.put('JP_'+paramObj.pageID, _panel);
        }
        else
        {
            var _panel = $( 'body' ).jsPanel({
                title : info.tit
              , resizable : { disabled: false }
              , overflow : { horizontal: 'scroll', vertical: 'scroll' }
              , size : { width : function(){return ($(window).width() + correctionWindowWidth)/2-50 }, height : 305 }
              , position : { top: info.top, left: info.left, right:info.right - correctionWindowWidth }
              , ajax : {
                    url: "<c:url value='/"+info.nm+"' />?"+param
                  , cache: false
                  , done : function()
                    {
                        //pannel 크기에 따른 그리드 리사이징처리
                        _panel.on('resize', function()
                        {
                            var width = $(this).width();
                            var height = $(this).height();

                            if($("#JP_"+paramObj.pageID).find(".grid").length > 0)
                            {
                                $("#JP_"+paramObj.pageID).find(".grid").setGridWidth(width-32, true);
                                if(height > 305)
                                {
                                    $("#JP_"+paramObj.pageID).find(".grid").setGridHeight(height*0.6, true);
                                }
                                else
                                {
                                    $("#JP_"+paramObj.pageID).find(".grid").setGridHeight(250, true);
                                }
                            }

                            if($("#JP_"+paramObj.pageID).find(".gridH6").length > 0)
                            {
                                if(height > 305)
                                {
                                    $("#JP_"+paramObj.pageID).find(".gridH6").setGridHeight(height*0.6, true);
                                }
                                else
                                {
                                    $("#JP_"+paramObj.pageID).find(".gridH6").setGridHeight(250, true);
                                }
                            }

                            if($("#JP_"+paramObj.pageID).find(".gridH7").length > 0)
                            {
                                if(height > 305)
                                {
                                    $("#JP_"+paramObj.pageID).find(".gridH7").setGridHeight(height*0.7, true);
                                }
                                else
                                {
                                    $("#JP_"+paramObj.pageID).find(".gridH7").setGridHeight(250, true);
                                }
                            }

                            if($("#JP_"+paramObj.pageID).find(".gridH8").length > 0)
                            {
                                if(height > 305)
                                {
                                    $("#JP_"+paramObj.pageID).find(".gridH8").setGridHeight(height*0.8, true);
                                }
                                else
                                {
                                    $("#JP_"+paramObj.pageID).find(".gridH8").setGridHeight(250, true);
                                }
                            }

                            //operation여부에 따른 버튼 제어
                            if(g_operationYn != "Y")
                            {
                                $("#JP_"+paramObj.pageID).find(".btn_operation").hide();
                            }

                        }).trigger('resize');
                    }
                }
              , id : "JP_"+paramObj.pageID
            });

            g_pannelMap.put('JP_'+paramObj.pageID, _panel);
        }
    }
    , fixed : function(arg)  { return; }
    , center : function(arg) { return; }
    , alignAll : function() {
            var keys = g_pannelMap.keys();
            var top = 55;
            var twidth = $(window).width()/2-50;

            for(var i = 0; i < keys.length; i++)
            {
                var jpObj = g_pannelMap.get(keys[i]);

                if(jpObj.hasClass("minimized")) { continue; }

                if(i %2 > 0)
                {
                    jpObj.width(twidth + 'px');
                    jpObj.height('337px');
                    jpObj.css('top', top + 'px');
                    jpObj.css('right', '30px');
                    jpObj.css('left', '');
                }
                else
                {
                    if(i > 1) { top += 350;}

                    jpObj.width(twidth+'px');
                    jpObj.height('337px');
                    jpObj.css('top', top + 'px');
                    jpObj.css('right', '');
                    jpObj.css('left', '30px');
                }
            }
        }
    , align : function(menu_id, width, height, top, right, left) {
            var jpObj = g_pannelMap.get('JP_'+menu_id);
            jpObj.width(width);
            jpObj.height(height);
            jpObj.css('top', top);
            jpObj.css('right', right);
            jpObj.css('left', left);
      }
    };

function Dashboard(){ this.resize = false; }

(function($) {
    $.fn.hasScrollBar = function()
    {
        return this.get(0) ? this.get(0).scrollHeight > this.innerHeight() : false;
    }
})(jQuery);

function checkSession()
{
    if("${sessUserInfo.user_id}" == "")
    {
        alert("로그인페이지로 이동합니다.");
        document.location.href = "<c:url value='/login' />";
    }
}

function loadBookmark()
{
    <c:forEach var="bookmarkList" items="${bookmarkList}" varStatus="status">

    var __url = '${bookmarkList.resourcePath}';
    var panelId = 'JP_${bookmarkList.menuId}';
    __url = __url.substring(1, __url.length);
    menuClick(__url, '', '${bookmarkList.menuId}');
    var imgObj = $('#'+panelId).find('a')[1];

    showCase.proc(imgObj, 'favorites');
    new Dashboard().align('${bookmarkList.menuId}',
        '${bookmarkList.screenWidth}',
        '${bookmarkList.screenHeight}',
        '${bookmarkList.screenTop}',
        '${bookmarkList.screenRight}',
        '${bookmarkList.screenLeft}');
    </c:forEach>
}

function connect()
{
	socket = new SockJS("/sockJS");
	stompClient = Stomp.over(socket);

	stompClient.connect({}, function(){
        // 접속 성공 시
		stompClient.subscribe("/stomp/alarm", function(msg){onMessage(msg);});
	    }, function(){
        // 접속 실패 시
        // setTimeout(function(){connect();}, 3000);
        alert("내부 소켓 연동 오류로 재접속이 필요합니다.");
        document.location.href = "<c:url value='/login' />";
	});

	stompClient.debug = null
}

function onMessage(msg)
{
	// alert 수신여부가 Y이면서 수신 alert가 존재하는 경우
    if ( g_alert_receive_yn == 'Y' && msg.body != null )
    {
        if (alertInterval != null)
        {
            clearInterval(alertInterval);
        }

        eventRecvData = JSON.parse(msg.body);

        if (eventRecvData.jsonData != null)
        {
            switch ( eventRecvData.procType )
            {
                case "pushEventAlert" :
                    eventCnt++;

                    // Event 알람창 반복 호출
                  	alertInterval = setInterval(function(){eventAlertPolling(eventRecvData.jsonData)}, 2000);
                    break;

                default :
                    break;
            }
        }
    }
}

// STOMP connect 해제 요청 시
function disconnect()
{
    if (stompClient != null)
    {
    	stompClient.disconnect();
    }
}

function eventAlertPolling(eventInfo)
{
    if (eventInfo != null)
    {
        //상단 종모양아이콘의 미확인이벤트 갯수 처리
        if ( $('.noti span').length > 0 )
        {
            $('.noti span').text(eventCnt);
        }
        else
        {
            var vHtml = '<span>' + eventCnt + '</span>';
            $('.noti').prepend(vHtml);
        }

        //이벤트팝업 닫음
        $('.event-msg').hide();

        $('#event_id').val(eventInfo.event_id);
        $('#event_title').text("[" + eventInfo.event_name + "]");
        $('#event_date').text("DATE: " + eventInfo.event_time.substring(0, 4)  + "-" + eventInfo.event_time.substring(4, 6)   + "-" + eventInfo.event_time.substring(6, 8)
                                 + " " + eventInfo.event_time.substring(8, 10) + ":" + eventInfo.event_time.substring(10, 12) + ":" + eventInfo.event_time.substring(12, 14)
                             );
        $('#event_bm_id').text("BPID: " + eventInfo.bp_id + ", BMID: " + eventInfo.bm_id);
        $('#event_message').text(eventInfo.message);

        $('.event-msg').slideDown(500);
    }
}

function confirmEventAlert()
{
    if (alertInterval != null)
    {
        clearInterval(alertInterval);
    }

    eventCnt = 0;
    eventRecvData = null;
    $('.noti span').remove();
}

function menuClick(gui_src, param_obj, menu_id)
{
    var param;

    if(typeof param_obj == "undefined" || param_obj == '')
    {
        param = {};
    }
    else
    {
        param = param_obj;
    }
    if($('#JP_' + menu_id).length > 0)
    {
        //alert("페이지가 떠있습니다.");
        return;
    }

    param.pageID = menu_id;

    new Dashboard().add(gui_src, param);
}

function moveEventList()
{
    confirmEventAlert();
    $('.event-msg').hide();
    menuClick('operation/eventsList', '', '200002');
}

function panelRemove(_arg)
{
    var _tId = $(_arg).parent().parent().parent().parent().parent()[0].id;

    if(_tId == "")
    {
        _tId = $(_arg).parent().parent().parent().parent()[0].id;
    }

    if(_tId.indexOf("200002") > -1 )
    {
        confirmEventAlert();
    }

    g_pannelMap.remove(_tId);

    // panelAlignAll();
}

function panelAlignAll()
{
	new Dashboard().alignAll();
}

$(window).on('beforeunload', function()
{
    var keys = g_pannelMap.keys();
    var nFavCnt = 0;

    var tmpObj = {};
    var userId = [];
    var menuId = [];
    var screenTop = [];
    var screenLeft = [];
    var screenRight = [];
    var screenHeight = [];
    var screenWidth = [];
    var screenStatus = [];

    for(var i = 0; i < keys.length; i++)
    {
        var jpObj = g_pannelMap.get(keys[i]);
        if(!jpObj.hasClass("favorite"))
        {
            nFavCnt++;
        }
        else
        {
            userId.push("${sessionScope.sessUserInfo.user_id}");
            menuId.push(replaceAll(keys[i], 'JP_', ''));
            screenTop.push(jpObj.css('top'));
            screenLeft.push(jpObj.css('left'));
            screenRight.push(jpObj.css('right'));
            screenHeight.push(jpObj.height());
            screenWidth.push(jpObj.width());

            if(jpObj.hasClass("minimized"))
            {
                screenStatus.push("0");
            }
            else if(jpObj.hasClass("maximized"))
            {
                screenStatus.push("2");
            }
            else
            {
                screenStatus.push("1");
            }
        }
    }

    tmpObj.userId = userId+"";
    tmpObj.menuId = menuId+"";
    tmpObj.screenTop = screenTop+"";
    tmpObj.screenLeft = screenLeft+"";
    tmpObj.screenRight = screenRight+"";
    tmpObj.screenHeight = screenHeight+"";
    tmpObj.screenWidth = screenWidth+"";
    tmpObj.screenStatus = screenStatus+"";

    var isSession = true;
    $.ajaxSettings.traditional = true;
    $.ajax({
        type: "GET",
        url: "<c:url value='/main/registerUserBookmark' />",
        data:tmpObj,
        dataType:'json',
        contentType: 'application/json',
        cache: false,
        async: false,
        success: function(data)
        {
            //console.log(data);
            isSession = data.result;
        }
    });
});
</script>