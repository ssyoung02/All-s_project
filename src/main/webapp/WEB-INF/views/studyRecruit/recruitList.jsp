<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 모집 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <link rel="stylesheet" href="${root}/resources/css/pagenation.css">
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="${root}/resources/css/slider.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
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
                <!--본문 콘텐트-->
                <div class="maxcontent">
                    <div class="list-title flex-between">
                        <div>
                            <i class="bi bi-map"></i>
                            <label for="studyLocation">
                                강남구
                            </label>
                            <input type="button" id="studyLocation" class="studyLocation" value="지도 선택">
                        </div>
                        <fieldset class="search-box flex-row">
                            <select id="searchOption" name="searchCnd" title="검색 조건 선택">
                                <option value="all-post">전체</option>
                                <option value="title-post">제목</option>
                                <option value="title-content">제목+내용</option>
                            </select>
                            <p class="search-field">
                                <input id="searchInput" type="text" name="searchWrd" placeholder="검색어를 입력해주세요">
                                <button onclick="searchPosts()">
                                    <span class="hide">검색</span>
                                    <i class="bi bi-search"></i>
                                </button>
                            </p>
                        </fieldset>
                    </div>

                    <!--슬라이드 배너-->
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <!-- 동적으로 생성된 슬라이드 아이템들 -->
                            <c:forEach var="study" items="${study_18}">
                                <div class="swiper-slide">
                                    <div class="study-banner-item bgwhite" tabindex="0"
                                         onclick="location.href='${root}/studyRecruit/recruitReadForm?studyIdx=${study.studyIdx}'">
                                        <div class="banner-bottom flex-between">
                                            <p class="study-tag">
                                                <span class="recruit-status ${study.status eq 'CLOSED' ? 'closed' : ''}">${study.status}</span>
                                                <span class="department">${study.category}</span>
                                            </p>
                                            <!-- 페이지 새로고침해도 좋아요된것은 유지되도록 -->
                                            <!-- 좋아요 상태를 반영하여 버튼 클래스 설정 -->
                                            <c:choose>
                                                <c:when test="${study.isLike != 0}">
                                                    <button class="flex-row liked" onclick="toggleLike(this, ${study.studyIdx})">
                                                        <i class="bi bi-heart-fill"></i>
                                                        <p class="info-post"></p>
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="flex-row" onclick="toggleLike(this, ${study.studyIdx})">
                                                        <i class="bi bi-heart"></i>
                                                        <p class="info-post"></p>
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="banner-item-top">
                                            <div class="banner-img">
                                                <c:choose>
                                                    <c:when test="${study.image != null}">
                                                        <img src="${root}${study.image}" alt="스터디 그룹 프로필"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${root}/resources/images/studyGroup.png" alt="스터디 그룹 프로필"/>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="banner-title">
                                                <p class="banner-main-title">${study.studyTitle}</p>
                                                <p class="banner-id">${study.leaderName}</p>
                                            </div>
                                        </div>
                                        <p class="banner-content">${study.description}</p>
                                        <p class="study-tag">
                                            <span class="study-tagItem">#${study.gender}</span>
                                            <span class="study-tagItem">#${study.age}</span>
                                            <span class="study-tagItem">#${study.studyOnline ? "온라인" : "오프라인"}</span>
                                        </p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>

                        <!-- 페이지 네이션 -->
                        <div class="swiper-pagination"></div>

                        <!-- 이전, 다음 버튼 -->
                        <div class="swiper-button-prev"></div>
                        <button class="control-button"><i class="bi bi-pause"></i></button>
                        <div class="swiper-button-next"></div>
                    </div>
                    <%--슬라이더 끝--%>

                    <div class="recruitmentStatus">
                        <a class="recruitmentStatusSelect" href="${root}/studyRecruit/recruitList?status=RECRUITING">모집 중</a>
                        <a class="" href="${root}/studyRecruit/recruitList?status=CLOSED">모집 마감</a>
                    </div>

                    <div class="recruitList">
                        <%-- 게시판 글 --%>
                        <c:forEach var="study" items="${studies}">
                            <div class="recruitItem" data-status="${study.status}">
                                <div class="studygroup-item flex-between">
                                    <button class="imgtitle link-button"
                                            onclick="location.href='${root}/studyRecruit/recruitReadForm?studyIdx=${study.studyIdx}'">
                                        <div class="board-item flex-columleft">
                                            <div class="flex-row">
                                                <c:choose>
                                                    <c:when test="${study.image != null}">
                                                        <img src="${root}${study.image}" alt="스터디 그룹 프로필" style="width: 50px; height: 50px; margin-right: 10px;"/>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${root}/resources/images/studyGroup.png" alt="스터디 그룹 프로필" style="width: 50px; height: 50px; margin-right: 10px;"/>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div>
                                                    <p class="study-tag">
                                                        <span class="recruit-status ${study.status eq 'CLOSED' ? 'closed' : ''}">
                                                                ${study.status eq 'CLOSED' ? '모집마감' : '모집중'}
                                                                <span class="recruitNum">(${study.currentParticipants}/${study.capacity})&nbsp;</span>
                                                        </span>
                                                        <span class="department">${study.category}</span>
                                                        <span class="study-tagItem">#${study.gender}</span>
                                                        <span class="study-tagItem">#${study.age}</span>
                                                        <span class="study-tagItem">#${study.studyOnline ? "온라인" : "오프라인"}</span>
                                                    </p>
                                                    <h3 class="board-title">${study.studyTitle}</h3>
                                                </div>
                                            </div>
                                        </div>
                                    </button>
                                    <!-- 페이지 새로고침해도 좋아요된것은 유지되도록 -->
                                    <div class="flex-row">
                                        <!-- 좋아요 버튼 -->
                                    <c:choose>
                                        <c:when test="${study.isLike != 0}">
                                            <button class="flex-row liked" onclick="toggleLike(this, ${study.studyIdx})">
                                                <i class="bi bi-heart-fill"></i>
                                                <p class="info-post">좋아요  </p>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="flex-row" onclick="toggleLike(this, ${study.studyIdx})">
                                                <i class="bi bi-heart"></i>
                                                <p class="info-post">좋아요</p>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    </div>
                                </div>
                                <button class="board-content link-button" onclick="location.href='recruitReadForm.jsp'">
                                        ${study.description}
                                </button>
                            </div>
                        </c:forEach>
                    </div>


