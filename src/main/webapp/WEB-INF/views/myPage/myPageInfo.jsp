<%@ page import="java.time.LocalDateTime" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns"></script>

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
        <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}&libraries=services"></script>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            for (let i = 0; i < 3; i++) {
                let fileInput = document.getElementById('uploadFile' + i);
                if (fileInput) {
                    fileInput.addEventListener('change', function() {
                        updateFileName(i);
                    });
                }
            }
        });

        function updateFileName(index) {
            var fileInput = document.getElementById('uploadFile' + index);
            if (!fileInput) return;

            var fileNameLabel = fileInput.nextElementSibling.querySelector('.filename');
            if (!fileNameLabel) return;

            if (fileInput.files.length > 0) {
                fileNameLabel.textContent = fileInput.files[0].name;
            } else {
                fileNameLabel.textContent = "이력서 파일을 업로드 해주세요";
            }
        }

        function uploadResume(event, index) {
            event.preventDefault();

            var formId = "#uploadForm" + index;
            var fileInputId = "#uploadFile" + index;

            var $frm = $(formId)[0];
            var fileInput = $(fileInputId)[0];

            if (fileInput.files.length === 0) {
                alert("업로드할 파일을 선택해주세요.");
                return;
            }

            var formData = new FormData($frm);
            formData.append("uploadFile", fileInput.files[0]);

            $.ajax({
                url: '/myPage/uploadResume',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                },
                success: function(response) {
                    if (typeof response === 'string' && response.startsWith('파일 용량은')) {
                        alert(response);
                    } else if (typeof response === 'string' && response.startsWith('이미지 파일만')) {
                        alert(response);
                    } else {
                        alert("파일업로드가 완료되었습니다.");
                        location.reload();
                    }
                },
                error: function(xhr) {
                    alert("파일업로드에 실패하였습니다. " + xhr.responseText);
                }
            });
        }

        // 다운로드
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
                    success: function(result) {
                        const fileItem = element.closest('.file-item');
                        if (fileItem) {
                            fileItem.remove();
                        }
                        alert("이력서가 삭제되었습니다.");
                        location.reload();  // 페이지 새로고침
                    },
                    error: function() {
                        alert("이력서 삭제에 실패하였습니다.");
                    }
                });
            }
        }
    </script>
        <script>
            $(document).ready(function() {
                const latitude = "${userVo.latitude}";
                const longitude = "${userVo.longitude}";

                if (latitude && longitude) {
                    var geocoder = new kakao.maps.services.Geocoder();
                    var coord = new kakao.maps.LatLng(latitude, longitude);

                    geocoder.coord2Address(coord.getLng(), coord.getLat(), function(result, status) {
                        if (status === kakao.maps.services.Status.OK) {
                            const address = result[0].address.address_name;
                            $("#location-info").text(address);
                        } else {
                            $("#location-info").text("주소를 가져올 수 없습니다.");
                        }
                    });
                }
            });
        </script>


