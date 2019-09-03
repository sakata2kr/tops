<%@ page language="java"  pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="<c:url value="/resources/css/vendor/fancytree/ui.fancytree.min.css"/>" rel="stylesheet" media="screen">

<style type = "text/css" >

    .tree-structure > ul.fancytree-container
    { height    : 870px;
      overflow  : auto;
      position  : relative;
      font-size : 11px;
      outline   : none !important;
      border    : 0 dotted gray;
    }

    span.fancytree-node.dashtree > span.fancytree-icon
    { width            : 19px;
      height           : 12px;
      margin-top       : 2px;
      padding-top      : 0px;
      background-image : none;
      color            : white;
      border-radius    : 4px;
      text-align       : center;
      font-size        : 8px;
    }

    span.fancytree-icon
    {
      background-image : none;
      border-radius    : 8px;
    }

    span.fancytree-node.dashtree > span.fancytree-title
    { font-family : "Malgun Gothic";
      font-size   : 11px;
    }

    /* Override */
    .dashboard-panel
    { width  : 100%;
      height : 700px;
      margin : 0;
    }

    .console-view-panel
    {  display : inline-block;
       width   : 100%;
       height  : 150px;
       color   : #E9D78E;
       background-color : #000000;
       font-size : 11px;
       overflow-x : hidden;
       overflow-y : auto;
       white-space: nowrap;
    }
</style >

<!--// 온라인 프로세스 트리는 감싸줘야함 -->
<div class="online-pro oper-table panel-con">
    <!--// 왼쪽 화면 박스 구성 -->
    <div class="left-box">
        <div class="showcase-title-sub">
            <h5>온라인 프로세스 현황</h5 >
            <a id="d_stTooltip" class="quest" >?</a >
            <a id="d_RefreshBtn" class="tree_refresh" onClick="dashReloadTree()"></a >
        </div>
        <!--// 프로세스 트리 관련 조회 조건 -->
        <div id="d_treeControlDiv" class="box-space">
            <div class="tree_form">
                <input type="radio"
                       name="d_viewType"
                       class="viewType"
                       onChange="dashReloadTree()"
                       value="GROUP"
                       checked="checked" />
                <label>그룹</label>

                <input type="radio"
                       name="d_viewType"
                       class="viewType"
                       onChange="dashReloadTree()"
                       value="SERVER" />
                <label>시스템</label>

                <input type="radio"
                       name="d_viewType"
                       class="viewType"
                       onChange="dashReloadTree()"
                       value="PROCESS" />
                <label>프로세스</label>
            </div>
            <div class="tree_form">
                <label>필터조건</label>
                <input type="text"
                       id="d_input_filter"
                       class="form-control"
                       style="width: 80px; text-align: left;" />
                <button type="button"
                        class="btn btn-search btn_operation"
                        onclick="procDashTreeFilter()">적용</button>
            </div>
        </div>
        <!-- 프로세스 트리 정보 -->
        <div id="d_processTreeDiv" class="tree-structure">
           <span id="d_treeLoad" style="float:left; display:inline-block; margin-left: 10px; font-size:15px; text-align:center"></span>
        </div>
    </div>

    <!--// 오른쪽 화면 박스 구성 -->
    <div class = "right-box">
        <!--// TOPS Framework 관련 프로세스 상태 표기 -->
        <div id="d_fwk-component-area" class = "com-box-min" style="margin:2px 2px 2px 2px">
            <span class="text-line" style="font-size:12px; font-weight:bold">TOPS FWK 상태</span>
            <span class="text-line">MASTER <img id="d_fwk_master" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <span class="text-line">MANAGER <img id="d_fwk_manager" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <span class="text-line">AGENT <img id="d_fwk_agent" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
            <span>기타 <img id="d_fwk_etc" src="<c:url value="/resources/img/icon/icon_normality.png"/>" title="" /></span>
        </div>
        <div class="showcase-title-sub" style="border-top:1px solid #bfbfbf;">
            <h5>전체 시스템 모니터링</h5>
        </div>
        <div class="dashboard-panel">
            <svg id="main_svg" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="100%" height="100%">

                <!-- IPMD Component -->
                <rect x="1%" y="10" rx="2" ry="2" width="12%" height="30" stroke="black" stroke-width="2" fill="white"></rect>
                <text x="7%" y="30"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">IPMD</text>

                <!-- IPMD to NAS 연결선 -->
                <line x1="7%" y1="40" x2="7%" y2="70" stroke="black" stroke-width="2"/>

                <!-- NAS Component -->
                <rect x="1%" y="70" rx="2" ry="2" width="12%" height="120" stroke="black" stroke-width="2" fill="white"></rect>
                <circle cx="2%" cy="85" r="7" fill="white" id="c_NAS"></circle>
                <text x="7%" y="90" text-anchor="middle" font-weight="bold" font-size="14" fill="black">NAS</text>

                <!-- NAS ICON -->
                <rect x="2%" y="110"  rx="2" ry="2" width="4%" height="20" stroke="black" stroke-width="1" fill="white"></rect>
                <circle cx="5%" cy="120" r="4" stroke="black" stroke-width="1" fill="white"></circle>
                <rect x="2%" y="135" rx="2" ry="2" width="4%" height="20" stroke="black" stroke-width="1" fill="white"></rect>
                <circle cx="5%" cy="145" r="4" stroke="black" stroke-width="1" fill="white"></circle>
                <line x1="4%" y1="155" x2="4%" y2="165" stroke="black" stroke-width="1" />
                <line x1="2%" y1="165" x2="2.5%" y2="165" stroke="black" stroke-width="1" />
                <line x1="3%" y1="165" x2="5%" y2="165" stroke="black" stroke-width="1" />
                <line x1="5.5%" y1="165" x2="6%" y2="165" stroke="black" stroke-width="1" />
                <circle cx="4%" cy="165" r="4" stroke="black" stroke-width="1" fill="white"></circle>

                <!-- NAS Usage -->
                <text x="10%" y="140" text-anchor="middle" font-weight="bold" font-size="25" fill="black" id = "t_NAS"></text>

                <!-- DCB Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="20%" y="10" rx="2" ry="2" width="8%" height="29" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="24%" y="30" text-anchor="middle" font-weight="bold" font-size="14" fill="black">DCB</text>
                </g>

                <!-- OCG Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="33%" y="10" rx="2" ry="2" width="8%" height="29" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="37%" y="30" text-anchor="middle" font-weight="bold" font-size="14" fill="black">OCG</text>
                </g>

                <!-- IVR Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="46%" y="10" rx="2" ry="2" width="8%" height="29" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="50%" y="30"text-anchor="middle" font-weight="bold" font-size="14" fill="black">IVR</text>
                </g>

                <!-- CDS Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="59%" y="10" rx="2" ry="2" width="8%" height="29" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="63%" y="30"text-anchor="middle" font-weight="bold" font-size="14" fill="black">CDS</text>
                </g>

                <!-- SDP/OCS Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="72%" y="10" rx="2" ry="2" width="8%" height="29" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="76%" y="30"text-anchor="middle" font-weight="bold" font-size="14" fill="black">SDP/OCS</text>
                </g>
