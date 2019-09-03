<%@ page language="java" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.tops.model.*" %>
<link href="<c:url value="/resources/css/vendor/fancytree/ui.fancytree.min.css"/>" rel="stylesheet" media="screen">
<link href="<c:url value="/resources/css/vendor/jquery.contextMenu.css"/>" rel="stylesheet" media="screen">

<style type="text/css">
    /* Override */
    .menu-form
    { width: 284px;
      float: left;
    }

</style>

<script>
var menuTree;
var OLD_ACTIVATE_NODE_KEY = "";
var ACTIVATE_NODE_KEY = "";
var ACTIVATE_NODE_LEVEL = "";
var WORKING_MODE = "";
//var NEW_NODE = "";
var NEW_NODE_KEY = "";

//DB 에서 조회한 메뉴 목록을 key : value 배열 형태로 스크립트 생성
var menuInfoArr = [
<c:if test="${not empty menuInfoList}">
<c:forEach var="menuInfo" items="${menuInfoList}" varStatus="i">
{
    "key" : "${menuInfo.menu_id}"
    , "parent_menu_id" : "${menuInfo.parent_menu_id}"
    , "title" : "${menuInfo.menu_name}"
    , "subcount" : "${menuInfo.subcount}"
    , "resource_name" : "${menuInfo.resource_name}"
    , "resource_id" : "${menuInfo.resource_id}"
    , "sort_order" : "${menuInfo.sort_order}"
    <c:if test="${0 ne menuInfo.subcount}">, "folder" : true</c:if>
    , "new_node" : ""
},
</c:forEach>
</c:if>
];


// 배열{key:value}을 받아 트리순서로 배열 재배치
function queryTreeSort(options)
{
    var cfi, e, i, id, o, pid, rfi, ri, thisid, _i, _j, _len, _len1, _ref, _ref1;
    id = options.id || "key";
    pid = options.parentid || "parent_menu_id";
    ri = [];
    rfi = {};
    cfi = {};
    o = [];
    _ref = options.q;

    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i)
    {
        e = _ref[i];
        rfi[e[id]] = i;

        if (cfi[e[pid]] == null)
        {
          cfi[e[pid]] = [];
        }

        cfi[e[pid]].push(options.q[i][id]);
    }

    _ref1 = options.q;

    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++)
    {
        e = _ref1[_j];

        if (rfi[e[pid]] == null)
        {
          ri.push(e[id]);
        }
    }

    while (ri.length)
    {
        thisid = ri.splice(0, 1);
        o.push(options.q[rfi[thisid]]);

        if (cfi[thisid] != null)
        {
            ri = cfi[thisid].concat(ri);
        }
    }

    return o;
}

// 배열순서대로 트리 json 생성
function makeTree(options)
{
    var children, e, id, o, pid, temp, _i, _len, _ref;

    id = options.id || "key";
    pid = options.parentid || "parent_menu_id";
    children = options.children || "children";
    temp = {};
    o = [];
    _ref = options.q;

    for (_i = 0, _len = _ref.length; _i < _len; _i++)
    {
        e = _ref[_i];
        e[children] = [];
        temp[e[id]] = e;

        if (temp[e[pid]] != null)
        {
            temp[e[pid]][children].push(e);
        }
        else
        {
            o.push(e);
        }
    }

    return o;
}

