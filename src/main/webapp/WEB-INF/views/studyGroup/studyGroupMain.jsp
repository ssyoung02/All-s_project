<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디그룹 메인 > 내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>

    <script src="${root}/resources/js/fullcalendar/core/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/daygrid/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/list/index.global.js"></script>
    <script>
        function openChatWindow(studyIdx) {
            window.open('${root}/studyGroup/chat?studyIdx=' + studyIdx, 'ChatWindow', 'width=500,height=500,resizable=no');
        }
        document.addEventListener('DOMContentLoaded', function () {
            let eventsData = [];
            const studyIdx = ${study.studyIdx};
            let monthCalendar, dayCalendar;

            // 캘린더 렌더링 함수
            function renderCalendars() {
                const monthCalendarEl = document.getElementById('monthCalendar');
                monthCalendar = new FullCalendar.Calendar(monthCalendarEl, {
                    initialView: 'dayGridMonth',
                    headerToolbar: { left: 'title', center: '', right: 'prev,next today' },
                    events: eventsData,
                    editable: false,
                    selectable: false,
                    eventClick: false,
                    locale: 'ko',
                    height: 'auto' // 높이를 자동으로 조절
                });
                monthCalendar.render();

                const dayCalendarEl = document.getElementById('dayCalendar');
                dayCalendar = new FullCalendar.Calendar(dayCalendarEl, {
                    initialView: 'listDay',
                    headerToolbar: { left: '', center: 'title', right: '' },
                    events: eventsData,
                    editable: false,
                    selectable: false,
                    eventClick: false,
                    locale: 'ko',
                    height: 'auto'
                });
                dayCalendar.render();
            }

            // 초기 렌더링 및 이벤트 리스너 등록
            $.ajax({
                url: "${root}/calendar/teamEvents/" + studyIdx,
                type: "GET",
                headers: {
                    "${_csrf.headerName}": "${_csrf.token}"
                },
                success: function (response) {
                    eventsData = response.map(event => ({
                        id: event.teamScheduleIdx,
                        title: event.title,
                        start: event.start,
                        end: event.end,
                        allDay: event.allDay === 1,
                        color: event.backgroundColor,
                    }));

                    renderCalendars(); // 캘린더 렌더링

                    // 캘린더가 변경될 때마다 다시 렌더링 (변수 범위 수정)
                    monthCalendar.on('datesSet', renderCalendars);
                    dayCalendar.on('datesSet', renderCalendars);
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.error('Error fetching events:', errorThrown);
                    alert('이벤트를 불러오는 중 오류가 발생했습니다.');
                }
            });
        });
    </script>
</head>
<body>
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
                <h1>내 스터디</h1>
                <%--본문 콘텐츠--%>
                <div class="maxcontent">
                    <section class="group-header flex-between">
                        <div class="profile-header">
                            <img src="" alt="">
                            <div class="group-title">
                                <h2>${study.studyTitle}</h2>
                                <p>${study.description}</p>
                            </div>
                        </div>
                        <div class="profile-link">
                            <a class="manager-page" href="${root}/studyGroup/studyGroupManagerInfo?studyIdx=${study.studyIdx}"><i class="bi bi-gear"></i>관리</a>
                            <button class="primary-default" onclick="openChatWindow(${study.studyIdx})">채팅 </button>
                        </div>
                    </section>
                    <section class="group-main">
                        <div class="group-content">
                            <h2>이달의 스터디 왕</h2>
                            <div class="group-lank">
                                <div class="lank-phase">
                                    <div class="lank-floor">
                                        <div class="">
                                            <div class="profile-img">
                                                <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                            </div>
                                            <p class="memberId">
                                                <i class="bi bi-award"></i>
                                                Jihyeon</p>
                                        </div>
                                        <div class="records lank-second">
                                            <p>82h</p>
                                            <p class="lanking">2</p>
                                        </div>
                                    </div>
                                    <div class="lank-floor">
                                        <div class="">
                                            <div class="profile-img">
                                                <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                            </div>
                                            <p class="memberId">
                                                <i class="bi bi-award"></i>
                                                Jihyeon
                                            </p>
                                        </div>
                                        <div class="records lank-first">
                                            <p>82h</p>
                                            <p class="lanking">2</p>
                                        </div>
                                    </div>
                                    <div class="lank-floor">
                                        <div class="">
                                            <div class="profile-img">
                                                <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                            </div>
                                            <p class="memberId">
                                                <i class="bi bi-award"></i>
                                                Jihyeon
                                            </p>
                                        </div>
                                        <div class="records lank-third">
                                            <p>82h</p>
                                            <p class="lanking">2</p>
                                        </div>
                                    </div>
                                </div>
                                <div class="lank-list">
                                    <div class="lank-item">
                                        <div class="lanking-circle">
                                            <div class="circle-number top3">
                                                1
                                            </div>
                                        </div>
                                        <p class="lank-id">Jihyeon</p>
                                        <p class="lank-time">120h</p>
                                    </div>
                                    <div class="lank-item">
                                        <div class="lanking-circle">
                                            <div class="circle-number top3">
                                                2
                                            </div>
                                        </div>
                                        <p class="lank-id">Jihyeon</p>
                                        <p class="lank-time">120h</p>
                                    </div>
                                    <div class="lank-item">
                                        <div class="lanking-circle">
                                            <div class="circle-number top3">
                                                3
                                            </div>
                                        </div>
                                        <p class="lank-id">Jihyeon</p>
                                        <p class="lank-time">87h</p>
                                    </div>
                                    <div class="lank-item">
                                        <div class="lanking-circle">
                                            <div class="circle-number">
                                                4
                                            </div>
                                        </div>
                                        <p class="lank-id">Yeajoon</p>
                                        <p class="lank-time">7h</p>
                                    </div>
                                    <div class="lank-item">
                                        <div class="lanking-circle">
                                            <div class="circle-number">
                                                5
                                            </div>
                                        </div>
                                        <p class="lank-id">Jeayung</p>
                                        <p class="lank-time">7h</p>
                                    </div>
                                </div>
                            </div>
                            <!--캘린더-->
                            <h2>스터디 일정</h2>
                            <div class="group-calender">
                                <div class="calendar-area">
                                    <div id="monthCalendar"></div>
                                    <div id="dayCalendar"></div>
                                </div>
                            </div>
                        </div>
                        <div class="group-member">
                            <h3>그룹 멤버</h3>
                            <div class="group-memberList">
                                <c:forEach var="member" items="${members}">
                                    <c:if test="${member.status == 'ACCEPTED'}">
                                        <div class="group-memberItem">
                                            <div class="profile-imgGroup">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/09.%20carrot.png" alt="프로필 이미지">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </div>
                                            <p class="memberId">${member.userName}</p>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
</div>
<!--푸터-->
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/footer.jsp" />
</body>
</html>
