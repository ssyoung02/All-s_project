<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%
    response.setHeader("Cache-Control","no-store");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires",0);
    if (request.getProtocol().equals("HTTP/1.1"))
        response.setHeader("Cache-Control", "no-cache");
%>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>


<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">

    <title>회원정보 수정 > 내 정보 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<script>
    //토큰값 전달
    $(document).ready(function () {
        var csrfToken = $('meta[name="_csrf"]').attr('content');
        var csrfHeader = $('meta[name="_csrf_header"]').attr('content');

        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader(csrfHeader, csrfToken);
        });

        //에러 메세지 모달

        // 회원정보 수정 결과 메시지 처리 (모달 표시)
        <c:if test="${not empty sessionScope.error}">
        $("#messageContent-userEdit").text("${sessionScope.error}");
        $('#modal-container-userEdit').toggleClass('opaque');
        $('#modal-container-userEdit').toggleClass('unstaged');
        $('.modal-close-x-userEdit').focus();
        <%session.removeAttribute("error");%> <%-- 오류 메시지 제거 --%>
        </c:if>
    });

    //비밀번호 중복 체크
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

    function UserEditModalOpen() {
        let userEditModalContainer = document.getElementById('modal-container-userEdit');
        userEditModalContainer.classList.toggle('opaque'); // 모달 활성화
        userEditModalContainer.classList.toggle('unstaged');
        document.getElementById('modal-close').focus();
    }

    function UserEditModalClose(event) {
        event.stopPropagation();
        let userEditModalContainerClose = document.getElementById('modal-container-userEdit');
        userEditModalContainerClose.classList.toggle('opaque'); // 모달 활성화
        userEditModalContainerClose.classList.toggle('unstaged');
        document.getElementById('modal-close').focus();
    }

    //프로필 업로드 모달
    function profileModalOpen() {
        let profileModalContainer = document.getElementById('profile-modal-container');
        profileModalContainer.classList.toggle('opaque'); // 모달 활성화
        profileModalContainer.classList.toggle('unstaged');
        document.getElementById('modal-close').focus();
    }

    function profileModalClose(event) {
        event.stopPropagation();
        let modalContainer = document.getElementById('profile-modal-container');
        modalContainer.classList.toggle('opaque'); // 모달 활성화
        modalContainer.classList.toggle('unstaged');
        document.getElementById('modal-close').focus();
    }

    // 프로필 이미지 업로드 함수
    function uploadImage(event) {
        event.preventDefault(); // 폼 제출 방지
        var formData = new FormData(document.getElementById("uploadForm"));

        $.ajax({
            url: '/Users/UsersImageUpdate',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            beforeSend: function (xhr) {
                xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
            },
            success: function (response) {
                if (typeof response === 'string' && response.startsWith('파일 용량은')) {
                    alert(response);
                } else if (typeof response === 'string' && response.startsWith('이미지 파일만')) {
                    alert(response);
                } else {
                    alert("파일 업로드가 완료되었습니다.");
                    location.reload(); // 성공 시 페이지 새로고침
                }
                closeModal(); // 모달 닫기
            },
            error: function (xhr) {
                alert("파일 업로드에 실패하였습니다. " + xhr.responseText);
                closeModal(); // 모달 닫기
            }
        });
    }


    function submitUpdateForm(event) {
        event.preventDefault(); // 기본 폼 제출 방지

        const password = $("#password").val();
        const password2 = $("#password2").val();
        const email = $("#email").val();
        const mobile = $("#mobile").val();
        // 필수 입력값 검증
        if (password === "" || email === ""|| mobile==="") {
            // alert("모두 입력해주세요.");
            $("#messageContent-userEdit").text("모두 입력해주세요");
            $('#modal-container-userEdit').toggleClass('opaque');
            $('#modal-container-userEdit').toggleClass('unstaged');
            $('.modal-close-x-userEdit').focus();

            return;
        }

        // 비밀번호 일치 검사
        if (password !== password2) {
            $("#passwordCheckResult").text("비밀번호가 일치하지 않습니다.");
            $("#passwordCheckResult").removeClass("success").addClass("error");
            return;
        } else {
            $("#passwordCheckResult").text(""); // 오류 메시지 제거
            $("#passwordCheckResult").removeClass("error");
        }
        $("#userEditForm").submit(); //
    }