//대메뉴 추가
function addRootMenu()
{
  $("#btn_add_root_menu").hide();

    if(WORKING_MODE != "")
    {
        showModal("메뉴 생성 중입니다.");
        return;
    }

    var newMenuId = "";

    // 선택한 메뉴의 하위 메뉴 id 중에서 최대값을 얻어온다.
    var tmpMenuId = 100000;
    var tmpSortOrder = 0;
    for ( var i = 0, _len = menuInfoArr.length; i < _len; i++ )
    {
        if ( menuInfoArr[i]['parent_menu_id'] == "" || menuInfoArr[i]['parent_menu_id'] == null )
        {
            if ( tmpMenuId<Number(menuInfoArr[i]['key']) )
            {
                tmpMenuId = Number(menuInfoArr[i]['key']);          // 마지막 대메뉴 키
            }

            if ( tmpSortOrder<Number(menuInfoArr[i]['sort_order']) )
            {
                tmpSortOrder = Number(menuInfoArr[i]['sort_order']);// 메뉴 정렬순번
            }
        }
    }

    newMenuId = tmpMenuId +100000;

    var node = {};
    node.key = newMenuId.toString();
    node.parent_menu_id = "";
    node.title = "";
    node.subcount = 0;
    node.sort_order = tmpSortOrder +1;
    node.resource_id = "";
    node.resource_name = "";
    node.new_node = "Y";

    menuInfoArr.push(node);

    OLD_ACTIVATE_NODE_KEY = ACTIVATE_NODE_KEY;

    var tree = $("#menuTree").fancytree("getTree");
    var nodeData = makeTree({q: queryTreeSort({q:menuInfoArr})});
    tree.reload(nodeData).done(function()
    {
            tree.getNodeByKey(node.key).setFocus();
            tree.getNodeByKey(node.key).setActive();
            WORKING_MODE = "ADDROOTMENU";
            ACTIVATE_NODE_KEY = NEW_NODE_KEY = node.key;
            viewMenuInfo(node.key);
            $("#menuName").focus();

            $("#btn_cancel_add_menu").show();
            $("#btn_save").show();
            $("#btn_add_sub_menu").hide();
            $("#btn_remove").hide();
    });
}

// 서브메뉴 추가
function addSubMenu()
{
    if(WORKING_MODE != "")
    {
        showModal("메뉴 생성 중입니다.");
        return;
    }

    if(ACTIVATE_NODE_KEY == "")
    {
        showModal("생성할 메뉴의 상위 메뉴를 선택해 주세요.");
        return;
    }

    var newMenuId = "";

    // 선택한 메뉴의 하위 메뉴 id 중에서 최대값을 얻어온다.
    var tmpMenuId = Number(ACTIVATE_NODE_KEY);
    var tmpSortOrder = 0;
    for (var i = 0, _len = menuInfoArr.length; i < _len; i++)
    {
        if(menuInfoArr[i]['parent_menu_id'] == ACTIVATE_NODE_KEY)
        {
            if(tmpMenuId<Number(menuInfoArr[i]['key']))
            {
                tmpMenuId = Number(menuInfoArr[i]['key']);          // 메뉴 키
            }

            if(tmpSortOrder<Number(menuInfoArr[i]['sort_order']))
            {
                tmpSortOrder = Number(menuInfoArr[i]['sort_order']);// 메뉴 정렬순번
            }
        }
    }

    if ( ACTIVATE_NODE_LEVEL == 1 )
    {
        newMenuId = tmpMenuId+100;
    }
    else if ( ACTIVATE_NODE_LEVEL == 2 )
    {
        newMenuId = tmpMenuId+1;
    }

    var node = {};
    node.key = newMenuId.toString();
    node.parent_menu_id = ACTIVATE_NODE_KEY;
    node.title = "";
    node.subcount = 0;
    node.sort_order = tmpSortOrder+1;
    node.resource_id = "";
    node.resource_name = "";
    node.new_node = "Y";

    menuInfoArr.push(node);

    OLD_ACTIVATE_NODE_KEY = ACTIVATE_NODE_KEY;

    var tree = $("#menuTree").fancytree("getTree");
    var nodeData = makeTree({q: queryTreeSort({q:menuInfoArr})});
    tree.reload(nodeData).done(function()
    {
            tree.getNodeByKey(node.key).setFocus();
            tree.getNodeByKey(node.key).setActive();
            WORKING_MODE = "ADDSUBMENU";

            ACTIVATE_NODE_KEY = NEW_NODE_KEY = node.key;
            viewMenuInfo(node.key);
            $("#menuName").focus();

            $("#btn_cancel_add_menu").show();
            $("#btn_save").show();
            $("#btn_add_root_menu").hide();
            $("#btn_add_sub_menu").hide();
            $("#btn_remove").hide();
    });
}

