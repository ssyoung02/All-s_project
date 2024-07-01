<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>게시글 상세 > 스터디 모집 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css?after">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <style>
        .modal-contents{
            left: 24%;
            top: 25%;
        }
    </style>
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
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>스터디 모집</h1>

                <c:if test="${not empty message}">
                    <script>alert("${message}");</script>
                </c:if>

                <div class="post-area">
                    <p class="study-tag">
                        <span class="recruit-status ${study.status eq 'CLOSED' ? 'closed' : 'open'}">${study.status eq 'CLOSED' ? '모집완료' : '모집중'}</span>
                        <span class="department">${study.category}</span>
                        <span class="study-tagItem">${study.studyOnline ? "#온라인" : "#오프라인"}</span>
                        <span class="study-tagItem">#${study.age}</span>
                        <span class="study-tagItem">#${study.gender}</span>
                    </p>
                    <div class="studygroup-item flex-between">
                        <!--스터디 목록-->
                        <div class="imgtitle flex-row">
                            <div class="board-item flex-columleft">
                                <h3 class="board-title">${study.studyTitle}</h3>
                                <p>작성자: ${study.leaderName} | 작성일:
                                    <script>
                                        var dateString = '${study.createdAt}'; // 서버에서 전송된 날짜 문자열
                                        var dateWithoutTimeZone = dateString.replace(' KST 2024', ''); // " KST 2024" 부분을 공백으로 대체하여 제거
                                        document.write(dateWithoutTimeZone);
                                    </script>
                                </p>
                            </div>
                        </div>
                        <!--좋아요-->
                        <div class="board-button">
                            <c:choose>
                                <c:when test="${study.isLike != 0}">
                                    <button class="flex-row liked" onclick="toggleLike(this, ${study.studyIdx})">
                                        <i class="bi bi-heart-fill"></i>
                                        <p class="info-post">좋아요</p>
                                    </button>
                                </c:when>
                                <c:otherwise>
                                    <button class="flex-row" onclick="toggleLike(this, ${study.studyIdx})">
                                        <i class="bi bi-heart"></i>
                                        <p class="info-post">좋아요</p>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                            <button class="report" onclick="reportPost(${study.studyIdx})">신고</button>
                        </div>
                    </div>
                    <div class="post-content">${study.description}</div>
                    <div class="buttonBox">
                        <c:choose>
                            <c:when test="${study.status eq 'CLOSED'}">
                                <p>모집 마감했습니다.</p>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${!isMember}">
                                    <button class="primary-default" onclick="modalOpen()">가입 신청</button>
                                </c:if>
                                <c:if test="${isMember}">
                                    <p>이미 가입한 스터디 입니다.</p>
                                </c:if>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="board-bottom">
                    <c:if test="${userVo.userIdx == study.studyLeaderIdx}">
                        <button class="secondary-default" onclick="showEditForm()">수정</button>
                        <button class="secondary-default" onclick="deleteStudy(${study.studyIdx})">삭제</button>
                    </c:if>
                    <button class="secondary-default" onclick="location.href='${root}/studyRecruit/recruitList'">목록</button>
                </div>
            </div>
            <%-- 수정 폼 영역 --%>
            <div id="editFormContainer" style="display:none;">
                <form id="updateForm" action="${root}/studyRecruit/updateStudyGroup" method="post" enctype="multipart/form-data">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" /> <%-- CSRF 토큰 추가 --%>
                    <input type="hidden" name="studyIdx" value="${study.studyIdx}" />
                    <input type="hidden" name="currentImage" value="${study.image}" />
                    <div class="tabInfo">
                        <div class="webInfo-itemfull">
                            <dt>모집글 제목</dt>
                            <dd><input class="manager-studyName" name="studyTitle" value="${study.studyTitle}" title="모집글 제목"></dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>설 명</dt>
                            <dd>
                                <textarea name="description" placeholder="스터디를 설명할 문장을 입력해주세요" title="설명">${study.description}</textarea>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>프로필</dt>
                            <dd class="profile-chage">
                                <form action="" class="group-imgChange">
                                    <input type="file" id="imageChange" name="profileImage" accept="image/*" onchange="previewImage(event)">
                                    <label for="imageChange" class="imgbox">
                                        <i class="bi bi-plus-lg"></i>
                                        <img id="profilePreview" src="${study.image}" alt="스터디 그룹 프로필" width="100px" height="100px">
                                    </label>
                                </form>
                                <div class="profile-change">
                                    <p>우리 스터디를 표현할 아이콘을 등록해주세요.</p>
                                    <p>(300px X 300px / 500kb 미만)</p>
                                </div>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>지역</dt>
                            <dd>
                                <div class="location-select">
                                    <select id="state" title="광역시/도 선택">
                                        <option>광역시/도</option>
                                    </select>
                                    <select id="district" title="지역 선택">
                                        <option>지역 상세</option>
                                    </select>
                                </div>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>모집분야</dt>
                            <dd>
                                <input type="radio" id="interview" name="category" value="면접"
                                       <c:if test="${study.category eq '면접'}">checked</c:if>>
                                <label for="interview">면접</label>
                                <input type="radio" id="introduction" name="category" value="자소서"
                                       <c:if test="${study.category eq '자소서'}">checked</c:if>>
                                <label for="introduction">자소서</label>
                                <input type="radio" id="certificate" name="category" value="자격증"
                                       <c:if test="${study.category eq '자격증'}">checked</c:if>>
                                <label for="certificate">자격증</label>
                                <input type="radio" id="studyGroup" name="category" value="스터디"
                                       <c:if test="${study.category eq '스터디'}">checked</c:if>>
                                <label for="studyGroup">스터디</label>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>연령대</dt>
                            <dd>
                                <ul class="todolist">
                                    <li>
                                        <c:if test="${fn:contains(study.age, '20대')}">
                                            <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대" checked="checked">
                                            <label for="twenty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                20대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(study.age, '20대')}">
                                            <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대">
                                            <label for="twenty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                20대
                                            </label>
                                        </c:if>
                                    </li>
                                    <li>
                                        <c:if test="${fn:contains(study.age, '30대')}">
                                            <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대" checked="checked">
                                            <label for="thirty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                30대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(study.age, '30대')}">
                                            <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대">
                                            <label for="thirty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                30대
                                            </label>
                                        </c:if>
                                    </li>

                                    <li>
                                        <c:if test="${fn:contains(study.age, '40대')}">
                                            <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대" checked="checked">
                                            <label for="forty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                40대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(study.age, '40대')}">
                                            <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대">
                                            <label for="forty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                40대
                                            </label>
                                        </c:if>
                                    </li>
                                    <li>
                                        <c:if test="${fn:contains(study.age, '연령무관')}">
                                            <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관" checked="checked">
                                            <label for="allAge" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                연령무관
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(study.age, '연령무관')}">
                                            <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관">
                                            <label for="allAge" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                연령무관
                                            </label>
                                        </c:if>
                                    </li>
                                </ul>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>성별</dt>
                            <dd>
                                <input id="male" class="gender" name="gender" type="radio" value="남자" <c:if test="${study.gender eq '남자'}">checked</c:if>>
                                <label for="male">남자</label>
                                <input id="female" class="gender" name="gender" type="radio" value="여자" <c:if test="${study.gender eq '여자'}">checked</c:if>>
                                <label for="female">여자</label>
                                <input id="allGender" class="gender" name="gender" type="radio" value="성별무관" <c:if test="${study.gender eq '성별무관'}">checked</c:if>>
                                <label for="allGender">남여모두</label>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>온/오프라인</dt>
                            <dd>
                                <input id="online" name="studyOnline" type="radio" value="true" <c:if test="${study.studyOnline}">checked</c:if>>
                                <label for="online">온라인</label>
                                <input id="offline" name="studyOnline" type="radio" value="false" <c:if test="${!study.studyOnline}">checked</c:if>>
                                <label for="offline">오프라인</label>
                            </dd>
                        </div>
                    </div>
                    <div class="board-bottom">
                        <button type="button" class="secondary-default" onclick="hideEditForm()">취소</button>
                        <button type="button" class="primary-default" onclick="submitUpdateForm()">수정</button>
                    </div>
                </form>
            </div>
            <%-- 수정 폼 영역 끝--%>
        </main>
    </section>
    <%-- 가입 신청 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay"></div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h3>${study.studyTitle}</h3>
                <button id="modal-close" class="modal-close" aria-label="닫기" onclick="madalClose()"><i
                        class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                <form id="joinForm" method="post" action="${root}/studyRecruit/apply">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <textarea name="joinReason" id="joinReasonTextarea" class="board-textarea" placeholder="신청서를 작성해주세요
