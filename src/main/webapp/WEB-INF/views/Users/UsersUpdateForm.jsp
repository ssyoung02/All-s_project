<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo"
       value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth"
       value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />
<!DOCTYPE html>
<html>
<head>
    <title>회원 정보 수정</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <style>
        .error {
            color: red;
        }
    </style>
</head>
<body>
<h2>회원 정보 수정</h2>
<form:form method="POST" action="${root}/Users/UsersUpdate" id="updateForm" modelAttribute="userVo">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    <div>
        <form:label path="username">아이디:</form:label>
        <form:input path="username" readonly="true" />
    </div>
    <div>
        <form:label path="password">새 비밀번호:</form:label>
        <form:password path="password" id="password" />
    </div>
    <div>
        <label for="password2">새 비밀번호 확인:</label>
        <input type="password" id="password2" name="password2">
        <span id="passwordCheckResult"></span>
    </div>
    <div>
        <form:label path="name">이름:</form:label>
        <form:input path="name" required="true"/>
        <form:errors path="name" cssClass="error"/>
    </div>
    <div>
        <form:label path="email">이메일:</form:label>
        <form:input path="email" type="email" required="true"/>
        <form:errors path="email" cssClass="error"/>
    </div>
    <div>
        <form:label path="birthdate">생년월일:</form:label>
        <form:input path="birthdate" type="date" required="true"/>
        <form:errors path="birthdate" cssClass="error"/>
    </div>
    <button type="submit">정보 수정</button>
</form:form>
<script>
    $(document).ready(function() {
        $("#updateForm").submit(function(event) {
            const password1 = $("#password").val();
            const password2 = $("#password2").val();

            if (password1 !== password2) {
                $("#passwordCheckResult").text("비밀번호가 일치하지 않습니다.");
                $("#passwordCheckResult").addClass("error");
                event.preventDefault();
            }else{
                $("#passwordCheckResult").text("");
                $("#passwordCheckResult").removeClass("error");
            }
        });
    });
</script>
</body>
</html>