// 입력 폼에 선택된 메뉴 정보 보여줌
function viewMenuInfo(menuId)
{
    var i;
    var _len;

    // 배열에서 찾기
    for ( i = 0, _len = menuInfoArr.length; i < _len; i++ )
    {
        if ( menuInfoArr[i]['key'] == menuId )
        {
            break;
        }
    }

    $("#menuId").val(menuInfoArr[i]['key'].trim());
    $("#parentMenuId").val(menuInfoArr[i]['parent_menu_id']);
    $("#menuName").val(menuInfoArr[i]['title']);
    $("#menuResourceId").val(menuInfoArr[i]['resource_id']);
    $("#menuResourceName").val(menuInfoArr[i]['resource_name']);
    $("#menuSortOrder").val(menuInfoArr[i]['sort_order']);
}

function init()
{
    $("#menuId").val('');
    $("#parentMenuId").val('');
    $("#menuName").val('');
    $("#menuResourceId").val('');
    $("#menuResourceName").val('');
    $("#menuSortOrder").val('');

    ACTIVATE_NODE_KEY = "";
    ACTIVATE_NODE_LEVEL = "";
    WORKING_MODE = "";
    //NEW_NODE_KEY = "";
}

// 조회
function menuInfoList()
{
    $.ajax({ type: "post"
    	   , url: "<c:url value='/auth/menuInfoList' />"
    	   , dataType:'json'
    	   , contentType: 'application/json'
    	   , cache: false
    	   , success: function(data,status)
             {
                 menuInfoArr = [];

                 $(data.menuInfoList).each(function(i)
                 {
                     var node = null;
                     node = {};
                     node.key = this.menu_id;
                     node.parent_menu_id = this.parent_menu_id;
                     node.title = this.menu_name;
                     node.resource_id = this.resource_id;
                     node.resource_name = this.resource_name;
                     node.subcount = this.subcount;
                     node.sort_order =  this.sort_order;

                     if ( this.subcount > 0 ) node.folder = true;

                     menuInfoArr.push(node);
                 });

                 var tree = $("#menuTree").fancytree("getTree");
                 var nodeData = makeTree({q: queryTreeSort({q:menuInfoArr})});

                 tree.reload(nodeData).done(function()
                 {
                     var node;

                     if ( ACTIVATE_NODE_KEY.length > 0 )
                     {
                         node = tree.getNodeByKey(ACTIVATE_NODE_KEY);
                         if ( node != null && node  != undefined )
                         {
                             node.setFocus();
                             node.setActive();                        	 
                         }
                     }
                 });

                 NEW_NODE_KEY = '';
             }
    	   , error: function()
             {
                 showModal("메뉴 조회 중 오류가 발생했습니다.");
             }
           });
}

