<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원정보 수정 > 내 정보 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<script>
    $(document).ajaxSend(function(e, xhr, options) {
        xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
    });
</script>
<script>
    $(document).ready(function() {
        // 회원가입 결과 메시지 처리 (모달 표시)
        <c:if test="${not empty error}">
        $("#messageContent").text("${error}");
        $('#modal-container').toggleClass('opaque'); //모달 활성화
        $('#modal-container').toggleClass('unstaged');
        $('#modal-close').focus();
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
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
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
                <h1>나의 정보</h1>
                <div class="updateForm bgwhite">
                    <form method="POST" action="${root }/Users/userUpdate" id="user">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <div class="userinputbox">
                            <label for="name">이름<span class="essential">*</span></label>
                            <input type="text" id="name" name="name" value="${userVo.name}" readonly required>
                        </div>
                        <div class="userinputbox">
                            <label for="username">아이디<span class="essential">*</span></label>
                            <input type="text" id="username" name="username" value="${userVo.username}" readonly required>
                            <span id="usernameCheckResult"></span>
                        </div>
                        <div class="userinputbox">
                            <label for="password">비밀번호<span class="essential">*</span></label>
                            <input type="password" id="password" name="password" placeholder="변경하려는 비밀번호를 입력해주세요" required>
                        </div>
                        <div class="userinputbox">
                            <label for="password2">비밀번호 확인<span class="essential">*</span></label>
                            <input type="password" id="password2" name="password2" placeholder="비밀번호 확인을 입력해주세요" required>
                            <span id="passwordCheckResult"></span>
                        </div>
                        <div class="userinputbox">
                            <label for="birthdate">생년월일<span class="essential">*</span></label>
                            <input type="text" id="birthdate" name="birthdate" value="${userVo.birthdate}" readonly required>
                        </div>
                        <div class="userinputbox">
                            <label for="tel">전화번호<span class="essential">*</span></label>
                            <input type="text" id="tel" name="tel" value="Users테이블에전화번호열필요" disabled required>
                        </div>
                        <div class="userinputbox">
                            <label for="gender">성별<span class="essential">*</span></label>
                            <input type="text" id="gender" name="gender" value="${userVo.gender}" disabled required>
                        </div>
                        <div class="userinputbox">
                            <label for="email">이메일<span class="essential">*</span></label>
                            <input type="email" id="email" name="email" placeholder="변경하려는 이메일을 입력해주세요">
                        </div>
                        <div class="userinputbox">
                            <dt>프로필</dt>
                            <dd class="profile-chage">
                                <input type="file" id="imageChange">
                                <label for="imageChange">
                                    <i class="bi bi-plus-lg"></i>
                                    <img src="${root}/resources/images/${userVo.profileImage}" alt="내 프로필" width="100px" height="100px">
                                </label>
                                <div class="profile-change">
                                    <p>우리 스터디를 표현할 아이콘을 등록해주세요.</p>
                                    <p>(300px X 300px / 500kb 미만)</p>
                                </div>
                            </dd>
                        </div>
                        <div class="buttonBox">
                            <button class="updatebutton secondary-default" type="button">취소</button>
                            <button class="updatebutton primary-default" type="submit">정보 수정</button>
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
                            <%-- 메시지 내용이 여기에 표시됩니다. --%>
                            <c:if test="${not empty error}">
                                <p>${error}</p>
                            </c:if>
                        </div>
                        <div class="modal-bottom">
                            <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
                        </div>
                    </div>
                </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
    <jsp:include page="../include/timer.jsp" />
</div>
</body>
</html>