<!--
                <!-- SWING Component --
                <rect x="87%" y="10" rx="2" ry="2" width="12%" height="30" stroke="black" stroke-width="2" fill="white"></rect>
                <text x="93%" y="30" text-anchor="middle" font-weight="bold" font-size="14" fill="black">SWING</text>
 
                <!-- SWING MQ Component 연결선 --
                <line x1="93%" y1="40" x2="93%" y2="70" stroke="black" stroke-width="2"/>

                <!-- MQ Component --
                <rect x="87%" y="70" rx="2" ry="2" width="12%" height="120" stroke="black" stroke-width="2" fill="white"></rect>
                <text x="93%" y="90" text-anchor="middle" font-weight="bold" font-size="14" fill="black">MQ</text>
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="88%" y="100" rx="2" ry="2" width="2%" height="20" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="91%" y="110" alignment-baseline="middle" text-anchor="start" font-size="14" fill="black">고객/상품정보/</text>
                    <text x="91%" y="130" alignment-baseline="middle" text-anchor="start" font-size="14" fill="black">충전정보</text>
                    <rect x="88%" y="150" rx="2" ry="2" width="2%" height="20" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="91%" y="160" alignment-baseline="middle" text-anchor="start" font-size="14" fill="black">CDS 연동</text>
                </g>
-->
                <!-- Guiding Server Component -->
                <rect x="28%" y="70" rx="2" ry="2" width="44%" height="220" fill="#DFDFDF"></rect>
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="29%" y="80" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_101"></rect>
                    <circle cx="30%" cy="95" r="7" fill="white" id="c_101"></circle>
                    <text x="33.5%" y="100" text-anchor="middle" font-weight="bold" font-size="14" fill="black" id="t_101">AI #1
                        <tspan x="30.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_101_CPU_t" />
                        <tspan x="33.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_101_MEM_t" />
                        <tspan x="36.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_101_DSK_t" />
                        <tspan x="30.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_101_CPU_v" />
                        <tspan x="33.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_101_MEM_v" />
                        <tspan x="36.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_101_DSK_v" />
                    </text>
                    <svg x="29%" y="140" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_101" ></svg>

                    <rect x="40%" y="80" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_102"></rect>
                    <circle cx="41%" cy="95" r="7" fill="white" id="c_102"></circle>
                    <text x="44.5%" y="100"  text-anchor="middle" font-weight="bold" font-size="14" fill="black" id="t_102">AI #2
                        <tspan x="41.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_102_CPU_t" />
                        <tspan x="44.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_102_MEM_t" />
                        <tspan x="47.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_102_DSK_t" />
                        <tspan x="41.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_102_CPU_v" />
                        <tspan x="44.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_102_MEM_v" />
                        <tspan x="47.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_102_DSK_v" />
                    </text>
                    <svg x="40%" y="140" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_102" ></svg>

                    <rect x="51%" y="80" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_103"></rect>
                    <circle cx="52%" cy="95" r="7" fill="white" id="c_103"></circle>
                    <text x="55.5%" y="100"  text-anchor="middle" font-weight="bold" font-size="14" fill="black" id="t_103">AI #3
                        <tspan x="52.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_103_CPU_t" />
                        <tspan x="55.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_103_MEM_t" />
                        <tspan x="58.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_103_DSK_t" />
                        <tspan x="52.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_103_CPU_v" />
                        <tspan x="55.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_103_MEM_v" />
                        <tspan x="58.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_103_DSK_v" />
                    </text>
                    <svg x="51%" y="140" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_103" ></svg>

                    <rect x="62%" y="80" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_104"></rect>
                    <circle cx="63%" cy="95" r="7" fill="white" id="c_104"></circle>
                    <text x="66.5%" y="100"  text-anchor="middle" font-weight="bold" font-size="14" fill="black" id="t_104">AI #4
                        <tspan x="63.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_104_CPU_t" />
                        <tspan x="66.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_104_MEM_t" />
                        <tspan x="69.5%" y="120" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_104_DSK_t" />
                        <tspan x="63.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_104_CPU_v" />
                        <tspan x="66.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_104_MEM_v" />
                        <tspan x="69.5%" y="130" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_104_DSK_v" />
                    </text>
                    <svg x="62%" y="140" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_104" ></svg>
                </g>

                <!-- Application Server Component -->
                <rect x="6%"  y="310" rx="2" ry="2" width="88%" height="220" fill="#DFDFDF"></rect>
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="7%"  y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_201"></rect>
                    <circle cx="8%" cy="335" r="7" fill="white" id="c_201"></circle>
                    <text x="11.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #1
                        <tspan x="8.5%"  y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_201_CPU_t" />
                        <tspan x="11.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_201_MEM_t" />
                        <tspan x="14.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_201_DSK_t" />
                        <tspan x="8.5%"  y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_201_CPU_v" />
                        <tspan x="11.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_201_MEM_v" />
                        <tspan x="14.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_201_DSK_v" />
                    </text>
                    <svg  x="7%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_201" ></svg>

                    <rect x="18%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_202"></rect>
                    <circle cx="19%" cy="335" r="7" fill="white" id="c_202"></circle>
                    <text x="22.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #2
                        <tspan x="19.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_202_CPU_t" />
                        <tspan x="22.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_202_MEM_t" />
                        <tspan x="25.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_202_DSK_t" />
                        <tspan x="19.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_202_CPU_v" />
                        <tspan x="22.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_202_MEM_v" />
                        <tspan x="25.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_202_DSK_v" />
                    </text>
                    <svg  x="18%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_202" ></svg>

                    <rect x="29%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_203"></rect>
                    <circle cx="30%" cy="335" r="7" fill="white" id="c_203"></circle>
                    <text x="33.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #3
                        <tspan x="30.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_203_CPU_t" />
                        <tspan x="33.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_203_MEM_t" />
                        <tspan x="36.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_203_DSK_t" />
                        <tspan x="30.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_203_CPU_v" />
                        <tspan x="33.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_203_MEM_v" />
                        <tspan x="36.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_203_DSK_v" />
                    </text>
                    <svg  x="29%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_203" ></svg>

                    <rect x="40%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_204"></rect>
                    <circle cx="41%" cy="335" r="7" fill="white" id="c_204"></circle>
                    <text x="44.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #4
                        <tspan x="41.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_204_CPU_t" />
                        <tspan x="44.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_204_MEM_t" />
                        <tspan x="47.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_204_DSK_t" />
                        <tspan x="41.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_204_CPU_v" />
                        <tspan x="44.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_204_MEM_v" />
                        <tspan x="47.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_204_DSK_v" />
                    </text>
                    <svg  x="40%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_204" ></svg>

                    <rect x="51%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_205"></rect>
                    <circle cx="52%" cy="335" r="7" fill="white" id="c_205"></circle>
                    <text x="55.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #5
                        <tspan x="52.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_205_CPU_t" />
                        <tspan x="55.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_205_MEM_t" />
                        <tspan x="58.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_205_DSK_t" />
                        <tspan x="52.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_205_CPU_v" />
                        <tspan x="55.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_205_MEM_v" />
                        <tspan x="58.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_205_DSK_v" />
                    </text>
                    <svg  x="51%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_205" ></svg>

                    <rect x="62%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_206"></rect>
                    <circle cx="63%" cy="335" r="7" fill="white" id="c_206"></circle>
                    <text x="66.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #6
                        <tspan x="63.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_206_CPU_t" />
                        <tspan x="66.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_206_MEM_t" />
                        <tspan x="69.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_206_DSK_t" />
                        <tspan x="63.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_206_CPU_v" />
                        <tspan x="66.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_206_MEM_v" />
                        <tspan x="69.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_206_DSK_v" />
                    </text>
                    <svg  x="62%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_206" ></svg>

                    <rect x="73%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_207"></rect>
                    <circle cx="74%" cy="335" r="7" fill="white" id="c_207"></circle>
                    <text x="77.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #7
                        <tspan x="74.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_207_CPU_t" />
                        <tspan x="77.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_207_MEM_t" />
                        <tspan x="80.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_207_DSK_t" />
                        <tspan x="74.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_207_CPU_v" />
                        <tspan x="77.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_207_MEM_v" />
                        <tspan x="80.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_207_DSK_v" />
                    </text>
                    <svg  x="73%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_207" ></svg>

                    <rect x="84%" y="320" rx="2" ry="2" width="9%" height="200" stroke="black" stroke-width="2" fill="white" id="rect_208"></rect>
                    <circle cx="85%" cy="335" r="7" fill="white" id="c_208"></circle>
                    <text x="88.5%" y="340"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">AP #8
                        <tspan x="85.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_208_CPU_t" />
                        <tspan x="88.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_208_MEM_t" />
                        <tspan x="91.5%" y="360" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_208_DSK_t" />
                        <tspan x="85.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_208_CPU_v" />
                        <tspan x="88.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_208_MEM_v" />
                        <tspan x="91.5%" y="370" tspan-anchor="middle" font-weight="bold" font-size="10" fill="none" id="t_208_DSK_v" />
                    </text>
                    <svg  x="84%" y="380" width="9%" height="140" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" id="svg_208" ></svg>
                </g>

                <!-- ALTIBASE DB Server Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="6%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="10.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ALTIBASE #1</text>
                    <svg x="6%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_IMDB_1" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_IMDB_1" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">IMDB-1</text>
                        <circle id="c_IMDB_GAP_1_2" cx="25%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_1_2"  x="25%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">2</text>
                        <circle id="c_IMDB_GAP_1_3" cx="50%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_1_3"  x="50%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">3</text>
                        <circle id="c_IMDB_GAP_1_4" cx="75%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_1_4"  x="75%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">4</text>
                    </svg>

                    <rect x="16%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="20.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ALTIBASE #2</text>
                    <svg x="16%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_IMDB_2" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_IMDB_2" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">IMDB-2</text>
                        <circle id="c_IMDB_GAP_2_1" cx="25%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_2_1" x="25%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">1</text>
                        <circle id="c_IMDB_GAP_2_3" cx="50%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_2_3" x="50%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">3</text>
                        <circle id="c_IMDB_GAP_2_4" cx="75%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_2_4" x="75%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">4</text>
                    </svg>

                    <rect x="26%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="30.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ALTIBASE #3</text>
                    <svg x="26%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_IMDB_3" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_IMDB_3" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">IMDB-3</text>
                        <circle id="c_IMDB_GAP_3_1" cx="25%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_3_1" x="25%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">1</text>
                        <circle id="c_IMDB_GAP_3_2" cx="50%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_3_2" x="50%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">2</text>
                        <circle id="c_IMDB_GAP_3_4" cx="75%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_3_4" x="75%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">4</text>
                    </svg>

                    <rect x="36%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="40.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ALTIBASE #4</text>
                    <svg x="36%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_IMDB_4" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_IMDB_4" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">IMDB-4</text>
                        <circle id="c_IMDB_GAP_4_1" cx="25%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_4_1" x="25%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">1</text>
                        <circle id="c_IMDB_GAP_4_2" cx="50%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_4_2" x="50%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">2</text>
                        <circle id="c_IMDB_GAP_4_3" cx="75%" cy="65%" r="10" stroke="black" stroke-width="1" fill="white"></circle>
                        <text id="t_IMDB_GAP_4_3" x="75%" y="72%"  text-anchor="middle" font-weight="bold" font-size="12" fill="black">3</text>
                    </svg>
                </g>