// 저장
function saveMenuInfo()
{
    if(WORKING_MODE == '' && ACTIVATE_NODE_KEY == '')
    {
        showModal("메뉴를 선택해 주세요.");
        return;
    }

    if(WORKING_MODE != '')
    {
        if($("#menuId").val().trim() == '')
  {
            showModal("메뉴 ID를 입력해 주세요.");
            return;
        }

        // 배열에서 찾기
        for (var i = 0, _len = menuInfoArr.length; i < _len; i++)
  {
            if(menuInfoArr[i]['key'] == $("#menuId").val().trim() && menuInfoArr[i]['new_node'] != 'Y')
      {
                showModal("이미 등록된 메뉴 ID입니다.");
                return;
            }
        }

        if($("#menuName").val().trim() == '')
  {
            showModal("메뉴명을 입력해 주세요.");
            return;
        }
    }

    if (!confirm('저장하시겠습니까?'))
    {
        return;
    }

    var obj = {};

    obj.menu_id        = $("#menuId").val();
    obj.parent_menu_id = $("#parentMenuId").val();
    obj.menu_name      = $("#menuName").val().trim().replace(/[^가-힣0-9a-zA-Z]/gi, "");
    $("#menuName").val(obj.menu_name);
    obj.sort_order     = $("#menuSortOrder").val();
    obj.resource_id    = $("#menuResourceId").val();
    var json_data      = JSON.stringify(obj);

    var url = '';

    if(WORKING_MODE == '')
    {
        url = "<c:url value='/auth/modifyMenuInfo' />";
    }
    else
    {
        url = "<c:url value='/auth/registerMenuInfo' />";
    }

    // 저장
    $.ajax({
        url : url
        , type : "POST"
        , dataType : "json"
        , data : json_data
        , contentType: 'application/json'
        , cache: false
        , success : function(data, status)
  {
            if(data.result==true)
      {
                showModal("저장되었습니다.");

                WORKING_MODE = '';

                $("#btn_cancel_add_menu").hide();
                $("#btn_add_root_menu").show();

                $("#btn_save").show();
                $("#btn_remove").show();

                menuInfoList();

            }
      else
      {
                showModal("저장 중 오류가 발생하였습니다.");
            }
        }
        , error : function()
  {
            showModal("메뉴 저장 중 오류가 발생했습니다.")
        }
    });
}

// 삭제
function removeMenuInfo()
{
    if(ACTIVATE_NODE_KEY == '')
    {
        showModal("삭제할 메뉴를 선택해 주세요.");
        return;
    }

    if (!confirm('선택한 MENU와 하위 MENU까지 모두 삭제됩니다.\n삭제하시겠습니까?'))
    {
        return;
    }

    if (!confirm('정말 삭제하시겠습니까?'))
    {
        return;
    }

    var obj = {};
    obj.menu_id = $("#menuId").val();
    var json_data = JSON.stringify(obj);

    var url = "<c:url value='/auth/removeMenuInfo' />";

    // 저장
    $.ajax({
        url : url
        , type : "POST"
        , dataType : "json"
        , data : json_data
        , contentType: 'application/json'
        , cache: false
        , success : function(data, status)
  {
            if(data.result == true)
      {
                ACTIVATE_NODE_KEY   = '';
                ACTIVATE_NODE_LEVEL = '';
                WORKING_MODE        = '';

                menuInfoList();

                $("#menuId").val('');
                $("#parentMenuId").val('');
                $("#menuName").val('');
                $("#menuResourceId").val('');
                $("#menuResourceName").val('');
                $("#menuSortOrder").val('');

                showModal("삭제되었습니다.");

                $("#btn_cancel_add_menu").hide();
                $("#btn_add_sub_menu").hide();
                $("#btn_save").hide();
                $("#btn_remove").hide();

            }
      else
      {
                showModal("삭제 중 오류가 발생하였습니다.");
            }
        }
        , error : function()
  {
            showModal("메뉴 삭제 중 오류가 발생했습니다.")
        }
    });
}

// 메뉴 생성 취소
function cancelAddMenu()
{
    $("#btn_add_root_menu").show();
    $("#btn_cancel_add_menu").hide();
    $("#btn_save").hide();

    init();
    menuInfoList();

    var oldNode = $("#menuTree").fancytree("getTree").getNodeByKey(OLD_ACTIVATE_NODE_KEY);
    if ( oldNode != null && oldNode != undefined )
    {
        oldNode.setFocus();
        oldNode.setActive();
    }
}

//리소스 입력 모달창으로부터 리소스 id 를 받기위한 부분 (받는문자열 : '리소스id|리소스명')
window.onmessage = function(e)
{
    if(e.data != null && e.data != '')
    {
        var obj = e.data;
        var resourceInfoArr =  e.data.split("|");

        $("#menuResourceId").val(resourceInfoArr[0]);
        $("#menuResourceName").val(resourceInfoArr[1]);
    }
};


