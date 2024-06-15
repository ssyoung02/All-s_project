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
    <div class="menu">
        <button class="primary-default timestart" onclick="timerOpen()">공부 시작</button>
        <div id="lnb" class="lnb">
            <ul class="main-menu">
                <li class="menu-item">
                    <div class="menu-area menu-select">
                        <a href="#" class="menu-top">대시보드</a>
                    </div>
                </li>
                <li class="menu-item">
                    <div class="menu-area menu-icon flex-between">
                        <a href="#" class="menu-top menu-text">공부</a>
                        <button class="tertiary-default">
                            <i class="bi bi-chevron-up"></i>
                            <span class="hide">메뉴 열기/닫기</span>
                        </button>
                    </div>
                    <ul class="submenu">
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="#">내 공부노트</a>
                            </div>
                        </li>
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="#">캘린더</a>
                            </div>
                        </li>
                        <li class="submenu-item dropdown">
                            <div class="menu-area menu-icon flex-between">
                                <a href="#" class="menu-text">스터디</a>
                                <button class="tertiary-default">
                                    <i class="bi bi-dash-lg"></i>
                                    <span class="hide">메뉴 열기/닫기</span>
                                </button>
                            </div>
                            <ul class="dropdown-menu">
                                <li class="dropdown-item">
                                    <div class="menu-area">
                                        <a href="#">내 스터디</a>
                                    </div>
                                </li>
                                <li class="dropdown-item">
                                    <div class="menu-area">
                                        <a href="#">스터디 모집</a>
                                    </div>
                                </li>
                            </ul>
                        </li>
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="/StudyReferences/referencesList">공부 자료</a>
                            </div>
                        </li>
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="#">관련 사이트</a>
                            </div>
                        </li>
                    </ul>
                </li>
                <li class="menu-item">
                    <div class="menu-area menu-icon flex-between">
                        <a href="#" class="menu-top menu-text">내 정보</a>
                        <button class="tertiary-default">
                            <i class="bi bi-chevron-up"></i>
                            <span class="hide">메뉴 열기/닫기</span>
                        </button>
                    </div>
                    <ul class="submenu">
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="#">나의 정보</a>
                            </div>
                        </li>
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="#">정보 수정</a>
                            </div>
                        </li>
                        <li class="submenu-item">
                            <div class="menu-area">
                                <a href="#">회원 탈퇴</a>
                            </div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>
</body>
</html>
