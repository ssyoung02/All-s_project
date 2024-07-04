<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
%>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 관리 > 관리자 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/pagenation.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <script>
        function deleteSelectedStudies() {
            const selectedStudyIds = [];
            $('input[name="selectedStudyIds"]:checked').each(function() {
                selectedStudyIds.push($(this).val());
            });

            if (selectedStudyIds.length === 0) {
                alert("삭제할 스터디를 선택해주세요.");
                return;
            }

            if (confirm("선택한 스터디를 삭제하시겠습니까?")) {
                const csrfToken = $('meta[name="_csrf"]').attr('content');
                const csrfHeaderName = $('meta[name="_csrf_header"]').attr('content');

                $.ajax({
                    url: '${root}/admin/deleteStudies',
                    type: 'DELETE',
                    data: JSON.stringify({ studyIds: selectedStudyIds }),
                    contentType: 'application/json',
                    headers: {
                        [csrfHeaderName]: csrfToken
                    },
                    success: function(result) {
                        if (result.success) {
                            alert("선택한 스터디가 삭제되었습니다.");
                            location.reload(); // 페이지 새로고침
                        } else {
                            const errorMessage = result.error || "스터디 삭제에 실패했습니다.";
                            alert(errorMessage);
                        }
                    },
                    error: function(error) {
                        alert("요청 중 오류가 발생했습니다.");
                    }
                });
            }
        }

        function deleteStudy(studyIdx) {
            if (confirm("정말로 이 스터디를 삭제하시겠습니까?")) {
                $.ajax({
                    url: '${root}/admin/deleteStudy',// 쿼리 파라미터 형태로 전달
                    type: 'DELETE',
                    data: JSON.stringify({ studyIdx: studyIdx }), // studyIdx를 JSON 데이터로 전송
                    contentType: 'application/json',
                    success: function(result) {
                        if (result.success) {
                            alert("스터디가 삭제되었습니다.");
                            location.reload(); // 페이지 새로고침
                        } else {
                            // 추가적인 예외 정보를 받을 경우 처리
                            const errorMessage = result.error || "스터디 삭제에 실패했습니다.";
                            alert(errorMessage);
                        }
                    },
                    error: function() {
                        alert("요청 중 오류가 발생했습니다.");
                    }
                });
            }
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
                    <div class="tapItem">
                        <a href="${root}/admin/userManagement">회원 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/admin/boardManagement">게시판 관리</a>
                    </div>
                    <div class="tapItem tapSelect">
                        <a href="${root}/admin/studyManagement">스터디 관리</a>
                    </div>
                </div>
                <%--탭 메뉴 끝--%>
                <div class="list-title flex-between">
                    <h3>신고된 스터디</h3>
                    <fieldset class="search-box flex-row">
                        <button class="secondary-default" onclick="deleteSelectedStudies()">선택 스터디 삭제</button>
                    </fieldset>
                </div>
                <table class="manager-table">
                    <caption style="opacity: 0">전체 스터디 관리표. 스터디 정보와 삭제 버튼이 있습니다</caption>
                    <thead>
                    <tr>
                        <th scope="col" class="trselect">선택</th>
                        <th scope="col" class="trname">스터디장</th>
                        <th scope="col">스터디명</th>
                        <th scope="col" class="trtime">생성날짜</th>
                        <th scope="col" class="trcount">신고 횟수</th>
                        <th scope="col" class="trbutton">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="study" items="${reportedStudies}">
                        <tr class="tableList">
                            <td>
                                <input type="checkbox" id="todolist${study.studyIdx}" class="todo-checkbox" name="selectedStudyIds" value="${study.studyIdx}">
                                <label for="todolist${study.studyIdx}" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                </label>
                            </td>
                            <td>${study.leaderName}</td>
                            <td>${study.studyTitle}</td>
                            <td>${study.createdAtString}</td>
                            <td>${study.reportCount}</td>
                            <td>
                                <button class="secondary-default" onclick="deleteStudy(${study.studyIdx})">스터디 삭제</button>
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
</div>
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>