// 리소스 선택창 열기
function setMenuResource()
{
    // 리소스 선택창이 open 조건
    if(WORKING_MODE == '' && ACTIVATE_NODE_KEY == '')
    {
        alert('MENU를 선택해 주세요.');
        return;
    }

    $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

    $("#formModal").modal({
        backdrop : 'static',
        remote: '/auth/menuInfoResourceInfoList?menuResourceId='+$("#menuResourceId").val()
    });
}

$(document).ready(function()
{
    init();

    var nodeData = makeTree({q: queryTreeSort({q:menuInfoArr})});

    $("#menuTree").fancytree({
        autoActivate : false,
        autoCollapse : true,
        autoScroll : true,
        clickFolderMode : 3,
        minExpandLevel : 3,
        tabindex : -1,
        source : nodeData,
        activate: function(e, data)
  {
            if(WORKING_MODE != "")
      {
                if(data.node.key != NEW_NODE_KEY)
    {
                    alert("메뉴 생성 중입니다.");
                    var newNode = $("#menuTree").fancytree("getTree").getNodeByKey(NEW_NODE_KEY);
                    newNode.setFocus();
                    newNode.setActive();
                    data.node.setActive(false);
                }

                return;
            }

            var node = data.node;

            ACTIVATE_NODE_KEY   = node.key;
            ACTIVATE_NODE_LEVEL = node.getLevel();

            if(!$.isEmptyObject(node.data))
      {
                if(ACTIVATE_NODE_LEVEL<3)
    {
                    $("#btn_add_sub_menu").show();
    }
                else
    {
                    $("#btn_add_sub_menu").hide();
    }

                $("#btn_save").show();
                $("#btn_remove").show();

                viewMenuInfo(node.key);
            }
        }
    });

    setOperationBtn();

});

</script>
            <div class="showcase">

                <!--// 상단 -->

                <div class="menu-contents">

                    <div id="menuTree" class="tree-menu" style="width:300px;">
                    </div>

                    <div class="menu-form">
                        <ul>
                            <li><label>MENU ID</label><input type="text" id="menuId" class="form-control02" readonly='readonly'/></li>
                            <li><label>부모 MENU ID</label><input type="text" id="parentMenuId" class="form-control02" readonly='readonly'/></li>
                            <li><label>MENU 명</label><input type="text" id="menuName" class="form-control02" maxlength="50" /></li>
                            <li><label>리소스명</label><input type="text" id="menuResourceName" class="form-control02" readonly='readonly' style="width:140px" />
                            <button type="button" id="btn_set_resource" class="btn btn-search btn_operation" onclick="setMenuResource();">입력</button>
                            <input type="hidden" id="menuResourceId" />
                            </li>
                            <li><label>MENU 정렬 순번</label><input type="text" id="menuSortOrder"  class="form-control02" readonly="readonly" /></li>

                        </ul>
                        <div class="menu-btn">
                            <button type="button" id="btn_add_root_menu" class="btn btn-search btn_operation" onclick="addRootMenu();">MENU생성</button>
                            <button type="button" id="btn_add_sub_menu" class="btn btn-search btn_operation" onclick="addSubMenu();" style="display:none;">SUB생성</button>
                            <button type="button" id="btn_cancel_add_menu" class="btn btn-search btn_operation" onclick="cancelAddMenu();" style="display:none;">생성취소</button>
                            <button type="button" id="btn_save" class="btn btn-search btn_operation" onclick="saveMenuInfo();" style="width:58px;display:none;">저장</button>
                            <button type="button" id="btn_remove" class="btn btn-search btn_operation" onclick="removeMenuInfo();" style="width:58px;display:none;">삭제</button>
                            <!--
                            <button type="button" class="btn btn-normal">닫기</button>
                             -->
                        </div>
                    </div>

                </div>

            </div>
