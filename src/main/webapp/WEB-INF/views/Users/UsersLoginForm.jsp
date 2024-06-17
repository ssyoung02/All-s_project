<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo"
       value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth"
       value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />
<%--SPRING_SECURITY_CONTEXT.authentication.principal은 Spring Security에서 인증된 사용자 정보를 담고 있는 객체입니다.
하지만, 이 객체의 타입은 UserDetails 인터페이스를 구현한 객체입니다.--%>
<%--UserDetails 인터페이스는 사용자 이름, 비밀번호, 권한 등의 정보를 제공하지만, 직접적으로 name, email 등의 추가적인 사용자 정보를 제공하지는 않습니다.--%>
<%--따라서, userVo.name, userVo.email 등의 표현식을 사용하여 값을 가져올 수 없습니다.--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title> 로그인 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body class="loginbg">
<script>
    $(document).ready(function() {
        console.log("Error: ${error}");
        <c:if test="${not empty error}">
        $("#errorMessage").text("${error}"); // 오류 메시지 설정
        $('#modal-container').toggleClass('opaque'); //모달 활성화
        $('#modal-container').toggleClass('unstaged');
        $('#modal-close').focus();
        </c:if>

        <c:if test="${not empty username}">
        console.log("Error:${error}");
        $("#username").val("${username}"); // 로그인 실패 시 아이디 값 유지
        </c:if>
    });       
        
</script>
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
            <div>
                <div class="inputbox">
                    <label for="username">아이디</label>
                    <input type="text" id="username" name="username" placeholder="아이디를 입력해주세요" required>
                </div>
                <div class="inputbox">
                    <label for="password">비밀번호</label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력해주세요" required >
                </div>
            </div>
            <div class="idpwsearch">
                <a href="#">아이디/비밀번호 찾기</a>
            </div>
            <div class="remember-me">
                <input type="checkbox" id="remember-me" name="remember-me">
                <label for="remember-me">로그인 상태 유지</label> <%-- Remember-Me 체크박스 추가 --%>
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

    <%-- 오류 메세지 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>오류 메세지</h4>
                <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                <c:if test="${not empty error}"> <%-- error 메시지 확인 --%>
                    <p>${error}</p>
                </c:if>
            </div>
            <div class="modal-bottom">
                <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
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


</body>
</html>
