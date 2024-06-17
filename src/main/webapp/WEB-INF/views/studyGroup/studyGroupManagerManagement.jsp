<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 관리 > 관리 > 스터디그룹 > 내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
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
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerInfo">스터디 정보</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerMember">멤버 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerSchedule">일정 관리</a>
                    </div>
                    <div class="tapItem tapSelect">
                        <a href="${root}/studyGroup/studyGroupManagerManagement">스터디 관리</a>
                    </div>
                </div>
                <%--탭 메뉴 끝--%>
                <%--탭 상세--%>
                <div class="tabInfo">
                    <div class="webInfo-itemfull">
                        <dt>모집글 제목</dt>
                        <dd><input value="자바 같이 공부해요~" title="모집글 제목" style="width: 30em"></dd>
                    </div>
                    <div class="webInfo-itemfull">
                        <dt>모집글 내용</dt>
                        <dd>
                            <textarea placeholder="스터디를 모집 내용을 입력해주세요" title="모집글 내용">강남근처에서 주1회 같이 공부하실 수 있는 분 구합니다!</textarea>
                        </dd>
                    </div>
                    <div class="webInfo-itemfull">
                        <dt>공개여부</dt>
                        <dd>
                            <input type="radio" id="public" name="public">
                            <label for="public">공개</label>
                            <input type="radio" id="private" name="public">
                            <label for="private">비공개</label>
                        </dd>
                    </div>
                    <div class="webInfo-itemfull">
                        <dt>스터디 삭제</dt>
                        <dd>
                            <a id="studyGroupDelet" href="#">스터디 삭제하기</a>
                        </dd>
                    </div>
                </div>
                <div class="board-bottom">
                    <button class="secondary-default">취소</button>
                    <button class="primary-default">확인</button>
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
