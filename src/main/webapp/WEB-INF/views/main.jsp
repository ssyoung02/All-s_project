<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<%--이제 필요없는 코드 --%>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All's</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="${root}/resources/css/slider.css">

    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
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
                            <div class="sceduler-area">
                                <div class="sceduler">
                                    달력 영역
                                </div>
                                <div class="todo">
                                    <h3>6월 15일</h3>
                                    <div class="achieve">
                                        <div class="todoTitle">달성도</div>
                                        <div class="gaugeBar">
                                            <progress id="progress" value="60" max="100"></progress>
                                        </div>
                                        <p class="percent">60%</p>
                                    </div>
                                    <div class="todoList">
                                        <div class="todoTitle">할 일</div>
                                        <ul class="todolist">
                                            <li>
                                                <input type="checkbox" id="todolist11" class="todo-checkbox">
                                                <label for="todolist11" class="todo-label">
                                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                                    자바 공부
                                                </label>
                                            </li>
                                            <li>
                                                <input type="checkbox" id="todolist22" class="todo-checkbox">
                                                <label for="todolist22" class="todo-label">
                                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                                    면접 준비
                                                </label>
                                            </li>
                                            <li>
                                                <input type="checkbox" id="todolist33" class="todo-checkbox">
                                                <label for="todolist33" class="todo-label">
                                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                                    UI 설계
                                                </label>
                                            </li>
                                            <li>
                                                <input type="checkbox" id="todolist44" class="todo-checkbox">
                                                <label for="todolist44" class="todo-label">
                                                        <span class="checkmark"><i
                                                                class="bi bi-check-square"></i></span>
                                                    자소서 작성
                                                </label>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="loginUserInfoRight">
                            <div class="studyTime">
                                <h2 class="">오늘의 공부 시간</h2>
                                <div>
                                    <div class="todoTitle">Total</div>
                                    <p id="totalstudytime">
                                        <%--<c:set var="totalSeconds" value="${userVo.total_study_time}" />

                                        <c:choose>
                                            <c:when test="${totalSeconds < 60}">
                                                &lt;%&ndash; 60초 미만일 경우: 초만 표시 &ndash;%&gt;
                                                ${totalSeconds} 초
                                            </c:when>
                                            <c:when test="${totalSeconds >= 60 and totalSeconds < 3600}">
                                                &lt;%&ndash; 60초 이상, 3600초 미만일 경우: 분과 초 표시 &ndash;%&gt;
                                                <fmt:formatNumber var="minutes" type="number" pattern="0" value="${totalSeconds / 60}" />
                                                <c:set var="seconds" value="${totalSeconds % 60}" />
                                                ${minutes} 분 ${seconds} 초
                                            </c:when>
                                            <c:otherwise>
                                                &lt;%&ndash; 3600초 이상일 경우: 시간, 분, 초 표시 &ndash;%&gt;
                                                <fmt:formatNumber var="hours" type="number" pattern="0" value="${totalSeconds / 3600}" />
                                                <c:set var="remainingSeconds" value="${totalSeconds % 3600}" />
                                                <fmt:formatNumber var="minutes" type="number" pattern="0" value="${remainingSeconds / 60}" />
                                                <c:set var="seconds" value="${remainingSeconds % 60}" />
                                                ${hours} 시간 ${minutes} 분 ${seconds} 초
                                            </c:otherwise>
                                        </c:choose>--%>
                                    </p>
                                </div>
                                <div>
                                    <div class="todoTitle">Today</div>
                                    <p id="todaystudytime">
                                        <%--<c:set var="todaySeconds" value="${userVo.today_study_time}" />

                                        <c:choose>
                                            <c:when test="${todaySeconds < 60}">
                                                &lt;%&ndash; 60초 미만일 경우: 초만 표시 &ndash;%&gt;
                                                ${todaySeconds} 초
                                            </c:when>
                                            <c:when test="${todaySeconds >= 60 and todaySeconds < 3600}">
                                                &lt;%&ndash; 60초 이상, 3600초 미만일 경우: 분과 초 표시 &ndash;%&gt;
                                                <fmt:formatNumber var="minutes" type="number" pattern="0" value="${todaySeconds / 60}" />
                                                <c:set var="seconds" value="${todaySeconds % 60}" />
                                                ${minutes} 분 ${seconds} 초
                                            </c:when>
                                            <c:otherwise>
                                                &lt;%&ndash; 3600초 이상일 경우: 시간, 분, 초 표시 &ndash;%&gt;
                                                <fmt:formatNumber var="hours" type="number" pattern="0" value="${todaySeconds / 3600}" />
                                                <c:set var="remainingSeconds" value="${todaySeconds % 3600}" />
                                                <fmt:formatNumber var="minutes" type="number" pattern="0" value="${remainingSeconds / 60}" />
                                                <c:set var="seconds" value="${remainingSeconds % 60}" />
                                                ${hours} 시간 ${minutes} 분 ${seconds} 초
                                            </c:otherwise>
                                        </c:choose>--%>
                                    </p>
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
                    <%--공부시간 차트--%>
                    <h3>주간 공부시간</h3>
                    <canvas id="studyTimeChart" style="max-height: 300px;"></canvas>

                </sec:authorize>
                <!--슬라이드 배너-->
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <!--슬라이드 아이템들-->
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                            </dlv>
                        </div>
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                            </dlv>
                        </div>
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                            </dlv>
                        </div>
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                            </dlv>
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
    fetch('/include/updateTime?userIdx=${userVo.userIdx}')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            // 데이터에서 total_study_time과 today_study_time 값을 추출
            const totalStudyTime = data.total_study_time;
            const todayStudyTime = data.today_study_time;

            // HTML 요소에 데이터를 삽입
            document.getElementById('totalstudytime').innerText = formatTime(totalStudyTime);
            document.getElementById('todaystudytime').innerText = formatTime(todayStudyTime);
        })
        .catch(error => {
            console.error('There has been a problem with your fetch operation:', error);
        });

    function formatTime(seconds) {
        const h = Math.floor(seconds / 3600);
        const m = Math.floor((seconds % 3600) / 60);
        const s = seconds % 60;
        const hDisplay = h > 0 ? h + '시간 ' : '';
        const mDisplay = m > 0 ? m + '분 ' : '';
        const sDisplay = s > 0 ? s + '초' : '';
        return hDisplay + mDisplay + sDisplay;
    }

    fetch('/include/study-time?userIdx=${userVo.userIdx}') // Adjust the userIdx as needed
        .then(response => response.json())
        .then(data => {
            const labels = ['일', '월', '화', '수', '목', '금', '토'];
            const currentWeekData = new Array(7).fill(0);
            const previousWeekData = new Array(7).fill(0);

            data.currentWeek.forEach(record => {
                const date = new Date(record.date.year, record.date.monthValue - 1, record.date.dayOfMonth);
                const dayIndex = date.getDay(); // 0 (일요일) - 6 (토요일)
                currentWeekData[dayIndex] = record.study_time;
            });

            data.previousWeek.forEach(record => {
                const date = new Date(record.date.year, record.date.monthValue - 1, record.date.dayOfMonth);
                const dayIndex = date.getDay(); // 0 (일요일) - 6 (토요일)
                previousWeekData[dayIndex] = record.study_time;
            });

            const ctx = document.getElementById('studyTimeChart').getContext('2d');
            new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '저번주',
                            data: previousWeekData,
                            borderColor: 'rgba(75, 192, 192, 1)',
                            borderWidth: 1,
                            backgroundColor: 'rgba(154, 208, 245, 1)',
                            fill: false
                        },
                        {
                            label: '이번주',
                            data: currentWeekData,
                            borderColor: 'rgb(255,99,132)',
                            borderWidth: 1,
                            backgroundColor: 'rgba(255, 177, 193, 1)',
                            fill: false
                        }
                    ]
                },
                options: {
                    maintainAspectRatio: false, // 가로 세로 비율을 유지하지 않음
                    aspectRatio: 4, // 가로 세로 비율 (width / height)
                    scales: {
                        x: {
                            type: 'category', // 범주형 x축
                            labels: labels // 레이블을 요일로 설정
                        },
                        y: {
                            beginAtZero: true, // y축이 0부터 시작하도록 설정
                            display: true // y축 범위 나타내기
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const label = context.dataset.label || '';
                                    const value = context.raw;
                                    return label + ': ' + formatTime(value);
                                }
                            }
                        }
                    }
                }
            });
        })
        .catch(error => {
            console.error('Fetch error:', error);
        });



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