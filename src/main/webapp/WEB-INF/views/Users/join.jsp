<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="googleUserInfo" value="${googleUserInfo}"/>
<c:set var="kakaoUserInfo" value="${kakaoUserInfo}"/>
<c:set var="naverUserInfo" value="${naverUserInfo}"/>
<c:set var="error" value="${requestScope.error}"/>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>--%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원가입 > All's</title>
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
        <h1>회원가입</h1>
        <a href="${root}/Users/UserLoginForm">이미 회원이신가요? <span class="underline">로그인</span></a>
    </div>

    <form method="POST" action="${root }/Users/UsersRegister" id="registerForm">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

        <c:if test="${not empty kakaoUserInfo.name}">
            <input type="hidden" name="profileImage" value="${kakaoUserInfo.profileImage}"
                   alt="https://www.talktobiz.co.kr/resources/images/ico/ico_kakao_chat.png">
            <input type="hidden" name="provider" value="kakao">
            <input type="hidden" name="socialLogin" value="true">
        </c:if>
        <c:if test="${not empty naverUserInfo.name}">
            <input type="hidden" name="profileImage" value="${naverUserInfo.profileImage}"
                   alt="https://clova-phinf.pstatic.net/MjAxODAzMjlfOTIg/MDAxNTIyMjg3MzM3OTAy.WkiZikYhauL1hnpLWmCUBJvKjr6xnkmzP99rZPFXVwgg.mNH66A47eL0Mf8G34mPlwBFKP0nZBf2ZJn5D4Rvs8Vwg.PNG/image.png">
            <input type="hidden" name="provider" value="naver">
            <input type="hidden" name="socialLogin" value="true">
        </c:if>
        <c:if test="${not empty googleUserInfo.name}">
            <input type="hidden" name="profileImage" value="${googleUserInfo.profileImage}"
                   alt="https://www.google.com/url?sa=i&url=https%3A%2F%2Ficonscout.com%2Ficons%2Fgoogle&psig=AOvVaw0dbE76jSgtZP20FKYyxeEW&ust=1719040155908000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCJi8yOCR7IYDFQAAAAAdAAAAABAI">
            <input type="hidden" name="provider" value="google">
            <input type="hidden" name="socialLogin" value="true">
        </c:if>

        <div class="inputbox">
            <label for="name">이름<span class="essential">*</span></label>
            <c:choose>
                <c:when test="${not empty googleUserInfo.name}">
                    <input type="text" id="name" name="name" value="${googleUserInfo.name}" readonly>
                </c:when>
                <c:when test="${not empty kakaoUserInfo.name}">
                    <input type="text" id="name" name="name" value="${kakaoUserInfo.name}" readonly>
                </c:when>
                <c:when test="${not empty naverUserInfo.name}">
                    <input type="text" id="name" name="name" value="${naverUserInfo.name}" readonly>
                </c:when>
                <c:otherwise>
                    <input type="text" id="name" name="name" placeholder="이름을 입력해주세요" required>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="inputbox">
            <label for="username">아이디<span class="essential">*</span></label>
            <div class="input-row flex-between">
                <c:choose>
                    <c:when test="${not empty googleUserInfo.email}">
                        <input type="text" id="username" name="username" value="${googleUserInfo.email}" readonly>
                    </c:when>
                    <c:when test="${not empty kakaoUserInfo.email}">
                        <input type="text" id="username" name="username" value="${kakaoUserInfo.email}" readonly>
                    </c:when>
                    <c:when test="${not empty naverUserInfo.email}">
                        <input type="text" id="username" name="username" value="${naverUserInfo.email}" readonly>
                    </c:when>
                    <c:otherwise>
                        <input type="text" id="username" name="username" placeholder="아이디를 입력해주세요" required>
                    </c:otherwise>
                </c:choose>
                <button class="double-check primary-default" type="button" onclick="checkDuplicate()">중복확인</button>
            </div>
            <span id="usernameCheckResult"></span>
        </div>
        <div class="inputbox">
            <c:choose>
                <c:when test="${not empty googleUserInfo.name}">
                    <input type="hidden" id="password" name="password" value="socialAllsOnlyPw11구글로그인" readonly>
                </c:when>
                <c:when test="${not empty kakaoUserInfo.name}">
                    <input type="hidden" id="password" name="password" value="socialAllsOnlyPw11카카오로그인" readonly>
                </c:when>
                <c:when test="${not empty naverUserInfo.name}">
                    <input type="hidden" id="password" name="password" value="socialAllsOnlyPw22네이버로그인" readonly>
                </c:when>
                <c:otherwise>
                    <label for="password">비밀번호<span class="essential">*</span></label>
                    <input type="password" id="password" name="password" placeholder="비밀번호를 입력해주세요" required>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="inputbox">
            <c:choose>
                <c:when test="${not empty googleUserInfo.name}">
                    <input type="hidden" id="password2" name="password2" value="socialAllsOnlyPw11구글로그인" readonly>
                </c:when>
                <c:when test="${not empty kakaoUserInfo.name}">
                    <input type="hidden" id="password2" name="password2" value="socialAllsOnlyPw11카카오로그인" readonly>
                </c:when>
                <c:when test="${not empty naverUserInfo.name}">
                    <input type="hidden" id="password2" name="password2" value="socialAllsOnlyPw22네이버로그인" readonly>
                </c:when>
                <c:otherwise>
                    <label for="password2">비밀번호 확인<span class="essential">*</span></label>
                    <input type="password" id="password2" name="password2" placeholder="비밀번호 확인을 입력해주세요" required>
                </c:otherwise>
            </c:choose>
            <span id="passwordCheckResult"></span>
        </div>
        <div class="inputbox">
            <label for="mobile">휴대전화<span class="essential">*</span></label>
            <c:choose>
                <c:when test="${not empty kakaoUserInfo.mobile}">
                    <input type="text" id="mobile" name="mobile" value="${kakaoUserInfo.mobile}" required>
                </c:when>
                <c:when test="${not empty naverUserInfo.mobile}">
                    <input type="text" id="mobile" name="mobile" value="${naverUserInfo.mobile}" readonly>
                </c:when>
                <c:otherwise>
                    <input type="text" id="mobile" name="mobile" placeholder="휴대전화번호를 입력해주세요" required>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="inputbox">
            <c:choose>
                <c:when test="${not empty naverUserInfo.birthdate}">
                    <label for="birthdate">생년월일<span class="essential">*</span></label>
                    <input type="date" id="birthdate" name="birthdate" value="${naverUserInfo.birthdate}" readonly>
                </c:when>
                <c:otherwise>
                    <label for="birthdate">생년월일<span class="essential">*</span></label>
                    <input type="date" id="birthdate" name="birthdate" required>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="inputbox">
            <label>성별<span class="essential">*</span></label>
            <div class="">
                <c:choose>
                    <c:when test="${not empty kakaoUserInfo.gender}">
                        <input id="male" class="gender" name="gender" type="radio"
                               value="M" ${kakaoUserInfo.gender == 'M' ? 'checked' : ''} >
                        <label for="male">남자</label>
                        <input id="female" class="gender" name="gender" type="radio"
                               value="F" ${kakaoUserInfo.gender == 'F' ? 'checked' : ''} >
                        <label for="female">여자</label>
                        <input id="other" class="gender" name="gender" type="radio"
                               value="OTHER" ${kakaoUserInfo.gender == 'OTHER' ? 'checked' : ''}>
                        <label for="other">기타</label>
                    </c:when>
                    <c:when test="${not empty naverUserInfo.gender}">
                        <input id="male" class="gender" name="gender" type="radio"
                               value="M" ${naverUserInfo.gender == 'M' ? 'checked' : ''} readonly>
                        <label for="male">남자</label>
                        <input id="female" class="gender" name="gender" type="radio"
                               value="F" ${naverUserInfo.gender == 'F' ? 'checked' : ''} readonly>
                        <label for="female">여자</label>
                        <input id="other" class="gender" name="gender" type="radio"
                               value="OTHER" ${naverUserInfo.gender == 'OTHER' ? 'checked' : ''} readonly>
                        <label for="other">기타</label>
                    </c:when>
                    <c:otherwise>
                        <input id="male" class="gender" name="gender" type="radio" value="M" required>
                        <label for="male">남자</label>
                        <input id="female" class="gender" name="gender" type="radio" value="F">
                        <label for="female">여자</label>
                        <input id="other" class="gender" name="gender" type="radio" value="OTHER">
                        <label for="other">기타</label>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="inputbox">
            <label for="email">이메일<span class="essential">*</span></label>
            <c:choose>
                <c:when test="${not empty googleUserInfo.email}">
                    <input type="text" id="email" name="email" value="${googleUserInfo.email}" readonly>
                </c:when>
                <c:when test="${not empty kakaoUserInfo.email}">
                    <input type="text" id="email" name="email" value="${kakaoUserInfo.email}" readonly>
                </c:when>
                <c:when test="${not empty naverUserInfo.email}">
                    <input type="text" id="email" name="email" value="${naverUserInfo.email}" readonly>
                </c:when>
                <c:otherwise>
                    <input type="text" id="email" name="email" placeholder="이메일을 입력해주세요" required>
                </c:otherwise>
            </c:choose>
        </div>
        <button class="loginbutton primary-default" type="submit">회원가입</button>
    </form>
