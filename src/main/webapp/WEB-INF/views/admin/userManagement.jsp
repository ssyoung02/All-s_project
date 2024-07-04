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
    <script>
        // 선택된 회원 강제 탈퇴
        function deleteSelectedUsers() {
            const selectedUserIds = [];
            $('input[name="selectedUserIds"]:checked').each(function() {
                selectedUserIds.push($(this).val());
            });

            if (selectedUserIds.length === 0) {
                alert("강제 탈퇴할 회원을 선택해주세요.");
                return;
            }

            if (confirm("선택한 회원을 강제 탈퇴시키겠습니까?")) {
                const csrfToken = $('meta[name="_csrf"]').attr('content');
                const csrfHeaderName = $('meta[name="_csrf_header"]').attr('content');

                $.ajax({
                    url: '${root}/admin/deleteUsers',
                    type: 'DELETE',
                    data: JSON.stringify({ userIds: selectedUserIds }),
                    contentType: 'application/json',
                    headers: {
                        [csrfHeaderName]: csrfToken
                    },
                    success: function(result) {
                        if (result.success) {
                            alert("선택한 회원이 강제 탈퇴되었습니다.");
                            location.reload();
                        } else {
                            const errorMessage = result.error || "회원 강제 탈퇴에 실패했습니다.";
                            alert(errorMessage);
                        }
                    },
                    error: function(error) {
                        alert("요청 중 오류가 발생했습니다.");
                    }
                });
            }
        }

        // 개별 회원 강제 탈퇴
        function deleteUser(userIdx) {
            if (confirm("정말로 이 회원을 강제 탈퇴시키겠습니까?")) {
                const csrfToken = $('meta[name="_csrf"]').attr('content');
                const csrfHeaderName = $('meta[name="_csrf_header"]').attr('content');

                $.ajax({
                    url: '${root}/admin/deleteUser',
                    type: 'DELETE',
                    data: JSON.stringify({ userIdx: userIdx }),
                    contentType: 'application/json',
                    headers: {
                        [csrfHeaderName]: csrfToken
                    },
                    success: function(result) {
                        if (result.success) {
                            alert("회원이 강제 탈퇴되었습니다.");
                            location.reload();
                        } else {
                            const errorMessage = result.error || "회원 강제 탈퇴에 실패했습니다.";
                            alert(errorMessage);
                        }
                    },
                    error: function() {
                        alert("요청 중 오류가 발생했습니다.");
                    }
                });
            }
        }

        // 서버에서 전달받은 학습 시간(초)을 시:분:초 형태로 변환하는 함수
        function formatTime(seconds) {
            const h = Math.floor(seconds / 3600);
            const m = Math.floor((seconds % 3600) / 60);
            const s = seconds % 60;
            return `${h > 0 ? h + '시간 ' : ''}${m > 0 ? m + '분 ' : ''}${s}초`;
        }

    </script>
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
                        <button class="secondary-default" onclick="deleteSelectedUsers()">선택 회원 강제탈퇴</button>
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
                        <th scope="col">공부 시간</th>
                        <th scope="col" class="trbutton">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr class="tableList">
                            <td>
                                <input type="checkbox" id="todolist${user.userIdx}" class="todo-checkbox" name="selectedUserIds" value="${user.userIdx}">
                                <label for="todolist${user.userIdx}" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                </label>
                            </td>
                            <td>${user.username}</td>
                            <td>${user.authorityName}</td>
                            <td>${user.formattedCreatedAt}</td>
                            <td>
                                <script>
                                    document.write(formatTime(${user.totalStudyTime})); // user.totalStudyTime을 formatTime 함수에 전달
                                </script>
                            </td>
                            <td>
                                <button class="secondary-default" onclick="deleteUser(${user.userIdx})">강제 탈퇴</button>
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
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
    <jsp:include page="../include/timer.jsp" />
</div>
</body>
</html>
