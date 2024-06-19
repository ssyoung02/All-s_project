<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세 > 내 공부노트 > 공부 > All's</title>
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
                        <div class="studygroup-item flex-between">
                            <!--스터디 목록-->
                            <div class="imgtitle flex-row">
                                <div class="board-item flex-columleft">
                                    <h3 class="board-title">12. 클래스와 생성자 함수</h3>
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
                    </div>
                    <div class="comment">
                        <h4 class="s-header">댓글(2)</h4>
                        <div class="flex-between">
                            <input id="comment-input" type="text" title="댓글입력" placeholder="댓글을 입력해주세요">
                            <button class="primary-default">댓글 입력</button>
                        </div>
                        <div class="comment-list">
                            <div class="comment-item">
                                <div class="comment-user flex-between">
                                    <div class="flex-row">
                                        <div class="profile-img">
                                            <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                        </div>
                                        <div class="comment-profile">
                                            <p class="comment-userId">Jihyeon</p>
                                            <p>2024.06.09</p>
                                        </div>
                                    </div>
                                    <button aria-label="댓글 삭제">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                                <p class="comment-detail">자바 공부중입니다</p>
                            </div>
                            <div class="comment-item">
                                <div class="comment-user flex-between">
                                    <div class="flex-row">
                                        <div class="profile-img">
                                            <img src="${root}/resources/images/기본이미지.gif" alt="프로필">
                                        </div>
                                        <div class="comment-profile">
                                            <p class="comment-userId">Yejoon</p>
                                            <p>2024.06.10</p>
                                        </div>
                                    </div>
                                    <button aria-label="댓글 삭제">
                                        <i class="bi bi-x-lg"></i>
                                    </button>
                                </div>
                                <p class="comment-detail">잘 보고 갑니다~</p>
                            </div>

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
