<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원탈퇴 > 내 정보 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/css/common.css">
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
    <section class="mainContaner">
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
                <h1>회원탈퇴</h1>

                <!--각 페이지의 콘텐츠-->

                    <form method="POST" action="${root }/Users/userEdit" id="userEditForm">
                        <div class="updateForm bgwhite">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="inputbox">
                                <label for="username">아이디<span class="essential">*</span></label>
                                <input type="text" id="username" name="username" value="Jihyeon" disabled required>
                                <span id="usernameCheckResult"></span>
                            </div>
                            <div class="inputbox">
                                <label for="password">비밀번호<span class="essential">*</span></label>
                                <input type="password" id="password" name="password" placeholder="변경하려는 비밀번호를 입력해주세요" required>
                            </div>
                            <div class="inputbox">
                                <label for="password2">비밀번호 확인<span class="essential">*</span></label>
                                <input type="password" id="password2" name="password2" placeholder="비밀번호 확인을 입력해주세요" required>
                                <span id="passwordCheckResult"></span>
                            </div>
                        </div>
                        <div class="buttonBox">
                            <button class="updatebutton primary-default" type="submit">회원 탈퇴</button>
                            <button class="updatebutton secondary-default" type="button">취소</button>
                        </div>
                    </form>


                <%-- 오류 메세지 모달 --%>
                <div id="modal-container" class="modal unstaged">
                    <div class="modal-overlay">
                    </div>
                    <div class="modal-contents">
                        <div class="modal-text flex-between">
                            <h4>오류 메세지</h4>
                            <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
                        </div>
                        <div class="modal-center">
                            <%-- 메시지 내용이 여기에 표시됩니다. --%>
                            <c:if test="${not empty error}">
                                <p>${error}</p>
                            </c:if>
                        </div>
                        <div class="modal-bottom">
                            <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
                        </div>
                    </div>
                </div>
                <%--콘텐츠 끝--%>

            </div>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
