<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/>


<div id="timer">
    <input type="hidden" id="hiddenId" value="${userVo.userIdx}">
    <div class="modal-text flex-between">
        <button class="timer-close" aria-label="타이머 닫기" onclick="timeStop()"><i class="bi bi-x-lg"></i></button>
    </div>
    <div class="time-area flex-row">
        <p id="timeHour">00</p>:
        <p id="timeMin">00</p>:
        <p id="timeSec">00</p>
        <div class="time-button flex-row">
            <!-- 타이머 컨트롤 버튼 -->
            <button id="time-stop" class="primary-default" onclick="endTimer()">그만하기</button>
            <button id="time-pause" class="primary-default" onclick="pauseTimer()">잠시쉬기</button>
            <button id="time-start" class="primary-default" onclick="startTimer()" style="display: block">공부시작</button>
            <button id="time-reStart" class="primary-default" onclick="timeReStart()" style="display: none">다시시작</button>
        </div>
    </div>

    <%--  모달 --%>
    <div id="timer-modal-container" class="timer-modal unstaged">
        <div class="timer-modal-overlay">
        </div>
        <div class="timer-modal-contents">
            <div class="timer-modal-text flex-between">
                <h4>타이머 기록</h4>
                <button id="timer-modal-close" class="modal-close-x" aria-label="닫기" onclick="timerAllClose()"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="timer-modal-center">
                <textarea class="timer-recode" placeholder="공부 내용을 입력해주세요" required maxlength="20" oninput="countCharacters(this)"></textarea>
                <div id="charCount">0 / 20</div>
            </div>
            <div class="timer-modal-bottom">
                <button type="button" class="button-disabled" data-dismiss="modal" onclick="timerAllClose()">취소</button>
                <button type="button" class="primary-default" data-dismiss="modal" onclick="updateMemo()">기록</button>
            </div>
        </div>
    </div>
</div>

