<%--
  Created by IntelliJ IDEA.
  Date: 2024-06-14
  Time: 오후 12:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/> --%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<%--이제 필요없는 코드 --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>내 정보</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
        <!-- 메뉴 영역 -->

        <!-- 본문 영역 -->
        <main>
            <%-- 로그인한 사용자에게만 정보 표시 --%>
            <sec:authorize access="isAuthenticated()">
                <c:if test="${not empty error}">
                    <p>${error}</p>
                </c:if>
                <c:if test="${not empty msg1}">
                    <p>${msg1}: ${msg2}</p>
                </c:if>
                <div>
                    <c:if test="${not empty userVo.profileImage}">
                        <img src="${root}/resources/images/${userVo.profileImage}" alt="프로필 이미지" class="profile-image">
                    </c:if>
                    <p>이름: ${userVo.name}</p>
                    <p>아이디: ${userVo.username}</p>
                    <p>이메일: ${userVo.email}</p>
                    <p>생년월일: ${userVo.birthdate}</p>
                    <p>성별: ${userVo.gender}</p>
                    <p>위도: ${userVo.latitude}</p>
                    <p>경도: ${userVo.longitude}</p>
                    <p>등급: ${userVo.gradeIdx}</p>
                    <p>SNS계정가입유무: ${userVo.socialLogin}</p>
                    <p>계정생성: ${userVo.createdAt}</p>
                    <p>계정수정: ${userVo.updatedAt}</p>
                </div>
            </sec:authorize>

            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>대시보드</h1>
                <%-- 로그인하지 않은 사용자에게만 표시 --%>
                <sec:authorize access="isAnonymous()">
                    <div class="non-login-section">
                        <div class="service-info bg-green">
                            <div class="service-info-left">
                                <h3>서비스</h3>
                                <h2>혼자 공부하기 힘든 분들을 위한 스터디 서비스!</h2>
                                <p>다양한 학습 관리, 정보 제공, 취업 지원 기능을 통합하여 학습자가 효율적으로 자기계발과 목표 달성에 집중할 수 있도록 돕는 포괄적인 스터디 플랫폼을
                                    제공합니다</p>
                            </div>
                            <div class="service-info-right flex-colum">
                                <button class="secondary-default">공부노트<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">캘린더<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">스터디 그룹<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">공부 자료<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">이력서 작성<i class="bi bi-arrow-right"></i></button>
                            </div>
                        </div>
                        <div class="iogin-info flex-colum bg-green">
                            <h3>지금부터<br> 함께 공부해봐요!</h3>
                            <button class="primary-default" onclick="location.href='${root}/Users/UserLoginForm'">로그인
                            </button>
                            <button class="secondary-default" onclick="location.href='${root}/Users/Join'">회원가입</button>
                        </div>
                    </div>
                </sec:authorize>
                <%-- 로그인한 사용자에게만 정보 표시 --%>
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${not empty error}">
                        <p>${error}</p>
                    </c:if>
                    <c:if test="${not empty msg1}">
                        <p>${msg1}: ${msg2}</p>
                    </c:if>
                    <div>
                        <c:if test="${not empty userVo.profileImage}">
                            <img src="${root}/resources/images/${userVo.profileImage}" alt="프로필 이미지" class="profile-image">
                        </c:if>
                        <p>이름: ${userVo.name}</p>
                        <p>아이디: ${userVo.username}</p>
                        <p>이메일: ${userVo.email}</p>
                        <p>생년월일: ${userVo.birthdate}</p>
                        <p>성별: ${userVo.gender}</p>
                        <p>위도: ${userVo.latitude}</p>
                        <p>경도: ${userVo.longitude}</p>
                        <p>등급: ${userVo.gradeIdx}</p>
                        <p>SNS계정가입유무: ${userVo.socialLogin}</p>
                        <p>계정생성: ${userVo.createdAt}</p>
                        <p>계정수정: ${userVo.updatedAt}</p>
                    </div>
                </sec:authorize>
            </div>
        </main>
    </section>




<%-- Modal 추가 --%>
<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-labelledby="messageModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="messageModalLabel">알림</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body" id="messageContent">
                <%-- 메시지 내용이 여기에 표시됩니다. --%>
                <c:if test="${not empty error}">
                    <p>${error}</p>
                </c:if>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>