<%@ page language = "java" contentType = "text/html; charset=UTF-8" pageEncoding = "UTF-8" %>
<%@ taglib prefix = "c"  uri = "http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fn" uri = "http://java.sun.com/jsp/jstl/functions" %>

<link href="<c:url value="/resources/css/vendor/fancytree/ui.fancytree.min.css"/>" rel="stylesheet" media="screen">
<link href="<c:url value="/resources/css/vendor/jquery.contextMenu.css"/>" rel="stylesheet" media="screen">

<style type="text/css">

    .tree-structure > ul.fancytree-container
    { height    : 665px;
      overflow  : auto;
      position  : relative;
      font-size : 11px;
      outline   : none !important;
      border    : 0 dotted gray;
    }

    span.fancytree-node.optree > span.fancytree-icon
    { width            : 19px;
      height           : 12px;
      margin-top       : 2px;
      padding-top      : 0px;
      background-image : none;
      color            : #FFF;
      border-radius    : 4px;
      text-align       : center;
      font-size        : 8px;
    }

    span.fancytree-icon
    {
      background-image : none;
      border-radius    : 8px;
    }

    span.fancytree-node.optree > span.fancytree-title
    { font-family : "Malgun Gothic";
      font-size   : 11px;
    }

    .ui-contextmenu
    { z-index    : 888888;
    }

    .ui-menu
    { width : 100px;
      background-color : #FFF;
      border-bottom    : 1px solid #d7dde4;
      font-family      : "Malgun Gothic";
      font-size        : 11px;
      font-weight      : normal;
    }

    .ui-menu-item
    { background-color : #FFF;
      border-bottom    : 1px solid #d7dde4;
      font-family      : "Malgun Gothic";
      font-size        : 11px;
    }

    .ui-state-focus,
    .ui-widget-content .ui-state-focus
    {
        color      : #FFF;
        border     : 1px solid #C12E2E;
        background : #C12E2E;
    }

    .ui-state-active,
    .ui-widget-content .ui-state-active
    {
        color      : #C12E2E;
        border     : 1px solid #C12E2E;
        background : #FFF;
    }

    .chart_box
    { display    : inline-block;
      float      : left;
      margin-top : 3px;
      width      : 100%;
      height     : 50%
    }
</style >

