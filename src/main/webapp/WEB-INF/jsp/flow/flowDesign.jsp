<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<link href="<c:url value="/resources/css/vendor/joint/joint.min.css"/>" rel="stylesheet" media="screen">
<link href="<c:url value="/resources/css/flow-design.css"/>" rel="stylesheet" media="screen">

<style type="text/css">
.ui-dialog
{
    z-index: 10000 !important;
}

/* Overlays */
.ui-widget-overlay
{
    background: #000;
    opacity: .5;
}

.ui-button-text
{
    padding: 0;
}

#processProperties
{
    width: 342px;
    position: absolute;
    top: 40px;
    right: -342px;
    background: #2D353E;
    padding-bottom: 8px;
}

#processProperties>h5
{
    font-size: 14px;
    color: #FFF;
    margin: 7px;
    text-align: center;
}

.input-dark
{
    color: #FFF !important;
    background-color: #333 !important;
}
</style>


<div id="flow-container">

    <div id="explorer-container">
<!-- 20180510 BP 또는 BM 은 기준정보 통하여 처리하는 것으로 처리
        <div id="bp-group-explorer">
            <div class="btn-wrap">
                <div class="new-btn" onclick="popupBpGroupInfoRegisterForm();"></div>
            </div>
    <c:if test="${not empty bpGroupList}">
        <c:forEach var="bpGroup" items="${bpGroupList}" varStatus="status">
            <div class="bp-group closed" data-name="${bpGroup}">
                <div class="bp-group-label">
                    <div class="bp-group-name">${bpGroup}</div>
                    <div class="bp-group-setting" onclick="popupBpGroupInfoModifyForm('${bpGroup}')"></div>
                </div>
                <div class="bp-explorer">
                    <div class="btn-wrap">
                        <div class="new-btn" onclick="popupBpInfoRegisterForm('${bpGroup}');"></div>
                    </div>
                    <div class="bp-list">
                    </div>
                </div>
            </div>
        </c:forEach>
    </c:if>
        </div>
        <div id="bm-explorer">
            <span id="bm-arrow"><img src="<c:url value="/resources/img/icon/flow/bm_arrow_left.png"/>"></span>
            <div class="btn-wrap">
                <div class="new-btn" onclick="popupBmInfoRegisterForm();"></div>
            </div>
            <div id="bm-setting-list"></div>
            <div id="stencil-container"></div>
        </div>
-->
    </div>

    <div id="paper-container">
        <div id="button-wrapper">
<!-- 20180510 Flow 변경 처리 불가 하도록 로직 수정
            <button type="button" id="cloneBtn" class="btn btn-green flow-copy-btn btn_operation">Flow 복제</button>
            <button type="button" id="saveBtn" class="btn btn-search flow-normal-btn btn_operation">저장</button>
            <button type="button" id="removeBtn" class="btn btn-gray flow-normal-btn btn_operation">삭제</button>
            <button type="button" id="listBtn" class="btn btn-gray flow-normal-btn">목록</button>
-->
            <button type="button" id="listBtn" class="btn btn-search btn_operation">목록</button>
        </div>
        <div id="paper-wrapper">
            <div id="paper"></div>
        </div>
    </div>

    <div id="processProperties">
        <h5>Properties</h5>
        <table class="property-table">
            <colgroup>
                <col width="30px" />
                <col width="100px" />
                <col width="211px" />
            </colgroup>
            <tbody>
                <tr>
                    <th rowspan="3">BP</th>
                    <td>ID</td>
                    <td id="bpIdProp"></td>
                </tr>
                <tr>
                    <td>Name</td>
                    <td id="bpNameProp"></td>
                </tr>
                <tr>
                    <td>Parameter</td>
                    <td>
                        <textarea id="parameterProp" rows="3" cols="10" class="form-control w100 input-dark"></textarea>
                    </td>
                </tr>
                <tr>
                    <th rowspan="4">BM</th>
                    <td>ID</td>
                    <td id="bmIdProp"></td>
                </tr>
                <tr>
                    <td>Name</td>
                    <td id="bmNameProp"></td>
                </tr>
                <tr>
                    <td>Min Thread Instance</td>
                    <td>
                        <input type="text" id="minThreadInstanceProp" class="form-control02 w100 input-dark" />
                    </td>
                </tr>
                <tr>
                    <td>Max Thread Instance</td>
                    <td>
                        <input type="text" id="maxThreadInstanceProp" class="form-control02 w100 input-dark" />
                    </td>
                </tr>
                <tr>
                    <th colspan="2">Flow Type</th>
                    <td>
                    <c:if test="${not empty flowTypeCodeList}">
                    <c:forEach var="flowTypeCode" items="${flowTypeCodeList}" varStatus="status">
                        <label class="radio-inline">
                            <input type="radio" name="flowTypeProp" value="${flowTypeCode.code}"<c:if test="${status.first}"> checked="checked"</c:if> />${flowTypeCode.code_name}
                        </label>
                    </c:forEach>
                    </c:if>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="property-btn">
            <button type="button" onclick="saveProcessProperties()" class="btn btn-search flow-normal-btn btn_operation">저장</button>
            <button type="button" onclick="hideProcessProperties()" class="btn btn-gray flow-normal-btn btn_operation">취소</button>
        </div>
    </div>

