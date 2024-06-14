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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <style>
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
<script>

    $("#registerForm").submit(function(event) {
        const password = $("#password").val();
        const password2 = $("#password2").val();

        if (password !== password2) {
            $("#passwordCheckResult").text("비밀번호가 일치하지 않습니다.");
            $("#passwordCheckResult").removeClass("success").addClass("error");
            event.preventDefault(); // 폼 제출 방지
        } else {
            // 비밀번호가 일치하면 password2 필드 제거 후 제출
            $("#password2").remove();
            $("#passwordCheckResult").remove(); // 오류 메시지 제거
            this.submit(); // 폼 제출
        }
    });
    $(document).ready(function() {
        // 회원가입 결과 메시지 처리 (모달 표시)
        <c:if test="${not empty error}">
        $("#messageContent").text("${error}");
        $("#messageModal").modal("show");
        </c:if>
    });

    function checkDuplicate() {
        const username = $("#username").val();
        $.ajax({
            url: "/Users/checkDuplicate",
            type: "POST",
            data: { username: username },
            success: function(response) {
                if (response === 0) {
                    $("#usernameCheckResult").text("사용 가능한 아이디입니다.");
                    $("#usernameCheckResult").removeClass("error").addClass("success");
                } else {
                    $("#usernameCheckResult").text("이미 사용 중인 아이디입니다.");
                    $("#usernameCheckResult").removeClass("success").addClass("error");
                }

            },
            error: function() { // AJAX 요청 실패 시
                $("#usernameCheckResult").text("중복 확인 중 오류가 발생했습니다.");
                $("#usernameCheckResult").removeClass("success").addClass("error");
            }
        });
    }
</script>

<h2>회원가입</h2>
<form method="POST" action="${root }/Users/UsersRegister" id="registerForm">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> <%-- CSRF 토큰 추가 --%>
    <div>
        <label for="username">아이디:</label>
        <input type="text" id="username" name="username" required>
        <button type="button" onclick="checkDuplicate()">중복 확인</button>
        <span id="usernameCheckResult"></span>
    </div>
    <div>
        <label for="password">비밀번호:</label>
        <input type="password" id="password" name="password" required>
    </div>
    <div>
        <label for="password2">비밀번호 확인:</label>
        <input type="password" id="password2" name="password2" required>
        <span id="passwordCheckResult"></span>
    </div>
    <div>
        <label for="name">이름:</label>
        <input type="text" id="name" name="name" required>
    </div>
    <div>
        <label for="email">이메일:</label>
        <input type="email" id="email" name="email" required>
    </div>
    <div>
        <label for="birthdate">생년월일:</label>
        <input type="date" id="birthdate" name="birthdate" required>
    </div>
    <div>
        <label for="gender">성별:</label>
        <select id="gender" name="gender">
            <option value="M">남성</option>
            <option value="F">여성</option>
            <option value="OTHER">기타</option>
        </select>
    </div>
    <button type="submit">회원가입</button>
</form>


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
