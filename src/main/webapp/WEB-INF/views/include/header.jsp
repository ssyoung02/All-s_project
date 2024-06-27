<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="userVoUpdatedProfile" value="${sessionScope.userVoUpdated}"/>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>--%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>

<!-- 헤더 영역 -->
<header>
    <!--스킵 내비게이션-->
    <div id="skipnav">
        <a href="#content">본문 바로가기</a>
    </div>
    <div class="logoarea">
        <!-- 로고 이미지 -->
        <a href="${root}/main"><img class="logo" src="${root}/resources/images/logo.png" style="width:100%" alt="all's 로고"/></a>
    </div>

        <div class="r-header">
            <div id="topmenu">
                <%-- 로그인한 사용자에게만 정보 표시 --%>
                <sec:authorize access="isAuthenticated()">
                    <%-- 관리자 권한을 가진 사용자에게만 표시 --%>
                    <script>
                        $(document).ready(function() {
                            $.ajax({
                                url: "${root}/Users/isAdmin",
                                method: "GET",
                                success: function(isAdmin) {
                                    if (isAdmin) {
                                        $('.manager-page').show();
                                    }
                                }
                            });
                        });
                    </script>
                    <%-- 관리자 권한을 가진 사용자에게만 표시 --%>
                    <a class="manager-page" href="${root}/admin/websiteInfo" style="display: none;"><i class="bi bi-gear"></i>관리자</a>
                </sec:authorize>
                <!-- 날씨 정보 링크 -->
                <a class="weather" href="#"><i class="bi bi-cloud-moon"></i>강남구 25°C</a>
                <%-- 로그인한 사용자에게만 정보 표시 --%>
                <sec:authorize access="isAuthenticated()">
                    <!-- 프로필 링크 -->
                    <a class="profile" href="#">
                        <div class="profile-img">
                            <c:choose>
                                <c:when test="${not empty userVoUpdatedProfile}">
                                    <img src="${userVoUpdatedProfile}?t=${System.currentTimeMillis()}" alt="Profile Image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${userVo.profileImage}?t=${System.currentTimeMillis()}" onerror="this.onerror=null; this.src='${root}/resources/profileImages/${userVo.profileImage}';" alt="Profile Image">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <span class="new-mark"><i class="bi bi-circle-fill"></i></span>
                    </a>
                    <!-- 알림 영역 -->
                    <div class="alarm flex-colum hidden">
                        <div>
                            <div class="profile-img">
                                <c:choose>
                                    <c:when test="${not empty userVoUpdatedProfile}">
                                        <img src="${userVoUpdatedProfile}?t=${System.currentTimeMillis()}" alt="Profile Image">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${userVo.profileImage}?t=${System.currentTimeMillis()}" onerror="this.onerror=null; this.src='${root}/resources/profileImages/${userVo.profileImage}';" alt="Profile Image">
                                    </c:otherwise>
                                </c:choose>                            </div>
                            <p class="profile-username">${userVo.name}</p>
                        </div>
                        <div class="alarmList">
                            <h3>알림 내역</h3>
                            <ul>
                                <li>
                                    <a href="#">
                                        <i class="bi bi-person-plus"></i>
                                        1건의 가입신청이 존재합니다
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <i class="bi bi-bell"></i>
                                        회원 등급이 상승했습니다
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <i class="bi bi-filter-square"></i>
                                        댓글이 달렸습니다
                                    </a>
                                </li>
                                <li>
                                    <a href="#">
                                        <i class="bi bi-filter-square"></i>
                                        좋아요가 눌렸습니다
                                    </a>
                                </li>
                            </ul>
                        </div>
                        <!-- 로그아웃 버튼 -->
                        <form method="POST" action="${root}/Users/logout">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <button class="secondary-default" type="submit">로그아웃</button>
                        </form>
                    </div>
                </sec:authorize>
            </div>
            <!-- 모바일 사이즈 메뉴 -->
            <div class="m-size-nav">
                <button class="secondary-default menu-open">
                    <i class="bi bi-list"></i>
                    <span class="hide">메뉴 열기</span>
                </button>
                <!-- 공부 시작 버튼 -->
                <button id="m-timestart" class="primary-default" onclick="timerOpen()">공부 시작</button>
            </div>
        </div>
    </header>
