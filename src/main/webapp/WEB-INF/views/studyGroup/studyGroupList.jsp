<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css?after">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
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

                <!--본문 콘텐츠-->
                <div class="maxcontent">
                    <div class="list-title flex-between">
                        <h3>가입 스터디(5)</h3>
                        <fieldset class="search-box flex-row">
                            <select name="searchCnd" title="검색 조건 선택">
                                <option value="제목">제목</option>
                                <option value="글내용">글내용</option>
                            </select>
                            <p class="search-field">
                                <input type="text" name="searchWrd" placeholder="검색어를 입력해주세요">
                                <button type="submit">
                                    <span class="hide">검색</span>
                                    <i class="bi bi-search"></i>
                                </button>
                            </p>
                        </fieldset>
                    </div>
                    <div class="boardContent flex-colum">
                        <div class="board-listBoarder flex-columleft" onclick="location.href='${root}/studyGroup/studyGroupMain'">
                            <div class="studygroup-item flex-between">
                                <!--스터디 목록-->
                                <div class="imgtitle flex-row">
                                    <div class="studygroup-profile-s">
                                        <img src="../img/logo.png">
                                    </div>
                                    <div class="board-item flex-columleft">
                                        <p class="board-title">자바 공부할 사람 모여라</p>
                                        <p class="board-content">전공자, 비전공자 상관없이 자바에 올인할 사람들을 위한 모임</p>
                                    </div>
                                </div>
                                <!--운영중인 스터디일 경우-->
                                <div>
                                    <p class="operate secondary-default">운영</p>
                                </div>
                            </div>
                        </div>
                        <div class="board-listBoarder flex-columleft">
                            <div class="studygroup-item flex-between">
                                <!--스터디 목록-->
                                <div class="imgtitle flex-row">
                                    <div class="studygroup-profile-s">
                                        <img src="../img/logo.png">
                                    </div>
                                    <div class="board-item flex-columleft">
                                        <p class="board-title">자바 공부할 사람 모여라</p>
                                        <p class="board-content">전공자, 비전공자 상관없이 자바에 올인할 사람들을 위한 모임</p>
                                    </div>
                                </div>
                                <!--운영중인 스터디일 경우-->
                                <div>
                                    <p></p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="board-bottom">
                        <button class="primary-default" onclick="location.href='${root}/studyGroup/studyGroupCreate'">스터디 만들기</button>
                    </div>
                </div>
                <%--본문 콘텐츠--%>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
