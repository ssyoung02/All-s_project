<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

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
                <h1>스터디 모집</h1>

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
                            <button class="flex-row" onclick="toggleLike(this, ${study.studyIdx})">
                                <i class="bi bi-heart-fill"></i>
                                <p class="info-post ">좋아요</p>
                            </button>|
                            <button class="report">신고</button>
                        </div>
                    </div>
                    <div class="post-content">${study.description}</div>
                    <div class="buttonBox">
                        <button class="primary-default" onclick="modalOpen()">가입 신청</button>
                    </div>
                </div>
                <div class="board-bottom">
                    <button class="secondary-default" onclick="">삭제</button>
                    <button class="secondary-default" onclick="">수정</button>
                    <button class="primary-default" onclick="">목록</button>
                </div>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />

    <%-- 오류 메세지 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay"></div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h3>${study.studyTitle}</h3>
                <button id="modal-close" class="modal-close" aria-label="닫기" onclick="madalClose()"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                <form id="joinForm" method="post" action="${root}/studyRecruit/recruitReadForm">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                    <textarea name="joinReason" id="joinReasonTextarea" class="board-textarea" placeholder="신청서를 작성해주세요
예)
거주지(또는 직장):
성별:
나이:
신청이유:
"></textarea>
                    <input type="hidden" name="studyIdx" value="${study.studyIdx}">
                </form>
            </div>
            <div class="modal-bottom">
                <button type="button" class="secondary-default" onclick="madalClose()">취소</button>
                <button type="button" class="primary-default" onclick="submitApplication()">신청</button>
            </div>
        </div>
    </div>

</div>
<jsp:include page="../include/timer.jsp" />

<script>

    function submitApplication() {
        document.getElementById('joinForm').submit();
    }
</script>

</body>
</html>
