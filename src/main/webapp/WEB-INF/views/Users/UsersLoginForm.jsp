<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>로그인 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body class="loginbg">
    <div class="logo">
        <a href="${root}/main"><img class="logo" src="${root}/resources/images/logo.png" style="width:15%" alt="all's 로고"/></a>
    </div>
    <div class="loginbox bgwhite">
        <div class="login-title flex-between">
            <h1>로그인</h1>
            <a href="${root}/Users/Join">회원이 아니신가요? <span class="underline">회원가입</span></a>
        </div>
        <form method="POST" action="${root}/Users/Login">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <div class="inputbox">
                <label for="username">아이디</label>
                <input type="text" id="username" name="username" placeholder="아이디를 입력해주세요" required>
            </div>
            <div class="inputbox">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" placeholder="비밀번호를 입력해주세요" required >
            </div>
            <div class="idpwsearch">
                <a href="#">아이디/비밀번호 찾기</a>
            </div>
            <button class="loginbutton primary-default" type="submit">로그인</button>
            <div class="orline flex-row">
                <hr>
                <p class="or">OR</p>
                <hr>
            </div>
            <div class="snsloginarea">
                <a href="#"><img src="${root}/resources/images/sns-kakao.png" alt="카카오 로그인"></a>
                <a href="#"><img src="${root}/resources/images/sns-naver.png" alt="네이버 로그인"></a>
                <a href="#"><img src="${root}/resources/images/sns-google.png" alt="구글 로그인"></a>
            </div>
        </form>
    </div>

    <%--    로그인 처리 팝업--%>
    <div class="modal fade" id="errorModal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="errorModalLabel">오류</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="errorMessage">
                    <%-- 오류 메시지가 여기에 표시됩니다. --%>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>


<%-- 로그인 실패 메시지 표시 --%>
<c:if test="${param.error != null}">
    <p>
        <c:choose>
            <c:when test="${SPRING_SECURITY_LAST_EXCEPTION.message == 'Bad credentials'}">
                아이디 또는 비밀번호가 맞지 않습니다.
            </c:when>
            <c:when test="${SPRING_SECURITY_LAST_EXCEPTION.message == 'User is disabled'}">
                계정이 비활성화되었습니다.
            </c:when>
            <c:when test="${SPRING_SECURITY_LAST_EXCEPTION.message == 'User account is locked'}">
                계정이 잠겼습니다.
            </c:when>
            <c:otherwise>
                로그인에 실패했습니다.
            </c:otherwise>
        </c:choose>
    </p>
</c:if>

<script>
    $(document).ready(function() {
        <c:if test="${param.error != null || param.expired != null || param.invalid != null}">
        $("#errorMessage").text("${SPRING_SECURITY_LAST_EXCEPTION.message}"); // 오류 메시지 설정
        $("#errorModal").modal("show"); // 모달 표시
        </c:if>

        <c:if test="${param.error != null}">
        $("#username").val("${SPRING_SECURITY_LAST_USERNAME}"); // 로그인 실패 시 아이디 값 유지
        </c:if>
    });
</script>

</body>
</html>
