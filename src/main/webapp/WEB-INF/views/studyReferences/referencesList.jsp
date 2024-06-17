<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공부 자료 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css?after">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
<%--    <script>--%>
<%--        $(document).ajaxSend(function(e, xhr, options) {--%>
<%--            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));--%>
<%--        });--%>
<%--    </script>--%>
    <script>
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

        function searchPosts() {
            let searchKeyword = document.getElementById('searchInput').value;
            let searchOption = document.getElementById('searchOption').value;

            location.href="/studyReferences/referencesList?searchKeyword="+searchKeyword + "&searchOption=" + searchOption;

        }

        function loadMore() {
            let searchKeyword = document.getElementById('searchInput').value;
            let searchOption = document.getElementById('searchOption').value;
            let limits = Number(document.getElementById('limits').value) ;

            let totalCount = '${studyReferencesEntity[0].TOTALCOUNT}'
            if(limits >= Number(totalCount)){
                alert('더이상 조회할 게시물이 없습니다.');

            }else{
                limits += 5;
                location.href="/studyReferences/referencesList?searchKeyword="+searchKeyword + "&searchOption=" + searchOption + "&limits="+limits;
            }
        }

        document.addEventListener("DOMContentLoaded", function () {
            var searchInput = document.getElementById("searchInput");
            searchInput.addEventListener("keypress", function (event) {
                if (event.key === "Enter") {
                    event.preventDefault();
                    searchPosts();
                }
            });
        });
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

                <button onclick="location.href='referencesWrite'">글작성</button>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp" />
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">

            <h1>공부자료</h1>

            <!-- 전체글(n) 검색창 -->
            <div class="container">
                <p class="total-post">전체글(${studyReferencesEntity[0].TOTALCOUNT})</p>
                <div class="flex-grow"></div>
                <select class="search-option" id="searchOption">
                    <option value="all-post">전체</option>
                    <option value="title-post">제목</option>
                    <option value="writer-post">작성자</option>
                </select>
                <div class="search-container">
                    <input type="text" id="searchInput" class="search-bar" placeholder=" 검색어를 입력해주세요" value="${searchKeyword}">
                    <input type="hidden" id="limits" class="search-bar" value="${limits}">
                    <button type="button" class="search-button" onclick="searchPosts()">
                        <i class="fa-solid fa-magnifying-glass"></i>
                    </button>
                </div>
            </div>

            <!-- 글 목록 -->
            <c:forEach var="data" items="${studyReferencesEntity}">
                <div class="post-container">
                    <div class="post-header">
                        <p class="title-post"
                           onclick="location.href='referencesSite?referenceIdx=${data.referenceIdx}'">${data.title}</p>
                        <!-- 페이지 새로고침해도 좋아요된것은 유지되도록-->
                        <c:if test="${data.isLike != 0}">
                            <div class="like-container">
                                <i class="fa-solid fa-heart heart-icon liked"
                                   onclick="toggleLike(this, ${data.referenceIdx})"></i>
                                <p class="info-post ">좋아요</p>
                            </div>
                        </c:if>
                        <c:if test="${data.isLike == 0}">
                            <div class="like-container">
                                <i class="fa-regular fa-heart heart-icon"
                                   onclick="toggleLike(this, ${data.referenceIdx})"></i>
                                <p class="info-post ">좋아요</p>
                            </div>
                        </c:if>
                    </div>
                    <p class="info-post">작성자: ${data.name} | 작성일: ${data.createdAt} | 조회수: ${data.viewsCount}</p>
                    <p class="content-post">${data.content}</p>
                    <hr class="green">
                </div>
            </c:forEach>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>