<!-- 
                <rect x="4%" y="590" rx="2" ry="2" width="43%" height="30" fill="none" id="rect_IMDB_GAP"></rect>
                <text x="24%" y="610" text-anchor="middle" font-weight="bold" font-size="14" fill="white" id="t_IMDB_GAP"/>
-->

                <!-- ORACLE DB Server Component -->
                <g stroke="none" transform="scale(1, 1)">
                    <rect x="55%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="59.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ORACLE #1</text>
                    <svg x="55%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_NURTP_1" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_NURTP_1" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">NURTP-1</text>
                    </svg>

                    <rect x="65%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="69.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ORACLE #2</text>
                    <svg x="65%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_NURTP_2" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_NURTP_2" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">NURTP-2</text>
                    </svg>
                    <rect x="75%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="79.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ORACLE #3</text>
                    <svg x="75%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_NURTP_3" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_NURTP_3" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">NURTP-3</text>
                    </svg>

                    <rect x="85%" y="550" rx="2" ry="2" width="9%" height="110" stroke="black" stroke-width="2" fill="white"></rect>
                    <text x="89.5%" y="570"  text-anchor="middle" font-weight="bold" font-size="14" fill="black">ORACLE #4</text>
                    <svg x="85%" y="590" width="9%" height="70" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" >
                        <rect id="r_NURTP_4" x="10%" y="10%" rx="3" ry="3" width="80%" height="80%" stroke="black" stroke-width="2" fill="white"></rect>
                        <text id="t_NURTP_4" x="50%" y="35%" text-anchor="middle" font-weight="bold" font-size="14" fill="black">NURTP-4</text>
                    </svg>
                </g>
<!--
                <rect x="53%" y="590" rx="2" ry="2" width="43%" height="30" fill="none" id="rect_PDB_GAP"></rect>
                <text x="73%" y="610" text-anchor="middle" font-weight="bold" font-size="14" fill="white" id="t_PDB_GAP"/>
