<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <style>
        .webInfo-item dd {
            margin-left: 10px;
        }
    </style>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>웹사이트 정보 > 관리자 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
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
                <h1>웹사이트 관리</h1>
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem tapSelect">
                        <a href="${root}/admin/websiteInfo">웹사이트 정보</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/admin/userManagement">회원 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/admin/boardManagement">게시판 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/admin/studyManagement">스터디 관리</a>
                    </div>
                </div>
                <%--탭 메뉴 끝--%>
                <%--탭 상세--%>
                <div class="tabInfo">
                    <div class="webInfo-item">
                        <dt>사이트 이름</dt>
                        <dd>All's</dd>
                    </div>
                    <div class="webInfo-item">
                        <dt>사이트 URL</dt>
                        <dd>www.alls.com</dd>
                    </div>
                    <div class="webInfo-item">
                        <dt>전체 회원 수</dt>
                        <dd>${totalUsers} 명</dd>
                    </div>
                    <div class="webInfo-item">
                        <dt>총 스터디 수</dt>
                        <dd>${totalStudies} 개</dd>
                    </div>
                    <div class="webInfo-item">
                        <dt>총 게시글 수</dt>
                        <dd>${totalPosts} 개</dd>
                    </div>
                    <div class="webInfo-item">
                        <dt>사이트 제작</dt>
                        <dd>스터디하는 42조</dd>
                    </div>
                </div>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
</div>
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>
