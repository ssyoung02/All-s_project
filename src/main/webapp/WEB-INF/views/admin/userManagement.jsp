<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원 관리 > 관리자 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/pagenation.css">
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
                    <div class="tapItem">
                        <a href="${root}/admin/websiteInfo">웹사이트 정보</a>
                    </div>
                    <div class="tapItem tapSelect">
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
                <div class="list-title flex-between">
                    <h3>전체 회원</h3>
                    <fieldset class="search-box flex-row">
                        <button class="secondary-default">선택회원 강제탈퇴</button>
                        <p class="search-field">
                            <input type="text" name="searchWrd" placeholder="검색어를 입력해주세요">
                            <button type="submit">
                                <span class="hide">검색</span>
                                <i class="bi bi-search"></i>
                            </button>
                        </p>
                    </fieldset>
                </div>
                <table class="manager-table">
                    <caption style="opacity: 0">전체 회원수 관리표. 회원 정보와 강제탈퇴 버튼이 있습니다</caption>
                    <thead>
                    <tr>
                        <th scope="col" class="trselect">선택</th>
                        <th scope="col" class="trname">회원명</th>
                        <th scope="col" class="trname">멤버등급</th>
                        <th scope="col" class="trtime">가입날짜</th>
                        <th scope="col">공부시간</th>
                        <th scope="col" class="trbutton">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr class="tableList">
                            <td>
                                <input type="checkbox" id="todolist${user.userIdx}" class="todo-checkbox">
                                <label for="todolist${user.userIdx}" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                </label>
                            </td>
                            <td>${user.username}</td>
                            <td>${user.authorityName}</td>
                            <td>${user.formattedCreatedAt}</td>
                            <td>${user.totalStudyTime} 시간</td>
                            <td>
                                <button class="button-disabled" tabindex="-1">강제 탈퇴</button>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>

                <!-- 페이지네이션 바 시작 -->
                <div class="pagination">
                    <ul>
                        <c:if test="${startPage > 1}">
                            <li><a href="?page=1">&lt;&lt;</a></li>
                        </c:if>
                        <c:if test="${currentPage > 1}">
                            <li><a href="?page=${currentPage - 1}">&lt;</a></li>
                        </c:if>
                        <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                            <li class="${pageNum == currentPage ? 'active' : ''}">
                                <a href="?page=${pageNum}">${pageNum}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li><a href="?page=${currentPage + 1}">&gt;</a></li>
                        </c:if>
                        <c:if test="${endPage < totalPages}">
                            <li><a href="?page=${totalPages}">&gt;&gt;</a></li>
                        </c:if>
                    </ul>
                </div>
                <!-- 페이지네이션 바 끝 -->


            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <%-- 오류 메세지 모달 --%>
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
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>
