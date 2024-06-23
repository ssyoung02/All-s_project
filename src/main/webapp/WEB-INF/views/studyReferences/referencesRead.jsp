<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공부 자료 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>

    <script>

        const profilePicUrl = "/mnt/data/image.png"; // URL to the profile picture

        //좋아요 버튼
        function toggleLike(element, idx) {
            const icon = element.querySelector('i');
            const isLiked = !element.classList.contains('liked');

            if (isLiked) {
                element.classList.add('liked');
                icon.className = 'bi bi-heart-fill';
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/insertLike',
                    data: { referenceIdx: idx, userIdx: ${userVo.userIdx} },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                });
            } else {
                element.classList.remove('liked');
                icon.className = 'bi bi-heart';
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/deleteLike',
                    data: { referenceIdx: idx, userIdx: ${userVo.userIdx} },
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                });
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
                    location.href = "${root}/studyReferences/referencesRead?referenceIdx=" + referenceIdx.value
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

                    success: function(result) {
                        const commentItem = element.closest('.comment-item');
                        if (commentItem) {
                            commentItem.remove();
                        }
                        alert("댓글이 삭제되었습니다.");
                        location.reload();  // 페이지 새로고침(=댓글(전체댓글수) 새로고침하기 위해서)
                    },
                    error: function() {
                        alert("댓글 삭제에 실패하였습니다.");
                    }
                });
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
                    url: '/studyReferences/deletePost',
                    data: {referenceIdx: idx},
                    beforeSend: function(xhr) {
                        xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                    },
                }).done(function (result) {
                    //alert("게시물이 삭제되었습니다.");
                    location.href='${root}/studyReferences/referencesList'
                })
            }
        }

        function modifyPost(idx){
            location.href ="${root}/studyReferences/referencesModify?referenceIdx=" + idx;
        }

    </script>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContaner">
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
                <h1>공부자료</h1>
                <div class="maxcontent">
                    <div class="post-area">

                        <input type="hidden" id="referenceIdx" name="referenceIdx" value="${studyReferencesEntity.referenceIdx}">
                        <!-- 로그인한 userIdx를 숨겨두기 위한 hidden = 내가작성한댓글 삭제하는 작업 등을 위해서 -->
                        <input type="hidden" id="userIdx" name="userIdx" value="${userIdx}">

                        <div class="studygroup-item flex-between">
                            <!--스터디 목록-->
                            <div class="imgtitle flex-row">
                                <div class="board-item flex-columleft">
                                    <h3 class="board-title">${studyReferencesEntity.title}
                                        <c:if test="${studyReferencesEntity.isPrivate == 'true'}">
                                            <i class="bi bi-lock-fill"></i>
                                        </c:if>
                                        <c:if test="${studyReferencesEntity.isPrivate == 'false'}">
                                            <i class="bi bi-lock-fill" style="display: none"></i>
                                        </c:if>
                                    </h3>
                                    <p>작성자: ${studyReferencesEntity.name}  |   작성일: ${studyReferencesEntity.createdAt}  |  조회수:  ${studyReferencesEntity.viewsCount}</p>
                                </div>
                            </div>
                            <!-- 좋아요 -->
                            <div class="board-button">
                                <c:choose>
                                    <c:when test="${studyReferencesEntity.isLike != 0}">
                                        <button class="flex-row liked" onclick="toggleLike(this, ${studyReferencesEntity.referenceIdx})">
                                            <i class="bi bi-heart-fill"></i>
                                            <p class="info-post">좋아요</p>
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <button class="flex-row" onclick="toggleLike(this, ${studyReferencesEntity.referenceIdx})">
                                            <i class="bi bi-heart"></i>
                                            <p class="info-post">좋아요</p>
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                                <button class="report" onclick="reportPost(${studyReferencesEntity.referenceIdx})">신고</button>
                            </div>
                        </div>
                        <div class="post-content">
                            ${studyReferencesEntity.content}
                        </div>
                    </div>
                    <div class="comment">
                        <h4 class="s-header">댓글(${studyRefencesComment[0].TOTALCOUNT})</h4>
                        <div class="comment-area">
                            <input id="input-comment" type="text" title="댓글입력" placeholder="댓글을 입력해주세요">
                            <button class="primary-default" onclick="submitComment()">댓글 입력</button>
                        </div>
                        <div class="comment-list">

                            <c:forEach var="comment" items="#{studyRefencesComment}">
                                <div class="comment-item">
                                    <div class="comment-user flex-between">
                                        <div class="flex-row">
                                            <div class="profile-img">
                                                <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                            </div>
                                            <div class="comment-profile">
                                                <p class="comment-userId">
                                                        ${comment.name}
                                                    <!-- 작성자의 USErIdx가 같을 때만 작성자 badge 보이게 하는 if문 -->
                                                    <c:if test="${studyReferencesEntity.userIdx eq comment.userIdx}">
                                                        <span class="writer-badge">작성자</span>
                                                    </c:if>
                                                </p>
                                                <p>${comment.createdAt}</p>
                                            </div>
                                        </div>
                                        <button aria-label="댓글 삭제" class="comment-delete" onclick="deleteComment(this,${comment.commentIdx})">
                                            <!-- 내가 작성한 댓글만 X 표시 보이게 하는 if문 -->
                                            <c:if test="${userIdx eq comment.userIdx}">
                                                <i class="bi bi-x-lg"></i>
                                            </c:if>
                                        </button>
                                    </div>
                                    <p class="comment-detail">${comment.content}</p>
                                </div>
                            </c:forEach>


                        </div>
                    </div>
                    <div class="board-bottom">
                        <c:if test="${userIdx eq studyReferencesEntity.userIdx}">
                            <button class="secondary-default" onclick="deletePost(${studyReferencesEntity.referenceIdx})">삭제</button>
                            <button class="secondary-default" onclick="modifyPost(${studyReferencesEntity.referenceIdx})">수정</button>
                        </c:if>
<%--                        <button class="primary-default" onclick="location.href='${root}/studyReferences/referencesList'">목록</button>--%>
                        <button class="primary-default" onclick="history.back();">목록</button>
                    </div>
                </div>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>
