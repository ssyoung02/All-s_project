<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<c:set var="currentURI" value="${pageContext.request.requestURL}" />

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
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}&libraries=clusterer,services"></script>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <style>  .cafe-info-window {
        background-color: white;
        border: 1px solid #ccc;
        border-radius: 5px;
        padding: 10px;
        width: 200px;
    }

    .map-search-container {
        position: absolute;
        top: 10px;
        left: 10px;
        z-index: 2; /* 지도 위에 표시되도록 설정 */
    }

    .map-search-container input[type="text"] {
        padding: 8px;
        border: 1px solid #ccc;
        border-radius: 4px;
        z-index: 2;
    }

    .map-search-container button {
        padding: 8px 12px;
        background-color: #fff;
        border: 1px solid #ccc;
        border-radius: 4px;
        cursor: pointer;
        z-index: 2;
    }</style>
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
                    <div id="map-recruitList"
                         style="width:100%; height:250px;border-radius: 5px; margin: 1em 0"> <%-- 로그인 후 지도 컨테이너 --%>
                        <div class="map-search-container">
                            <button id="cafeSearchButton" class="toggle-button-map">내 주변 카페 보기☕</button>
                            <button id="myLocationButton" class="toggle-button-map">내 위치로 가기📍</button> <%-- 버튼 추가 --%>

                        </div>
                    </div>
                    <div id="studyListContainer" style="display: block;"> <%-- display: block 추가 --%>
                        <h3>${userVo.name}님 주변의 스터디🗺️📌</h3>
                        <ul id="studyListHi">

                        </ul>
                    </div> <%-- 스터디 목록 컨테이너 추가 --%>

<%--
                    <div class="recruitmentStatus">
                        <a class="recruitmentStatusSelect" href="${root}/studyRecruit/recruitList?status=RECRUITING">모집 중</a>
                        <a class="" href="${root}/studyRecruit/recruitList?status=CLOSED">모집 마감</a>
                    </div>
