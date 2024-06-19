<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공부 사이트 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <script>

        const profilePicUrl = "/mnt/data/image.png"; // URL to the profile picture

        function toggleLike(element, idx) {
            element.classList.toggle('liked');
            if (element.classList.contains('liked')) {
                element.className = 'fa-solid fa-heart heart-icon liked';
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/insertLike',
                    data: {referenceIdx: idx, userIdx: ${userIdx}},
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                })
            } else {
                element.className = 'fa-regular fa-heart heart-icon';
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/deleteLike',
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                    },
                    data: {referenceIdx: idx, userIdx: ${userIdx}}
                })
            }
        }

        function reportPost(idx) {
            if(confirm("게시글을 신고하시겠습니까?")) {
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/updateReport',
                    data: {referenceIdx : idx},
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                })
                alert("게시글 신고가 완료되었습니다.");
            }else {
                alert("게시글 신고가 취소되었습니다.");
            }

        }

        function submitComment() {
            const commentInput = document.getElementById("input-comment");
            const referenceIdx = document.getElementById("referenceIdx");
            if (commentInput.value.trim() === "") {
                alert("댓글에 내용을 입력해주세요");
                return;
            }
            $.ajax({
                method: 'POST',
                url: '/studyReferences/insertComment',
                data: {
                    content: commentInput.value,
                    referenceIdx: referenceIdx.value
                },  // 여기서 'content' 키를 사용합니다.
                beforeSend: function(xhr) {
                    xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                },
                contentType: "application/x-www-form-urlencoded; charset=UTF-8",
                success: function (response) {
                    location.href = "/studyReferences/referencesSite?referenceIdx=" + referenceIdx.value
                },
                error: function () {
                    alert("댓글 작성에 실패하였습니다.");
                }
            });
        }


        function deleteComment(element, idx) {
            if (confirm('댓글을 삭제하시겠습니까?')) {
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/deleteComment',
                    data: {commentIdx: idx},
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                }).done(function (result) {
                    /* alert(result) 삭제가 완료되었습니다 띄우는 작업 */
                })

                const commentItem = element.parentElement;
                commentItem.remove();

            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            const commentInput = document.getElementById("input-comment");
            commentInput.addEventListener("keypress", function (event) {
                if (event.key === "Enter") {
                    submitComment();
                }
            });
        });

        function deletePost(idx) {
            if (confirm("게시글을 삭제하시겠습니까?")) {
                $.ajax({
                    method: 'POST',
                    url: '/StudyReferences/deletePost',
                    data: {referenceIdx: idx},
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                }).done(function (result) {
                    location.href='/studyReferences/referencesList'
                })
            }
        }

        function modifyPost(idx){
            location.href ="/studyReferences/referencesModify?referenceIdx=" + idx;
        }

    </script>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp" />
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!-- 본문영역 -->
            <h1>내 공부노트</h1>

            <!-- 글 -->
            <div class="post-container">
                <div class="title-container">
                    <div class="title-post">${studyReferencesEntity.title}</div>
                    <!-- 글에 idx를 숨겨두기 위한 hidden = 왜냐면 같은글idx에 달린 댓글들을 찾아야하니깐 -->
                    <input type="hidden" id="referenceIdx" name="referenceIdx"
                           value="${studyReferencesEntity.referenceIdx}">
                    <!-- 로그인한 userIdx를 숨겨두기 위한 hidden = 내가작성한댓글 삭제하는 작업 등을 위해서 -->
                    <input type="hidden" id="userIdx" name="userIdx"
                           value="${userIdx}">

                        <div class="actions-container">
                            <c:if test="${studyReferencesEntity.isLike !=0}">
                                <i class="fa-solid fa-heart heart-icon liked" onclick="toggleLike(this, ${studyReferencesEntity.referenceIdx})"> 좋아요</i>
                            </c:if>
                            <c:if test="${studyReferencesEntity.isLike == 0}">
                                <i class="fa-regular fa-heart heart-icon" onclick="toggleLike(this, ${studyReferencesEntity.referenceIdx})"> 좋아요</i>
                            </c:if>
                            <p class="icon-section">|</p>
                            <p class="report-post" onclick="reportPost(${studyReferencesEntity.referenceIdx})">신고</p>
                        </div>

                </div>
                <p class="info-post">작성자: ${studyReferencesEntity.name} | 작성일: ${studyReferencesEntity.createdAt} |
                    조회수: ${studyReferencesEntity.viewsCount}</p>
                <p class="content-post">${studyReferencesEntity.content}</p>
            </div>

            <!-- 댓글 -->
            <div class="comment-section">
                <div class="total-comment">댓글(${studyRefencesComment[0].TOTALCOUNT})</div>
                <div>
                    <input type="text" id="input-comment" class="input-comment" placeholder=" 댓글을 입력해주세요">
                    <button type="button" class="button-comment" onclick="submitComment()">댓글입력</button>
                </div>
                <c:forEach var="comment" items="#{studyRefencesComment}">
                    <div class="comment-list">
                        <div class="comment-item">
                            <p class="comment-delete" onclick="deleteComment(this,${comment.commentIdx})">
                                <!-- 내가 작성한 댓글만 X 표시 보이게 하는 if문 -->
                                <c:if test="${userIdx eq comment.userIdx}">
                                <i class="fa-solid fa-x"></i></p>
                            </c:if>
                            <div class="comment-header">
                                <div class="profile-pic"></div>
                                <div>
                                    <p class="comment-writer">${comment.name}
                                        <!-- 작성자의 USErIdx가 같을 때만 작성자 badge 보이게 하는 if문 -->
                                        <c:if test="${studyReferencesEntity.userIdx eq comment.userIdx}">
                                            <span class="writer-badge">작성자</span>
                                        </c:if>
                                    </p>
                                    <p class="comment-day">${comment.createdAt}</p>
                                </div>
                            </div>
                            <p class="detail-comment">${comment.content}</p>
                            <hr>
                        </div>
                    </div>
                </c:forEach>


            </div>

            <!-- 수정 삭제 목록 -->
            <div class="button-group">
                <c:if test="${userIdx eq studyReferencesEntity.userIdx}">
                    <button type="button" class="button-delete" onclick="deletePost(${studyReferencesEntity.referenceIdx})">삭제</button>
                    <button type="button" class="button-modify" onclick="modifyPost(${studyReferencesEntity.referenceIdx})">수정</button>
                </c:if>
                <button type="button" class="button-list" onclick="location.href='referencesList'">목록</button>
            </div>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
