<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공부 자료 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css?after">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
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
                <h1>공부 자료</h1>

                <!--본문 콘텐츠-->
                <div class="maxcontent">
                    <div class="list-title flex-between">
                        <h3>전체 글(5)</h3>
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
                            <button type="button" class="primary-default" onclick="location.href='${root}/studyNote/noteWrite'">글쓰기</button>
                        </fieldset>                    </div>
                    <div class="boardContent flex-colum">
                        <div class="board-listline flex-columleft" onclick="location.href='${root}/studyNote/noteRead'">
                            <div class="studygroup-item flex-between">
                                <!--스터디 목록-->
                                <div class="imgtitle flex-row">
                                    <div class="board-item flex-columleft">
                                        <a href="${root}/studyNote/noteWrite'" class="board-title">12. 클래스와 생성자 함수</a>
                                        <p class="board-content">작성자: Jihyeon  |   작성일: 2024.06.09  |  조회수: 30</p>
                                    </div>
                                </div>
                                <!--좋아요-->
                                <div>
                                    <button class="board-like">
                                        <i class="bi bi-heart"></i>
                                        <p class="info-post ">좋아요</p>
                                    </button>
                                </div>
                            </div>
                            <div class="studygroup-item flex-between">
                                <a href="${root}/studyNote/noteWrite'">
                                    1. Access Modifier의 특징 - 객체의 특정 내용(멤버변수, 멤버함수)에 대해서 외부의 객체가 접근할 수 없도록, 또는 접근하더라도 제한된 방식으로 접근하도록 할 수 있음 - 접근제어, 접근제한, 접근수정 등 다양하게 해석됨 - 적용대상: 클래스, 멤버변수, 멤버함수, 생성자 접근 제어 범위 private 외부 객체 접근 불가. 비공개...
                                </a>
                            </div>
                        </div>
                        <div class="board-listline flex-columleft">
                            <div class="studygroup-item flex-between">
                                <!--스터디 목록-->
                                <div class="imgtitle flex-row">
                                    <div class="board-item flex-columleft">
                                        <h3 class="board-title">12. 클래스와 생성자 함수</h3>
                                        <p class="board-content">작성자: Jihyeon  |   작성일: 2024.06.09  |  조회수: 30</p>
                                    </div>
                                </div>
                                <!--좋아요-->
                                <div>
                                    <button class="board-like">
                                        <i class="bi bi-heart"></i>
                                        <p class="info-post ">좋아요</p>
                                    </button>
                                </div>
                            </div>
                            <div class="studygroup-item flex-between">
                                <p>
                                    1. Access Modifier의 특징 - 객체의 특정 내용(멤버변수, 멤버함수)에 대해서 외부의 객체가 접근할 수 없도록, 또는 접근하더라도 제한된 방식으로 접근하도록 할 수 있음 - 접근제어, 접근제한, 접근수정 등 다양하게 해석됨 - 적용대상: 클래스, 멤버변수, 멤버함수, 생성자 접근 제어 범위 private 외부 객체 접근 불가. 비공개...
                                </p>
                                <img src="/resources/images/02. intellij.png">
                            </div>
                        </div>
                    </div>
                    <div class="flex-row">
                        <button class="secondary-default">목록 더보기</button>
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
