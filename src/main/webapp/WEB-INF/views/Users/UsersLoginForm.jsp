f<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
%>

<c:set var="root" value="${pageContext.request.contextPath }"/>
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
            <input type="hidden" name="loginState" value="${loginState}" />
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
<%--
            <div class="idpwsearch">
                <a href="#">아이디/비밀번호 찾기</a>
            </div>
            <div class="remember-me">
                <input type="checkbox" id="remember-me" name="remember-me">
                <label for="remember-me">로그인 상태 유지</label> &lt;%&ndash; Remember-Me 체크박스 추가 &ndash;%&gt;
            </div>
--%>
            <button class="loginbutton primary-default" type="submit">로그인</button>
            <div class="orline flex-row">
                <hr>
                <p class="or">OR</p>
                <hr>
            </div>
            <div class="snsloginarea">
                <a href="https://kauth.kakao.com/oauth/authorize?client_id=78180039709b2c1a976f10b5b9ce0d24&redirect_uri=http://localhost:8080/kakao/login/alls&response_type=code"><img src="${root}/resources/images/sns-kakao.png" alt="카카오 로그인"></a>                <a href="${root}/login/naver"><img src="${root}/resources/images/sns-naver.png" alt="네이버 로그인"></a>
                <a href="${root}/login/google"><img src="${root}/resources/images/sns-google.png" alt="구글 로그인"></a>
            </div>
        </form>
    </div>

    <%-- 오류 메세지 모달 --%>
    <div id="modal-container" class="modal unstaged" onclick="modalClose(event)">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>오류 메세지</h4>
                <button class="modal-close-x" aria-label="닫기" onclick="modalClose(event)">
                    <i class="bi bi-x-lg"></i>
                </button>
            </div>
            <div id="errorMessage" class="modal-center">
                <c:if test="${not empty param.error}">
                    ${sessionScope.error}
                </c:if>
            </div>
            <div class="modal-bottom">
                <button type="button" class="modal-close" data-dismiss="modal" onclick="modalClose(event)">닫기</button>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            <c:if test="${not empty param.error}">
            console.log("Error: " + ${param.error});
            $("#errorMessage").text("아이디 또는 비밀번호가 맞지 않습니다"); // 오류 메시지 설정
            $('#modal-container').toggleClass('opaque');
            $('#modal-container').toggleClass('unstaged');
            $('.modal-close-x').focus();


                <c:if test="${not empty sessionScope.loginusername}">

                var loginusername = "${sessionScope.loginusername}"; // 세션에서 값 가져오기
                console.log("Username: " + loginusername);
                $("#username").val(loginusername);

                </c:if>
            </c:if>
        });

        <%session.removeAttribute("error");%>
    </script>


</body>
</html>
