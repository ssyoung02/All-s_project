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
                <h1>웹사이트 관리</h1>
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem">
                        <a href="${root}admin/websiteInfo">웹사이트 정보</a>
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
                    <h3>전체 회원 수(5)</h3>
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
                    <tr class="tableList">
                        <td>
                            <input type="checkbox" id="todolist1" class="todo-checkbox">
                            <label for="todolist1" class="todo-label">
                                <span class="checkmark"><i class="bi bi-square"></i></span>
                            </label>
                        </td>
                        <td>Jihyeon</td>
                        <td>관리자</td>
                        <td>2024.06.10</td>
                        <td>204시간</td>
                        <td>
                            <button class="button-disabled" tabindex="-1">강제 탈퇴</button>
                        </td>
                    </tr>
                    <tr class="tableList">
                        <td>
                            <input type="checkbox" id="todolist11" class="todo-checkbox">
                            <label for="todolist11" class="todo-label">
                                <span class="checkmark"><i class="bi bi-square"></i></span>
                            </label>
                        </td>
                        <td>Yejoon</td>
                        <td>일반멤버</td>
                        <td>2024.06.13</td>
                        <td>154시간</td>
                        <td>
                            <button class="secondary-default">강제 탈퇴</button>
                        </td>
                    </tr>
                    </tbody>
                </table>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
