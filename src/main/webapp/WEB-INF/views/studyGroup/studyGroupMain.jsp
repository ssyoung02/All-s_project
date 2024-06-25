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
    <script>
        function openChatWindow() {
            window.open('${root}/studyGroup/chat', 'ChatWindow', 'width=400,height=500');
        }
    </script>
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
                            <button class="primary-default" onclick="openChatWindow(${study.studyIdx})">채팅</button>
                        </div>
                    </section>
                    <section class="group-main">
                        <div class="group-content">
                            <h3>이달의 스터디 왕</h3>
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
                            <div class="group-calender">
                                <h3>그룹 일정</h3>
                                <%--캘린더--%>
                            </div>
                        </div>
                        <div class="group-member">
                            <h3>그룹 멤버</h3>
                            <div class="group-memberList">
                                <c:forEach var="member" items="${members}">
                                    <div class="group-memberItem">
                                        <div class="profile-imgGroup">
                                            <div class="profile-img">
                                                <img src="${root}/resources/images/09.%20carrot.png" alt="프로필 이미지">
                                            </div>
                                            <div class="status"><span class="status">접속중</span></div>
                                        </div>
                                        <p class="memberId">${member.userName}</p>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </section>
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
