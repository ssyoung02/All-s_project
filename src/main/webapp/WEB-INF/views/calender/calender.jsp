<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>캘린더 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <title>Title</title>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp" />
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp" />
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>캘린더</h1>




                <%-- 일정 추가 모달--%>
                <div id="scheduleModal" class="modal unstaged">
                    <div class="modal-overlay"></div>
                    <div class="modal-contents">
                        <div class="modal-text flex-between">
                            <h4>일정 추가</h4>
                            <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
                        </div>
                        <form id="addScheduleForm">
                            <div class="inputbox">
                                <label for="title">일정 제목<span class="essential">*</span></label>
                                <input type="text" id="title" name="title" required maxlength="20">
                            </div>
                            <div class="inputbox">
                                <label for="description">일정 내용</label>
                                <textarea id="description" name="description" maxlength="255"></textarea>
                            </div>
                            <div class="inputbox">
                                <label for="location">장소</label>
                                <input type="text" id="location" name="location">
                            </div>
                            <div class="inputbox flex-between">
                                <div class="date-time">
                                    <label for="startDate">시작 날짜<span class="essential">*</span></label>
                                    <input type="date" id="startDate" name="startDate" required>
                                    <input type="time" id="startTime" name="startTime" required>
                                </div>
                                <div class="date-time">
                                    <label for="endDate">종료 날짜</label>
                                    <input type="date" id="endDate" name="endDate">
                                    <input type="time" id="endTime" name="endTime">
                                </div>
                            </div>
                            <div class="inputbox">
                                <label for="reminder">알림</label>
                                <input type="datetime-local" id="reminder" name="reminder">
                            </div>
                            <div class="inputbox">
                                <label>종일 여부<span class="essential">*</span></label>
                                <div class="radio-group">
                                    <input type="radio" id="allDayYes" name="allDay" value="1">
                                    <label for="allDayYes">예</label>
                                    <input type="radio" id="allDayNo" name="allDay" value="0" checked>
                                    <label for="allDayNo">아니오</label>
                                </div>
                            </div>
                            <div class="inputbox">
                                <label>배경색<span class="essential">*</span></label>
                                <div class="color-picker">
                                </div>
                                <input type="hidden" id="backgroundColorInput" name="backgroundColor" value="#A2B18A">
                            </div>
                            <button class="primary-default" type="submit">일정 추가</button>
                        </form>
                    </div>
                </div>




            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