</head>
<body>
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
                                <li>
                                    <c:choose>
                                        <c:when test="${userVo.gender == 'F'}">여자</c:when>
                                        <c:when test="${userVo.gender == 'M'}">남자</c:when>
                                        <c:when test="${userVo.gender == 'OTHER'}">기타</c:when>
                                        <c:otherwise>알 수 없음</c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                            <ul class="userItem">
                                <li><b>이메일</b></li>
                                <li>${userVo.email}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>생년월일</b></li>
                                <li>${userVo.birthdate}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>위치정보</b></li>
                                <li id="location-info">${userVo.latitude}, ${userVo.longitude}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>등급</b></li>
                                <li>${userVo.gradeName}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>SNS 연동</b></li>
                                <li>${userVo.socialLogin ? 'O' : 'X'}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>가입날짜</b></li>
                                <li>${formattedCreatedAt}</li>
                            </ul>
                            <ul class="userItem">
                                <li><b>연락처</b></li>
                                <li>
                                    <c:choose>
                                        <c:when test="${empty userVo.mobile}">X</c:when>
                                        <c:otherwise>${userVo.mobile}</c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="total-activity flex-between">
                        <button class="secondary-default flex-between">
                            <p class="activity-title">총 공부시간</p>
                            <p class="totalstudytime"></p>
                        </button>
                        <button class="secondary-default flex-between" onclick="location.href='${root}/myPage/myPageLikePost'">
                            <p class="activity-title">좋아요한 게시글</p>
                            <p>${empty studyReferencesEntity[0].TOTALCOUNT ? '0' : studyReferencesEntity[0].TOTALCOUNT}개</p>
                        </button>
                        <button class="secondary-default flex-between" onclick="location.href='${root}/myPage/myPageLikeStudy?userIdx=${userVo.userIdx}'">
                            <p class="activity-title">좋아요한 스터디</p>
                            <p>${empty likedStudies[0].TOTALCOUNT ? '0' : likedStudies[0].TOTALCOUNT}개</p>
                        </button>
                    </div>
                    <%--차트영역--%>
                    <canvas id="monthlyStudyTimeChart" style="max-height: 300px;"></canvas>
                    <div class="resume">
                        <div class="resume-title flex-between">
                            <h3>이력서</h3>
                            <a href="https://chatgpt.com/">AI로 자소서 작성하기 →</a>
                        </div>

                        <div class="resume-file flex-between">
                            <!-- 파일 업로드 됐을 때 만들기 -->
                            <c:forEach begin="0" end="2" varStatus="status">
                                <c:choose>
                                    <c:when test="${resumesEntity[status.index].fileName ne '' and resumesEntity[status.index].fileName ne null}">
                                        <div class="file-item">
                                            <button class="file-delete" onclick="deleteResume(this, ${resumesEntity[status.index].resumeIdx})">
                                                <i class="bi bi-x-lg"></i>
                                            </button>
                                            <div class="customfile-label flex-column">
                                                <p class="filename" style="margin-bottom: 20px;">${resumesEntity[status.index].fileName}</p>
                                                <a href="javascript:download('${resumesEntity[status.index].resumeIdx}')" class="fileUpload" style="padding-left: 20px; padding-right: 20px;"> 이력서 다운로드 </a>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="file-item non-file">
                                            <form id="uploadForm${status.index}" onsubmit="uploadResume(event, ${status.index});" style="width: 100%;">
                                                <input type="file" id="uploadFile${status.index}" name="uploadFile" class="customfile" style="width: 100%;">
                                                <label for="uploadFile${status.index}" class="customfile-label flex-column" style="width: 100%;">
                                                    <p class="filename">이력서 파일을 업로드 해주세요</p>
                                                </label>
                                                <button type="submit" class="fileUpload" style="font-size: 17px;">업로드</button>
                                            </form>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </div>

                </sec:authorize>
            </div>
        </main>
    </section>
</div>
<sec:authorize access="isAuthenticated()">
    <script>
        function formatTime(seconds) {
            const h = Math.floor(seconds / 3600);
            const m = Math.floor((seconds % 3600) / 60);
            const s = seconds % 60;
            const hDisplay = h > 0 ? h + '시간 ' : '';
            const mDisplay = m > 0 ? m + '분 ' : '';
            const sDisplay = s > 0 ? s + '초' : '';
            return hDisplay + mDisplay + sDisplay;
        }

        document.addEventListener("DOMContentLoaded", function () {
            fetch('/include/monthly?userIdx=${userVo.userIdx}')
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok ' + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    const labels = [];
                    const studyTimes = [];

                    data.monthlyStudyTime.forEach(record => {
                        const date = new Date(record.date);
                        labels.push(date.getDate()); // 일(day)만 표시
                        studyTimes.push(record.studytime);
                    });

                    console.log(data)

                    const ctx = document.getElementById('monthlyStudyTimeChart').getContext('2d');
                    new Chart(ctx, {
                        type: 'bar',
                        data: {
                            labels: labels,
                            datasets: [{
                                label: '공부시간',
                                data: studyTimes,
                                backgroundColor: 'rgba(75, 192, 192, 0.2)',
                                borderColor: 'rgba(75, 192, 192, 1)',
                                borderWidth: 1
                            }]
                        },
                        options: {
                            scales: {
                                x: {
                                    grid: {
                                        display: false // 가로 줄 숨기기
                                    },
                                    beginAtZero: true,
                                    title: {
                                        display: true,
                                        text: ''
                                    }
                                },
                                y: {
                                    grid: {
                                        display: false // 세로 줄 숨기기
                                    },
                                    beginAtZero: true,
                                    title: {
                                        display: true,
                                        text: '공부시간'
                                    }
                                }
                            },
                            plugins: {
                                tooltip: {
                                    callbacks: {
                                        label: function (context) {
                                            const label = context.dataset.label || '';
                                            const value = context.raw;
                                            return label + ': ' + formatTime(value);
                                        }
                                    }
                                }
                            }
                        }
                    });
                })
                .catch(error => console.error('Error fetching study time data:', error));
        });
    </script>
</sec:authorize>

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
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>
