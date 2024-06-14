<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body class="loginbg">
    <div class="logo">
        <a href="01. main.html"><img class="logo" src="${root}/resources/images/logo.png" style="width:15%" alt="all's 로고"/></a>
    </div>
    <div class="loginbox bgwhite">
        <div class="login-title flex-between">
            <h1>회원가입</h1>
            <a href="${root}/Users/UserLoginForm">이미 회원이신가요? <span class="underline">로그인</span></a>
        </div>

        <form method="POST" action="${root }/Users/UsersRegister" id="registerForm">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="inputbox">
                <label for="name">이름<span class="essential">*</span></label>
                <input type="text" id="name" name="name" placeholder="이름을 입력해주세요" required>
            </div>
            <div class="inputbox">
                <label for="username">아이디<span class="essential">*</span></label>
                <div class="input-row flex-between">
                    <input type="text" id="username" name="username" placeholder="이름을 입력해주세요" required>
                    <button class="double-check primary-default" onclick="checkDuplicate()">중복확인</button>
                </div>
                <span id="usernameCheckResult"></span>
            </div>
            <div class="inputbox">
                <label for="password">비밀번호<span class="essential">*</span></label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력해주세요" required>
            </div>
            <div class="inputbox">
                <label for="password2">비밀번호 확인<span class="essential">*</span></label>
                <input type="password" id="password2" name="password2" placeholder="비밀번호 확인을 입력해주세요" required>
                <span id="passwordCheckResult"></span>
            </div>
            <div class="inputbox">
                <label for="birthdate">생년월일<span class="essential">*</span></label>
                <input type="date" id="birthdate" name="birthdate" required>
            </div>
            <div class="inputbox">
                <label>성별<span class="essential">*</span></label>
                <div class="">
                    <input id="male" class="gender" name="gender" type="radio" value="M" required>
                    <label for="male">남자</label>
                    <input id="female" class="gender" name="gender" type="radio" value="F">
                    <label for="female">여자</label>
                    <input id="other" class="gender" name="gender" type="radio" value="OTHER">
                    <label for="other">기타</label>
                </div>
            </div>
            <div class="inputbox">
                <label for="email">이메일<span class="essential">*</span></label>
                <input type="email" id="email" name="email" placeholder="이메일을 입력해주세요">
            </div>
            <button class="loginbutton primary-default" type="submit">회원가입</button>
        </form>
    </div>

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
    <script>
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
    </script>
</body>
</html>