--%>

                    <%
                        String status = request.getParameter("status");
                        if (status == null) {
                            status = "RECRUITING"; // 기본값 설정
                        }
                    %>
                    <div class="recruitmentStatus">
                        <a class="<%= "RECRUITING".equals(status) ? "recruitmentStatusSelect" : "" %>"
                           href="${root}/studyRecruit/recruitList?status=RECRUITING">모집 중</a>
                        <a class="<%= "CLOSED".equals(status) ? "recruitmentStatusSelect" : "" %>"
                           href="${root}/studyRecruit/recruitList?status=CLOSED">모집 마감</a>
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
        const contextPath = 'http://localhost:8080/WEB-INF/views/';
        const currentURI = '${currentURI}';

        console.log("현재 URL: "+currentURI)
    });


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
<script>

    $(document).ajaxSend(function (e, xhr, options) {
        xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
    });

    var mapRecruitList;
    var marker;
    var markers = []; // 마커 배열

    var zoomLevel = 6;
    var isWideView = false;

    // 인포윈도우 객체 배열 (로그인 상태)
    var infowindows = [];

    var clusterer = new kakao.maps.MarkerClusterer({
        map: mapRecruitList, // 클러스터러를 적용할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 8 // 클러스터 할 최소 지도 레벨
    });

    // 마커 이미지 생성
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 마커 이미지 URL
    var imageSize = new kakao.maps.Size(24, 35);
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);


    // 지도 생성 및 초기화 (로그인 후)
    function initializeMapRecruitList() {
        var mapContainer = document.getElementById('map-recruitList');
        var mapOption = {
            center: new kakao.maps.LatLng(37.49564, 127.0275), // 초기 지도 중심좌표 (비트캠프)
            level: zoomLevel
        };
        mapRecruitList = new kakao.maps.Map(mapContainer, mapOption);

        // 지도 확대, 축소 컨트롤 생성 및 추가
        var zoomControl = new kakao.maps.ZoomControl();
        mapRecruitList.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 초기 위치 가져오기 및 지도 중심 설정
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;

                var locPosition = new kakao.maps.LatLng(lat, lon);
                mapRecruitList.setCenter(locPosition); // 지도 중심을 현재 위치로 설정
            }, function(error) {
                console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
            });
        } else {
            // Geolocation을 사용할 수 없을 때 처리 로직
        }

        // 마커를 생성합니다
        marker = new kakao.maps.Marker({
            position: mapRecruitList.getCenter()
        });
        marker.setMap(mapRecruitList);

        // 마커 클러스터러 생성 (지도 초기화 후)
        clusterer = new kakao.maps.MarkerClusterer({
            map: mapRecruitList,
            averageCenter: true,
            minLevel: 8
        });

    }

    // 사용자 위치 가져오기 및 지도에 표시
    function getLocationAndDisplayOnMap() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;

                var locPosition = new kakao.maps.LatLng(lat, lon);
                 marker.setPosition(locPosition);

                // 로그인 여부 확인 후 위치 정보 전송
                <sec:authorize access="isAuthenticated()">
                sendLocationToServer(lat, lon);
                </sec:authorize>
            }, function(error) {
                console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
            });
        } else {
            // Geolocation을 사용할 수 없을 때 처리 로직
        }
    }


    // 위치 정보 서버 전송 함수
    function sendLocationToServer(latitude, longitude) {
        // 로그인 여부 확인
        $.ajax({
            url: '/Users/updateLocation',  // 위치 정보 업데이트 요청을 처리할 컨트롤러 URL
            type: 'POST',
            data: {latitude: latitude, longitude: longitude},
            beforeSend: function (xhr) {
                xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
            },
            success: function (response) {
                console.log('위치 정보 업데이트 성공:', response);
            },
            error: function (xhr, status, error) {
                console.error('위치 정보 업데이트 실패:', error);
            }
        });
    }

    // 스터디 마커 표시 함수
    function displayStudyMarkers(map, studyData) {
        var markers = []; // 마커들을 담을 배열
        // 스터디 목록 초기화
        const studyList = document.getElementById('studyList');
        if (studyList) { // studyList가 null인지 확인
            studyList.innerHTML = ''; // 기존 목록 내용 지우기
        }

        for (var i = 0; i < studyData.length; i++) {
            var study = studyData[i];
            var position = new kakao.maps.LatLng(study.latitude, study.longitude);
            var Removeable = true;

            // 마커 생성
            var marker = new kakao.maps.Marker({
                map: map,
                position: position,
                title: study.studyTitle,
                image: markerImage // 마커 이미지 설정
            });

            markers.push(marker); // 생성된 마커를 배열에 추가

            // 인포윈도우 생성 및 배열에 저장
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:160px;text-align:center;padding:10px 0;border-radius: 20px;">' +
                    '<h4>' + study.studyTitle + '</h4>' +
                    '<p>' + study.category + '</p>' +
                    '<p>' + "💚 likes : " + study.likesCount + '</p>' +
                    '<p>' + "모집 :" + study.currentParticipants + '/' + study.capacity + '</p>' + '<br>' +
                    '<a href="${root}/studyRecruit/recruitReadForm?studyIdx=' + study.studyIdx + '" class="btn btn-primary" style="background-color: #dbe0d2;color: #000000;padding: 5px;border-radius: 5px;font-size: 10px;">더보기</a>' + // 상세보기 버튼 추가
                    '</div>',
                removable: Removeable,
                yAnchor: -45 // 인포윈도우를 마커 위쪽으로 이동
            });
            infowindows.push(infowindow);

            // 마커 클릭 이벤트 리스너 등록 (클로저 활용)
            (function (marker, index) { // index 매개변수 추가
                kakao.maps.event.addListener(marker, 'click', function () {
                    // 다른 인포윈도우 닫기
                    infowindows.forEach(function (iw) {
                        iw.close();
                    });
                    // 클릭된 마커에 해당하는 인포윈도우 열기
                    infowindows[index].open(map, marker);
                });
            })(marker, i); // marker와 index를 클로저에 전달
        }
        clusterer.addMarkers(markers); // 클러스터러에 마커 추가
    }



    // 지도 확대/축소 토글 함수
    function toggleMapView() {
        var mapContainer = document.getElementById('map-recruitList');
        var toggleButton = document.getElementById('toggleButton');

        if (isWideView) {
            // 현재 확대 상태이면 축소
            getLocationAndDisplayOnMap();
            mapContainer.style.width = '100%';
            mapContainer.style.height = '250px';
            toggleButton.textContent = '🔍창 확대';

        } else {
            // 현재 축소 상태이면 확대
            getLocationAndDisplayOnMap();
            mapContainer.style.width = '100%';
            mapContainer.style.height = '800px';
            toggleButton.textContent = '🔍창 축소';
        }
        // 지도 크기 변경 후 relayout 호출 (setTimeout을 사용하여 렌더링 후 호출)
        setTimeout(function () {
            mapRecruitList.relayout();
            // 딜레이 후 화면 중심을 지도 중심으로 이동
            setTimeout(function () {
                window.scrollTo({
                    top: mapContainer.offsetTop - (window.innerHeight - mapContainer.offsetHeight) / 2,
                    left: mapContainer.offsetLeft - (window.innerWidth - mapContainer.offsetWidth) / 2,
                    behavior: 'smooth'
                });
                moveToCurrentLocation();
            }, 500); // 0.5초 후에 실행 (딜레이 시간 조절 가능)
        }, 500); // 0.5초 후에 relayout 호출 (transition 시간과 동일하게 설정)

        isWideView = !isWideView; // 확대 상태 반전
    }
    // studyIdx 값을 저장할 배열
    var studyIndices = [];
    // 스터디 목록 조회 및 표시 함수
    function getStudyListAndDisplayList() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function (position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;
                var studyIndices = [];
                $.ajax({
                    url: '/studies/nearestStudies',
                    type: 'GET',
                    dataType: 'json',
                    data: {latitude: lat, longitude: lon},
                    success: function (studyData) {
                        studyIndices = studyData.map(study => study.studyIdx); // studyIdx 배열 생성

                        // 스터디 목록 초기화
                        const studyListHi = document.getElementById('studyListHi');
                        if (studyListHi) {
                            studyListHi.innerHTML = ''; // 기존 목록 내용 지우기
                        } else {
                            console.error('studyListHi 요소를 찾을 수 없습니다.');
                            return; // 함수 종료
                        }

                        // 스터디 데이터 거리순으로 정렬
                        studyData.sort((a, b) => a.distance - b.distance);

                        // 가까운 스터디 3개만 목록에 추가
                        for (let i = 0; i < Math.min(studyData.length, 3); i++) {
                            const study = studyData[i];

                            // recruitItem div 생성
                            const recruitItem = document.createElement('div');
                            recruitItem.className = 'recruitItem';

                            // studygroup-item div 생성
                            const studygroupItem = document.createElement('div');
                            studygroupItem.className = 'studygroup-item flex-between';
                            recruitItem.appendChild(studygroupItem);

                            // imgtitle 버튼 생성
                            const imgtitleButton = document.createElement('button');
                            imgtitleButton.className = 'imgtitle link-button';
                            imgtitleButton.onclick = function() {
                                location.href = '${root}/studyRecruit/recruitReadForm?studyIdx=' + study.studyIdx;
                            };
                            studygroupItem.appendChild(imgtitleButton);

                            // board-item div 생성
                            const boardItem = document.createElement('div');
                            boardItem.className = 'board-item flex-columleft';
                            imgtitleButton.appendChild(boardItem);

                            // study-tag p 생성 (EL 표현식 제거)
                            const studyTag = document.createElement('p');
                            studyTag.className = 'study-tag';

                            // span 요소 생성 및 내용 설정
                            const statusSpan = document.createElement('span');
                            statusSpan.className = 'recruit-status ' + (study.status === 'CLOSED' ? 'closed' : 'open');
                            statusSpan.textContent = study.status;
                            studyTag.appendChild(statusSpan);

                            const categorySpan = document.createElement('span');
                            categorySpan.className = 'department';
                            categorySpan.textContent = study.category;
                            studyTag.appendChild(categorySpan);

                            const genderSpan = document.createElement('span');
                            genderSpan.className = 'study-tagItem';
                            genderSpan.textContent = '#' + study.gender;
                            studyTag.appendChild(genderSpan);

                            const ageSpan = document.createElement('span');
                            ageSpan.className = 'study-tagItem';
                            ageSpan.textContent = '#' + study.age;
                            studyTag.appendChild(ageSpan);

                            const onlineSpan = document.createElement('span');
                            onlineSpan.className = 'study-tagItem';
                            onlineSpan.textContent = '#' + (study.studyOnline ? '온라인' : '오프라인');
                            studyTag.appendChild(onlineSpan);

                            boardItem.appendChild(studyTag);

                            // board-title h3 생성
                            const boardTitle = document.createElement('h3');
                            boardTitle.className = 'board-title';
                            boardTitle.textContent = study.studyTitle;
                            boardItem.appendChild(boardTitle);

                            // 좋아요 버튼 생성 (AJAX 처리 필요)
                            const likeButton = document.createElement('button');
                            likeButton.className = 'flex-row';
                            // 좋아요 버튼의 클릭 이벤트 처리 (toggleLike 함수 호출)는 별도로 구현해야 합니다.
                            studygroupItem.appendChild(likeButton);

                            // board-content 버튼 생성
                            const boardContentButton = document.createElement('button');
                            boardContentButton.className = 'board-content link-button';
                            boardContentButton.textContent = study.description;
                            boardContentButton.onclick = function() {
                                location.href = '${root}/studyRecruit/recruitReadForm?studyIdx=' + study.studyIdx;
                            };
                            recruitItem.appendChild(boardContentButton);

                            // studyList에 recruitItem 추가
                            studyListHi.appendChild(recruitItem);
                        }

                    },
                    error: function (xhr, status, error) {
                        console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
                    }
                });
            }, function (error) {
                console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
            });
        } else {
            // Geolocation을 사용할 수 없을 때 처리 로직
        }
    }

    // 현재 위치로 지도 이동 함수
    function moveToCurrentLocation() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;

                var locPosition = new kakao.maps.LatLng(lat, lon);
                marker.setPosition(locPosition);
                mapRecruitList.panTo(locPosition); // panTo 메서드 사용
                // mapRecruitList.setCenter(locPosition); // 지도 중심을 현재 위치로 설정
            }, function(error) {
                console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
            });
        } else {
            // Geolocation을 사용할 수 없을 때 처리 로직
        }
    }

    // 페이지 로드 시 지도 초기화 및 위치 정보 가져오기
    $(document).ready(function () {

        $(document).ajaxSend(function(e, xhr, options) {
            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
        });

        initializeMapRecruitList();
        getLocationAndDisplayOnMap();
        // 초기 스터디 목록 조회 및 표시
        getStudyListAndDisplayList();
        $.ajax({
            url: '/studies/listOnMap',
            type: 'GET',
            dataType: 'json',
            success: function (studyData) {
                displayStudyMarkers(mapRecruitList, studyData);
            },
            error: function (xhr, status, error) {
                console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
            }
        });
        // 1초마다 위치 정보 업데이트
        setInterval(getLocationAndDisplayOnMap, 1000);
        setInterval(getStudyListAndDisplayList,10000);

        // 토글 버튼 1 생성 및 추가 (지도 확대/축소)
        var toggleButton = document.createElement('button');
        toggleButton.id = 'toggleButton';
        toggleButton.textContent = "🔍창 확대";
        toggleButton.className = 'toggle-button-map';
        document.getElementById('map-recruitList').appendChild(toggleButton);

        // 토글 버튼 클릭 이벤트 리스너 등록
        toggleButton.addEventListener('click', toggleMapView);


        function searchCafesNearMapCenter(map) {
            // 현재 위치 정보 가져오기
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;
                    var locPosition = new kakao.maps.LatLng(lat, lon);

                    // 카페 검색 객체 생성 및 옵션 설정 (2km 반경 제한 추가)
                    var ps = new kakao.maps.services.Places(map);
                    var options = {
                        location: locPosition,
                        radius: 2000, // 2km 반경
                        category_group_code: 'CE7',
                        sort: kakao.maps.services.SortBy.DISTANCE
                    };

                    // 카페 검색 실행
                    ps.keywordSearch('카페', function (data, status, pagination) {
                        if (status === kakao.maps.services.Status.OK) {
                            displayCafeMarkers(map, data.slice(0, 15)); // 최대 15개만 표시
                        } else {
                            console.error('카페 검색 실패:', status);
                        }
                    }, options);
                });
            } else {
                console.error("Geolocation is not available.");
            }
        }


        function displayCafeMarkers(map, cafes) {
            // 기존 마커 및 인포윈도우 제거
            clusterer.clear();
            if (infowindows) {
                infowindows.forEach(function(iw) {
                    iw.close();
                });
            }
            infowindows = []; // 인포윈도우 배열 초기화
            // 카페 마커 이미지 설정 (스프라이트 이미지 사용)
            var imageSrc = '${root}/resources/images/icons8-커피-이동합니다-64.png';
            var imageSize = new kakao.maps.Size(50, 50);
            var cafeMarkerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

            // 카페 마커 생성 및 표시
            for (let i = 0; i < cafes.length; i++) {
                const cafe = cafes[i];
                const position = new kakao.maps.LatLng(cafe.y, cafe.x);

                const marker = new kakao.maps.Marker({
                    map: map,
                    position: position,
                    title: cafe.place_name,
                    image: cafeMarkerImage
                });

                // 각 마커에 대한 인포윈도우 생성
                var infowindow = new kakao.maps.InfoWindow({
                    content: '<div style="width:160px;text-align:center;padding:10px 0;border-radius: 20px;">' +
                        '<h4>' + cafe.place_name + '</h4>' +
                        '<p>' + cafe.address_name + '</p>' +
                        '<p>' + cafe.phone + '</p>' +
                        '<a href="' + cafe.place_url + '" target="_blank" class="btn btn-primary" style="background-color: #dbe0d2;color: #000000;padding: 5px;border-radius: 5px;font-size: 10px;">상세 정보</a>' +
                        '</div>',
                    removable: true,
                    yAnchor: 1 // 인포윈도우를 마커 아래쪽으로 이동
                });

                // 마커 클릭 이벤트 리스너 등록 (클로저 활용)
                (function (marker, infowindow) {
                    kakao.maps.event.addListener(marker, 'click', function () {
                        // 모든 인포윈도우 닫기
                        infowindows.forEach(function (iw) {
                            iw.close();
                        });
                        // 클릭된 마커에 해당하는 인포윈도우 열기
                        infowindow.open(map, marker);
                    });
                })(marker, infowindow); // marker와 infowindow를 즉시 실행 함수에 전달

                // 마커와 인포윈도우를 배열에 추가
                clusterer.addMarker(marker);
                infowindows.push(infowindow);
            }
        }


        // 내 위치로 가기 버튼 클릭 이벤트 처리
        const myLocationButton = document.getElementById('myLocationButton');
        myLocationButton.addEventListener('click', moveToCurrentLocation);

