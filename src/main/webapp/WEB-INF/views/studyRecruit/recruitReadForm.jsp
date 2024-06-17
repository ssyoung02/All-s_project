<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세 > 스터디 모집 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
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
                <h1>내 공부노트</h1>
                <div class="maxcontent">
                    <div class="post-area">
                        <ul class="taglist flex-row">
                            <li class="tagitem ing">모집중</li>
                            <li class="tagitem studyField">면접</li>
                            <li class="tagitem">지역</li>
                            <li class="tagitem">20대</li>
                            <li class="tagitem">성별무관</li>
                            <li class="tagitem">오프라인</li>
                        </ul>
                        <div class="studygroup-item flex-between">
                            <!--스터디 목록-->
                            <div class="imgtitle flex-row">
                                <div class="board-item flex-columleft">
                                    <h3 class="board-title">백앤드 개발자 코딩 면접 같이 준비하실 분</h3>
                                    <p>작성자: Jihyeon  |   작성일: 2024.06.09  |  조회수: 30</p>
                                </div>
                            </div>
                            <!--좋아요-->
                            <div class="board-button">
                                <button class="flex-row">
                                    <i class="bi bi-heart"></i>
                                    <p class="info-post ">좋아요</p>
                                </button>
                                |
                                <button class="report">신고</button>
                            </div>
                        </div>
                        <div class="post-content">
                            <textarea class="board-detail">
1. 전달값(argument)과 매개변수(parameter)
- Method: 일정한 기능을 가짐
- funtion, 함수라고도 함
- 함수를 작성하고, 그 함수를 호출함으로써 실행
- void: 리턴값이 없다
                            </textarea>
                        </div>
                        <div class="buttonBox">
                            <button class="updatebutton primary-default">가입신청</button>
                        </div>
                    </div>
                    <div class="board-bottom">
                        <button class="secondary-default">삭제</button>
                        <button class="secondary-default">수정</button>
                        <button class="primary-default">목록</button>
                    </div>
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
