<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 모집 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="${root}/resources/css/slider.css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
<jsp:include page="../include/timer.jsp"/>
<jsp:include page="../include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContaner">
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
                            <label for="studyLocation">
                                <i class="bi bi-map"></i>
                                강남구
                            </label>
                            <input type="button" id="studyLocation" class="studyLocation" value="지도 선택">
                        </div>
                        <fieldset class="search-box flex-row">
                            <select name="searchCnd" title="검색 조건 선택">
                                <option value="제목">제목</option>
                                <option value="글내용">글내용</option>
                            </select>
                            <p class="search-field">
                                <input type="text" name="searchWrd" placeholder="검색어를 입력해주세요">
                                <button type="submit">
                                    <span class="hide">검색</span>
                                    <i class="bi bi-search"></i>
                                </button>
                            </p>
                        </fieldset>
                    </div>

                    <!--슬라이드 배너-->
                    <div class="swiper-container">
                        <div class="swiper-wrapper">
                            <!--슬라이드 아이템들-->
                            <div class="swiper-slide">
                                <div class="study-banner-item bgwhite" tabindex="0" onclick="">
                                    <div class="banner-bottom flex-between">
                                        <p class="study-tag">
                                            <span class="recruit-status">모집중</span>
                                            <span class="department">면접</span>
                                        </p>
                                        <button class="banner-like" aria-label="좋아요">
                                            <i class="bi bi-heart"></i>
                                        </button>
                                    </div>
                                    <div class="banner-item-top">
                                        <div class="banner-img">
                                            <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                        </div>
                                        <div class="banner-title">
                                            <p class="banner-main-title">강남인근 면접 스터디 모집1</p>
                                            <p class="banner-id">Jihyeon</p>
                                        </div>
                                    </div>
                                    <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                    <p class="study-tag">
                                        <span class="study-tagItem">#위치</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#연령대</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#온라인</span>
                                    </p>
                                </div>
                            </div>
                            <div class="swiper-slide">
                                <div class="study-banner-item bgwhite" tabindex="0" onclick="">
                                    <div class="banner-bottom flex-between">
                                        <p class="study-tag">
                                            <span class="recruit-status">모집중</span>
                                            <span class="department">면접</span>
                                        </p>
                                        <button class="banner-like" aria-label="좋아요">
                                            <i class="bi bi-heart"></i>
                                        </button>
                                    </div>
                                    <div class="banner-item-top">
                                        <div class="banner-img">
                                            <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                        </div>
                                        <div class="banner-title">
                                            <p class="banner-main-title">강남인근 면접 스터디 모집2</p>
                                            <p class="banner-id">Jihyeon</p>
                                        </div>
                                    </div>
                                    <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                    <p class="study-tag">
                                        <span class="study-tagItem">#위치</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#연령대</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#온라인</span>
                                    </p>
                                </div>
                            </div>

                            <div class="swiper-slide">
                                <div class="study-banner-item bgwhite" tabindex="0" onclick="">
                                    <div class="banner-bottom flex-between">
                                        <p class="study-tag">
                                            <span class="recruit-status">모집중</span>
                                            <span class="department">면접</span>
                                        </p>
                                        <button class="banner-like" aria-label="좋아요">
                                            <i class="bi bi-heart"></i>
                                        </button>
                                    </div>
                                    <div class="banner-item-top">
                                        <div class="banner-img">
                                            <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                        </div>
                                        <div class="banner-title">
                                            <p class="banner-main-title">강남인근 면접 스터디 모집3</p>
                                            <p class="banner-id">Jihyeon</p>
                                        </div>
                                    </div>
                                    <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                    <p class="study-tag">
                                        <span class="study-tagItem">#위치</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#연령대</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#온라인</span>
                                    </p>
                                </div>
                            </div>

                            <div class="swiper-slide">
                                <div class="study-banner-item bgwhite" tabindex="0" onclick="">
                                    <div class="banner-bottom flex-between">
                                        <p class="study-tag">
                                            <span class="recruit-status">모집중</span>
                                            <span class="department">면접</span>
                                        </p>
                                        <button class="banner-like" aria-label="좋아요">
                                            <i class="bi bi-heart"></i>
                                        </button>
                                    </div>
                                    <div class="banner-item-top">
                                        <div class="banner-img">
                                            <img src="${root}/resources/images/logo.png" alt="스터디 그룹 로고"/>
                                        </div>
                                        <div class="banner-title">
                                            <p class="banner-main-title">강남인근 면접 스터디 모집4</p>
                                            <p class="banner-id">Jihyeon</p>
                                        </div>
                                    </div>
                                    <p class="banner-content">강남역 근처에서 스터디 모집해요~</p>
                                    <p class="study-tag">
                                        <span class="study-tagItem">#위치</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#연령대</span>
                                        <span class="study-tagItem">#성별</span>
                                        <span class="study-tagItem">#온라인</span>
                                    </p>
                                </div>
                            </div>

                            <!-- 다른 슬라이드들 추가 가능 -->
                        </div>
                        <!-- 페이지 네이션 -->
                        <div class="swiper-pagination"></div>

                        <!-- 이전, 다음 버튼 -->
                        <div class="swiper-button-prev"></div>
                        <button class="control-button"><i class="bi bi-pause"></i></button>
                        <div class="swiper-button-next"></div>
                    </div>
                    <%--슬라이더 끝--%>

                    <div class="list-title flex-between">
                        <h3>전체 글(15)</h3>
                    </div>

                    <div class="recruitList">
                        <%--게시판 글--%>
                        <div class="recruitItem">
                            <div class="studygroup-item flex-between">
                                <button class="imgtitle link-button" onclick="">
                                    <div class="board-item flex-columleft">
                                        <p class="study-tag">
                                            <span class="recruit-status">모집중</span>
                                            <span class="department">면접</span>
                                            <span class="study-tagItem">#위치</span>
                                            <span class="study-tagItem">#성별</span>
                                            <span class="study-tagItem">#연령대</span>
                                            <span class="study-tagItem">#성별</span>
                                            <span class="study-tagItem">#온라인</span>
                                        </p>
                                        <h3 class="board-title">백앤드 개발자 코딩 면접 같이 준비하실 분</h3>
                                    </div>
                                </button>
                                <button class="board-like" onclick="">
                                    <i class="bi bi-heart"></i>
                                    <p class="info-post">좋아요</p>
                                </button>
                            </div>
                            <button class="board-content link-button" onclick="location.href='recruitReadForm.jsp'">
                                강남 근처에서 백앤드 개발자 코딩 면접을 같이 준비하실 분 모집합니다. 주 1회 카페에서 대면으로 만나서 준비할 예정이니 근처 사시는 분만 지원해주세요. 지원하실 때 사는곳이나 직장이 근처인지 꼭 적어주세요!(안적으면 죄송하지만 가입 신청 거절합니다!!
                            </button>
                        </div>
                            <div class="recruitItem">
                                <div class="studygroup-item flex-between">
                                    <button class="imgtitle link-button" onclick="">
                                        <div class="board-item flex-columleft">
                                            <p class="study-tag">
                                                <span class="recruit-status closed">모집완료</span>
                                                <span class="department">면접</span>
                                                <span class="study-tagItem">#위치</span>
                                                <span class="study-tagItem">#성별</span>
                                                <span class="study-tagItem">#연령대</span>
                                                <span class="study-tagItem">#성별</span>
                                                <span class="study-tagItem">#온라인</span>
                                            </p>
                                            <h3 class="board-title">백앤드 개발자 코딩 면접 같이 준비하실 분</h3>
                                        </div>
                                    </button>
                                    <button class="board-like" onclick="">
                                        <i class="bi bi-heart"></i>
                                        <p class="info-post">좋아요</p>
                                    </button>
                                </div>
                                <button class="board-content link-button" onclick="">
                                    강남 근처에서 백앤드 개발자 코딩 면접을 같이 준비하실 분 모집합니다. 주 1회 카페에서 대면으로 만나서 준비할 예정이니 근처 사시는 분만 지원해주세요. 지원하실 때 사는곳이나 직장이 근처인지 꼭 적어주세요!(안적으면 죄송하지만 가입 신청 거절합니다!!
                                </button>
                            </div>


                    </div>

                </div>
                <%--본문 콘텐츠 끝--%>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp"/>
</div>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${root}/resources/js/slider.js"></script>
</body>
</html>
