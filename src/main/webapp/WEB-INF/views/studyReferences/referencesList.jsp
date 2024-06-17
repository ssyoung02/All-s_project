<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공부 자료 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css?after">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
        <script>
        function toggleLike(element, idx) {
            element.classList.toggle('liked');
            if (element.classList.contains('liked')) {
                element.className = 'fa-solid fa-heart heart-icon liked';
                $.ajax({
                    method: 'POST',
                    url: '/StudyReferences/insertLike',
                    data: {referenceIdx: idx, userIdx: ${userIdx}}
                })
            } else {
                element.className = 'fa-regular fa-heart heart-icon';
                $.ajax({
                    method: 'POST',
                    url: '/StudyReferences/deleteLike',
                    data: {referenceIdx: idx, userIdx: ${userIdx}}
                })
            }
        }

        function searchPosts() {
            let searchKeyword = document.getElementById('searchInput').value;
            let searchOption = document.getElementById('searchOption').value;

            location.href="/StudyReferences/referencesList?searchKeyword="+searchKeyword + "&searchOption=" + searchOption;

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
                location.href="/StudyReferences/referencesList?searchKeyword="+searchKeyword + "&searchOption=" + searchOption + "&limits="+limits;
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
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp" />
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>공부 자료</h1>

                <!--본문 콘텐츠-->
                <div class="maxcontent">
                    <div class="list-title flex-between">
                        <h3>전체 글(${studyReferencesEntity[0].TOTALCOUNT})</h3>
                        <fieldset class="search-box flex-row">
                            <select id="searchOption" name="searchCnd" title="검색 조건 선택">
                              <option value="all-post">전체</option>
                              <option value="title-post">제목</option>
                              <option value="writer-post">작성자</option>
                            </select>
                            <p class="search-field">
                                <input type="text" id="searchInput" name="searchWrd" class="search-bar" placeholder=" 검색어를 입력해주세요" value="${searchKeyword}">
                                <input type="hidden" id="limits" class="search-bar" value="${limits}">
                                <button type="submit" onclick="searchPosts()">
                                    <span class="hide">검색</span>
                                    <i class="bi bi-search"></i>
                                </button>
                            </p>
                            <button type="button" class="primary-default" onclick="location.href='referencesWrite'">글쓰기</button>
                        </fieldset>
                    </div>
                    <div class="boardContent flex-colum">
                      <!-- 글목록 -->
                      <c:forEach var="data" items="${studyReferencesEntity}">
                        <div class="board-listline flex-columleft" onclick="location.href='referencesSite?referenceIdx=${data.referenceIdx}'">
                            <div class="studygroup-item flex-between">
                                <!--스터디 목록-->
                                <div class="imgtitle flex-row">
                                    <div class="board-item flex-columleft">
                                        <a href="/referencesSite?referenceIdx=${data.referenceIdx}" class="board-title">${data.title}</a>
                                        <p class="board-content">작성자: ${data.name}  |   작성일: ${data.createdAt}  |  조회수: ${data.viewsCount}</p>
                                    </div>
                                </div>
                                <!--페이지 새로고침되도 좋아요 뜨도록-->
                               <c:if test="${data.isLike != 0}">
                                    <div class="board-like">
                                        <i class="bi bi-heart-fill" onclick="toggleLike(this, ${data.referenceIdx})"></i>
                                        <p class="info-post ">좋아요</p>
                                    </div>
                                </c:if>
                                <c:if test="${data.isLike == 0}">
                                    <div class="board-like">
                                        <i class="bi bi-heart"
                                           onclick="toggleLike(this, ${data.referenceIdx})"></i>
                                        <p class="info-post ">좋아요</p>
                                    </div>
                                  </c:if>
                            </div>
                            <div class="studygroup-item flex-between">
                                <a href="/referencesSite?referenceIdx=${data.referenceIdx}">
                                    ${data.content}
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                    </div>
                    <div class="flex-row">
                        <button class="secondary-default" onclick="loadMore()">목록 더보기</button>
                    </div>
                </div>
                <%--본문 콘텐츠--%>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>