예)
거주지(또는 직장):
성별:
나이:
신청이유:"></textarea>
                    <input type= "hidden" name="studyIdx" value="${study.studyIdx}">
                </form>
            </div>
            <div class="modal-bottom">
                <button type="button" class="secondary-default" onclick="modalClose()">취소</button>
                <button type="button" class="primary-default" onclick="submitApplication()">신청</button>
            </div>
        </div>
    </div>

</div>
<script>

    function previewImage(event) {
        const preview = document.getElementById('profilePreview');
        if (event.target.files && event.target.files[0]) {
            const reader = new FileReader();
            reader.onload = function (e) {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(event.target.files[0]);
        }
    }

    function modalOpen() {
        document.getElementById('modal-container').classList.remove('unstaged');
    }

    function modalClose() {
        document.getElementById('modal-container').classList.add('unstaged');
    }

    function submitApplication() {
        const joinReasonTextarea = document.getElementById('joinReasonTextarea');
        if (joinReasonTextarea.value.trim() === "") {
            joinReasonTextarea.value = "신청내용이 없습니다";
        }
        document.getElementById('joinForm').submit();
    }

    function showEditForm() {
        document.getElementById('editFormContainer').style.display = 'block';
    }

    function hideEditForm() {
        document.getElementById('editFormContainer').style.display = 'none';
    }

    function submitUpdateForm() {
        if (confirm('수정하시겠습니까?')) {
            const imageChangeInput = document.getElementById('imageChange');
            if (!imageChangeInput.value) { // Check if new image is not provided
                const currentImageInput = document.createElement('input'); // Create new hidden input
                currentImageInput.type = 'hidden';
                currentImageInput.name = 'profileImage';
                currentImageInput.value = document.getElementsByName('currentImage')[0].value; // Use current image value
                document.getElementById('updateForm').appendChild(currentImageInput); // Append hidden input to form
            }
            document.getElementById('updateForm').submit();
        }

    }

    //좋아요 버튼
    function toggleLike(element, idx) {
        const icon = element.querySelector('i');
        const isLiked = !element.classList.contains('liked');
        const csrfToken = $("meta[name='_csrf']").attr("content");
        const csrfHeader = $("meta[name='_csrf_header']").attr("content");

        if (isLiked) {
            element.classList.add('liked');
            icon.className = 'bi bi-heart-fill';
            $.ajax({
                method: 'POST',
                url: '/studyRecruit/insertLike',
                data: {studyIdx: idx, userIdx: ${userVo.userIdx}},
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function (response) {
                    console.log("Like inserted successfully.");
                },
                error: function (error) {
                    console.error("Error inserting like:", error);
                }
            });
        } else {
            element.classList.remove('liked');
            icon.className = 'bi bi-heart';
            $.ajax({
                method: 'POST',
                url: '/studyRecruit/deleteLike',
                data: {studyIdx: idx, userIdx: ${userVo.userIdx}},
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function (response) {
                    console.log("Like removed successfully.");
                },
                error: function (error) {
                    console.error("Error removing like:", error);
                }
            });
        }
    }

    function reportPost(idx) {
        if(confirm("게시글을 신고하시겠습니까?")) {
            $.ajax({
                method: 'POST',
                url: '/studyRecruit/updateReport',
                data: {studyIdx : idx},
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
            })
            alert("게시글 신고가 완료되었습니다.");
        }else {
            alert("게시글 신고가 취소되었습니다.");
        }
    }

    function deleteStudy(studyIdx) {
        if(confirm("정말로 이 스터디를 삭제하시겠습니까?")) {
            $.ajax({
                method: 'POST',
                url: '/studyGroup/deleteStudyGroup',
                data: {studyIdx: studyIdx},
                beforeSend: function(xhr) {
                    xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                },
                success: function(response) {
                    if(response.success) {
                        alert(response.message);
                        window.location.href = "${root}/studyRecruit/recruitList";
                    } else {
                        alert("스터디 삭제에 실패했습니다: " + response.message);
                    }
                },
                error: function(error) {
                    alert("스터디 삭제 중 오류가 발생했습니다: " + error.responseText);
                }
            });
        }
    }
</script>
<!--푸터-->
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>
