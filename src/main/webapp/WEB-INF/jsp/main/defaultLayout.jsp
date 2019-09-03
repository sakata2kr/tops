<%@ page language="java" contentType="text/html; charset=utf8"    pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html class="no-js" lang="ko">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9">
        <title>SKT OSS</title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link href="<c:url value="/resources/css/bootstrap.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/vendor/jquery-ui/jquery-ui.min.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/jquery.mCustomScrollbar.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/ui.jqgrid.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/vendor/jquery.contextMenu.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/jsPanel.css"/>" rel="stylesheet">
        <link href="<c:url value="/resources/css/jquery.fs.selecter.css"/>" rel="stylesheet">
        <link href="<c:url value="/resources/css/fullcalendar.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/style.css"/>" rel="stylesheet" media="screen">
        <link href="<c:url value="/resources/css/localStyle.css"/>" rel="stylesheet" media="screen">

        <script src="<c:url value="/resources/js/vendor/joint/joint.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery-1.11.3.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/bootstrap.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery-ui/jquery-ui.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.flot.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.flot.resize.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.flot.categories.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.flot.time.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.treeview.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.multiple.select.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/grid.locale-kr.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.jqGrid.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/fancytree/jquery.fancytree-all.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.mCustomScrollbar.concat.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jcanvas.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.jspanel.bs-1.4.0.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.fs.selecter.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/moment.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/fullcalendar.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/spin.min.js"/>"></script>
        <script src="<c:url value="/resources/js/vendor/jquery.validate.min.js"/>"></script>

        <script src="<c:url value="/resources/js/vendor/jquery.scrollTo.js"/>"></script>

        <script src="<c:url value="/resources/js/main.js"/>"></script>
        <script src="<c:url value="/resources/js/common.js"/>"></script>
        <script src="<c:url value="/resources/js/dateUtils.js"/>"></script>

        <script src = "<c:url value="/resources/js/vendor/sockjs/sockjs.min.js"/>" ></script >
        <script src = "<c:url value="/resources/js/vendor/sockjs/stomp.min.js"/>" ></script >

        <script> selectCust(); </script>

        <sitemesh:write property="head" />
    </head>
    <body>
        <!-- sitemesh:decorate decorator="/WEB-INF/jsp/include/nav.jsp"/ -->
        <sitemesh:decorate decorator="/main/setMenuOnScreen"/>

        <sitemesh:write property="body" />

        <!-- 레이어팝업 -->
        <div class="event-msg" style="display:none;">
            <span class="msg"><a href="#" onclick="moveEventList()">Events List  ></a></span>
            <span id='event_title' class="warning-tit"></span>
            <div class="warning-msg">
                <span id='event_date'></span><br />
                <span id='event_bm_id'></span><br />
                <span id='event_message'></span><br />
                <input id="event_id" type="hidden" />
            </div>
            <div class="event-msg-area">
                <a href="#" onclick="confirmEventAlert()">Event Message Confirm</a>
            </div>
        </div>

        <!-- Modal -->
        <div class="modal" id="alertModal">
            <div class="modal-dialog dialog-style01">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title">알림창</h4>
                    </div>
                    <div class="modal-body" style="text-align:center">
                        <textarea id="modalMessage"  rows="10" cols="40" readonly="readonly"></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-search w25" data-dismiss="modal">
                            확인
                        </button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div>

    <!-- 전문 처리 Confirm을 위한 Hidden Modal -->
    <div class="modal" id="confirmCommandModal">
        <div class="modal-dialog dialog-style01">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">알림창</h4>
                </div>
                <div class="modal-body" style="text-align: center;" >
                    <input type="hidden" id="cmdTargetKey" />
                    <input type="hidden" id="cmdTargetType" />
                    <input type="hidden" id="cmdAction" />
                    <input type="hidden" id="cmdTargetName" />
                    <input type="hidden" id="cmdActionName" />
                    <textarea id="cmdMessage" rows="5" cols="40" disabled="disabled"></textarea >
                </div>
                <div class="modal-footer" >
                    <button type="button"
                            class="btn btn-search w25 confirmOk"
                            data-dismiss="modal"
                            onclick="sendCommand()" >
                        실행
                    </button>
                    <button type="button"
                            class="btn btn-search w25 confirmCanc"
                            data-dismiss="modal"
                            onclick="cancelCommand()">
                        취소
                    </button >
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div>

        <!-- ## 입력 Modal 공통 -->
        <div class="modal" id="formModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        </div><!-- /.modal -->
    </body>
</html>