// 카페 검색 버튼 클릭 이벤트 처리
        let cafeSearchButton = document.getElementById('cafeSearchButton');
        // 토글 버튼 클릭 이벤트 처리
        cafeSearchButton.addEventListener('click', function () {
            var mapContainer = document.getElementById('map-recruitList');
            if (cafeSearchButton.textContent == '내 주변 카페 보기☕') {
                clusterer.clear();
                getLocationAndDisplayOnMap(); // 현재 위치로 지도 중심 이동
                infowindows.forEach(function (iw) {
                    iw.close();
                });
                infowindows=[];
                searchCafesNearMapCenter(mapRecruitList);
                mapRecruitList.setLevel(3); // 지도 확대 레벨 설정
                mapContainer.style.width = '100%';
                mapContainer.style.height = '800px';
                toggleButton.textContent = '🔍창 축소';

                // 지도 크기 변경 후 relayout 호출 (setTimeout을 사용하여 렌더링 후 호출)
                setTimeout(function () {
                    mapRecruitList.relayout();
                    // 딜레이 후 화면 중심을 지도 중심으로 이동
                    setTimeout(function () {
                        window.scrollTo({
                            top: mapContainer.offsetTop - (window.innerHeight - mapContainer.offsetHeight) / 2,
                            left: mapContainer.offsetLeft - (window.innerWidth - mapContainer.offsetWidth) / 2,
                            behavior: 'smooth'
                        });
                         moveToCurrentLocation();
                    }, 500); // 0.5초 후에 실행 (딜레이 시간 조절 가능)
                }, 500); // 0.5초 후에 relayout 호출 (transition 시간과 동일하게 설정)

                cafeSearchButton.textContent = '주변 스터디 보기📗';
            } else if (cafeSearchButton.textContent == '주변 스터디 보기📗') {
                clusterer.clear();
                infowindows.forEach(function (iw) {
                    iw.close();
                });
                infowindows=[];
                getLocationAndDisplayOnMap(); // 현재 위치로 지도 중심 이동
                getStudyListAndDisplayList(); // 스터디 목록 다시 조회 및 표시
                $.ajax({
                    url: '/studies/listOnMap',
                    type: 'GET',
                    dataType: 'json',
                    success: function (studyData) {
                        displayStudyMarkers(mapRecruitList, studyData);
                    },
                    error: function (xhr, status, error) {
                        console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
                    }
                });
                mapRecruitList.setLevel(zoomLevel); // 기본 확대 레벨로 복원

                mapContainer.style.width = '100%';

                mapRecruitList.relayout();
                cafeSearchButton.textContent = '내 주변 카페 보기☕';
            }
        });
    });


    <%session.removeAttribute("error");%> <%-- 오류 메시지 제거 --%>
</script>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${root}/resources/js/slider.js"></script>
</body>
</html>
