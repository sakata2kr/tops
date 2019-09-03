<%@ page language="java" contentType="text/html; charset=UTF-8"
  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="com.tops.model.*"%>

<style type="text/css">
    .thisHyperLink_ui
    { cursor: pointer;
      color: #0094C8;
    }
</style>

<script>

var PANEL_PAGE_ID = "${pageID}";

function viewTableListModifyForm(tableName, ownerId, db)
{
		    $('body').on('hidden.bs.modal','#formModal',function(){ $(this).removeData('bs.modal')}); // modal에 넘겼던 데이터 지움

		    // 패널 숨기기
		    var _panel = g_pannelMap.get("JP_"+PANEL_PAGE_ID);
		    _panel.css('display', 'none');

		    var viewTableDetailUrl = "/viewTable/viewTableDetail?tableName="+tableName+"&ownerId="+ownerId+"&db="+db+"&startRow="+0+"&endRow="+0+"&pageID="+PANEL_PAGE_ID;
		    // 패널내에서 url 이동
		    var _panel = g_pannelMap.get("JP_"+PANEL_PAGE_ID);
		    _panel.content.load(viewTableDetailUrl,'',function(){
		        _panel.css('display', '');
		    });
}
</script>

<div class="table-responsive">
  <table class="table table-blue bbs100">
    <thead>
      <tr>
        <th scope="col">소유자</th>
        <th scope="col">테이블 명</th>
      </tr>
    </thead>
    <tbody id="viewTableList">
      <c:choose>
        <c:when test="${not empty urtTableList or not empty fwkTableList}">
          <c:forEach var="urtTableList" items="${urtTableList}"
            varStatus="i">
            <tr>
              <td>${urtTableList.ownerId}</td>
              <td class="thisHyperLink_ui" onclick="viewTableListModifyForm('${urtTableList.tableName}', '${urtTableList.ownerId}', 'urt');">${urtTableList.tableName}
              </td>
            </tr>
          </c:forEach>
          <c:forEach var="fwkTableList" items="${fwkTableList}"
            varStatus="i">
            <tr>
              <td>${fwkTableList.ownerId}</td>
              <td class="thisHyperLink_ui" onclick="viewTableListModifyForm('${fwkTableList.tableName}','${fwkTableList.ownerId}', 'fwk');">${fwkTableList.tableName}
              </td>
            </tr>
          </c:forEach>
        </c:when>
        <c:otherwise>
          <tr>
            <td colspan="3">검색 조건에 해당하는 건이 없습니다.</td>
          </tr>
        </c:otherwise>
      </c:choose>
    </tbody>
  </table>
</div>
