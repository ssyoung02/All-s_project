<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<%--이제 필요없는 코드 --%>
<!DOCTYPE html>
<html>
<head>
    <style>
        .loginMain {
            display: flex; /* flexbox 사용 */
        }

        .loginUserInfoLeft {
            width: 65%;
            margin-right: 20px;
            display: flex; /* 내부 요소들을 flexbox로 배치 */
        }
        .scheduler-area {
            display: flex;
            width: 100%; /* scheduler-area가 loginUserInfoLeft의 전체 너비를 차지하도록 설정 */
        }
        .scheduler { /* 월별 캘린더 */
            width: 67%;
            margin-right: 10px;  /*일별 캘린더와의 간격 */
        }

        .todo { /* 일별 캘린더 */
            width: 33%;
            margin-top: 62px;
        }

        .fc-calendarLink-button {
            background-color: #717171 !important;
            color: white !important;
            border: none !important;
        }

        /* 일별 캘린더 제목 숨기기 */
        #dayCalendar .fc-toolbar {
            display: none;
        }


    </style>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All's</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="${root}/resources/css/slider.css">

    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <script src="${root}/resources/js/fullcalendar/core/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/daygrid/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/list/index.global.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // 캘린더 이벤트 데이터 가져오기
            let eventsData = [];
            $.ajax({
                url: "${root}/calendar/events",
                type: "GET",
                headers: {
                    "${_csrf.headerName}": "${_csrf.token}"
                },
                success: function (response) {
                    eventsData = response.map(event => ({
                        id: event.scheduleIdx,
                        title: event.title,
                        start: event.start,
                        end: event.end,
                        allDay: event.allDay === 1,
                        color: event.backgroundColor,
                    }));

                    // 캘린더 렌더링 함수
                    function renderCalendars() {
                        const monthCalendarEl = document.getElementById('monthCalendar');
                        new FullCalendar.Calendar(monthCalendarEl, {
                            initialView: 'dayGridMonth',
                            customButtons: { // 버튼 추가
                                calendarLink: {
                                    text: '캘린더 바로가기',
                                    click: function() {
                                        location.href = "${root}/calendar"; // 페이지 이동
                                    }
                                }
                            },
                            headerToolbar: {
                                left: 'title',
                                center: '',
                                right: 'calendarLink' // 버튼 위치 지정
                            },
                            events: eventsData,
                            editable: false,
                            selectable: false,
                            eventClick: false,
                            locale: 'ko'
                        }).render();

                        const dayCalendarEl = document.getElementById('dayCalendar');
                        new FullCalendar.Calendar(dayCalendarEl, {
                            initialView: 'listDay',
                            headerToolbar: { left: '', center: 'title', right: '' },
                            events: eventsData,
                            editable: false,
                            selectable: false,
                            eventClick: false,
                            locale: 'ko',
                            height: 'auto' // 높이를 자동으로 조절
                        }).render();
                    }

                    // 초기 렌더링 및 이벤트 리스너 등록
                    renderCalendars();

                    // 캘린더가 변경될 때마다 다시 렌더링
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
<!-- 중앙 컨테이너 -->
<jsp:include page="include/timer.jsp"/>
<jsp:include page="include/header.jsp"/>
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="include/navbar.jsp"/>
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="include/navbar.jsp"/>
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>대시보드</h1>
                <%-- 로그인하지 않은 사용자에게만 표시 --%>
                <sec:authorize access="isAnonymous()">
                    <div class="non-login-section">
                        <div class="service-info bg-green">
                            <div class="service-info-left">
                                <h3>서비스</h3>
                                <h2>혼자 공부하기 힘든 분들을 위한 스터디 서비스!</h2>
                                <p>다양한 학습 관리, 정보 제공, 취업 지원 기능을 통합하여 학습자가 효율적으로 자기계발과 목표 달성에 집중할 수 있도록 돕는 포괄적인 스터디 플랫폼을 제공합니다</p>
                            </div>
                            <div class="service-info-right flex-colum">
                                <button class="secondary-default">공부노트<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">캘린더<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">스터디 그룹<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">공부 자료<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">이력서 작성<i class="bi bi-arrow-right"></i></button>
                            </div>
                        </div>
                        <div class="iogin-info flex-colum bg-green">
                            <h3>지금부터<br> 함께 공부해봐요!</h3>
                            <button class="primary-default" onclick="location.href='${root}/Users/UsersLoginForm'">로그인
                            </button>
                            <button class="secondary-default" onclick="location.href='${root}/Users/Join'">회원가입</button>
                        </div>
                    </div>
                </sec:authorize>
                <%-- 로그인한 사용자에게만 표시 --%>
                <sec:authorize access="isAuthenticated()">
                    <div class="loginMain">
                        <div class="loginUserInfoLeft">
                            <div class="scheduler-area">
                                <div class="scheduler">
                                    <div id="monthCalendar"></div>
                                </div>
                                <div class="todo">
                                    <div id="dayCalendar"></div>
                                </div>
                            </div>
                        </div>
                        <div class="loginUserInfoRight">
                            <div class="studyTime">
                                <h2 class="">오늘의 공부 시간</h2>
                                <div>
                                    <div class="todoTitle">Total</div>
                                    <p id="totalstudytime">${userVo.total_study_time}</p>
                                </div>
                                <div>
                                    <div class="todoTitle">Today</div>
                                    <p id="todaystudytime">${userVo.today_study_time}</p>
                                </div>
                            </div>
                            <div class="userStudyGroup">
                                <div class="userStudyGroupTitle flex-between">
                                    <h3>공부하는 42조</h3>
                                    <div class="slide-button-group">
                                        <button class="slide-button" title="이전">
                                            <i class="bi bi-caret-left-fill"></i>
                                            <span class="hide">이전</span>
                                        </button>
                                        <button class="slide-button" title="다음">
                                            <i class="bi bi-caret-right-fill"></i>
                                            <span class="hide">다음</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="userStudyGroupMember">
                                    <div class="memberItem">
                                        <div class="studyMemberProfile">
                                            <a class="profile" href="#">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </a>
                                        </div>
                                        <a href="#" class="memberName">Yejoon</a>
                                    </div>
                                    <div class="memberItem">
                                        <div class="studyMemberProfile">
                                            <a class="profile" href="#">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </a>
                                        </div>
                                        <a href="#" class="memberName">Jeayang</a>
                                    </div>
                                    <div class="memberItem">
                                        <div class="studyMemberProfile">
                                            <a class="profile" href="#">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </a>
                                        </div>
                                        <a href="#" class="memberName">Yujung</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </sec:authorize>
                <!--슬라이드 배너-->
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <!--슬라이드 아이템들-->
                        <div class="swiper-slide">
                            <div class="banner-item bgwhite" tabindex="0" onclick="">
                                <div class="banner-item-top">
                                    <div class="banner-img">
                                        <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                    </div>
                                    <div class="banner-title">
                                        <p class="banner-main-title">강남인근 면접 스터디 모집1</p>
                                        <p class="banner-id">Jihyeon</p>
                                    </div>
                                </div>
                                <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide">
                            <div class="banner-item bgwhite" tabindex="0" onclick="">
                                <div class="banner-item-top">
                                    <div class="banner-img">
                                        <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                    </div>
                                    <div class="banner-title">
                                        <p class="banner-main-title">강남인근 면접 스터디 모집2</p>
                                        <p class="banner-id">Jihyeon</p>
                                    </div>
                                </div>
                                <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide">
                            <div class="banner-item bgwhite" tabindex="0" onclick="">
                                <div class="banner-item-top">
                                    <div class="banner-img">
                                        <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                    </div>
                                    <div class="banner-title">
                                        <p class="banner-main-title">강남인근 면접 스터디 모집3</p>
                                        <p class="banner-id">Jihyeon</p>
                                    </div>
                                </div>
                                <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="swiper-slide">
                            <div class="banner-item bgwhite" tabindex="0" onclick="">
                                <div class="banner-item-top">
                                    <div class="banner-img">
                                        <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                    </div>
                                    <div class="banner-title">
                                        <p class="banner-main-title">강남인근 면접 스터디 모집4</p>
                                        <p class="banner-id">Jihyeon</p>
                                    </div>
                                </div>
                                <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                        <!-- 다른 슬라이드들 추가 가능 -->
                    </div>
                    <!-- 페이지 네이션 -->
                    <div class="swiper-pagination"></div>

                    <!-- 이전, 다음 버튼 -->
                    <div class="swiper-button-prev"></div>
                    <button class="control-button"><i class="bi bi-pause"></i></button>
                    <div class="swiper-button-next"></div>
                </div>
                <%--슬라이더 끝--%>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>

    <%-- 로그인 성공 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>알림</h4>
                <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
            </div>
            <div id="messageContent" class="modal-center">
                <%-- 메시지 내용이 여기에 표시됩니다. --%>
            </div>
            <div class="modal-bottom">
                <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>

    <jsp:include page="include/footer.jsp"/>
</div>
<script>
    $(document).ready(function () {
        if ("${error}" !== "") {
            $("#messageContent").text("${error}");
            $('#modal-container').toggleClass('opaque'); //모달 활성화
            $('#modal-container').toggleClass('unstaged');
            $('#modal-close').focus();
        }

        if ("${msg}" !== "") {
            $("#messageContent").text("${msg}");
            $('#modal-container').toggleClass('opaque'); //모달 활성화
            $('#modal-container').toggleClass('unstaged');
            $('#modal-close').focus();
        }
    });
</script>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${root}/resources/js/slider.js"></script>
</body>
</html>