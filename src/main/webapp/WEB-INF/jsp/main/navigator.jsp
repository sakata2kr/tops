<%@ page language="java" contentType="text/html; charset=utf8"    pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script>

//DB 에서 조회한 메뉴 목록을 key : value 배열 형태로 스크립트 생성
var menuInfoArr = [
<c:if test="${not empty menuInfoList}">
<c:forEach var="menuInfo" items="${menuInfoList}" varStatus="i">
{ "menu_id" : "${menuInfo.menu_id}"
, "parent_menu_id" : "${menuInfo.parent_menu_id}"
, "menu_name" : "${menuInfo.menu_name}"
, "subcount" : "${menuInfo.subcount}"
, "resource_name" : "${menuInfo.resource_name}"
, "resource_id" : "${menuInfo.resource_id}"
, "resource_path" : "${menuInfo.resource_path}"
, "sort_order" : "${menuInfo.sort_order}"
},
</c:forEach>
</c:if>
];

//배열{key:value}을 받아 트리순서로 배열 재배치
function queryTreeSort(options)
{
    var cfi, e, i, id, o, pid, rfi, ri, thisid, _i, _j, _len, _len1, _ref, _ref1;
    id = options.id || "menu_id";
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

    id = options.id || "menu_id";
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

function renderTree(tree)
{
    var e = null;
    var html = "";
    var _i, _len;

    for (_i = 0, _len = tree.length; _i < _len; _i++)
    {

        e = tree[_i];

        if(e.parent_menu_id == '')
        {
            html += "<li class='dropdown'><a href='#' class='dropdown-toggle' data-toggle='dropdown'>" + e.menu_name + " <b class='nav-line'></b></a>";
        }
        else if(e.subcount > 0)
        {
            html += "<li><a href='#' class='on'>" + e.menu_name + "</a>";
        }
        else if(e.subcount == 0)
        {
            html += "<li><a href='#' onclick='menuClick(\"" + e.resource_path + "\", \"\", \"" + e.menu_id + "\")';>" + e.menu_name + "</a>";
        }

        if (e.children != null)
        {
            if(e.parent_menu_id == '')
            {
                html += "<ul class='dropdown-menu'>";
            }
            else if(e.subcount > 0)
            {
                html += "<ul class='sub-menu'>";
            }

            html += renderTree(e.children);

            if(e.subcount > 0)
            {
                html += "</ul>";
            }
        }

        html += "</li>\n";
    }

    return html;
}

// 사용자별 메뉴 목록을 담을 array
var userMenuArr = [];

// 사용자별 메뉴 목록을 만드는 재귀함수
function setUserMenuArr(menuArr, isParent)
{
    var isDupId = false;

    // 권한이 있으면
    if(isParent || (menuArr['resource_name'] != null && menuArr['resource_name'] != ''))
    {
        //console.log('ok1');
        // parent 있으면
        if(menuArr['parent_menu_id'] != null && menuArr['parent_menu_id'] != '')
        {
            //console.log('ok2');
            for(var i = 0; i < userMenuArr.length; i++)
            {
            	//console.log("{} vs {}", userMenuArr[i]['menu_id'], menuArr['parent_menu_id']);
                if(userMenuArr[i]['menu_id'] == menuArr['parent_menu_id'])
                {
                    isDupId = true;
                    //break;
                }
            }

            //console.log('ok3 : {}', isDupId);

            if(!isDupId)
            {
                for(var i = 0; i < menuInfoArr.length; i++)
                {
                    if(menuInfoArr[i]['menu_id'] == menuArr['parent_menu_id'])
                    {
                        setUserMenuArr(menuInfoArr[i], true);
                        break;
                    }
                }
            }
        }

        //alert('push');

        userMenuArr.push(menuArr);
    }
}

$(document).ready(function()
{
    // 보이는 메뉴만 배열 재구성
    for(var i = 0; i < menuInfoArr.length; i++)
    {
        if(menuInfoArr[i]['resource_id'] != null && menuInfoArr[i]['resource_id'] != '')
        {
            //console.log(menuInfoArr[i]['resource_id']);
            setUserMenuArr(menuInfoArr[i], false);
        }
    }

    if(userMenuArr != null)
    {
        var nodeData = makeTree({q: queryTreeSort({q:userMenuArr})});
        var userMenuTree =  renderTree(nodeData);
        $("#userMenuTree").html(userMenuTree);
    }
    //alert(userMenuTree);
});
</script>

    <!-- Nav -->
    <div class="navbar navbar-inverse">
        <div class="container">
            <div class="navbar-header">
                <img class="navbar-brand" src="<c:url value="/resources/img/tops.png"/>" alt="" />
            </div>

            <!-- 메뉴 생성되는 부분 -->
            <div class="navbar-collapse collapse">
                <ul id="userMenuTree" class="nav navbar-nav"></ul>
            </div>

            <div class="component-set">
                <ul>
                    <li class="noti"><a href="#" class="icon01" onclick="moveEventList()">이벤트알림</a></li>
                    <li><a href="#" id="layer_open" onclick="panelAlignAll();" class="icon02" title="전체정렬">전체정렬</a></li>
                    <li style="width:2px"><b class='nav-line' style="left:0px;margin-top:10px; padding-top:10px;"></b></li>
                </ul>
            </div>

            <div class="admin-set">
                <ul>
                    <li>Welcome</li>
                    <li>
                        <a href="<c:url value="/main/myInfoModifyForm"/>" data-toggle="modal" data-backdrop="static" data-target="#formModal" >
                            <span id="nav_user_name" >${sessUserInfo.user_name}</span><img src="<c:url value="/resources/img/icon/setting_btn.png"/>" alt="설정" />
                        </a>
                    </li>
                    <li><a id="logOut" href="/login/logOut">Log Out</a></li>
                </ul>
            </div>
        </div>
    </div>
    <!--// Nav -->