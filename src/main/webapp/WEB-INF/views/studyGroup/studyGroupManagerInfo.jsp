<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 정보 > 관리 > 스터디그룹 > 내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <script>
        function updateStudyGroup() {
            if (confirm('수정하시겠습니까?')) {
                document.getElementById('updateForm').submit();
            }
        }
    </script>
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
                <h1>스터디</h1>
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem tapSelect">
                        <a href="${root}/studyGroup/studyGroupManagerInfo?studyIdx=${studyGroup.studyIdx}">스터디 정보</a>
                    </div>
                    <div class="tapItem">
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
                <%--탭 상세--%>
                <form id="updateForm" action="${root}/studyGroup/updateStudyGroup" method="post">
                    <sec:csrfInput /> <%-- CSRF 토큰 추가 --%>
                    <input type="hidden" name="studyIdx" value="${studyGroup.studyIdx}" />
                    <div class="tabInfo">
                        <div class="webInfo-itemfull">
                            <dt>스터디명</dt>
                            <dd><input class="manager-studyName" name="descriptionTitle" value="${studyGroup.descriptionTitle}" title="스터디명"></dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>설 명</dt>
                            <dd>
                                <textarea name="description" placeholder="스터디를 설명할 문장을 입력해주세요" title="설명">${studyGroup.description}</textarea>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>프로필</dt>
                            <dd class="profile-chage">
                                <form action="" class="group-imgChange">
                                    <input type="file" id="imageChange">
                                    <label for="imageChange" class="imgbox">
                                        <i class="bi bi-plus-lg"></i>
                                        <img src="${studyGroup.image}" alt="스터디 그룹 프로필" width="100px" height="100px">
                                    </label>
                                </form>
                                <div class="profile-change">
                                    <p>우리 스터디를 표현할 아이콘을 등록해주세요.</p>
                                    <p>(300px X 300px / 500kb 미만)</p>
                                </div>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>지역</dt>
                            <dd>
                                <div class="location-select">
                                    <select id="state" title="광역시/도 선택">
                                        <option>광역시/도</option>
                                    </select>
                                    <select id="district" title="지역 선택">
                                        <option>지역 상세</option>
                                    </select>
                                </div>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>모집분야</dt>
                            <dd>
                                <input type="radio" id="interview" name="category" value="면접"
                                       <c:if test="${studyGroup.category eq '면접'}">checked</c:if>>
                                <label for="interview">면접</label>
                                <input type="radio" id="introduction" name="category" value="자소서"
                                       <c:if test="${studyGroup.category eq '자소서'}">checked</c:if>>
                                <label for="introduction">자소서</label>
                                <input type="radio" id="certificate" name="category" value="자격증"
                                       <c:if test="${studyGroup.category eq '자격증'}">checked</c:if>>
                                <label for="certificate">자격증</label>
                                <input type="radio" id="studyGroup" name="category" value="스터디"
                                       <c:if test="${studyGroup.category eq '스터디'}">checked</c:if>>
                                <label for="studyGroup">스터디</label>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>연령대</dt>
                            <dd>
                                <ul class="todolist">
                                    <!-- 할 일 항목 -->
                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '20대')}">
                                            <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대" checked="checked">
                                            <label for="twenty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                20대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '20대')}">
                                            <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대">
                                            <label for="twenty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                20대
                                            </label>
                                        </c:if>
                                    </li>
                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '30대')}">
                                            <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대" checked="checked">
                                            <label for="thirty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                30대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '30대')}">
                                            <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대">
                                            <label for="thirty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                30대
                                            </label>
                                        </c:if>
                                    </li>

                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '40대')}">
                                            <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대" checked="checked">
                                            <label for="forty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                40대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '40대')}">
                                            <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대">
                                            <label for="forty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                40대
                                            </label>
                                        </c:if>
                                    </li>

                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '연령무관')}">
                                            <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관" checked="checked">
                                            <label for="allAge" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                연령무관
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '연령무관')}">
                                            <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관">
                                            <label for="allAge" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                연령무관
                                            </label>
                                        </c:if>
                                    </li>
                                </ul>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>성별</dt>
                            <dd>
                                <input id="male" class="gender" name="gender" type="radio" value="남자"
                                       <c:if test="${studyGroup.gender eq '남자'}">checked</c:if>>
                                <label for="male">남자</label>
                                <input id="female" class="gender" name="gender" type="radio" value="여자"
                                       <c:if test="${studyGroup.gender eq '여자'}">checked</c:if>>
                                <label for="female">여자</label>
                                <input id="allGender" class="gender" name="gender" type="radio" value="성별무관"
                                       <c:if test="${studyGroup.gender eq '성별무관'}">checked</c:if>>
                                <label for="allGender">남여모두</label>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>온/오프라인</dt>
                            <dd>
                                <input id="online" name="studyOnline" type="radio" value="true"
                                       <c:if test="${studyGroup.studyOnline}">checked</c:if>>
                                <label for="online">온라인</label>
                                <input id="offline" name="studyOnline" type="radio" value="false"
                                       <c:if test="${!studyGroup.studyOnline}">checked</c:if>>
                                <label for="offline">오프라인</label>
                            </dd>
                        </div>
                    </div>
                    <div class="board-bottom">
                        <button type="button" class="secondary-default" onclick="location.href='${root}/studyGroupMain?studyIdx=${studyGroup.studyIdx}'">취소</button>
                        <button type="button" class="primary-default" onclick="updateStudyGroup()">수정</button>
                    </div>
                </form>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
