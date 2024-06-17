<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
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
</body>
</html>