-->

                <!-- DCB Active Arrow -->
                <line x1="24%" y1="40" x2="24%" y2="66" stroke="none" stroke-width="2" id="l_S_DCB_1_1"/>
                <line x1="24%" y1="65" x2="53%" y2="65" stroke="none" stroke-width="2" id="l_S_DCB_1_2"/>
                <line x1="53%" y1="64" x2="53%" y2="74" stroke="none" stroke-width="2" id="l_S_DCB_1_3"/>
                <svg x="52%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_DCB_1"/>
                </svg>

                <!-- DCB Stand-by Arrow -->
                <line x1="24%" y1="40" x2="24%" y2="66" stroke="none" stroke-width="2" id="l_S_DCB_2_1"/>
                <line x1="24%" y1="65" x2="32%" y2="65" stroke="none" stroke-width="2" id="l_S_DCB_2_2"/>
                <line x1="32%" y1="64" x2="32%" y2="74" stroke="none" stroke-width="2" id="l_S_DCB_2_3"/>
                <svg x="31%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_DCB_2" />
                </svg>

                <!-- OCG Active Arrow -->
                <line x1="37%" y1="40" x2="37%" y2="61" stroke="none" stroke-width="2" id="l_S_OCG_1_1"/>
                <line x1="37%" y1="60" x2="55%" y2="60" stroke="none" stroke-width="2" id="l_S_OCG_1_2"/>
                <line x1="55%" y1="59" x2="55%" y2="74" stroke="none" stroke-width="2" id="l_S_OCG_1_3"/>
                <svg x="54%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_OCG_1"/>
                </svg>

                <!-- OCG Stand-by Arrow -->
                <line x1="37%" y1="40" x2="37%" y2="51" stroke="none" stroke-width="2" id="l_S_OCG_2_1"/>
                <line x1="37%" y1="50" x2="34%" y2="50" stroke="none" stroke-width="2" id="l_S_OCG_2_2"/>
                <line x1="34%" y1="49" x2="34%" y2="74" stroke="none" stroke-width="2" id="l_S_OCG_2_3"/>
                <svg x="33%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_OCG_2" />
                </svg>

                <!--IVR Active Arrow -->
                <line x1="50%" y1="40" x2="50%" y2="56" stroke="none" stroke-width="2" id="l_S_IVR_1_1"/>
                <line x1="50%" y1="55" x2="57%" y2="55" stroke="none" stroke-width="2" id="l_S_IVR_1_2"/>
                <line x1="57%" y1="54" x2="57%" y2="74" stroke="none" stroke-width="2" id="l_S_IVR_1_3"/>
                <svg x="56%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_IVR_1"/>
                </svg>

                <!-- IVR Stand-by Arrow -->
                <line x1="50%" y1="40" x2="50%" y2="56" stroke="none" stroke-width="2" id="l_S_IVR_2_1"/>
                <line x1="50%" y1="55" x2="36%" y2="55" stroke="none" stroke-width="2" id="l_S_IVR_2_2"/>
                <line x1="36%" y1="54" x2="36%" y2="74" stroke="none" stroke-width="2" id="l_S_IVR_2_3"/>
                <svg x="35%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_IVR_2" />
                </svg>

                <!-- CDS Active Arrow -->
                <line x1="63%" y1="40" x2="63%" y2="56" stroke="none" stroke-width="2" id="l_S_CDS_1_1"/>
                <line x1="63%" y1="55" x2="65%" y2="55" stroke="none" stroke-width="2" id="l_S_CDS_1_2"/>
                <line x1="65%" y1="54" x2="65%" y2="74" stroke="none" stroke-width="2" id="l_S_CDS_1_3"/>
                <svg x="64%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_CDS_1"/>
                </svg>

                <!-- CDS Stand-by Arrow -->
                <line x1="63%" y1="40" x2="63%" y2="46" stroke="none" stroke-width="2" id="l_S_CDS_2_1"/>
                <line x1="63%" y1="45" x2="43%" y2="45" stroke="none" stroke-width="2" id="l_S_CDS_2_2"/>
                <line x1="43%" y1="44" x2="43%" y2="74" stroke="none" stroke-width="2" id="l_S_CDS_2_3"/>
                <svg x="42%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_CDS_2" />
                </svg>

                <!-- SDP Active Arrow -->
                <line x1="76%" y1="40" x2="76%" y2="56" stroke="none" stroke-width="2" id="l_S_SDP_1_1"/>
                <line x1="76%" y1="55" x2="67%" y2="55" stroke="none" stroke-width="2" id="l_S_SDP_1_2"/>
                <line x1="67%" y1="54" x2="67%" y2="74" stroke="none" stroke-width="2" id="l_S_SDP_1_3"/>
                <svg x="66%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_SDP_1"/>
                </svg>

                <!-- SDP Stand-by Arrow -->
                <line x1="76%" y1="40" x2="76%" y2="51" stroke="none" stroke-width="2" id="l_S_SDP_2_1"/>
                <line x1="76%" y1="50" x2="45%" y2="50" stroke="none" stroke-width="2" id="l_S_SDP_2_2"/>
                <line x1="45%" y1="49" x2="45%" y2="74" stroke="none" stroke-width="2" id="l_S_SDP_2_3"/>
                <svg x="44%" y="72" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,0 2,0" fill="none" id="tr_S_SDP_2" />
                </svg>

                <!-- AP#3 Server to SDP Arrow -->
                <line x1="33%" y1="319" x2="33%" y2="299" stroke="none" stroke-width="2" id="l_R_SDP_1_1"/>
                <line x1="33%" y1="300" x2="78%" y2="300" stroke="none" stroke-width="2" id="l_R_SDP_1_2"/>
                <line x1="78%" y1="301" x2="78%" y2="42"  stroke="none" stroke-width="2" id="l_R_SDP_1_3"/>
                <svg x="77%" y="34" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,2 2,2" fill="none" id="tr_R_SDP_1"/>
                </svg>

                <!-- AP#5 Server to SDP Arrow -->
                <line x1="55%" y1="319" x2="55%" y2="299" stroke="none" stroke-width="2" id="l_R_SDP_2_1"/>
                <line x1="55%" y1="300" x2="78%" y2="300" stroke="none" stroke-width="2" id="l_R_SDP_2_2"/>
                <line x1="78%" y1="301" x2="78%" y2="42"  stroke="none" stroke-width="2" id="l_R_SDP_2_3"/>
                <svg x="77%" y="34" width="2%" height="14" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewbox="0 0 2 2" >
                    <polygon points="1,1 0,2 2,2" fill="none" id="tr_R_SDP_2"/>
                </svg>
            </svg>
        </div>
        <div id="dashEvent" class="showcase-title-sub" style="border-top:1px solid #bfbfbf;">
            <h5>이벤트 발생 정보</h5>
        </div>
        <div id="csView" class="console-view-panel">
        </div>
    </div>
    <!-- 상태 정보 tool-tip -->
    <div id="d_stTooltip_info" class="quest_info">
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

