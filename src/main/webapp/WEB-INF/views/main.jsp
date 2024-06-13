<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />

<!DOCTYPE html>
<html>
<head>
    <title>메인 페이지</title>
    <style>
        .profile-image {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body>
<h2>메인 페이지</h2>

<sec:authorize access="isAuthenticated()"> <%-- 로그인한 사용자에게만 정보 표시 --%>
    <div>
        <c:if test="${not empty userVo.profileImage}">
            <img src="${root}/resources/images/${userVo.profileImage}" alt="프로필 이미지" class="profile-image">
        </c:if>
        <p>환영합니다, ${userVo.name}님!</p>
        <p>아이디: ${userVo.username}</p>
        <p>이메일: ${userVo.email}</p>
    </div>
    <div>
        <a href="${root}/Users/UsersUpdateForm">회원 정보 수정</a>
        <a href="${root}/Users/UsersImageForm">프로필 이미지 변경</a>
        <form method="POST" action="${root}/logout">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit">로그아웃</button>
        </form>
    </div>
</sec:authorize>

<sec:authorize access="isAnonymous()"> <%-- 로그인하지 않은 사용자에게만 표시 --%>
    <p>로그인 후 이용 가능합니다.</p>
    <a href="${root}/Users/UsersLoginForm">로그인</a>
    <a href="${root}/Users/Join">회원가입</a>
</sec:authorize>

</body>
</html>
