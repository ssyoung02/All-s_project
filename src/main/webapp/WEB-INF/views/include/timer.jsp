<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />

<head>
    <meta charset="UTF-8">
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
</head>
<!-- 타이머 영역 -->
<div id="timer">
    <div class="time-area flex-row">
        <p id="timeHour">00</p>:<p id="timeMin">00</p>:<p id="timeSec">00</p>
        <div class="time-button flex-row">
            <!-- 타이머 컨트롤 버튼 -->
            <button id="time-stop" class="primary-default" onclick="timeStop()">그만하기</button>
            <button id="time-pause" class="primary-default" onclick="timePause()">잠시쉬기</button>
            <button id="time-start" class="primary-default" onclick="timeStart()">공부시작</button>
        </div>
    </div>
    <!-- 할 일 목록 영역 -->
    <div class="unfinished-todo">
        <h2>오늘의 할 일</h2>
        <ul class="todolist">
            <!-- 할 일 항목 -->
            <li>
                <input type="checkbox" id="todolist1" class="todo-checkbox">
                <label for="todolist1" class="todo-label">
                    <span class="checkmark"><i class="bi bi-square"></i></span>
                    자바 공부
                </label>
            </li>
            <li>
                <input type="checkbox" id="todolist2" class="todo-checkbox">
                <label for="todolist2" class="todo-label">
                    <span class="checkmark"><i class="bi bi-square"></i></span>
                    면접 준비
                </label>
            </li>
            <li>
                <input type="checkbox" id="todolist3" class="todo-checkbox">
                <label for="todolist3" class="todo-label">
                    <span class="checkmark"><i class="bi bi-square"></i></span>
                    UI 설계
                </label>
            </li>
            <li>
                <input type="checkbox" id="todolist4" class="todo-checkbox">
                <label for="todolist4" class="todo-label">
                    <span class="checkmark"><i class="bi bi-check-square"></i></span>
                    자소서 작성
                </label>
            </li>
        </ul>
    </div>
</div>