</div>
<!-- 
<div id="cloneFlowDialog" title="복제로 구성할 Flow 선택">
    <div class="form-container">
        <div class="com-01 mT5">
            <div>
                <table id="flowGridForClone" class="table table-blue">
                </table>
            </div>
        </div>
    </div>
</div>
 -->
<script src="<c:url value="/resources/js/vendor/keyboardjs/keyboard.js"/>"></script>
<script src="<c:url value="/resources/js/joint-extensions/joint.ui.paperScroller.js"/>"></script>
<script src="<c:url value="/resources/js/joint-extensions/joint.ui.stencil.js"/>"></script>
<script src="<c:url value="/resources/js/joint-extensions/joint.ui.selectionView.js"/>"></script>
<script src="<c:url value="/resources/js/joint-extensions/joint.ui.halo.js"/>"></script>

<script type="text/javascript">

    var spinObj = null;

    /* 2016.07.14 Chrome 48 이후 SVGGraphicsElement.getTransformToElement 삭제로 joint.js 이상 작용에 대한 임시 해결 방안 적용
     * 참조 : http://jointjs.com/blog/get-transform-to-element-polyfill.html
     */
    SVGElement.prototype.getTransformToElement = SVGElement.prototype.getTransformToElement || function(toElement)
    {
        return toElement.getScreenCTM().inverse().multiply(this.getScreenCTM());
    };

    var graph = new joint.dia.Graph;

    var paperScroller = new joint.ui.PaperScroller({
        autoResizePaper : true
    });

    var paper = new joint.dia.Paper({
        el : paperScroller.el,
        width : 1000,
        height : 500,
        gridSize : 10,
        perpendicularLinks : true,
        model : graph
    });
    paperScroller.options.paper = paper;
    $("#paper").append(paperScroller.render().el);

    var stencil = new joint.ui.Stencil({
        graph : graph,
        paper : paper,
        width : 130,
        height : 450
    });

    $("#stencil-container").append(stencil.render().el);

    joint.shapes.process = {};
    joint.shapes.process.Entity = joint.shapes.basic.Generic.extend({
        markup: '<g class="rotatable"><g class="scalable"><rect/></g><text class="bp-name-text"/><text class="bm-name-text"/></g>',

        defaults: joint.util.deepSupplement({
            type: 'entity',
            attrs: {
                'rect': {
                    width: 90,
                    height: 40,
                    rx : 2,
                    ry : 2,
                    stroke: '#31C5F0',
                    'stroke-width' : 2,
                    fill: {
                        type: 'linearGradient',
                        stops: [
                            { offset: '1.82%', color: '#303E45' },
                            { offset: '100%', color: '#05151F' }
                        ],
                        attrs: { x1: '0%', y1: '0%', x2: '100%', y2: '100%' }
                    }
                },
                '.bp-name-text': { 'font-size': 10, text: '', 'ref-x': .5, 'ref-y': .3, ref: 'rect', 'y-alignment': 'middle', 'x-alignment': 'middle', fill: '#31C5F0', 'font-family': 'Arial, helvetica, sans-serif' },
                '.bm-name-text': { 'font-size': 14, text: '', 'ref-x': .5, 'ref-y': .7, ref: 'rect', 'y-alignment': 'middle', 'x-alignment': 'middle', fill: '#31C5F0', 'font-family': 'Arial, helvetica, sans-serif' }
            }
        }, joint.shapes.basic.Generic.prototype.defaults)
    });

    var bmEl = new joint.shapes.process.Entity({
        position : { x : 10, y : 5 },
        size : { width : 90, height : 38 }
    });

    var selection = new Backbone.Collection;

    var selectionView = new joint.ui.SelectionView({
        paper : paper,
        graph : graph,
        model : selection
    });

    // Flow Diagram에서 선택된 Element
    var selectedElement;

    $(function() {
    	
    	// spin 처리
    	spinObj = startSpin("paper-container");

        paper.on("blank:pointerdown", function(evt, x, y) {
            hideProcessProperties();

            if (_.contains(KeyboardJS.activeKeys(), 'shift')) {
                selectionView.startSelecting(evt, x, y);
            } else {
                paperScroller.startPanning(evt, x, y);
            }
        });

        paper.on("cell:pointerdown", function(cellView, evt) {
            // Select an element if CTRL/Meta key is pressed while the element is clicked.
            if ((evt.ctrlKey || evt.metaKey)
                    && !(cellView.model instanceof joint.dia.Link)) {
                selectionView.createSelectionBox(cellView);
                selection.add(cellView.model);
            }
        });

        selectionView.on("selection-box:pointerdown", function(evt) {
            // Unselect an element if the CTRL/Meta key is pressed while a selected element is clicked.
            if (evt.ctrlKey || evt.metaKey) {
                var cell = selection.get($(evt.target).data('model'));
                selectionView.destroySelectionBox(paper.findViewByModel(cell));
                selection.reset(selection.without(cell));
            }
        });

        // Flow Process Entity 클릭 시 Process Properties 창을 연다.
        paper.on("cell:pointerup", function(cellView, evt) {
        	
            if (cellView.model instanceof joint.dia.Link || selection.contains(cellView.model))
                return;

            var halo = new joint.ui.Halo({
                graph : graph,
                paper : paper,
                cellView : cellView,
                linkAttributes : {
                    '.marker-source' : { d : 'M 10 0 L 0 5 L 10 10 z', transform : 'scale(0.001)' },
                    '.marker-target' : { d : 'M 10 0 L 0 5 L 10 10 z' }
                }
            });

            halo.render();

            selectedElement = cellView.model;
            var entity = selectedElement.attributes;

            // 선택한 Element의 정보를 Process Properties 창에 설정한다.
            $("#bpIdProp").text(entity.bp.bp_id);
            $("#bpNameProp").text(entity.bp.bp_name);
            $("#parameterProp").val(entity.bp.parameter);
            $("#bmIdProp").text(entity.bm.bm_id);
            $("#bmNameProp").text(entity.bm.bm_name);
            
            if (entity.bm.min_thread_instance <= 0)
            {
                entity.bm.min_thread_instance = 1;
            }

            $("#minThreadInstanceProp").val(entity.bm.min_thread_instance);

            if (entity.bm.max_thread_instance < entity.bm.min_thread_instance)
            {
                entity.bm.max_thread_instance = entity.bm.min_thread_instance;
            }

            $("#maxThreadInstanceProp").val(entity.bm.max_thread_instance);

            /*
            if (entity.flowType != "")
            {
                $("input:radio[name='flowTypeProp']").removeAttr("checked");
                $("input:radio[name='flowTypeProp'][value='" + entity.flowType + "']").prop("checked", true);
            }
            */

            showProcessProperties();
        });

        var cloneYn = "N";

        loadFlowDiagram("${flow_id}", "${group_id}", "${system_id}", cloneYn);

        // BP 그룹명 클릭시 Toggle
        $(".bp-group-name").click(function(evt)
        {
            evt.preventDefault();

            var $bpGroup = $(evt.target).closest(".bp-group");
            var bpGroup = $bpGroup.data("name");
            toggleBpGroup(bpGroup);
            closeBpGroupOthers(bpGroup);
        });

        // 페이지 Load 시 첫번째 BP Group을 Toggle한다.
        var $firstBpGroup = $(".bp-group:first");
        toggleBpGroup($firstBpGroup.data("name"));

        // 복제 대상 Group 리스트 Modal 창 설정
        $("#cloneFlowDialog").dialog({
            autoOpen: false,
            width: 850,
            height: 400,
            zIndex: 10000,
            modal: true,
            buttons: {
                "복제": cloneFlow,
                "닫기": function() {
                    $(this).dialog("close");
                }
            },
            create: function () {
                var $cloneBtn = $(this).closest(".ui-dialog").find(".ui-button").eq(1); // 복제 버튼
                var $closeBtn = $(this).closest(".ui-dialog").find(".ui-button").eq(2); // 취소 버튼
                $cloneBtn.addClass("btn-clone");
                $cloneBtn.find("> span").removeAttr("class");
                $closeBtn.addClass("btn-clone");
                $closeBtn.find("> span").removeAttr("class");
            },
            close: function() {
                //$("#Form")[0].reset();
            }
        });

        // Flow 복제 버튼 클릭
        /*
        $("#cloneBtn").click(function() {
            $("#cloneFlowDialog").dialog("open");

            $("#flowGridForClone").jqGrid({
                url: "${pageContext.request.contextPath}/flow/groupInfoList",
                datatype: "json",
                mtype : "post",
                contentType: 'application/json',
                width: 810,
                height: 250,
                viewrecords: true,
                shrinkToFit : true,
                loadonce: true,
                rowNum: 10000,
                jsonReader : {
                     root : "groupInfoList"
                },
                colModel : [
                    {
                        label: '선택',
                        name : 'id',
                        width:50,
                        align:'center',
                        sortable: false,
                        formatter: function (cellValue, options, rowObject) {
                            var flow_id = rowObject.flow_id == null ? "" : rowObject.flow_id;
                            return '<input type="radio" id="clone_flow_id'+options.rowId+'" name="clone_flow" value="' + flow_id + '"  />';
                        }
                    },
                    { label: 'Flow ID', name : 'flow_id', index:'flow_id', width:80, align:'center'},
                    { label: '그룹ID', name : 'group_id', index:'group_id',  width:50,  align:'center', key: true },
                    { label: '그룹명', name : 'group_name',  index:'group_name',  width:100,  align:'center'},
                    { label: 'Service', name : 'ui_lcl_nm',  index:'ui_lcl_nm',  width:80,  align:'center'},
                    { label: 'Service Type', name : 'ui_mcl_nm',  index:'ui_mcl_nm',  width:80,  align:'center'},
                    { label: 'N/W Equipment', name : 'ui_scl_nm',  index:'ui_scl_nm',  width:80,  align:'center'},
                    { label: 'Switch Type', name : 'switch_type',  index:'switch_type',  width:80,  align:'center'},
                    { label: '설명', name : 'description',  index:'description',  width:150,  align:'center'}
                ],
                onSelectRow: function(id, status){
                    $('#sourceFlowId'+id).prop('checked',true);
                    //selectGroupInfoUid(id);
                }
            });
        });
        */

        // 저장 버튼 클릭
        $("#saveBtn").click(function() {
            saveFlow();
        });

        // 삭제 버튼 클릭
        $("#removeBtn").click(function() {
            if (confirm("정말 삭제하시겠습니까?") == false) {
                return;
            }

            $.ajax({
                cache : false,
                type : "post",
                url : "${pageContext.request.contextPath}/flow/removeFlow",
                data : {
                    group_id : "${group_id}",
                    flow_id  : "${flow_id}"
                },
                success : function(result) {
                    var resultCode = result.resultCode;
                    if(resultCode == "0") {
                        alert("Flow를 삭제하였습니다.");
                        goGroupList();
                    } else {
                        showModal(result.resultMessage);
                    }
                },
                error : function(e) {
                    showModal("삭제 중 오류가 발생했습니다.");
                },
                timeout : 10000
            });
        });

        // 목록 버튼 클릭
        $("#listBtn").click(function() {
            if (confirm("목록 화면으로 이동하시겠습니까?") == false) {
                return;
            }
            goGroupList();
        });
    });

    // 마우스 클릭시 이벤트 처리
    $(document).mouseup(function(e) {
        // BM 탐색기 외부 영역을 클릭하면 BM 탐색기를 닫는다.
        var $bmExplorer = $("#bm-explorer");
        if (!$bmExplorer.is(e.target) && $bmExplorer.has(e.target).length === 0) {
            $(".bp-explorer > .bp-list > .bp > div").each(function() {
                $(this).removeClass("active");
                $(this).removeClass("active-icon");
            });
            $bmExplorer.hide();
        }
    });

    // Scroll하면 BM 탐색기를 닫는다.
    $(".panel-body").scroll(function() {
        hideBmExplorer();
    });
    $(".paper-scroller").scroll(function() {
        hideBmExplorer();
    });

    // BM 탐색기 닫기
    function hideBmExplorer() {
        $(".bp-explorer > .bp-list > .bp > div").each(function() {
            $(this).removeClass("active");
            $(this).removeClass("active-icon");
        });
        $("#bm-explorer").hide();
    }

    // BP Group Toggle
    function toggleBpGroup(bpGroup) {
        var $bpGroup = $(".bp-group[data-name='" + bpGroup + "']");
        if ($bpGroup.hasClass("closed")) {
            $(".bp-group[data-name='" + bpGroup + "']").find("> .bp-explorer > .bp-list").empty();
            loadBpList(bpGroup);
        }
        $bpGroup.toggleClass("closed");
    }

    // Toggle한 것 외의 다른 BP Group 접기
    function closeBpGroupOthers(bpGroup) {
        $(".bp-group[data-name!='" + bpGroup + "']").addClass("closed");
    }

    // BP 리스트 Load
    function loadBpList(bpGroup) {
    	/*
        $.ajax({
            cache : false,
            type : "get",
            url : "${pageContext.request.contextPath}/flow/getBpList",
            data : {
                bpGroup : bpGroup,
                switchType : "${switchType}",
                group_id    : "${group_id}"
            },
            success : function(data) {
                if (data != null) {
                    var $bpList = $(".bp-group[data-name='" + bpGroup + "']").find("> .bp-explorer > .bp-list");
                    $bpList.empty();
                    $.each(data, function(i, item) {
                        var $bp = "<div class=\"bp\">";
                        $bp += "<div class=\"bp-setting\" onclick=\"popupBpInfoModifyForm('" + item.bp_id + "');\"></div>";
                        $bp += "<div class=\"normal\" onclick=\"loadBmList('" + item.bpGroup + "', '" + item.bp_id + "', '" + item.bpName + "', this);\">" + item.bpName + "</div>";
                        $bp += "</div>";
                        $bpList.append($bp);
                    });
                }
            },
            error : function(e) {
                showModal("BP 목록 조회 중 오류가 발생했습니다.");
            },
            timeout : 10000
        });
    	*/
    }

    var TARGET_BP_GROUP = '';

    // BM 리스트 Load
    function loadBmList(bpGroup, bpId, bpName, $bp) {

        TARGET_BP_GROUP = bpGroup;  // 선택한 BG GROUP을 임시로 담아둠

        $.ajax({
            cache : false,
            type : "get",
            url : "${pageContext.request.contextPath}/flow/getBmList",
            data : {
                bpGroup : bpGroup,
                group_id    : "${group_id}"
            },
            success : function(data) {
                var system_id = data.system_id;
                var bmList = data.bmList;
                if (bmList != null) {
                    $("#bm-setting-list").empty();
                    showBmExplorer($bp);

                    var bmArray = [];
                    $.each(bmList, function(i, item) {
                        var bm = bmEl.clone();
                        bm.get("attrs")[".bp-name-text"].text = system_id + " / " + bp_name;
                        bm.get("attrs")[".bm-name-text"].text = item.bp_name;
                        bm.translate(0, 55 * i);
                        bm.prop("flow_id",   "${flow_id}");
                        bm.prop("System_id", system_id);
                        bm.prop("group_id",  "${group_id}");
                        bm.prop("bp", {"bp_id" : bp_id, "bp_name" : bp_name, "parameter" : ""});
                        bm.prop("bm", {"bm_id" : item.bm_id, "bm_name" : item.bm_name, "min_thread_instance" : 0, "max_thread_instance" : 0});
                        bm.prop("flowType", "");
                        //console.log(bm);

                        bmArray.push(bm);
                        //console.log(i + " : " + item.bmId + " : " + item.bmName);

                        $("#bm-setting-list").append("<div id=\"bm_" + item.bm_id + "\" class=\"bm-setting\" onclick=\"popupBmInfoModifyForm('" + item.bm_id + "');\"></div>");
                        var $bmSetting = $("#bm_" + item.bm_id);
                        $bmSetting.css({
                            top : 43 + 55 * i
                        });
                    });
                    stencil.load(bmArray);
                }
            },
            error : function(e) {
                showModal("BM 목록 조회 중 오류가 발생했습니다.");
            },
            timeout : 10000
        });
    }

    // BM 탐색기 열기
    function showBmExplorer(bp) {
        var posTop = $(bp).position().top;

        $(bp).parent().find("> .bp-setting").addClass("active-icon");
        $(bp).addClass("active");

        $("#bm-explorer").css({
            top : posTop - 60
        }).show();
    }

    // 저장된 Flow Diagram Load
    function loadFlowDiagram(flow_id, group_id, system_id, cloneYn)
    {
        $.ajax({
            cache : false,
            type : "get",
            url : "${pageContext.request.contextPath}/flow/getDiagram",
            data : {
            	flow_id   : flow_id,
                group_id  : group_id,
                system_id : system_id,
                cloneYn   : cloneYn
            },
            success : function(data) {
                if (data != null) {
                    var cells = data.cells;
                    if (cells != null) {
                        $.each(cells, function(i, item) {
                            if (item.type == "entity") {
                                var entity = bmEl.clone();
                                entity.set("id", item.id);
                                entity.get("attrs")[".bp-name-text"].text = item.system_id + " / " + item.group_id;
                                entity.get("attrs")[".bm-name-text"].text = item.bm.bm_id + "(" + item.bm.bm_name + ")";
                                entity.translate(item.position.x, item.position.y);
                                entity.prop("flow_id",   item.flow_id);
                                entity.prop("system_id", item.system_id);
                                entity.prop("group_id",  item.group_id);
                                entity.prop("bp", {"bp_id" : item.bp.bp_id, "bp_name" : item.bp.bp_name, "parameter" : item.bp.parameter});
                                entity.prop("bm", {"bm_id" : item.bm.bm_id, "bm_name" : item.bm.bm_name, "min_thread_instance" : item.bm.min_thread_instance, "max_thread_instance" : item.bm.max_thread_instance});
                                entity.prop("flowType", item.flowType);

                                graph.addCell(entity);
                            }
                        });
                        $.each(cells, function(i, item) {
                            if (item.type == "link") {
                                var link = new joint.dia.Link({
                                    source: { id: item.source.id }
                                  , target: { id: item.target.id }
                                });
                                link.attr({
                                    '.connection': { stroke: 'black' },
                                    '.marker-source': { fill: 'black', d: 'M 10 0 L 0 5 L 10 10 z', transform: 'scale(0.001)' },
                                    '.marker-target': { fill: 'black', d: 'M 10 0 L 0 5 L 10 10 z' }
                                });

                                graph.addCell(link);
                            }
                        });

                        stopSpin(spinObj);

                        $(".paper-scroller").scrollTop(0);
                        $(".paper-scroller").scrollLeft(0);
                        $(".panel-body").scrollTop(0);
                        $(".panel-body").scrollLeft(0);
                    }
                }
            },
            error : function(e) {
                // console.log(e);
                showModal("조회 중 오류가 발생했습니다.");
            },
            timeout : 10000
        });
    }

    // Process Properties 창 보이기
    function showProcessProperties() {
        $("#processProperties").animate({
            right: 35,
            opacity: 1
        }, 200);
    }

    // Process Properties 창 숨기기
    function hideProcessProperties() {
        $("#processProperties").animate({
            right : -342
        });
    }

    // Process Properties 저장
    function saveProcessProperties() {
        var parameter = $("#parameterProp").val();
        parameter = parameter.replace(/(\r\n|\n|\r)/gm,""); // CRLF 공백 치환
        selectedElement.prop("bp/parameter", parameter);
        selectedElement.prop("bm/min_thread_instance", $("#minThreadInstanceProp").val());
        selectedElement.prop("bm/max_thread_instance", $("#maxThreadInstanceProp").val());
        //selectedElement.prop("flowType", $("input:radio[name='flowTypeProp']:checked").val());
        showModal("Properties를 저장하였습니다.");
    }

    // Flow 복제
    function cloneFlow() {
        var $selectedSource = $("input:radio[name='sourceFlow']:checked");
        if ($selectedSource.length > 0) {
            var flow_id = $selectedSource.val();
            var cloneYn = "Y";
            if (flow_id == "") {
                alert("등록되지 않은 Flow는 복제할 수 없습니다.");
            } else {
                graph.clear();
                loadFlowDiagram(group_id, system_id);
                $("#cloneFlowDialog").dialog("close");
            }
        } else {
            alert("Flow 복제할 그룹정보를 선택해 주세요.");
        }
    }

    // Flow 저장
    function saveFlow()
    {
        if (confirm("Flow를 저장하시겠습니까?") == false)
        {
            return;
        }

        graph.set({flow_id : "${flow_id}"});
        graph.set({group_id : "${group_id}"});

        if(graph.getElements().length == 0)
        {
            alert("Flow Design 작성 후 저장하십시오.");
            return;
        }

        $.ajax({
            cache : false,
            type : "post",
            url : "${pageContext.request.contextPath}/flow/saveFlow",
            contentType : "application/json",
            data : JSON.stringify(graph),
            success : function(result)
            {
                if(result.resultCode == "0")
                {
                    showModal("Flow를 저장하였습니다.");
                }
                else
                {
                    showModal(result.resultMessage);
                }
            },
            error : function(request, status, error) {
                // console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                showModal("FLOW 저장 중 오류가 발생했습니다.");
            },
            timeout : 35000
        });
    }

    // 처리 그룹 목록으로 이동
    function goGroupList() {
        var _panel = g_pannelMap.get("JP_"+PANEL_PAGE_ID);
        _panel.content.load("/flow/viewFlowInfoList?pageID="+PANEL_PAGE_ID+"&timestamp="+Date.now());
    }

    //BP GROUP 정보 등록창
    function popupBpGroupInfoRegisterForm(){

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/flow/bpGroupInfoRegisterForm?timestamp='+Date.now()
        });
    }

    //BP GROUP 정보 수정창
    function popupBpGroupInfoModifyForm(bpGroup){

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/flow/bpGroupInfoModifyForm?bp_group_id='+bpGroup+'&timestamp='+Date.now()
        });
    }

    //BP 정보 등록창
    function popupBpInfoRegisterForm(bpGroup){

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/flow/bpInfoRegisterForm?ui_bp_group='+bpGroup+'&switch_type=${switchType}&biz_domain=${bizDomain}&timestamp='+Date.now()
        });
    }

    //BP 정보 수정창
    function popupBpInfoModifyForm(bpid){

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/flow/bpInfoModifyForm?bpid='+bpid+'&biz_domain=${bizDomain}&timestamp='+Date.now()
        });
    }


    //BM 정보 등록창
    function popupBmInfoRegisterForm(){

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/flow/bmInfoRegisterForm?ui_bp_group='+TARGET_BP_GROUP+"&biz_domain=${bizDomain}&timestamp="+Date.now()
        });
    }

    //BM 정보 수정창
    function popupBmInfoModifyForm(bmId){

        $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

        $("#formModal").modal({
            backdrop : 'static',
            remote: '/flow/bmInfoModifyForm?bmid='+bmId+'&biz_domain=${bizDomain}&timestamp='+Date.now()
        });
    }


    //모달창으로 부터데이터를 받기위한 부분
    window.onmessage = function(e) {

        var dataArr = e.data.split("|");

        if(e.data=="bpGroupInfoListReload") {

            var flowDesignUrl = "/flow/flowDesign?flow_id=${flow_id}&group_id=${group_id}&system_id=${system_id}&timestamp="+Date.now();

            // 패널내에서 url 이동
            var _panel = g_pannelMap.get("JP_"+PANEL_PAGE_ID);
            _panel.content.load(flowDesignUrl);

        } else if(dataArr[0]=="bpInfoListReload"){

            loadBpList(dataArr[1]);

        } else if(dataArr[0]=="bmInfoListReload"){

            loadBmList(dataArr[1]);
        }
    };

    setOperationBtn();
</script>