<!--// 온라인 프로세스 트리는 감싸줘야함 -->
<div class="online-pro oper-table panel-con">
    <!--// 왼쪽 화면 박스 구성 -->
    <div class="left-box">
        <div class="showcase-title-sub">
            <h5 >온라인 프로세스 현황</h5 >
            <a id="stTooltip" class="quest" >?</a >
            <a id="stRefreshBtn" class="tree_refresh" onClick="reloadTree()"></a >
        </div>
        <!--// 프로세스 트리 관련 조회 조건 -->
        <div id="treeControlDiv" class="box-space">
            <div class="tree_form">
                <input type="radio"
                       name="viewType"
                       class="viewType"
                       onChange="reloadTree()"
                       value="GROUP"
                       checked="checked" />
                <label>그룹</label>

                <input type="radio"
                       name="viewType"
                       class="viewType"
                       onChange="reloadTree()"
                       value="SERVER" />
                <label>서버</label>

                <input type="radio"
                       name="viewType"
                       class="viewType"
                       onChange="reloadTree()"
                       value="PROCESS" />
                <label>프로세스</label>
            </div>
            <div class="tree_form">
                <label>필터조건</label>
                <input type="text"
                       id="input_filter"
                       class="form-control"
                       style="width: 80px; text-align: left;" />
                <button type="button"
                        class="btn btn-search btn_operation"
                        onclick="processTreeFilter()">적용</button>
            </div>
        </div>
        <!-- 프로세스 트리 정보 -->
        <div id="processTreeDiv" class="tree-structure">
           <span id="treeLoad" style="float:left; display:inline-block; margin-left: 10px; font-size:15px; text-align:center"></span>
        </div>
    </div>

    <!--// 오른쪽 화면 박스 구성 -->
    <div class = "right-box">
        <!--// TOPS Framework 관련 프로세스 상태 표기 -->
        <div id="fwk-component-area" class = "com-box-min" style="margin:2px 2px 2px 2px">
            <span class="text-line" style="font-size:12px; font-weight:bold">TOPS FWK 상태</span>
            <span class="text-line">MASTER <img id="fwk_master" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <span class="text-line">MANAGER <img id="fwk_manager" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <span class="text-line">AGENT <img id="fwk_agent" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <span>기타 <img id="fwk_etc" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <button id="btn_fwk_refresh" type="button" class="btn btn-search btn_operation" style="margin-left:10px">RELOAD</button>
        </div>
        <!--// 서버별 처리 상태 Chart 및 Grid 표기 -->
        <div id="chart-area" style="margin-top:1px">
            <div class="showcase-title-sub" style="border-top:1px solid #bfbfbf;">
                <h5 >프로세스 처리 현황</h5 >
            </div>
            <div class="com-box-form" style="padding:0 0 10px 10px" >
                <span class="text-line">그룹 유형1 <input type="text" id="selGrpCtg1_text" class="form-control" style="width: 150px; padding-left:10px; text-align: left;" disabled /></span>
                <span class="text-line">그룹 유형2 <input type="text" id="selGrpCtg2_text" class="form-control" style="width: 150px; padding-left:10px; text-align: left;" disabled /></span>
                <span class="text-line">그룹 명 <input type="text" id="selGroup_text" class="form-control" style="width: 150px; padding-left:10px; text-align: left;" disabled /></span>
                <span>대상 서버 <input type="text" id="selSystem_text" class="form-control inputWidth" style="width: 150px; padding-left:10px; text-align: left;" disabled /></span>
                <button id="btn_status_check" type="button" class="btn btn-search btn_operation" style="margin-left:10px">조회</button>
            </div>
            <div class="chart_box">
                <canvas id="ChartBox"></canvas>
            </div>
        </div>
        <div id="top_grid" class="showcase-content">
            <div class="showcase-title-sub" style="border-top:1px solid #bfbfbf;">
                <h5 >특이 사항 발생 프로세스 내역</h5 >
            </div>
            <div class="table-responsive">
                <table id="topStatusGrid" class="grid gridH8"></table>
            </div>
        </div>
    </div >

    <!-- 프로세스 트리 상태 표기 관련 툴팁 -->
    <div id="stTooltip_info" class="quest_info">
        <dl>
            <dt>BP 상태</dt>
            <dd><span class="fancytree-icon" style="background-color:#000000" >G</span><span class="fancytree-title">Group 기준</span></dd>
            <dd><span class="fancytree-icon" style="background-color:#000000" >S</span><span class="fancytree-title">Server 기준</span></dd>
            <dd><span class="fancytree-icon" style="background-color:#000000" >B</span><span class="fancytree-title">BP/BM 기준</span></dd>
            <dd style="height:10px"></dd>
            <dd><span class="fancytree-icon" style="background-color:#777777" ></span><span class="fancytree-title">사용안함 상태</span></dd>
            <dd><span class="fancytree-icon" style="background-color:#00BCF5" ></span><span class="fancytree-title">정상 기동 상태</span></dd>
            <dd><span class="fancytree-icon" style="background-color:#315EF5" ></span><span class="fancytree-title">처리 HOLD 상태</span></dd>
            <dd><span class="fancytree-icon" style="background-color:#6100F5" ></span><span class="fancytree-title">사용자 중지 상태</span></dd>
            <dd><span class="fancytree-icon" style="background-color:#C12E2E" ></span><span class="fancytree-title">비정상 종료 상태</span></dd>
        </dl>
    </div>
</div>
<!--// 온라인 프로세스 트리는 감싸줘야함 -->

<script src="<c:url value="/resources/js/vendor/jquery.contextMenu.js" />"></script>
<script src="<c:url value="/resources/js/vendor/Chart.js/Chart.min.js" />"></script>
<script src="<c:url value="/resources/js/vendor/fancytree/jquery.ui-contextmenu.min.js"/>"></script>

