<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
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
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp" />
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>공부 사이트</h1>

                <%--사이트 목록--%>
                <h3 class="siteTitle">개발환경 관련 사이트</h3>
                <div class="siteList">
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/01.%20eclipse.png" alt="Eclipse">
                            </div>
                            <h3>Eclipse</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/02.%20intellij.png" alt="IntelliJ">
                            </div>
                            <h3>IntelliJ</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/03.%20mysql.png" alt="MySQL">
                            </div>
                            <h3>MySQL</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/04.%20vscode.png" alt="VS Code">
                            </div>
                            <h3>VS Code</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/05.%20gitbash.png" alt="Git Bash">
                            </div>
                            <h3>Git Bash</h3>
                        </a>
                    </div>
                </div>
                <h3 class="siteTitle">개발자 공부 관련 사이트</h3>
                <div class="siteList">
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/06.%20github.png" alt="Eclipse">
                            </div>
                            <h3>Git Hub</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/07.%20kakaotech.png" alt="IntelliJ">
                            </div>
                            <h3>kakao Tech</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/08.%20ouahan.png" alt="MySQL">
                            </div>
                            <h3>우아한형제들 기술블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/09.%20carrot.png" alt="VS Code">
                            </div>
                            <h3>당근태크 블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/10.%20kurly.png" alt="Git Bash">
                            </div>
                            <h3>컬리 기술블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/11.%20banksalad.png" alt="Git Bash">
                            </div>
                            <h3>뱅크샐러드 블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/12.%20line.png" alt="Git Bash">
                            </div>
                            <h3>LINE Enginearing</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/13.%20nhncloud.png" alt="Git Bash">
                            </div>
                            <h3>NHN Cloud</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/14.%20aws.png" alt="Git Bash">
                            </div>
                            <h3>W3C schools</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/15.%20mdn.png" alt="Git Bash">
                            </div>
                            <h3>mdn wec docs</h3>
                        </a>
                    </div>
                </div>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
    <jsp:include page="../include/timer.jsp" />
</div>
</body>
</html>