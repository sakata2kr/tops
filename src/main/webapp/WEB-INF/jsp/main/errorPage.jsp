<%@ page language="java" contentType="text/html; charset=utf8"    pageEncoding="utf8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<link href="<c:url value="/resources/css/bootstrap.css"/>" rel="stylesheet" media="screen">
<link href="<c:url value="/resources/css/style.css"/>" rel="stylesheet" media="screen">

<div style="text-align:center">
    <h1 style="font-size:140px; font-weight:bold; color:#28B779">${errCode}</h1>
    <h2>
        <c:choose>
            <c:when test = "${errCode eq '400'}">잘못된 요청입니다.</c:when>
            <c:when test = "${errCode eq '401'}">접근 권한이 없습니다.</c:when>
            <c:when test = "${errCode eq '403'}">접근이 금지되었습니다.</c:when>
            <c:when test = "${errCode eq '404'}">요청 페이지가 존재하지 않습니다.</c:when>
            <c:when test = "${errCode eq '500'}">서버에 오류가 발생하였습니다.</c:when>
            <c:when test = "${errCode eq '503'}">서비스 사용이 불가합니다.</c:when>
            <c:otherwise>예외가 발생하였습니다.</c:otherwise>
        </c:choose>
    </h2>
    <br/>
    <a class="btn btn-warning btn-big"  href="/login">로그인 화면으로</a>
</div>