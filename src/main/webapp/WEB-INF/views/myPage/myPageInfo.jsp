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

    <%-- CSRF 토큰 자동 포함 --%>
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

    <script>
        function uploadResume(event) {
            event.preventDefault(); // 폼 제출을 막음

            var $frm = $("#uploadForm")[0];
            var fileInput = $("#uploadFile")[0];

            //파일이 선택되지 않았을 경우 알림창 표시
            if(fileInput.files.length === 0) {
                alert("업로드할 파일을 선택해주세요.");
                return;
            }

            var formData = new FormData($frm);
            formData.append("uploadFile", fileInput.files[0]);

            console.log("uploadFile 호출됨");

            // AJAX를 사용하여 폼 데이터를 서버로 전송
            $.ajax({
                url : '/myPage/uploadResume',
                type : 'POST',
                data : formData,
                processData : false,
                contentType : false,
                beforeSend : function(xhr) {
                    xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                },
                success : function(response) {
                    if (typeof response === 'string' && response.startsWith('파일 용량은')) {
                        alert(response);
                    } else if (typeof response === 'string' && response.startsWith('이미지 파일만')) {
                        alert(response);
                    } else {
                        alert("파일업로드가 완료되었습니다.");
                        location.reload();
                    }
                },
                error : function(xhr) {
                    alert("파일업로드에 실패하였습니다. " + xhr.responseText);
                }
            });
        }

        //다운로드
        function download(resumeIdx){
            window.location.href = '/myPage/download?resumeIdx=' + resumeIdx;
        }

        function deleteResume(element, idx) {
            if (confirm('이력서를 삭제하시겠습니까?')) {
                $.ajax({
                    method: 'POST',
                    url: '/myPage/deleteResume',
                    data: {resumeIdx: idx},
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },

                    success: function (result) {
                        const fileItem = element.closest('.file-item');
                        if (fileItem) {
                            fileItem.remove();
                        }
                        alert("이력서가 삭제되었습니다.");
                        location.reload();  // 페이지 새로고침(=댓글(전체댓글수) 새로고침하기 위해서)
                    },
                    error: function() {
                        alert("이력서 삭제에 실패하였습니다.");
                    }
                });
            }
        }
    </script>

</head>
<body>
<jsp:include page="${root}/WEB-INF/views/include/timer.jsp"/>
<jsp:include page="${root}/WEB-INF/views/include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
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
                                <img src="${userVo.profileImage}" onerror="this.onerror=null; this.src='${root}/resources/profileImages/${userVo.profileImage}';">                            </div>
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
                            <ul class="userItem">
                                <li><b>연락처</b></li>
                                <li>${userVo.mobile}</li>
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
                            <!-- 파일 업로드 됐을 때 만들기 -->
                            <c:choose>
                            <c:when test="${ resumesEntity[0].fileName ne '' and resumesEntity[0].fileName ne null }">
                            <div class="file-item">
                                <button class="file-delete" onclick="deleteResume(this, ${resumesEntity[0].resumeIdx})">
                                    <i class="bi bi-x-lg"></i>
                                </button>
                                <div class="customfile-lable flex-colum">
                                            <p class="filename">${resumesEntity[0].fileName}</p>
                                            <a href="javascript:download('${resumesEntity[0].resumeIdx}')" class="fileUpload">이력서 다운로드</a>
                                </div>
                            </div>
                            </c:when>
                                <c:otherwise>
                                    <form id="uploadForm" onsubmit="uploadResume(event);">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                        <div class="file-item non-file">
                                            <input type="file" id="uploadFile" name="uploadFile" class="customfile">
                                            <label for="uploadFile" class="customfile-lable flex-colum">
                                                <p class="filename">이력서 파일을 업로드 해주세요</p>
                                            </label>
                                                <button type="submit" class="fileUpload">업로드</button>
                                        </div>
                                    </form>
                                </c:otherwise>
                            </c:choose>
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