</div>

<%-- 오류 메세지 모달 --%>
<div id="modal-container" class="modal unstaged">
    <div class="modal-overlay">
    </div>
    <div class="modal-contents">
        <div class="modal-text flex-between">
            <h4>오류 메세지</h4>
            <button class="modal-close-x" aria-label="닫기" onclick="madalClose()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="modal-center">
            <%-- 메시지 내용이 여기에 표시됩니다. --%>
            <c:if test="${not empty param.error}">
                <p>${requestScope.error}</p>
            </c:if>
        </div>
        <div class="modal-bottom">
            <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
        </div>
    </div>
</div>
</body>
<script>
    $(document).ready(function () {
// 회원가입 결과 메시지 처리 (모달 표시)
        <c:if test="${not empty param.error}">
        $("#messageContent").text("${requestScope.error}");
        $('#modal-container').toggleClass('opaque'); //모달 활성화
        $('#modal-container').toggleClass('unstaged');
        $('.modal-close-x').focus();
        </c:if>
    });

    function checkDuplicate() {
        const username = $("#username").val();
        $.ajax({
            url: "/Users/checkDuplicate",
            type: "POST",
            data: {username: username},
            success: function (response) {
                if (response === 0) {
                    $("#usernameCheckResult").text("사용 가능한 아이디입니다.");
                    $("#usernameCheckResult").removeClass("error").addClass("success");
                } else {
                    $("#usernameCheckResult").text("이미 사용 중인 아이디입니다.");
                    $("#usernameCheckResult").removeClass("success").addClass("error");
                }

            },
            error: function () { // AJAX 요청 실패 시
                $("#usernameCheckResult").text("중복 확인 중 오류가 발생했습니다.");
                $("#usernameCheckResult").removeClass("success").addClass("error");
            }
        });
    }

    function modalClose() {
        $('#modal-container').removeClass('opaque').addClass('unstaged');
    }
</script>
</html>
