<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>멤버 관리 > 관리 > 스터디그룹 > 내 스터디 > 스터디 > 공부 > All's</title>
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
                <h1>내 스터디</h1>
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerInfo">스터디 정보</a>
                    </div>
                    <div class="tapItem tapSelect">
                        <a href="${root}/studyGroup/studyGroupManagerMember?studyIdx=${studyGroup.studyIdx}">멤버 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerSchedule?studyIdx=${studyGroup.studyIdx}">일정 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerManagement?studyIdx=${studyGroup.studyIdx}">스터디 관리</a>
                    </div>
                </div>
                <%--탭 메뉴 끝--%>

                <table class="manager-table">
                    <caption style="opacity: 0">스터디 멤버 관리표. 강제 탈퇴 및 가입 승인이 가능합니다</caption>
                    <thead>
                    <tr>
                        <th scope="col">멤버명</th>
                        <th scope="col">멤버등급</th>
                        <th scope="col">가입날짜</th>
                        <th scope="col">공부시간</th>
                        <th scope="col">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="member" items="${members}">
                        <tr class="tableList">
                            <td>${member.userName}</td>
                            <td>${member.role}</td>
                            <td>${member.createdAt}</td>
                            <td>${member.studyTime != null ? member.studyTime : 'N/A'}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>오류 메세지</h4>
                <button class="modal-close-x" aria-label="닫기" onclick="madalClose()"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                선택한 회원을 강제탈퇴 시키겠습니까?
            </div>
            <div class="modal-bottom">
                <button class="secondary-default" onclick="madalClose()">취소</button>
                <button type="button" class="modal-close" data-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
