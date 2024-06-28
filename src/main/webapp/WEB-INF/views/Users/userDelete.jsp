<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>회원탈퇴 > 내 정보 > All's</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
        });
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
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
                <h1>회원탈퇴</h1>

                <!--각 페이지의 콘텐츠-->
                <div class="updateForm bgwhite">
                    <form method="POST" action="${root }/Users/delete" id="user">
                        <div class="updateForm bgwhite">
                            <h1>"함께하면 더 멀리 갈 수 있습니다!"</h1>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <input type="hidden" name="userId" value="${userVo.userIdx}" />
                            <input type="hidden" name="username" value="${userVo.username}" />
                            <div>
                                <img src="${root}/resources/images/userDelete.png" style="width: 100%; height: 90%; object-fit: contain;">
                                <ul>
                                    <li><h3>서로에게 도움이 되는 네트워크</h3>: 여러분이 겪는 어려움을 함께 나누고 해결할 수 있는 든든한 동료들이 있습니다.</li>
                                    <li><h3>고유한 학습 자원</h3>: 우리 커뮤니티만의 특별한 자료와 정보를 공유받을 수 있습니다.</li>
                                    <li><h3>동기 부여</h3>: 서로의 성과를 통해 더욱 강력한 동기부여를 얻을 수 있습니다.</li><br>
                                    <li><h2>지금의 노력이 쌓여 큰 성과로 돌아옵니다. 이곳에서 계속 함께 성장해 나가요!</h2></li><br>
                                </ul>
                            </div>

                            <div class="inputbox">
                                <label for="username">아이디<span class="essential">*</span></label>
                                <input type="text" id="username" name="username" value="${userVo.username}" disabled required>
                                <span id="usernameCheckResult"></span>
                            </div>
                            <c:choose>
                                <c:when test="${not empty userVo.provider}">
                                    <!-- provider가 있을 때, 비밀번호 입력란 숨김 -->
                                </c:when>
                                <c:otherwise>
                                    <div class="inputbox">
                                        <label for="password">비밀번호<span class="essential">*</span></label>
                                        <input type="password" id="password" name="password" placeholder="현재비밀번호를 입력 하세요" required>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="buttonBox">
                            <button class="updatebutton secondary-default" type="submit">회원 탈퇴</button>
                            <button class="updatebutton primary-default" type="button" onclick="window.location.href='${root}/main';">취소</button>
                        </div>
                    </form>
                </div>
            </div>
        </main>
    </section>
    <!--푸터-->

    <jsp:include page="${root}/WEB-INF/views/include/footer.jsp"/>
    <jsp:include page="../include/timer.jsp" />
</div>
<%-- 모달 --%>
<div id="modal-container" class="modal unstaged">
    <div class="modal-overlay">
    </div>
    <div class="modal-contents">
        <div class="modal-text flex-between">
            <h4>알림</h4>
            <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
        </div>
        <div id="messageContent" class="modal-center">
            <%-- 메시지 내용이 여기에 표시됩니다. --%>
        </div>
        <div class="modal-bottom">
            <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
        </div>
    </div>
</div>


<script>
    $(document).ready(function () {
        if ("${error}" !== "") {
            $("#messageContent").text("${error}");
            $('#modal-container').toggleClass('opaque'); //모달 활성화
            $('#modal-container').toggleClass('unstaged');
            $('#modal-close').focus();
        }

        if ("${msg}" !== "") {
            $("#messageContent").text("${msg}");
            $('#modal-container').toggleClass('opaque'); //모달 활성화
            $('#modal-container').toggleClass('unstaged');
            $('#modal-close').focus();
        }
    });
</script>
</body>
</html>
