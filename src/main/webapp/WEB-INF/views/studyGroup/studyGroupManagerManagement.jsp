<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 관리 > 관리 > 스터디그룹 > 내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <script>
        function modalOpen() {
            document.getElementById('modal-container').classList.remove('unstaged');
        }

        function modalClose() {
            document.getElementById('modal-container').classList.add('unstaged');
        }

        function deleteStudyGroup() {
            if (confirm('스터디를 삭제하시겠습니까?')) {
                $.ajax({
                    url: '${root}/studyGroup/deleteStudyGroup',
                    type: 'POST',
                    data: {
                        studyIdx: ${studyGroup.studyIdx}
                    },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
                    },
                    success: function(response) {
                        if (response.success) {
                            alert('스터디가 삭제되었습니다.');
                            window.location.href = '${root}/studyGroup/studyGroupList';
                        } else {
                            alert('스터디 삭제에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('Error deleting study group:', errorThrown);
                        alert('스터디 삭제 중 오류가 발생했습니다.');
                    }
                });
            }
        }
    </script>
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
                <h1>내 스터디</h1>
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerInfo?studyIdx=${studyGroup.studyIdx}">스터디 정보</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerMember?studyIdx=${studyGroup.studyIdx}">멤버 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerSchedule?studyIdx=${studyGroup.studyIdx}">일정 관리</a>
                    </div>
                    <div class="tapItem tapSelect">
                        <a href="${root}/studyGroup/studyGroupManagerManagement?studyIdx=${studyGroup.studyIdx}">스터디 관리</a>
                    </div>
                </div>
                <%--탭 메뉴 끝--%>
                <%--탭 상세--%>
                <div class="tabInfo">
                    <div class="webInfo-itemfull">
                        <dt>모집글 제목</dt>
                        <dd><input value="${studyGroup.studyTitle}" title="모집글 제목" style="width: 30em"></dd>
                    </div>
                    <div class="webInfo-itemfull">
                        <dt>모집글 내용</dt>
                        <dd>
                            <textarea placeholder="스터디를 모집 내용을 입력해주세요" title="모집글 내용">${studyGroup.description}</textarea>
                        </dd>
                    </div>
                    <div class="webInfo-itemfull">
                        <dt>공개여부</dt>
                        <dd>
                            <input type="radio" id="public" name="public">
                            <label for="public">공개</label>
                            <input type="radio" id="private" name="public">
                            <label for="private">비공개</label>
                        </dd>
                    </div>
                    <div class="webInfo-itemfull">
                        <dt>스터디 삭제</dt>
                        <dd>
                            <a id="studyGroupDelete" href="#" onclick="deleteStudyGroup()">스터디 삭제하기</a>
                        </dd>
                    </div>
                </div>
                <div class="board-bottom">
                    <button class="secondary-default" onclick="location.href='${root}/studyGroupMain?studyIdx=${studyGroup.studyIdx}'">취소</button>
                    <button class="primary-default" onclick="modalOpen()">확인</button>
                </div>
            </div>

            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
    <%-- 오류 메세지 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>오류 메세지</h4>
                <button class="modal-close-x" aria-label="닫기" onclick="modalClose()"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                스터디 관리 정보를 변경하겠습니까?
            </div>
            <div class="modal-bottom">
                <button class="secondary-default" onclick="modalClose()">취소</button>
                <button type="button" class="modal-close" data-dismiss="modal">확인</button>
            </div>
        </div>
    </div>
</div>
</body>
</html>
