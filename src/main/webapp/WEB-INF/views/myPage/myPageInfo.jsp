<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/> --%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<%--이제 필요없는 코드 --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>나의 정보 > 내 정보 > All's</title>
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
<jsp:include page="${root}/WEB-INF/views/include/timer.jsp"/>
<jsp:include page="${root}/WEB-INF/views/include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContaner">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="${root}/WEB-INF/views/include/navbar.jsp"/>
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="${root}/WEB-INF/views/include/navbar.jsp"/>
            </div>
            <div id="content">
                <h1>${userVo.name} 님의 회원 정보</h1>
                <%-- 로그인한 사용자에게만 정보 표시 --%>
                <sec:authorize access="isAuthenticated()">
                    <c:if test="${not empty error}">
                        <p>${error}</p>
                    </c:if>
                    <c:if test="${not empty msg1}">
                        <p>${msg1}: ${msg2}</p>
                    </c:if>

                    <div class="userinfo">
                        <div class="userprofile">
                            <div class="profile-img">
                                <img src="${root}/resources/images/${userVo.profileImage}" alt="내 프로필">
                            </div>
                            <h3>${userVo.username}</h3>
                        </div>
                        <div class="userdata bgwhite">
                            <ul class="userItem">
                                <li><b>이름</b></li>
                                <li>${userVo.name}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>성별</b></li>
                                <li>${userVo.gender}</li>
                            </ul>
                            <ul class="longUserItem">
                                <li><b>이메일</b></li>
                                <li>${userVo.email}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>생년월일</b></li>
                                <li>${userVo.birthdate}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>위치정보</b></li>
                                <li>${userVo.latitude}, ${userVo.longitude}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>등급</b></li>
                                <li>${userVo.gradeIdx}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>SNS 연동</b></li>
                                <li>${userVo.socialLogin}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>가입날짜</b></li>
                                <li>${userVo.createdAt}</li>
                            </ul>
                        </div>
                    </div>
                    <div class="statistics flex-between">
                        <div class="graph-area" style="width: 200px; height: 50px;">
                            그래프 영역
                        </div>
                        <div class="total-activity flex-colum">
                            <button class="secondary-default flex-between">
                                <p class="activity-title">총 공부시간</p>
                                <p>150시간</p>
                            </button>
                            <button class="secondary-default flex-between" onclick="location.href='${root}/myPage/myPageLikePost'">
                                <p class="activity-title">좋아요한 게시글</p>
                                <p>${studyReferencesEntity[0].TOTALCOUNT}개</p>
                            </button>
                            <button class="secondary-default flex-between">
                                <p class="activity-title">좋아요한 스터디</p>
                                <p>5개</p>
                            </button>
                        </div>
                    </div>
                    <div class="resume">
                        <div class="resume-title flex-between">
                            <h3>이력서</h3>
                            <a href="https://chatgpt.com/">AI로 자소서 작성하기 →</a>
                        </div>
                        <div class= "resume-file flex-between">
                            <div class="file-item">
                                <button class="file-delete">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                                <input type="file" id="resume1" class="customfile">
                                <label for="resume1" class="customfile-lable flex-colum">
                                    <p class="filename">이력서1.hwp</p>
                                    <div class="fileUpload">업로드↑</div>
                                </label>
                            </div>
                            <div class="file-item non-file">
                                <input type="file" id="resume2" class="customfile">
                                <label for="resume2" class="customfile-lable flex-colum">
                                    <p class="filename">이력서 파일을 업로드 해주세요</p>
                                    <div class="fileUpload">업로드↑</div>
                                </label>
                            </div>
                            <div class="file-item non-file">
                                <input type="file" id="resume3" class="customfile">
                                <label for="resume3" class="customfile-lable flex-colum">
                                    <p class="filename">이력서 파일을 업로드 해주세요</p>
                                    <div class="fileUpload">업로드↑</div>
                                </label>
                            </div>
                        </div>
                    </div>
                </sec:authorize>

            </div>
        </main>
    </section>



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