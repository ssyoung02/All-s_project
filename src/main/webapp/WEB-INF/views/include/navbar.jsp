<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>


<head>
    <meta charset="UTF-8">
    <title>All's</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
<div class="menu">
    <%-- 로그인한 사용자에게만 표시 --%>
    <sec:authorize access="isAuthenticated()">
        <button class="primary-default timestart" onclick="timerOpen()">공부 시작</button>
    </sec:authorize>    <div id="lnb" class="lnb">
        <ul class="main-menu">
            <li class="menu-item">
                <div class="menu-area menu-select">
                    <a href="${root}/main" class="menu-top">대시보드</a>
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
                            <form method="POST" action="<c:url value='${root }/studyNote/noteList' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">내 공부노트</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div class="menu-area">
                            <form method="POST" action="<c:url value='${root}/calendar' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">캘린더</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item dropdown">
                        <div class="menu-area menu-icon flex-between">
                            <a href="${root}/studyGroup/studyGroupList" class="menu-text">스터디</a>
                            <button class="tertiary-default">
                                <i class="bi bi-dash-lg"></i>
                                <span class="hide">메뉴 열기/닫기</span>
                            </button>
                        </div>
                        <ul class="dropdown-menu">
                            <li class="dropdown-item">
                                <div class="menu-area">
                                    <form method="POST" action="<c:url value='${root}/studyGroup/studyGroupList' />">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="link-button">내 스터디</button>
                                    </form>
                                </div>
                            </li>
                            <li class="dropdown-item">
                                <div class="menu-area">
                                    <form method="POST" action="<c:url value='${root}/studyRecruit/recruitList' />">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <button type="submit" class="link-button">스터디 모집</button>
                                    </form>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <li class="submenu-item">
                        <div class="menu-area">
                            <form method="POST" action="<c:url value='${root }/studyReferences/referencesList' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">공부 자료</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div class="menu-area">
                            <a href="${root}/studyReferences/referencesSite">관련 사이트</a>
                        </div>
                    </li>
                </ul>
            </li>
            <li class="menu-item">
                <div class="menu-area menu-icon flex-between">
                    <a href="${root}/Users/userInfo" class="menu-top menu-text">내 정보</a>
                    <button class="tertiary-default">
                        <i class="bi bi-chevron-up"></i>
                        <span class="hide">메뉴 열기/닫기</span>
                    </button>
                </div>
                <ul class="submenu">
                    <li class="submenu-item">
                        <div class="menu-area">
                            <form method="POST" action="<c:url value='${root }/myPage/myPageInfo' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">나의 정보</button>
                            </form>
<%--                            <form method="POST" action="<c:url value='${root }/Users/userInfoProcess' />">--%>
<%--                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />--%>
<%--                                <button type="submit" class="link-button">나의 정보</button>--%>
<%--                            </form>--%>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div class="menu-area">
                            <form method="POST" action="<c:url value='${root }/Users/userEdit' />">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">정보 수정</button>
                            </form>
                        </div>
                    </li>
                    <li class="submenu-item">
                        <div class="menu-area">
                            <form method="POST" action="<c:url value='${root}/Users/userdelete'/>">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                <button type="submit" class="link-button">회원 탈퇴</button>
                            </form>
                        </div>
                    </li>
                </ul>
            </li>
        </ul>
    </div>
</div>
</body>