</script>
<jsp:include page="../include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp"/>
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp"/>
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>나의 정보</h1>
                <div class="updateForm bgwhite">
                    <form method="POST" action="${root }/Users/userUpdate" id="userEditForm">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div class="userinputbox">
                            <label for="name">이름<span class="essential">*</span></label>
                            <input type="text" id="name" name="name" value="${userVo.name}" readonly required>
                        </div>
                        <div class="userinputbox">
                            <label for="username">아이디<span class="essential">*</span></label>
                            <input type="text" id="username" name="username" value="${userVo.username}" readonly
                                   required>
                            <span id="usernameCheckResult"></span>
                        </div>
                        <c:choose>
                            <c:when test="${not empty userVo.provider}">
                                <!-- provider가 있을 때, 비밀번호 입력란 숨김 -->
                                <input type="hidden" id="password" name="password" value="${userVo.password}">
                                <input type="hidden" id="password2" name="password2" value="${userVo.password}">
                                <span id="passwordCheckResult"></span>
                            </c:when>
                            <c:otherwise>
                                <div class="userinputbox">
                                    <label for="password">비밀번호<span class="essential">*</span></label>
                                    <input type="password" id="password" name="password"
                                           placeholder="변경하려는 비밀번호를 입력해주세요" required>
                                </div>
                                <div class="userinputbox">
                                    <label for="password2">비밀번호 확인<span class="essential">*</span></label>
                                    <input type="password" id="password2" name="password2" placeholder="비밀번호 확인을 입력해주세요"
                                           required>
                                    <span id="passwordCheckResult"></span>
                                        <%--                                    password와 passsword2,passwordCheckResult 중복오류 표시 작동하는데 문제 없습니다!!--%>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        <div class="userinputbox">
                            <label for="birthdate">생년월일<span class="essential">*</span></label>
                            <input type="text" id="birthdate" name="birthdate" value="${userVo.birthdate}" readonly required>
                        </div>
                        <div class="userinputbox">
                            <label for="mobile">전화번호<span class="essential">*</span></label>
                            <input type="text" id="mobile" name="mobile" value="${userVo.mobile}" required>
                        </div>
                        <div class="userinputbox">
                            <label for="gender">성별<span class="essential">*</span></label>
                            <input type="text" id="gender" name="gender" value="${userVo.gender}" disabled required>
                        </div>
                        <div class="userinputbox">
                            <label for="email">이메일<span class="essential">*</span></label>
                            <c:choose>
                                <c:when test="${not empty userVo.provider}">
                                    <input type="text" id="email" name="email" value="${userVo.email}" readonly>
                                </c:when>
                                <c:otherwise>
                                    <input type="text" id="email" name="email" placeholder="변경하려는 이메일을 입력해주세요" required>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="userinputbox">
                            <input type="hidden" name="profileImage" value="${userVo.profileImage}">
                        </div>
                    </form>

                    <div class="userinputbox">
                        <dt style="width: 7em;">프로필</dt>
                        <dd class="profile-chage" onclick="profileModalOpen()">
                            <div class="imgbox div-img-box">
                                <i class="bi bi-plus-lg"></i>
                                <img src="${userVo.profileImage}" style="width:100px;height: 100px;"
                                     onerror="this.onerror=null; this.src='${root}/resources/profileImages/${userVo.profileImage}';">
                            </div>
                            <div class="profile-change-user">
                                <p>변경할 프로필을 등록해주세요.</p>
                                <p>(300px X 300px / 500kb 미만)</p>
                            </div>
                        </dd>
                    </div>

                    <div class="buttonBox">
                        <button class="updatebutton secondary-default" type="button"
                                onclick="window.location.href='${root}/'">취소
                        </button>
                        <button class="updatebutton primary-default" type="submit" form="userEditForm"
                                onclick="submitUpdateForm(event)">정보 수정
                        </button>
                    </div>
                </div>
            </div>


            <%-- 프로필 업로드 모달 --%>
            <div id="profile-modal-container" class="modal unstaged" onclick="profileModalClose(event)">
                <div class="modal-overlay">
                </div>
                <div class="modal-contents">
                    <div class="modal-text flex-between">
                        <h4>프로필 업로드</h4>
                        <button class="modal-close-x" aria-label="닫기" onclick="profileModalClose(event)">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                    <div class="modal-center">
                        <form method="POST" action="${root}/Users/UsersImageUpdate" enctype="multipart/form-data"
                              id="uploadForm">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="username" value="${userVo.username}"/> <%-- 사용자 아이디 추가 --%>
                            <div>
                                <label for="profileImage">프로필 이미지:</label>
                                <input type="file" id="profileImage" name="profileImage" accept="image/*">
                                <button type="submit" class="primary-default" form="uploadForm">이미지 변경</button>
                            </div>
                        </form>
                    </div>
                    <div class="modal-bottom">
                        <button type="button" class="secondary-default" data-dismiss="modal"
                                onclick="profileModalClose(event)">닫기
                        </button>
                    </div>
                </div>
            </div>


            <%-- 오류 메세지 모달 --%>
            <div id="modal-container-userEdit" class="modal unstaged" onclick="UserEditModalClose(event)">
                <div class="modal-overlay">
                </div>
                <div class="modal-contents">
                    <div class="modal-text flex-between">
                        <h4>메세지</h4>
                        <button class="modal-close-x-userEdit" aria-label="닫기" onclick="UserEditModalClose(event)">
                            <i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                    <div class="modal-center">
                        <div id="messageContent-userEdit">
                        </div>
                    </div>
                    <div class="modal-bottom">
                        <button type="button" class="modal-close" data-dismiss="modal" onclick="UserEditModalClose(event)">닫기
                        </button>
                    </div>
                </div>
            </div>

            <%--콘텐츠 끝--%>
        </main>
    </section>
</div>
<!--푸터-->
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>