<script type = "text/javascript">
    var sockSendData = null;
    var sockRecvData = null;
    var sockTimeout  = null;

    var treeFilter = null;

    var systemListJson = null;

    // STATUS 조회를 위한 parameter 초기값 설정
    var statusParam = {};
    var statusChart = null;

    $(document).ready(function()
    {
        // Tree Component 구성
        $("#processTreeDiv").fancytree(
        {
            source         : null
          , cache          : false
          , tabindex       : ""
          , titlesTabbable : false
          , debugLevel     : 0
          , selectMode     : 1
          , extensions     : [ "filter", "persist" ]
          , filter         : {autoExpand: true, counter:false, nodata: true, mode:"hide"}
          , scrollOfs      : {top:50, bottom:0}
          , autoCollapse   : false
          , postProcess    : function (event)
            {
                $(':radio[name="viewType"]').attr('disabled', 'disabled');
                $("#stRefreshBtn").attr('disabled', 'disabled');
            }
          , renderNode     : function (event, tree)
            {
                tree.node.extraClasses = "optree";
                tree.node.renderTitle();
                setTreeIcon(tree.node, tree.node.type, tree.node.data.status);
                setTreeTitle(tree.node, tree.node.title);
            }
          , persist : {
              cookiePrefix : "fancytree-"
            , expandLazy : false
            , expandOpts : undefined
            , overrideSource : true
            , store : "local"
            , types : "active expanded focus selected"
            }
        });

        // Command 수행 권한 여부 체크
        if ( g_operationYn != "N" )
        {
            // fancyTree ContextMenu 구성
            $("#processTreeDiv").contextmenu({
                delegate : "span.fancytree-title"
              , autoFocus: true
              , preventContextMenuForPopup: true
              , preventSelect: true
              , taphold: true
              , hide : false
              , show : false
              , beforeOpen: function(event, ui) {
                  var node = $.ui.fancytree.getNode(ui.target);
                  $("#processTreeDiv").contextmenu("replaceMenu", composeDataContextMenu(node, $(':radio[name="viewType"]:checked').val()));
                  node.setActive();
                }
              , select: function(event, ui) {
                  var node = $.ui.fancytree.getNode(ui.target);
                  confirmCommand(node, ui.cmd, ui.item.data().desc);
                }
            })
        }

        // fancyTree 관련 디버그 모드 해제
        $.ui.fancytree.debugLevel = 0;

        // STOMP client 설정
        initConn();

        // Tree 구성 시 Loading 표시
        suspendTree();
    });

    function initConn()
    {
        if ( stompClient == null)
        {
            connect();
        }

        // 사용자 전용 채널이 없을 경우에만 설정
        if (stompConn.treeUser == null)
        {
            stompConn.treeUser = stompClient.subscribe("/user/stomp/resTree", function(msg){
                onTreeMsg(msg);
            });
        }

        // 전체 PUSH 채널은 존재하는 경우 해제 후 재생성
        if (stompConn.treePush != null)
        {
            stompConn.treePush.unsubscribe();
        }

        stompConn.treePush = stompClient.subscribe("/stomp/treeView/" + $(':radio[name="viewType"]:checked').val(), function(msg){
            onTreeMsg(msg);
        });

        statusParam.procType = "reqTreeData";
        statusParam.viewType = $(':radio[name="viewType"]:checked').val();
        sockSendData = statusParam;

        stompClient.send("/stomp/reqTree", {}, JSON.stringify(sockSendData));
    }

    // Tree Loading 처리 로직
    function suspendTree()
    {
        // right box 내 프로세스 현황 조회 정보 초기화
        initStatusParam();

        // fancyTree persist 초기화
        $("#processTreeDiv").fancytree("getTree").clearPersistData();

        $("#processTreeDiv").fancytree("option", "source", [{title: "로딩 중", key: "Loading"}]);

        /*
        $(':radio[name="viewType"]').attr('disabled', 'disabled');
        $("#stRefreshBtn").attr('disabled', 'disabled');
        sockTimeout = setTimeout(function(){
            releaseTree();
        }, 3000);
        */
    }

    // STATUS 조회 파라미터 및 요소 초기화
    function initStatusParam()
    {
        statusParam.grp_ctg1  = null;
        statusParam.grp_ctg2  = null;
        statusParam.group_id  = null;
        statusParam.system_id = null;

        $("#selGrpCtg1_text").val("전체");
        $("#selGrpCtg2_text").val("전체");
        $("#selGroup_text").val("전체");
        $("#selSystem_text").val("전체");

    }

    function onTreeMsg(msg)
    {
        if ( msg.body.length > 0 )
        {
            //console.log(msg.body);
            sockRecvData = JSON.parse(msg.body);
        }

        switch ( sockRecvData.procType )
        {
            case "reqProcessCommand" :
                if ( sockRecvData.jsonData.result != "S" )
                {
                    alertModal($("#cmdTargetName").val() + " 에 대한 " + $("#cmdActionName").val() + " 명령 처리에 실패하였습니다.");
                }
                break;

            case "reqFwkInfo" :
                refreshFwkStatus(sockRecvData.jsonData);

                // Framework 정보 업데이트 후 Status 정보 조회 요청
                reqNodeStatus();
                break;

            case "reqServerList" :
                systemListJson = sockRecvData.jsonData;
                break;

            case "reqTreeData" :
                if ( sockRecvData.dataRefresh === "true" )
                {
                    loadTree(sockRecvData.jsonData, $(':radio[name="viewType"]:checked').val());

                    releaseTree();
                }
                else
                {
                    //console.log(sockRecvData.jsonData);
                    updateTreeNodes(sockRecvData.jsonData);
                }

                // Tree 정보 업데이트 후 Server 정보 조회 요청
                sockSendData = new Object();
                sockSendData.procType = "reqServerList";
                sockSendData.viewType = $(':radio[name="viewType"]:checked').val();
                stompClient.send("/stomp/reqTree", {}, JSON.stringify(sockSendData));
                break;

            case "reqNodeStatus" :
                //console.log(sockRecvData.jsonData);
                makeChart(sockRecvData.jsonData.QueueStatus);
                makeTopStatusGrid(sockRecvData.jsonData.TopQueueList);
                break;

            default :
                break;
         }
    }

    // Tree Load 완료 시 처리 로직
    function releaseTree()
    {
        $("#stRefreshBtn").removeAttr('disabled');
        $(':radio[name="viewType"]').removeAttr('disabled');

        if ( !$("#processTreeDiv").fancytree("getRootNode").getFirstChild().hasChildren() )
        {
            $("#processTreeDiv").fancytree("option", "source", [{title: "연결 끊김 (새로 고침 필요)", key: "err"}]);
        }
    }

    // 알람 처리
    function alertModal(message)
    {
        $("#modalMessage").text(message);
        $("#modalMessage").attr("disabled", true);

        $("#alertModal").modal({show : true,backdrop : 'static'});
    }

    // 아이콘 세팅
    function setTreeIcon(node, type, status)
    {
        var color;

        switch ( status )
        {
            case "HDDN" :
                color = "#777777";
                break;

            case "PS03" :
                color = "#00BCF5";
                break;

            case "PS04" :
                color = "#315EF5";
                break;

            case "PS06" :
                color = "#6100F5";
                break;

            default :
                color = "#C12E2E";
                break;
        }

        if ( type != null )
        {
            $(node.span).find("> span.fancytree-icon").text(type.substring(0, 1)).css({"background-color" : color});
        }
    }

    // 노드 타이틀 세팅
    function setTreeTitle(node, title, status)
    {
        var color;

        switch ( status )
        {
            case "HDDN" :
                color = "#777777";
                break;

            case "PS04" :
                color = "#315EF5";
                break;

            default :
                color = "#333333";
                break;
        }

        $(node.span).find("> span.fancytree-title").text(title).css({"color": color});
    }

    // 컨텍스트 메뉴 구성
    function composeDataContextMenu(node, viewType)
    {
        if ( !node )  return;

        switch ( node.type )
        {
            case "SERVER" :
                /* 2019.04.15 자동 Take Over 기능 삭제
                if ( node.data.depth == "1" )
                {
                    commands = { "BG01|R"   : { name : "Run" }
                               , "BG01|S"   : { name : "Stop" }
                               , "SUB_MENU" : { name : "Auto Take Over"
                                             , items: { "BS05|M" : { name: "Migrate" }
                                                      , "BS05|R" : { name: "Restore" }
                                                      }
                                             }
                               };
                }
                else
                */
                {
                    // 조회 대상 서버의 SYSTEM GROUP 정보 추출 후 subMenu 구성
                    var systemGroup;
                    var subMenu = [];

                    $.each(systemListJson, function(i, entity)
                    {
                        if (entity.system_id == node.data.psystem_id)
                        {
                            systemGroup = entity.system_group;
                        }
                    });

                    // 조회 대상 서버 SYSTEM GROUP과 동일하면서 SYSTEM ID 가 다른 서버 정보 조회
                    $.each(systemListJson, function(i, entity)
                    {
                        if ( entity.system_id != node.data.psystem_id && entity.system_group == systemGroup )
                        {
                            subMenu.push({ title : entity.system_name, cmd : "BP05|" + entity.system_id , data : { desc : "Take Over(" + node.title + " → " + entity.system_name + ")" }  });
                        }
                    });

                    switch ( node.data.status )
                    {
                        case "PS03" :
                            commands = [ { title : "Stop" , cmd : "BG01|S" , data : { desc : "중지" } } ];

                            if (subMenu.length > 0)
                            {
                                commands.push({ title : "Take Over" , children : subMenu });
                            }
                            break;

                       default :
                           commands = [ { title : "Run"  , cmd : "BG01|R" , data : { desc : "기동" } }
                                      , { title : "Stop" , cmd : "BG01|S" , data : { desc : "중지" } }
                                      ];

                           if (subMenu.length > 0)
                           {
                               commands.push({ title : "Take Over" , children : subMenu });
                           }
                           break;
                    }
                }
                break;

            case "GROUP" :
            case "GROUP_CTG1" :
            case "GROUP_CTG2" :
                switch ( viewType )
                {
                    case "PROCESS" :
                        switch ( node.data.status )
                        {
                            case "HDDN" :
                                commands = [ { title : "Enable"  , cmd : "BP07|B|R" , data : { desc : "활성화"   } , disabled: false }
                                           , { title : "Disable" , cmd : "BP07|B|S" , data : { desc : "비활성화" } , disabled: true  }
                                           ];
                                break;

                            case "PS03" :
                                commands = [ { title : "Stop" , cmd : "BP01|S" , data : { desc : "중지" } } ];
                                break;

                            default :
                                commands = [ { title : "Run"     , cmd : "BP01|R"   , data : { desc : "기동" } }
                                           , { title : "Stop"    , cmd : "BP01|S"   , data : { desc : "중지" } }
                                           , { title : "Enable"  , cmd : "BP07|B|R" , data : { desc : "활성화"   } , disabled: true  }
                                           , { title : "Disable" , cmd : "BP07|B|S" , data : { desc : "비활성화" } , disabled: false }
                                           ];
                                break;

                        }
                        break;

                    case "SERVER" :
                    case "GROUP" :
                        switch ( node.data.status )
                        {
                            case "HDDN" :
                                commands = [ { title : "Enable"  , cmd : "BP07|G|R" , data : { desc : "활성화"   }, disabled: false }
                                           , { title : "Disable" , cmd : "BP07|G|S" , data : { desc : "비활성화" }, disabled: true  }
                                           ];
                                break;

                            case "PS03" :
                                commands = [ { title : "Stop" , cmd : "BG01|S" , data : { desc : "중지" } } ];
                                break;

                            default :
                                commands = [ { title : "Run"     , cmd : "BG01|R"   , data : { desc : "기동" } }
                                           , { title : "Stop"    , cmd : "BG01|S"   , data : { desc : "중지" } }
                                           , { title : "Enable"  , cmd : "BP07|G|R" , data : { desc : "활성화"   } , disabled: true  }
                                           , { title : "Disable" , cmd : "BP07|G|S" , data : { desc : "비활성화" } , disabled: false }
                                           ];
                                break;

                        }
                        break;

                    default :
                        break;
                }
                break;

            case "BP" :
            case "BP_GROUP" :
                switch ( node.data.status )
                {
                    case "HDDN" :
                        commands = [ { title : "Enable"  , cmd : "BP07|B|R" , data : { desc : "활성화"   } , disabled: false }
                                   , { title : "Disable" , cmd : "BP07|B|S" , data : { desc : "비활성화" } , disabled: true  }
                                   ];
                        break;

                    case "PS03" :
                        if ( node.data.bp_group != null && node.data.bp_group.substring(0, 2) == "GD" )
                        {
                            commands = [ { title : "Hold"    , cmd : "BP14|R" , data : { desc : "Hold" } }
                                       , { title : "Stop"    , cmd : "BP01|S" , data : { desc : "기동" } }
                                       , { title : "Kill"    , cmd : "BP01|K" , data : { desc : "중지" } }
                                       ];
                        }
                        else
                        {
                            commands = [ { title : "Stop"    , cmd : "BP01|S" , data : { desc : "중지" } }
                                       , { title : "Kill"    , cmd : "BP01|K" , data : { desc : "Kill" } }
                                       ];
                        }
                        break;

                    case "PS04" :
                        commands = [ { title : "Free"    , cmd : "BP14|S" , data : { desc : "Free" } }
                                   , { title : "Stop"    , cmd : "BP01|S" , data : { desc : "중지" } }
                                   , { title : "Kill"    , cmd : "BP01|K" , data : { desc : "Kill" } }
                                   ];
                        break;

                    default :
                        if ( node.data.bp_group != null && node.data.bp_group.substring(0, 2) == "GD" )
                        {
                            commands = [ { title : "Run"     , cmd : "BP01|R"   , data : { desc : "기동" } }
                                       , { title : "Stop"    , cmd : "BP01|S"   , data : { desc : "중지" } }
                                       , { title : "Hold"    , cmd : "BP14|R"   , data : { desc : "Hold" } }
                                       , { title : "Kill"    , cmd : "BP01|K"   , data : { desc : "Kill" } }
                                       , { title : "Enable"  , cmd : "BP07|B|R" , data : { desc : "활성화"   } , disabled: true  }
                                       , { title : "Disable" , cmd : "BP07|B|S" , data : { desc : "비활성화" } , disabled: false }
                                       , { title : "LOG LEVEL"    , children : [
                                             { title : "CRITICAL" , cmd : "LO02|0" , data : { desc : "로그 레벨 조정(CRITICAL)" } }
                                           , { title : "ERROR"    , cmd : "LO02|1" , data : { desc : "로그 레벨 조정(ERROR)"    } }
                                           , { title : "WARNING"  , cmd : "LO02|2" , data : { desc : "로그 레벨 조정(WARNING)"  } }
                                           , { title : "INFO"     , cmd : "LO02|3" , data : { desc : "로그 레벨 조정(INFO)"     } }
                                           , { title : "DEBUG"    , cmd : "LO02|4" , data : { desc : "로그 레벨 조정(DEBUG)"    } }
                                         ]}
                                       ];
                        }
                        else
                        {
                            commands = [ { title : "Run"     , cmd : "BP01|R"   , data : { desc : "기동" } }
                                       , { title : "Stop"    , cmd : "BP01|S"   , data : { desc : "중지" } }
                                       , { title : "Kill"    , cmd : "BP01|K"   , data : { desc : "Kill" } }
                                       , { title : "Enable"  , cmd : "BP07|B|R" , data : { desc : "활성화"   } , disabled: true  }
                                       , { title : "Disable" , cmd : "BP07|B|S" , data : { desc : "비활성화" } , disabled: false }
                                       , { title : "LOG LEVEL"    , children : [
                                             { title : "CRITICAL" , cmd : "LO02|0" , data : { desc : "로그 레벨 조정(CRITICAL)" } }
                                           , { title : "ERROR"    , cmd : "LO02|1" , data : { desc : "로그 레벨 조정(ERROR)"    } }
                                           , { title : "WARNING"  , cmd : "LO02|2" , data : { desc : "로그 레벨 조정(WARNING)"  } }
                                           , { title : "INFO"     , cmd : "LO02|3" , data : { desc : "로그 레벨 조정(INFO)"     } }
                                           , { title : "DEBUG"    , cmd : "LO02|4" , data : { desc : "로그 레벨 조정(DEBUG)"    } }
                                         ]}
                                       ];
                        }
                        break;
                }
                break;

            case "BM" :
                if ( node.data.status != "HDDN" )
                {
                    commands = [ { title : "Thread 추가" , cmd : "TH01|R" , data : { desc : "Thread 추가" } }
                               , { title : "Thread 삭제" , cmd : "TH01|S" , data : { desc : "Thread 삭제" } }
                               ];
                }
                break;

            default :
                break;
        }

        return commands;
    }

    // Load Tree
    function loadTree(data, viewType)
    {
        $("#processTreeDiv").fancytree("option", "source", data);

        if ( viewType == "GROUP" )
        {
            expandDataTreeNode($("#processTreeDiv").fancytree("getRootNode"), 2);
        }
        else
        {
            expandDataTreeNode($("#processTreeDiv").fancytree("getRootNode"), 3);
        }

        if ( treeFilter != null && treeFilter != "" )
        {
            processTreeFilter();
        }
    }

    // 해당 노드와 자식 노드를 Expand하는 recusive function
    function expandDataTreeNode(node, depth)
    {
        node.setExpanded(true);
        depth--;

        // depth 기준으로 node를 확장 (자식 Node가 존재하지 않는 경우 Skip)
        if ( depth > 0 && node.hasChildren() )
        {
            // Go recursive on child nodes
            expandDataTreeNode(node.getFirstChild(), depth);
        }
    }

    // 변경된 Tree node 갱신
    function updateTreeNodes(data)
    {
        if ( data != null )
        {
            $.each(data, function (i, item)
            {
                var node = $("#processTreeDiv").fancytree("getTree").getNodeByKey(item.key);

                if ( !node )    return;

                node.data = item;
                setTreeIcon(node, node.type, item.status);
                setTreeTitle(node, item.title, item.status);
            });
        }
    }

    // Reload Tree
    function reloadTree()
    {
        initConn();

        suspendTree();
    }

    // Filtering Tree
    function processTreeFilter()
    {
        treeFilter = $("#input_filter").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
        $("#input_filter").val(treeFilter);

        if ( treeFilter != null && treeFilter != "" )
        {
            $("#processTreeDiv").fancytree("getTree").filterBranches(treeFilter);
        }
        else
        {
            $("#processTreeDiv").fancytree("getTree").clearFilter();
        }
    }

    // Filter 버튼 엔터키 기능 추가
    $("#input_filter").keydown(function(e)
    {
        if(e.keyCode == 13)
        {
            processTreeFilter();
        }
    });

    // 명령 확인 Modal
    function confirmCommand(node, action, actionName)
    {
        var targetName = node.key.replace(/\|/gi, " / ");

        $("#cmdTargetKey").val(node.key);
        $("#cmdTargetType").val(node.type);
        $("#cmdAction").val(action);
        $("#cmdTargetName").val(targetName);
        $("#cmdActionName").val(actionName);
        $("#cmdMessage").text(targetName + " 에 대한 " + actionName + " 처리를 요청하겠습니까?");

        $("#confirmCommandModal").modal({show:true, backdrop: false});
    }

    // Operation 명령 전송
    function sendCommand()
    {
        sockSendData = new Object();

        sockSendData.procType = "reqProcessCommand";
        sockSendData.viewType = $(':radio[name="viewType"]:checked').val();
        sockSendData.nodeKey  = $("#cmdTargetKey").val();
        sockSendData.nodeType = $("#cmdTargetType").val();

        var actionArray = $("#cmdAction").val().split("|");
        sockSendData.cmdCode    = actionArray[0];
        sockSendData.cmdInfo    = actionArray[1];
        sockSendData.cmdInfoSub = actionArray[2];

        // console.log(sockSendData);
        stompClient.send("/stomp/reqTree", {}, JSON.stringify(sockSendData));
    }

    // Operation 명령 취소
    function cancelCommand()
    {
        return false;
    }

    // Tree 내 BP 상태 관련 tool-tip 표시
    $("#stTooltip").on("click", function ()
    {
        if ( $(this).hasClass("questOn") )
        {
            $(this).removeClass("questOn");
            $("#stTooltip_info").hide();
        }
        else
        {
            $(this).addClass("questOn");
            $("#stTooltip_info").show();
        }
    });

    // TOPS Framework Info 정보 갱신
    function refreshFwkStatus(fwkList)
    {
        if ( !fwkList )    return;

        $("#fwk_master").attr("title", "");
        $("#fwk_manager").attr("title", "");
        $("#fwk_agent").attr("title", "");
        $("#fwk_etc").attr("title", "");

        $.each(fwkList, function(i, fwkInfo)
        {
            switch ( fwkInfo.comp_type )
            {
                case "MASTER" :
                    $("#fwk_master").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#fwk_master").attr("title", $("#fwk_master").attr("title") + "\n" + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류");
                    break;

                case "MANAGER" :
                    $("#fwk_manager").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#fwk_manager").attr("title", $("#fwk_manager").attr("title") + "\n" + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류");
                    break;

                case "AGENT" :
                    $("#fwk_agent").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#fwk_agent").attr("title", $("#fwk_agent").attr("title") + "\n" + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류");
                    break;

                case "ETC" :
                    $("#fwk_etc").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#fwk_etc").attr("title", $("#fwk_etc").attr("title") + "\n" + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류");
                    break;

                case "ALL" :
                default :
                    $("#fwk_master").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    $("#fwk_manager").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    $("#fwk_agent").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    $("#fwk_etc").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    break;
            }
        });
    }

    // Framework RELOAD 버튼 클릭 시 RELOAD 전문 요청 처리
    $("#btn_fwk_refresh").on("click", function ()
    {
        var node  = {};
        node.key  = "TOPS Framework";
        node.type = "FWK";

        confirmCommand(node, "FB01", "RELOAD");
    });

    // Tree 내 선택 Node에 대한 STATUS 조회
    $("#btn_status_check").on("click", function ()
    {
        initStatusParam();

        var node = $("#processTreeDiv").fancytree("getActiveNode");

        if ( node )
        {
            selectNodeStatus(node)
        }
    });

    function selectNodeStatus(node)
    {
        if (node.type == "GROUP_CTG1" && node.data.grp_ctg_cd1 != undefined )
        {
            statusParam.grp_ctg1 = node.data.grp_ctg_cd1;
            $("#selGrpCtg1_text").val(node.title);
        }

        if (node.type == "GROUP_CTG2" && node.data.grp_ctg_cd2 != undefined )
        {
            statusParam.grp_ctg2 = node.data.grp_ctg_cd2;
            $("#selGrpCtg2_text").val(node.title);
        }

        if (node.type == "GROUP" && node.data.group_id != undefined )
        {
            statusParam.group_id = node.data.group_id;
            $("#selGroup_text").val(node.title);
        }

        if (node.type == "SERVER" && node.data.psystem_id != undefined)
        {
            statusParam.system_id = node.data.psystem_id;
            $("#selSystem_text").val(node.title);
        }

        if ( node.data.parent_key != "ROOT" )
        {
            selectNodeStatus(node.parent);
        }
        else
        {
            // 선택 Node가 변경된 경우 reqNodeStatus 처리를 위한 조회 값 초기화
            reqNodeStatus();
        }
    }

    function reqNodeStatus()
    {
        statusParam.procType = "reqNodeStatus";
        sockSendData = statusParam;
        stompClient.send("/stomp/reqTree", {}, JSON.stringify(sockSendData));
    }

    // Chart 생성
    function makeChart(chartList)
    {
        if ( !chartList || chartList.length <= 0 )    return;

        var chartLabels    = [];
        var fileChartData  = [];
        var cdrChartData   = [];

        $.each(chartList, function(i, chartData)
        {
            chartLabels.push(chartData.itm_name);
            cdrChartData.push(chartData.tot_cdr_count);
            fileChartData.push(chartData.tot_file_count);
        });

        if ( document.getElementById("ChartBox") != null )
        {
            var chartctx = document.getElementById("ChartBox").getContext("2d");

            if (statusChart)    statusChart.destroy();

            statusChart = new Chart(chartctx, { type : "line"
                                              , data : { labels   : chartLabels
                                                       , datasets : [{ label : "CDR 건수"
                                                                     , yAxisID : "CDR"
                                                                     , data : cdrChartData
                                                                     , fill : false
                                                                     , borderColor     : "#FF6384"
                                                                     }
                                                                    ,{ label : "File 건수"
                                                                     , yAxisID : "File"
                                                                     , data : fileChartData
                                                                     , fill : false
                                                                     , borderColor     : "#36A2EB"
                                                                     }]
                                                       }
                                           , options : { legend  : { display : false}
                                                       , element : { line  : { tension : 0.4 } }
                                                       , scales  : { yAxes : [{ id : "CDR"
                                                                             , type : "linear"
                                                                             , display : true
                                                                             , position : "left"
                                                                             , scaleLabel : { display : true, labelString : "CDR 건수", fontColor: "#FF6384"}
                                                                             , ticks: { fontColor: "#FF6384"
                                                                                      , beginAtZero:true
                                                                                      , userCallback: function(value, index, values) {
                                                                                          // Convert the number to a string and splite the string every 3 charaters from the end
                                                                                          value = value.toString().split(/(?=(?:...)*$)/).join(',');
                                                                                          return value;
                                                                                      }}
                                                                             }
                                                                            ,{ id : "File"
                                                                             , type : "linear"
                                                                             , display : true
                                                                             , position : "right"
                                                                             , scaleLabel : { display : true, labelString : "File 건수", fontColor: "#36A2EB"}
                                                                             , ticks: { fontColor: "#36A2EB"
                                                                                      , beginAtZero:true
                                                                                      , userCallback: function(value, index, values) {
                                                                                            // Convert the number to a string and splite the string every 3 charaters from the end
                                                                                            value = value.toString().split(/(?=(?:...)*$)/).join(',');
                                                                                            return value;
                                                                                 }}
                                                                             }]
                                                                  , xAxes : [{ gridLines : {zeroLineColor : "black", zeroLineWidth : 2}
                                                                             , scaleLabel : {display : false}
                                                                             , ticks: { autoSkip: true, maxRotation: 90, minRotation: 90 }
                                                                             }]
                                                                  }
                                                       , responsive : true
                                                       , maintainAspectRatio : false
                                                       , animation : false
                                                       , tooltips : { position: "nearest"
                                                                    , mode: "index"
                                                                    , intersect: false
                                                                    , callbacks: {
                                                                            label: function(tooltipItem, data) {
                                                                                var value = data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index].toString().split(/(?=(?:...)*$)/).join(',');
                                                                                return value;
                                                                            }
                                                                        }
                                                                    }
                                                       }
                        });
        }
    }

    // Grid 생성
    function makeTopStatusGrid(gridList)
    {
        $("#topStatusGrid").jqGrid({ datatype : "local"
                                        , autowidth: true
                                        , shrinkToFit : true
                                        , height: "270px"
                                        , rowNum : 100000
                                        , colNames : [ '시스템', 'GROUP', 'BP', 'BM', '대기파일건수', '대기CDR건수', '평균대기시간']
                                        , colModel : [ { name : 'system_id',    width:10,  align:'center' }
                                                     , { name : 'group_id',     width:10,  align:'center' }
                                                     , { name : 'bp_id',        width:10,  align:'center' }
                                                     , { name : 'bm_id',        width:10,  align:'center' }
                                                     , { name : 'file_count',   width:20,  sorttype : "int", align:'center', formatter:"currency", formatoptions:{decimalSeparator:".", thousandsSeparator:",", decimalPlaces:0, defaultValue:0} }
                                                     , { name : 'cdr_count',    width:20,  sorttype : "int", align:'center', formatter:"currency", formatoptions:{decimalSeparator:".", thousandsSeparator:",", decimalPlaces:0, defaultValue:0} }
                                                     , { name : 'avg_duration', width:20,  sorttype : "int", align:'center', formatter:"currency", formatoptions:{decimalSeparator:".", thousandsSeparator:",", decimalPlaces:0, defaultValue:0} }
                                                     ]
        });

        $("#topStatusGrid").clearGridData();

        if ( gridList != null && gridList.length > 0)
        {
            $.each(gridList, function(i, gridData)
            {
                $("#topStatusGrid").jqGrid('addRowData', 'TQS_'+(i +1), gridData);
            });
        }
        else
        {
            $("#topStatusGrid").jqGrid('addRowData', 'TQS_0', {system_id:"No Data"});

            for ( var i=0; i < $('#TQS_0 td').length; i++ )
            {
                if ( i == 0 )
                {
                    $('#TQS_0 td:eq('+i+')').attr('colspan', $('#TQS_0 td').length);
                }
                else
                {
                    $('#TQS_0 td:eq('+i+')').hide();
                }
            }
        }
    }

    // 패널 resize 시 그리드 resize
    $(window).bind('resize',function(){
        $("#nodeStatusGrid").setGridWidth($("#status_grid").width() -20);
        $("#topStatusGrid").setGridWidth($("#top_grid").width() -20);
    }).trigger('resize');
</script>