<script>
    var dashInfoSend = null;
    var dashInfoRecv = null;
    var dashSubInfoRecv = null;
    var dashTimeout  = null;

    var dashInfoParam  = {};
    var dashTreeFilter = null;

    $(document).ready(function()
    {
        // STOMP client 설정
        initDashConn();

        // 화면 Component 초기화
        initAllSvgComp();

        // Tree 구성 시 Loading 표시
        dashSuspendTree();

        // Console Viewer 처리
        $("#csView").empty();

    });

    function initDashConn()
    {
        if ( stompClient == null)
        {
            connect();
        }

        // 사용자 전용 채널이 없을 경우에만 설정
        if (stompConn.dashUser == null)
        {
            stompConn.dashUser = stompClient.subscribe("/user/stomp/resDash", function(msg){
                onDashMsg(msg);
            });
        }

        // 전체 PUSH 채널은 존재하는 경우 해제 후 재생성
        if (stompConn.dashPush != null)
        {
            stompConn.dashPush.unsubscribe();
        }

        stompConn.dashPush = stompClient.subscribe("/stomp/dashView/" + $(':radio[name="d_viewType"]:checked').val(), function(msg){
            onDashMsg(msg);
        });

        dashInfoParam.procType = "reqTreeData";
        dashInfoParam.viewType = $(':radio[name="d_viewType"]:checked').val();
        dashInfoSend = dashInfoParam;

        stompClient.send("/stomp/reqDash", {}, JSON.stringify(dashInfoSend));
    }
    // Tree Loading 처리 로직
    function dashSuspendTree()
    {
        $("#d_treeLoad").text("로딩 중...");
        $("#d_treeLoad").val(true);
        $(':radio[name="d_viewType"]').attr('disabled', 'disabled');
        $("#d_RefreshBtn").attr('disabled', 'disabled');

        dashTimeout = setTimeout(function()
        {
            dashReleaseTree(false);
        }, 3000);
    }

    function onDashMsg(msg)
    {
        if ( msg.body.length > 0 )
        {
            console.log(msg.body);
            dashInfoRecv = JSON.parse(msg.body);
        }

        switch ( dashInfoRecv.procType )
        {
            case "reqDashBoard" :
                drawSvg(dashInfoRecv.jsonData);
                break;

            case "reqFwkInfo" :
                refreshDashFwkStatus(dashInfoRecv.jsonData);
                break;

            case "reqTreeData" :
                if ( dashInfoRecv.dataRefresh === "true" )
                {
                    if ( $("#d_processTreeDiv").fancytree() != null )
                    {
                        $("#d_processTreeDiv").fancytree("destroy");
                    }

                    //console.log(dashInfoRecv.jsonData);
                    // Loading 문구 제거 및 radio 버튼 활성화
                    dashReleaseTree(true);

                    dashLoadTree(dashInfoRecv.jsonData, $(':radio[name="d_viewType"]:checked').val());
                }
                else
                {
                    //console.log(dashInfoRecv.jsonData);
                    updateDashTreeNodes(dashInfoRecv.jsonData);
                }
                break;

            case "pushEventAlert" :
                makeConsoleText(dashInfoRecv.jsonData);
                break;

            default :
                break;
         }
    }

    // Tree Load 완료 시 처리 로직
    function dashReleaseTree(conn)
    {
        clearTimeout(dashTimeout);
        $("#d_RefreshBtn").removeAttr('disabled');

        if ( conn )
        {
            $("#d_treeLoad").text("");
            $("#d_treeLoad").val(true);
            $(':radio[name="d_viewType"]').removeAttr('disabled');
        }
        else
        {
            $("#d_treeLoad").text("연결 끊김 (새로고침 시 재연결 요청)");
            $("#d_treeLoad").val(false);
        }
    }

    // 아이콘 세팅
    function setDashTreeIcon(node, type, status)
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

        if (type != null)
        {
            $(node.span).find("> span.fancytree-icon").text(type.substring(0, 1)).css({"background-color" : color});
        }
    }

    // 노드 타이틀 세팅
    function setDashTreeTitle(node, title, status)
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

        var $span = $(node.span);
        $(node.span).find("> span.fancytree-title").text(title).css({"color": color});
    }

    // Load Tree
    function dashLoadTree(data, dashViewType)
    {
        $("#d_processTreeDiv").fancytree(
        {
            source     : data
          , tabindex   : ""
          , titlesTabbable : false
          , selectMode : 1
          , extensions : [ "filter" ]
          , filter     : {autoExpand: true, counter:false, nodata: true, mode:"hide"}
          , scrollOfs  : {top:50, bottom:0}
          , autoCollapse: false
          , renderNode : function (event, tree)
            {
                tree.node.extraClasses = "dashtree";
                tree.node.renderTitle();
                setDashTreeIcon(tree.node, tree.node.type, tree.node.data.status);
                setDashTreeTitle(tree.node, tree.node.title);
            }
        });

        if ( dashViewType == "GROUP" )
        {
            expandDashTreeNode($("#d_processTreeDiv").fancytree("getRootNode"), 2);
        }
        else
        {
            expandDashTreeNode($("#d_processTreeDiv").fancytree("getRootNode"), 3);
        }

        if ( dashTreeFilter != null && dashTreeFilter != "" )
        {
            procDashTreeFilter();
        }
    }

    // 해당 노드와 자식 노드를 Expand하는 recusive function
    function expandDashTreeNode(node, depth)
    {
        node.setExpanded(true);
        depth--;

        // depth 기준으로 node를 확장 (자식 Node가 존재하지 않는 경우 Skip)
        if ( depth > 0 && node.hasChildren() )
        {
            // Go recursive on child nodes
            expandDashTreeNode(node.getFirstChild(), depth);
        }
    }

    // 변경된 Tree node 갱신
    function updateDashTreeNodes(data)
    {
        if ( data != null )
        {
            $.each(data, function (i, item)
            {
                var node = $("#d_processTreeDiv").fancytree("getTree").getNodeByKey(item.key);

                if ( !node )    return;

                node.data = item;
                setDashTreeIcon(node, node.type, item.status);
                setDashTreeTitle(node, item.title, item.status);
            });
        }
    }

    // Reload Tree
    function dashReloadTree()
    {
    	initDashConn();

        if ( $("#d_processTreeDiv").fancytree() != null )
        {
            $("#d_processTreeDiv").fancytree("destroy");
        }

        dashSuspendTree();
    }

    // Filtering Tree
    function procDashTreeFilter()
    {
        dashTreeFilter = $("#d_input_filter").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
        $("#d_input_filter").val(dashTreeFilter);

        if ( dashTreeFilter != null && dashTreeFilter != "" )
        {
            $("#d_processTreeDiv").fancytree("getTree").filterBranches(dashTreeFilter);
        }
        else
        {
            $("#d_processTreeDiv").fancytree("getTree").clearFilter();
        }
    }

    // Filter 버튼 엔터키 기능 추가
    $("#d_input_filter").keydown(function(e)
    {
        if(e.keyCode == 13)
        {
            procDashTreeFilter();
        }
    });

    // Tree 내 BP 상태 관련 tool-tip 표시
    $("#d_stTooltip").on("click", function ()
    {
        if ( $(this).hasClass("questOn") )
        {
            $(this).removeClass("questOn");
            $("#d_stTooltip_info").hide();
        }
        else
        {
            $(this).addClass("questOn");
            $("#d_stTooltip_info").show();
        }
    });

    // TOPS Framework Info 정보 갱신
    function refreshDashFwkStatus(fwkList)
    {
        if ( !fwkList )    return;

        $("#d_fwk_master").attr("title", "");
        $("#d_fwk_manager").attr("title", "");
        $("#d_fwk_agent").attr("title", "");
        $("#d_fwk_etc").attr("title", "");

        $.each(fwkList, function(i, fwkInfo)
        {
            switch ( fwkInfo.comp_type )
            {
                case "MASTER" :
                    $("#d_fwk_master").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#d_fwk_master").attr("title", $("#d_fwk_master").attr("title") + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류" + "\n" );
                    break;

                case "MANAGER" :
                    $("#d_fwk_manager").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#d_fwk_manager").attr("title", $("d_#fwk_manager").attr("title") + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류" + "\n" );
                    break;

                case "AGENT" :
                    $("#d_fwk_agent").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#d_fwk_agent").attr("title", $("#d_fwk_agent").attr("title") + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류" + "\n" );
                    break;

                case "ETC" :
                    $("#d_fwk_etc").attr("src", "<c:url value="/resources/img/icon/icon_down.png"/>");
                    $("#d_fwk_etc").attr("title", $("#d_fwk_etc").attr("title") + fwkInfo.comp_id + " - " + fwkInfo.sub_comp_id + " 오류" + "\n" );
                    break;

                case "ALL" :
                default :
                    $("#d_fwk_master").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    $("#d_fwk_manager").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    $("#d_fwk_agent").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    $("#d_fwk_etc").attr("src", "<c:url value="/resources/img/icon/icon_normality.png"/>");
                    break;
            }
        });
    }

    function drawSvg(compDataList)
    {
        var maxStat = 0;
        var x_pos = 0;

        $.each(compDataList, function(i, compData)
        {
            // SVG 요소 초기화
            if (i == 0 || (i > 1 && compDataList[i -1].comp_type != compData.comp_type) )
            {
                initSvgComp(compData.comp_type);
            }

            switch ( compData.comp_type )
            {
                case "PROCESS" :
                    if ( i == 0 || (i > 1 && compDataList[i -1].comp_id != compData.comp_id) )
                    {
                        x_pos = 0;
                        tmpCompId = compData.comp_id;
                    }
                    else
                    {
                        x_pos++;
                    }

                    var svg = document.getElementById("svg_" + compData.comp_id);

                    if ( svg != null )
                    {
                        var newRect = document.getElementById("r_" + compData.comp_id + compData.sub_comp_id);
                        var newText = document.getElementById("t_" + compData.comp_id + compData.sub_comp_id);

                        if ( newRect == null )
                        {
                            newRect = document.createElementNS("http://www.w3.org/2000/svg", 'rect');
                            newRect.setAttribute("id", "r_" + compData.comp_id + compData.sub_comp_id);
                            newRect.setAttribute("x", 10);
                            newRect.setAttribute("y", 25 * x_pos);
                            newRect.setAttribute("rx", 2);
                            newRect.setAttribute("ry", 2);
                            newRect.setAttribute("width", "85%");
                            newRect.setAttribute("height", "20");
                            newRect.setAttribute("strokeWidth", "2");
                            newRect.setAttribute("stroke", "black");
                            svg.appendChild(newRect);
                        }

                        if ( newText == null )
                        {
                            newText = document.createElementNS("http://www.w3.org/2000/svg", 'text');
                            newText.setAttribute("id", "t_" + compData.comp_id + compData.sub_comp_id);
                            newText.setAttribute("x", 15);
                            newText.setAttribute("y", 25 * x_pos + 14);
                            newText.setAttribute("anchor", "middle");
                            newText.setAttribute("font-size", "12");
                            newText.textContent = compData.sub_comp_name;
                            svg.appendChild(newText);
                        }

                        switch ( compData.status )
                        {
                            case "PS00" :
                                newRect.setAttribute("fill", "#777777");
                                newText.setAttribute("fill", "black");
                                break;

                            case "PS03" :
                                newRect.setAttribute("fill", "#00BCF5");
                                newText.setAttribute("fill", "white");
                                break;

                            case "PS06" :
                                newRect.setAttribute("fill", "#6100F5");
                                newText.setAttribute("fill", "white");
                                break;

                            default :
                                newRect.setAttribute("fill", "#C12E2E");
                                newText.setAttribute("fill", "white");
                                break;
                        }

                        makeAnimation(newRect);
                        makeAnimation(newText);
                    }
                break;

            case "DATABASE" :
            	/*
                switch ( compData.sub_comp_id )
                {
                    case "GAP" :

                        var dbGapRect = document.getElementById("rect_" + compData.comp_id + "_GAP");
                        var dbGapText = document.getElementById("t_" + compData.comp_id + "_GAP");

                        if ( dbGapRect != null )
                        {
                            if (compData.status != "0")
                            {
                                dbGapRect.setAttribute("fill", "#E10505");
                                dbGapText.textContent = compData.message;
                                makeAnimation(dbGapRect);
                            }
                        }
                        break;

                    default :
                        var dbPath = document.getElementById("p_" + compData.sub_comp_id);

                        if ( dbPath != null )
                        {
                            if (compData.status != "0")
                            {
                                dbPath.setAttribute("fill", "#E10505");
                            }
                            else
                            {
                                dbPath.setAttribute("fill", "#00BCF5");
                            }
                        }

                        makeAnimation(dbPath);
                        break;
                }
                */
                if ( compData.sub_comp_id.indexOf("GAP") > -1 )
                {
                    var dbGapCr = document.getElementById("c_" + compData.sub_comp_id);
                    var dbGapTx = document.getElementById("t_" + compData.sub_comp_id);

                    if ( dbGapCr != null && dbGapTx != null)
                    {
                        switch ( compData.status )
                        {
                            case "0" :
                            	dbGapCr.setAttribute("fill", "white");
                            	dbGapTx.setAttribute("fill", "black");
                                break;

                            case "1" :
                            	dbGapCr.setAttribute("fill", "#FF9000");
                            	dbGapTx.setAttribute("fill", "white");
                                break;

                            case "2" :
                            	dbGapCr.setAttribute("fill", "#C12E2E");
                            	dbGapTx.setAttribute("fill", "white");
                                break;

                            default :
                                break;
                        }

                        makeAnimation(dbGapCr);
                        makeAnimation(dbGapTx);
                    }
                }
                else
                {
                    var dbRect = document.getElementById("r_" + compData.sub_comp_id);
                    var dbText = document.getElementById("t_" + compData.sub_comp_id);

                    if ( dbRect != null && dbText != null )
                    {
                        if (compData.status != "0")
                        {
                        	dbRect.setAttribute("fill",   "#C12E2E");
                        	dbRect.setAttribute("stroke", "#E10505");
                        }
                        else
                        {
                        	dbRect.setAttribute("fill",   "#4472C4");
                        	dbRect.setAttribute("stroke", "#2F528F");
                        }

                        dbText.setAttribute("fill",   "white");
                    }

                    makeAnimation(dbRect);
                    makeAnimation(dbText);
                    break;
                }
                
                break;

            case "NE" :
                var pLn1 = document.getElementById("l_" + compData.comp_id  + "_1_1");
                var pLn2 = document.getElementById("l_" + compData.comp_id  + "_1_2");
                var pLn3 = document.getElementById("l_" + compData.comp_id  + "_1_3");
                var ptr  = document.getElementById("tr_" + compData.comp_id + "_1");

                var sLn1 = document.getElementById("l_" + compData.comp_id  + "_2_1");
                var sLn2 = document.getElementById("l_" + compData.comp_id  + "_2_2");
                var sLn3 = document.getElementById("l_" + compData.comp_id  + "_2_3");
                var str  = document.getElementById("tr_" + compData.comp_id + "_2");

                if ( pLn1 != null && pLn2 != null && pLn3 != null && ptr != null
                  && sLn1 != null && sLn2 != null && sLn3 != null && str != null
                   )
                {
                    // Active / Stand-by를 구분하여 처리
                    switch ( compData.sub_comp_id )
                    {
                        case "1" :
                            if ( compData.status == "0" )
                            {
                                pLn1.setAttribute("stroke", "#28BE6F");
                                pLn1.setAttribute("stroke-width", "2");
                                pLn2.setAttribute("stroke", "#28BE6F");
                                pLn2.setAttribute("stroke-width", "2");
                                pLn3.setAttribute("stroke", "#28BE6F");
                                pLn3.setAttribute("stroke-width", "2");
                                ptr.setAttribute("fill", "#28BE6F");

                                sLn1.setAttribute("stroke", "none");
                                sLn1.setAttribute("stroke-width", "0");
                                sLn2.setAttribute("stroke", "none");
                                sLn2.setAttribute("stroke-width", "0");
                                sLn3.setAttribute("stroke", "none");
                                sLn3.setAttribute("stroke-width", "0");
                                str.setAttribute("fill", "none");

                                makeAnimation(pLn2);
                                makeAnimation(pLn2);
                                makeAnimation(pLn3);
                                makeAnimation(ptr);
                            }
                            break;

                        case "2" :
                            // 기존 Active가 비정상이나 Stand-by가 정상인 경우 일 경우 Stand-by를 정상으로 표기
                            if ( compDataList[i -1] != null && compDataList[i -1].comp_id == compData.comp_id && compDataList[i -1].status != "0" && compData.status == "0" )
                            {
                                pLn1.setAttribute("stroke", "none");
                                pLn1.setAttribute("stroke-width", "0");
                                pLn2.setAttribute("stroke", "none");
                                pLn2.setAttribute("stroke-width", "0");
                                pLn3.setAttribute("stroke", "none");
                                pLn3.setAttribute("stroke-width", "0");
                                ptr.setAttribute("fill", "none");

                                sLn1.setAttribute("stroke", "#027524");
                                sLn1.setAttribute("stroke-width", "2");
                                sLn2.setAttribute("stroke", "#027524");
                                sLn2.setAttribute("stroke-width", "2");
                                sLn3.setAttribute("stroke", "#027524");
                                sLn3.setAttribute("stroke-width", "2");
                                str.setAttribute("fill", "#027524");

                                makeAnimation(sLn1);
                                makeAnimation(sLn2);
                                makeAnimation(sLn3);
                                makeAnimation(str);
                            }
                            // Active / Stand-by 모두 비정상인 경우 일 경우 Active를 비정상으로 표기
                            else if ( compDataList[i -1] != null && compDataList[i -1].comp_id == compData.comp_id && compDataList[i -1].status != "0" && compData.status != "0" )
                            {
                                pLn1.setAttribute("stroke", "#C12E2E");
                                pLn1.setAttribute("stroke-width", "2");
                                pLn2.setAttribute("stroke", "#C12E2E");
                                pLn2.setAttribute("stroke-width", "2");
                                pLn3.setAttribute("stroke", "#C12E2E");
                                pLn3.setAttribute("stroke-width", "2");
                                ptr.setAttribute("fill", "#C12E2E");

                                sLn1.setAttribute("stroke", "none");
                                sLn1.setAttribute("stroke-width", "0");
                                sLn2.setAttribute("stroke", "none");
                                sLn2.setAttribute("stroke-width", "0");
                                sLn3.setAttribute("stroke", "none");
                                sLn3.setAttribute("stroke-width", "0");
                                str.setAttribute("fill", "none");

                                makeAnimation(pLn1);
                                makeAnimation(pLn2);
                                makeAnimation(pLn3);
                                makeAnimation(ptr);
                            }
                            break;
                    }
                }
                break;

            case "SERVER" :
                var compRe = document.getElementById("rect_" + compData.comp_id);
                var compCr = document.getElementById("c_" + compData.comp_id);
                var compTt = document.getElementById("t_" + compData.comp_id + "_" + compData.sub_comp_id + "_t");
                var compTv = document.getElementById("t_" + compData.comp_id + "_" + compData.sub_comp_id + "_v");

                if ( i == 0 || (i > 1 && compDataList[i -1].comp_id != compData.comp_id) )
                {
                    maxStat = compData.status;
                }
                else if ( compData.status > maxStat)
                {
                    maxStat = compData.status;
                }

                if ( compRe != null && maxStat == "3" )
                {
                	compRe.setAttribute("fill", "#C12E2E");

                	if ( compData.sub_comp_id == "MEM" && compTv != null )
                	{
                		compTv.setAttribute("font-size", "16");
                		compTv.setAttribute("fill", "white");
                		compTv.textContent = "SERVER DOWN";
                	}

                    makeAnimation(compRe);
                    makeAnimation(compTv);
                }
                else
                {
                	if ( compCr != null )
                	{ 
                        switch ( maxStat )
                        {
                            case "0" :
                                compCr.setAttribute("fill", "#28BE6F");
                                break;

                            case "1" :
                                compCr.setAttribute("fill", "#FF9000");
                                break;

                            case "2" :
                                compCr.setAttribute("fill", "#C12E2E");
                                break;

                            default :
                                break;
                        }
                    }

                    if (compTt != null && compTv != null)
                    {
                        switch (compData.sub_comp_id)
                        {
                            case "CPU" :
                                compTt.textContent = "CPU";
                                compTv.textContent = compData.stat_value + "%";
                                break;

                            case "MEM" :
                                compTt.textContent = "MEMORY";
                                compTv.textContent = compData.stat_value + "%";
                                break;

                            case "DSK" :
                                compTt.textContent = "DISK";
                                compTv.textContent = compData.stat_value + "%";
                                break;

                            default :
                                break;
                        }

                        switch ( compData.status )
                        {
                            case "0" :
                                compTt.setAttribute("fill", "#28BE6F");
                                compTv.setAttribute("fill", "#28BE6F");
                                break;

                            case "1" :
                                compTt.setAttribute("fill", "#FF9000");
                                compTv.setAttribute("fill", "#FF9000");
                                break;

                            case "2" :
                                compTt.setAttribute("fill", "#C12E2E");
                                compTv.setAttribute("fill", "#C12E2E");
                                break;

                            default :
                                break;
                        }
                    }

                    makeAnimation(compCr);
                    makeAnimation(compTt);
                    makeAnimation(compTv);
                }
                break;

            case "NAS" :
            default :
                var nasCrcl = document.getElementById("c_" + compData.comp_id);
                var nasText = document.getElementById("t_" + compData.comp_id);
                if ( nasCrcl != null )
                {
                    switch ( compData.status )
                    {
                        case "0" :
                            nasCrcl.setAttribute("fill", "#28BE6F");
                            nasText.setAttribute("fill", "#28BE6F");
                            break;

                        case "1" :
                            nasCrcl.setAttribute("fill", "#FF9000");
                            nasText.setAttribute("fill", "#FF9000");
                            break;

                        case "2" :
                        default :
                            nasCrcl.setAttribute("fill", "#C12E2E");
                            nasText.setAttribute("fill", "#C12E2E");
                            break;
                    }

                    nasText.textContent = compData.stat_value + "%";

                    makeAnimation(nasCrcl);
                    makeAnimation(nasText);
                }
                break;
            }
        });
    }

    function initAllSvgComp()
    {
        initSvgComp("PROCESS");
        initSvgComp("DATABASE");
        initSvgComp("NE");
        initSvgComp("SERVER");
        initSvgComp("NAS");
    }

    function initSvgComp(compType)
    {
        var svCompArr = ["101", "102", "103", "104", "201", "202", "203", "204", "205", "206", "207", "208"];
        var svSubCArr = ["CPU", "MEM", "DSK"];
        var dbCompArr = ["IMDB_1", "IMDB_2", "IMDB_3", "IMDB_4", "NURTP_1", "NURTP_2", "NURTP_3", "NURTP_4"];
        var dbGapArr  = ["IMDB_GAP_1_2", "IMDB_GAP_1_3", "IMDB_GAP_1_4", "IMDB_GAP_2_1", "IMDB_GAP_2_3", "IMDB_GAP_2_4", "IMDB_GAP_3_1", "IMDB_GAP_3_2", "IMDB_GAP_3_4", "IMDB_GAP_4_1", "IMDB_GAP_4_2", "IMDB_GAP_4_3"];
        var nwCompArr = ["S_DCB", "S_OCG", "S_IVR", "S_CDS", "S_SDP", "R_SDP"];

        switch ( compType )
        {
            case "PROCESS" :
                // SVG Component 초기화
                var parentCp = null;
                var cloneSvg = null;

                $.each(svCompArr, function(i, svComp)
                {
                    if ( document.getElementById("svg_" + svComp) != null)
                    {
                        parentCp = document.getElementById("svg_" + svComp).parentNode;
                        cloneSvg = document.getElementById("svg_" + svComp).cloneNode(false);

                        parentCp.removeChild(document.getElementById("svg_" + svComp));
                        parentCp.appendChild(cloneSvg);
                    }
                });
                break;

            case "DATABASE" :
                // DB Component 초기화
                $.each(dbCompArr, function(i, dbComp)
                {
                    if (document.getElementById("r_" + dbComp) != null)
                    {
                        document.getElementById("r_" + dbComp).setAttribute("fill",   "white");
                        document.getElementById("r_" + dbComp).setAttribute("stroke", "black");
                    }

                    if (document.getElementById("t_" + dbComp) != null)
                    {
                        document.getElementById("t_" + dbComp).setAttribute("fill", "black");
                    }
                });

                // DB GAP Component 초기화
                $.each(dbGapArr, function(i, dbGapComp)
                {
                    if (document.getElementById("c_" + dbGapComp) != null)
                    {
                        document.getElementById("c_" + dbGapComp).setAttribute("fill", "none");
                    }

                    if (document.getElementById("t_" + dbGapComp) != null)
                    {
                        document.getElementById("t_" + dbGapComp).setAttribute("fill", "black");
                    }

                });
                break;

            case "NE" :
                // Arrow Component 초기화
                $.each(nwCompArr, function(i, nwComp)
                {
                    for (var tlp = 0 ; tlp < 2; tlp++)
                    {
                        for (var lc = 0 ; lc < 3; lc++)
                        {
                            if (document.getElementById("l_"  + nwComp + "_" + tlp + "_" + lc) != null)
                            {
                                document.getElementById("l_"  + nwComp + "_" + tlp + "_" + lc).setAttribute("stroke", "none");
                                document.getElementById("l_"  + nwComp + "_" + tlp + "_" + lc).setAttribute("stroke-width", "0");
                            }
                        }

                        if (document.getElementById("t_"  + nwComp + "_" + tlp) != null)
                        {
                            document.getElementById("t_"  + nwComp + "_" + tlp).setAttribute("fill", "none");
                        }
                    }
                });
                break;

            case "SERVER" :
                // 서버별 Circle Component 초기화
                $.each(svCompArr, function(i, svComp)
                {
                    if (document.getElementById("rect_" + svComp) != null)
                    {
                        document.getElementById("rect_" + svComp).setAttribute("fill", "white");
                    }

                    if (document.getElementById("c_" + svComp) != null)
                    {
                        document.getElementById("c_" + svComp).setAttribute("fill", "none");
                    }

                    $.each(svSubCArr, function(i, svSub)
                    {
                        if (document.getElementById("t_" + svComp + "_" + svSub + "_t") != null)
                        {
                            document.getElementById("t_" + svComp + "_" + svSub + "_t").setAttribute("fill", "none");
                        }

                        if (document.getElementById("t_" + svComp + "_" + svSub + "_v") != null)
                        {
                            document.getElementById("t_" + svComp + "_" + svSub + "_v").setAttribute("fill", "none");
                            document.getElementById("t_" + svComp + "_" + svSub + "_v").setAttribute("font-size", "10");
                        }
                    });
                });
                break;

            case "NAS" :
                // NAS Component 초기화
                if (document.getElementById("c_NAS") != null)
                {
                    document.getElementById("c_NAS").setAttribute("fill", "none");
                }

                if (document.getElementById("t_NAS") != null)
                {
                    document.getElementById("t_NAS").setAttribute("fill", "none");
                }
                break;

            default :
                break;
        }
    }

    function makeAnimation(svgObj)
    {
        if ( svgObj == null ) return;

        var animation = document.getElementById(svgObj.id + "_ani");

        if( animation != null )
        {
            animation.endElement();
        }
        else
        {
            animation = document.createElementNS("http://www.w3.org/2000/svg", "animate");

            if (svgObj.tagName != "line")
            {
                animation.setAttributeNS(null, "attributeName", "fill-opacity");
                animation.setAttributeNS(null, "begin", "indefinite");
                animation.setAttributeNS(null, "from", "0");
                animation.setAttributeNS(null, "to", "1");
                animation.setAttributeNS(null, "dur", "0.5");
                animation.setAttributeNS(null, "fill", "freeze");
                animation.setAttributeNS(null, "id", svgObj.id + "_ani");
                svgObj.appendChild(animation);
            }
            else
            {
                animation.setAttributeNS(null, "attributeName", "stroke-dasharray");
                animation.setAttributeNS(null, "begin", "indefinite");
                animation.setAttributeNS(null, "from", "0");
                animation.setAttributeNS(null, "to", "1000");
                animation.setAttributeNS(null, "dur", "0.5");
                animation.setAttributeNS(null, "id", svgObj.id + "_ani");
                svgObj.appendChild(animation);
            }
        }

        animation.beginElement();
    }

    function makeConsoleText(eventInfo)
    {
        var csViewText =  "(" + eventInfo.event_name + ") "
                        + "[" + eventInfo.event_time.substring(0, 4)
                        + "-" + eventInfo.event_time.substring(4, 6)
                        + "-" + eventInfo.event_time.substring(6, 8)
                        + " " + eventInfo.event_time.substring(8, 10)
                        + ":" + eventInfo.event_time.substring(10, 12)
                        + ":" + eventInfo.event_time.substring(12, 14) + "] "
                        + "(" + eventInfo.bp_id + " / " + eventInfo.bm_id + ") "
                        + eventInfo.message
                        ;
        csViewText = csViewText.replace(/\n/g, "");

        if ( $("#csView > span").length >= 100)
        {
            $('#csView').find('span').first().remove();
            $('#csView').find('br').first().remove();
        }

        if ( $("#csView > span").length != 0)
        {
            $("#csView").append("<br>");
        }

        $("#csView").append("<span>" + csViewText + '</span>');
        $("#csView").scrollTop($("#csView").height());
    }
</script>