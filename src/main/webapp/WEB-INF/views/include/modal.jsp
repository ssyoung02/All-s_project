<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/>

<%--  모달 --%>
<div id="modal-container" class="modal unstaged">
    <div class="modal-overlay">
    </div>
    <div class="modal-contents">
        <div class="modal-text flex-between">
            <h4>타이머 기록</h4>
            <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
        </div>
        <div id="messageContent" class="modal-center">
        </div>
        <div class="modal-bottom">
            <button type="button" class="button-disabled" data-dismiss="modal">취소</button>
            <button type="button" class="primary-default" data-dismiss="modal">기록</button>
        </div>
    </div>
</div>
