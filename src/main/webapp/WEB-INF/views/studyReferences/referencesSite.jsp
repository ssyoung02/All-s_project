<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: ilove
  Date: 2024-06-14
  Time: 오후 12:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
        h1 {
            font-weight: 600;
            font-size: 36px;
            color: #263238;
        }

        .post-container {
            border: 1px solid #C6C6C6;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            overflow: hidden; /* to handle large content */
            word-wrap: break-word; /* to handle long words */
            width: 935px;
        }

        .title-post {
            color: #1d1d1d;
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .info-post {
            color: #8c8c8c;
            text-align: left;
            font-size: 16px;
            margin: 0 0 10px 0;
        }

        .content-post {
            color: #1d1d1d;
            text-align: left;
            font-size: 16px;
            margin: 0 0 20px 0;
        }

        .heart-icon {
            cursor: pointer;
            font-size: 16px;
            color: #8c8c8c;
        }

        .heart-icon.liked {
            color: black;
        }

        .icon-section {
            color: #8c8c8c;
        }

        .report-post {
            cursor: pointer;
            font-size: 16px;
            color: #8c8c8c;
        }

        .button-group {
            display: flex;
            justify-content: flex-start;
            margin-top: 20px;
            gap: 10px;
            position: relative; /* 추가 */
            left: 650px; /* 추가 */
        }

        .button {
            border: 1px solid;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            height: 48px;
            margin-left: 0;
        }

        .button-comment {
            background-color: #3b593f;
            color: white;
            width: 125px;
            height: 56px;
            border-radius: 5px;
            border: 1px solid #3b593f;
            font-size: 16px;
            text-align: center;
            line-height: 20px;
            font-weight: 200;
        }

        .button-delete {
            border: 1px solid #588159;
            background-color: #588159;
            color: white;
            border-radius: 4px;
            width: 94px;
            height: 48px;
            font-size: 16px;
            text-align: center;
            line-height: 20px;
            font-weight: 200;
        }

        .button-modify {
            border: 1px solid #588159;
            background-color: white;
            color: #588159;
            border-radius: 4px;
            width: 94px;
            height: 48px;
            font-size: 16px;
            text-align: center;
            line-height: 20px;
            font-weight: 200;
        }

        .button-list {
            border: 1px solid #3b593f;
            background-color: #3b593f;
            color: white;
            border-radius: 4px;
            width: 94px;
            height: 48px;
            font-size: 16px;
            text-align: center;
            line-height: 20px;
            font-weight: 200;
        }

        .fa-x {
            font-size: 25px;
        }

        .comment-section {
            margin-top: 30px;
        }

        .total-comment {
            font-size: 20px;
            color: #212121;
            font-weight: 600;
            margin-bottom: 24px;
        }

        .input-comment {
            border: 1px solid #717171;
            border-radius: 8px;
            width: 774px;
            height: 56px;
            font-size: 18px;
            padding-left: 10px;
            margin-right: 25px;
        }

        .comment-list {
            margin-top: 20px;
        }

        .comment-item {
            display: flex;
            flex-direction: column;
            position: relative;
            margin-bottom: 10px;
        }

        .comment-item p {
            margin: 0;
        }

        .comment-writer {
            font-weight: bold;
            display: flex;
            align-items: center;
        }

        .writer-badge {
            border: 1px solid #588159;
            color: #767676;
            border-radius: 5px;
            font-size: 12px;
            text-align: center;
            line-height: 20px;
            font-weight: 500;
            position: relative;
            width: 46px;
            height: 20px;
            padding-top: 2px;
            margin-left: 10px;
        }

        .comment-day {
            color: #8c8c8c;
            font-size: 14px;
            padding-top: 10px;
            padding-bottom: 25px;
        }

        .detail-comment {
            padding-bottom: 20px;
            padding-left: 5px;
        }

        .comment-delete {
            color: #8c8c8c;
            cursor: pointer;
            position: absolute;
            top: 0px;
            left: 910px;
        }

        .comment-header {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .profile-pic {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #A2B18A;
            background-size: cover;
            background-position: center;
            position: relative;
            top: -16px;
        }

        hr {
            border: 1px solid #344e41;
            width: 924px;
            margin-left: 0px;
        }

        .title-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .actions-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
    </style>
    <script>

        const profilePicUrl = "/mnt/data/image.png"; // URL to the profile picture

        function toggleLike(element, idx) {
            element.classList.toggle('liked');
            if (element.classList.contains('liked')) {
                element.className = 'fa-solid fa-heart heart-icon liked';
                $.ajax({
                    method: 'POST',
                    url: '/studyReferences/insertLike',
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                    },
                    data: {referenceIdx: idx, userIdx: ${userIdx}}
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
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                    },
                    data: {referenceIdx : idx}
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
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                },
                data: {
                    content: commentInput.value,
                    referenceIdx: referenceIdx.value
                },  // 여기서 'content' 키를 사용합니다.
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
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                    },
                    data: {commentIdx: idx}
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
                    headers: {
                        'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                    },
                    data: {referenceIdx: idx}
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
<jsp:include page="../include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp"/>
        </nav>
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

<jsp:include page="../include/timer.jsp"/>
</body>
</html>
