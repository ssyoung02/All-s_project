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
    <title>글쓰기 > 내 공부노트 > 공부 > All's</title>
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
                <!--본문 콘텐츠-->
                <h4 class="s-header">글쓰기</h4>
                <div class="maxcontent">
                    <div class="post-area">
                        <input type="text" id="writeTitle" title="제목" placeholder="제목을 입력해주세요">
                        <ul class="todolist">
                            <!-- 태그 항목 -->
                            <li>
                                <input type="checkbox" id="public" class="todo-checkbox">
                                <label for="public" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                    게시물 비공개
                                </label>
                            </li>
                        </ul>
                            <textarea id="write-textarea" title="게시글 작성">
                            </textarea>
                            <div class="buttonBox">
                                <button class="updatebutton secondary-default" type="button" onclick="location.href='${root}/studyNote/noteList'">취소</button>
                                <button class="updatebutton primary-default" type="submit">저장</button>
                            </div>
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
