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
                <h1>내 공부노트</h1>

                <div class="post-area">
                    <p class="study-tag">
                        <span class="recruit-status closed">모집완료</span>
                        <span class="department">면접</span>
                        <span class="study-tagItem">#위치</span>
                        <span class="study-tagItem">#성별</span>
                        <span class="study-tagItem">#연령대</span>
                        <span class="study-tagItem">#성별</span>
                        <span class="study-tagItem">#온라인</span>
                    </p>
                    <div class="studygroup-item flex-between">
                        <!--스터디 목록-->
                        <div class="imgtitle flex-row">
                            <div class="board-item flex-columleft">
                                <h3 class="board-title">제목</h3>
                                <p>작성자: 유저네임  |   작성일: 2024.06.19  |  조회수:  30</p>
                            </div>
                        </div>
                        <!--좋아요-->
                        <div class="board-button">
                            <button class="flex-row" onclick="toggleLike(this, ${studyReferencesEntity.referenceIdx})">
                                <i class="bi bi-heart-fill"></i>
                                <p class="info-post ">좋아요</p>
                            </button>|
                            <button class="report">신고</button>
                        </div>
                    </div>
                    <div class="post-content">내용</div>
                    <div class="buttonBox">
                        <button class="primary-default" onclick="modalOpen()">가입 신청</button>
                    </div>
                </div>
                <div class="board-bottom">
                    <button class="secondary-default" onclick="">삭제</button>
                    <button class="secondary-default" onclick="">수정</button>
                    <button class="primary-default" onclick="">목록</button>
                </div>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />

    <%-- 오류 메세지 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h3>백엔드 개발자 코등 면접 같이 준비하실 분</h3>
                <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                <textarea class="board-textarea">
신청서를 작성해주세요
예)
거주지(또는 직장):
성별:
나이:
신청이유:
                </textarea>
            </div>
            <div class="modal-bottom">
                <button type="button" class="secondary-default" data-dismiss="modal">취소</button>
                <button type="button" class="primary-default" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>

</div>
</body>
</html>