<%--                    <div class="flex-row">--%>
<%--                        <button class="secondary-default" onclick="loadMore()">목록 더보기</button>--%>
<%--                    </div>--%>


                    <!-- 페이지네이션 바 시작 -->
                    <div class="pagination">
                        <ul>
                            <c:if test="${status == 'RECRUITING'}">
                                <c:if test="${startPage > 1}">
                                    <li><a href="?page=1&status=RECRUITING">&lt;&lt;</a></li>
                                </c:if>
                                <c:if test="${currentPage > 1}">
                                    <li><a href="?page=${currentPage - 1}&status=RECRUITING">&lt;</a></li>
                                </c:if>
                                <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                    <li class="${pageNum == currentPage ? 'active' : ''}">
                                        <a href="?page=${pageNum}&status=RECRUITING">${pageNum}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li><a href="?page=${currentPage + 1}&status=RECRUITING">&gt;</a></li>
                                </c:if>
                                <c:if test="${endPage < totalPages}">
                                    <li><a href="?page=${totalPages}&status=RECRUITING">&gt;&gt;</a></li>
                                </c:if>
                            </c:if>

                            <c:if test="${status == 'CLOSED'}">
                                <c:if test="${startPage > 1}">
                                    <li><a href="?page=1&status=CLOSED">&lt;&lt;</a></li>
                                </c:if>
                                <c:if test="${currentPage > 1}">
                                    <li><a href="?page=${currentPage - 1}&status=CLOSED">&lt;</a></li>
                                </c:if>
                                <c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
                                    <li class="${pageNum == currentPage ? 'active' : ''}">
                                        <a href="?page=${pageNum}&status=CLOSED">${pageNum}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li><a href="?page=${currentPage + 1}&status=CLOSED">&gt;</a></li>
                                </c:if>
                                <c:if test="${endPage < totalPages}">
                                    <li><a href="?page=${totalPages}&status=CLOSED">&gt;&gt;</a></li>
                                </c:if>
                            </c:if>
                        </ul>
                    </div>
                    <!-- 페이지네이션 바 끝 -->
                </div>
                <%--본문 콘텐츠 끝--%>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
</div>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${root}/resources/js/slider.js"></script>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${root}/resources/js/slider.js"></script>
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
<script>

    document.addEventListener("DOMContentLoaded", function () {
        var searchInput = document.getElementById("searchInput");
        searchInput.addEventListener("keypress", function (event) {
            if (event.key === "Enter") {
                event.preventDefault();
                searchPosts();
            }
        });
    });

    document.addEventListener("DOMContentLoaded", function () {
        const statusElements = document.querySelectorAll('.recruit-status');

        statusElements.forEach(element => {
            const status = element.innerText;

            if (status === 'RECRUITING') {
                element.innerText = '모집중';
            } else if (status === 'CLOSED') {
                element.innerText = '모집마감';
            }
        });
    });

    // 페이지 로드 시 모집 중인 스터디만 표시
    $(document).ready(function() {
        filterStudies('RECRUITING');

        // 지역 정보 가져와서 표시
        var savedLocationName = localStorage.getItem("locationName");
        if (savedLocationName) {
            $("#studyLocation").prev("label").text(savedLocationName);
        }
    });

    //검색 버튼
    function searchPosts() {
        let searchKeyword = document.getElementById('searchInput').value;
        let searchOption = document.getElementById('searchOption').value;

        console.log("Search Option: " + searchOption);
        console.log("search Keyword: " + searchKeyword);

        window.location.href = "${root}/studyRecruit/recruitList?searchKeyword=" + searchKeyword + "&searchOption=" + searchOption;
    }

    function redirectToStudyDetail(studyIdx) {
        var url = "${root}/studyRecruit/recruitReadForm?studyIdx=" + studyIdx;
        window.location.href = url;
    }

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
                data: { studyIdx: idx, userIdx: ${userVo.userIdx} },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function(response) {
                    console.log("Like inserted successfully.");
                },
                error: function(error) {
                    console.error("Error inserting like:", error);
                }
            });
        } else {
            element.classList.remove('liked');
            icon.className = 'bi bi-heart';
            $.ajax({
                method: 'POST',
                url: '/studyRecruit/deleteLike',
                data: { studyIdx: idx, userIdx: ${userVo.userIdx} },
                beforeSend: function(xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function(response) {
                    console.log("Like removed successfully.");
                },
                error: function(error) {
                    console.error("Error removing like:", error);
                }
            });
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
</html>
