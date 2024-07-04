<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
    <title>프로필 이미지 변경</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<div class="modal-dialog" role="document">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title" id="imageModalLabel">프로필 이미지 변경</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body">
            <form method="POST" action="${root}/Users/UsersImageUpdate" enctype="multipart/form-data" id="uploadForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> <%-- CSRF 토큰 추가 --%>
                <input type="hidden" name="username" value="${userVo.username}" /> <%-- 사용자 아이디 추가 --%>
                <div class="userinputbox">
                    <dt>프로필</dt>
                    <dd class="profile-chage">
                        <input type="file" id="uploadFile" name="profileImage" accept="image/*">
                        <label for="uploadFile" class="imgbox">
                            <i class="bi bi-plus-lg"></i>
                            <img src="${userVo.profileImage}" alt="Profile Image" onerror="this.onerror=null; this.src='${root}/resources/profileImages/img.png';">
                        </label>
                        <div class="profile-change">
                            <p>변경할 프로필을 등록해주세요.</p>
                            <p>(300px X 300px / 500kb 미만)</p>
                        </div>
                    </dd>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
                    <button type="submit" onclick="uploadImage(event)" class="btn btn-primary">이미지 변경</button> <%-- 폼 제출 버튼 추가 --%>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    $(document).ready(function () {
        <c:if test="${not empty error}">
        $("#messageContent").text("${error}");
        $('#modal-container').toggleClass('opaque'); //모달 활성화
        $('#modal-container').toggleClass('unstaged');
        $('#modal-close').focus();
        </c:if>
    });
</script>

</body>
</html>
