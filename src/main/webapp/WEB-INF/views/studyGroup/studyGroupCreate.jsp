<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>

    <title>스터디 생성 > 내 스터디 > 스터디 > 공부 > All's</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <script>
        function previewImage(event) {
            var reader = new FileReader();
            reader.onload = function () {
                var output = document.getElementById('profilePreview');
                output.src = reader.result;
            };
            reader.readAsDataURL(event.target.files[0]);
        }

        // 사용자 위치 가져오기
        $(document).ready(function () {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;

                    // 폼에 hidden input 추가
                    $('<input>').attr({
                        type: 'hidden',
                        name: 'latitude',
                        value: lat
                    }).appendTo('#writeForm');
                    $('<input>').attr({
                        type: 'hidden',
                        name: 'longitude',
                        value: lon
                    }).appendTo('#writeForm');
                }, function(error) {
                    console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
                });
            }
        });


    </script>
</head>
<body>
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
                <h1>내 스터디</h1>
                <!--본문 콘텐츠-->
                <h4 class="s-header">스터디 생성</h4>
                <form id="writeForm" method="post" action="${root}/studyGroup/studyGroupCreate" enctype="multipart/form-data">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <div class="post-area">
                        <input type="text" class="title-post" name="studyTitle" placeholder="제목을 입력해주세요" required>
                        <article class="studyTag">
                            <div class="studyTagLine">
                                <label for="studyName"><p class="studyTag-title">스터디명</p></label>
                                <input type="text" id="studyName" name="descriptionTitle" placeholder="스터디명을 입력해주세요" required>
                            </div>
                            <div class="studyTagLine">
                                <p class="studyTag-title">프로필</p>
                                <dd class="profile-chage">
                                    <input type="file" id="imageChange" name="profileImage" accept="image/*" onchange="previewImage(event)">
                                    <label for="imageChange" class="imgbox">
                                        <i class="bi bi-plus-lg"></i>
                                        <img id="profilePreview" src="${root}/resources/images/02.%20intellij.png" alt="스터디 그룹 프로필" width="50px" height="50px">
                                    </label>
                                    <div class="profile-change">
                                        <p>우리 스터디를 표현할 아이콘을 등록해주세요.</p>
                                        <p>(300px X 300px / 500kb 미만)</p>
                                    </div>
                                </dd>
                            </div>
                            <h4>태그 선택</h4>
                            <ul class="taglist">
                                <!-- 태그 항목 -->
                                <li>
                                    <p class="tag-title">지역</p>
                                    <input type="text" placeholder="위치를 선택해주세요" id="locationTag" readonly required>
                                    <label for="locationTag"><button type="button" class="studyTagLocation">지도선택</button></label>
                                </li>
                                <li>
                                    <p class="tag-title">모집분야</p>
                                    <div class="tag-details">
                                        <input type="radio" id="interviewTag" name="category" value="면접">
                                        <label for="interviewTag">면접</label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="radio" id="introductionTag" name="category" value="자소서">
                                        <label for="introductionTag">자소서</label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="radio" id="certificateTag" name="category" value="자격증">
                                        <label for="certificateTag">자격증</label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="radio" id="studyTag" name="category" value="스터디">
                                        <label for="studyTag">스터디</label>
                                    </div>
                                </li>
                                <li>
                                    <p class="tag-title">연령대</p>
                                    <div class="tag-details">
                                        <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대">
                                        <label for="twenty" class="todo-label">
                                            <span class="checkmark"><i class="bi bi-square"></i></span>
                                            20대
                                        </label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대">
                                        <label for="thirty" class="todo-label">
                                            <span class="checkmark"><i class="bi bi-square"></i></span>
                                            30대
                                        </label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대">
                                        <label for="forty" class="todo-label">
                                            <span class="checkmark"><i class="bi bi-square"></i></span>
                                            40대
                                        </label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관">
                                        <label for="allAge" class="todo-label">
                                            <span class="checkmark"><i class="bi bi-square"></i></span>
                                            연령무관
                                        </label>
                                    </div>
                                </li>
                                <li>
                                    <p class="tag-title">성별</p>
                                    <div class="tag-details">
                                        <input type="radio" id="male" name="gender" value="남자">
                                        <label for="male">남자</label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="radio" id="female" name="gender" value="여자">
                                        <label for="female">여자</label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="radio" id="allGender" name="gender" value="성별무관">
                                        <label for="allGender">남여모두</label>
                                    </div>
                                </li>
                                <li>
                                    <p class="tag-title">온/오프라인</p>
                                    <div class="tag-details">
                                        <input type="radio" id="online" name="study_online" value="1">
                                        <label for="online">온라인</label>
                                    </div>
                                    <div class="tag-details">
                                        <input type="radio" id="offline" name="study_online" value="0">
                                        <label for="offline">오프라인</label>
                                    </div>
                                </li>
                                <li>
                                    <p class="tag-title">모집 인원</p>
                                    <input type="number" name="capacity" value="2" min="2" required> <%-- Default to 2, at least 2 including the leader --%>
                                </li>
                            </ul>
                        </article>

                        <textarea class="board-textarea" name="description" placeholder="내용을 입력해주세요" required></textarea>
                        <div class="buttonBox">
                            <button type="reset" class="updatebutton secondary-default" onclick="location.href='studyGroupList.jsp'">취소</button>
                            <button type="submit" class="updatebutton primary-default">작성</button>
                        </div>
                    </div>
                </form>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
</div>
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>