<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<%--이제 필요없는 코드 --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All's</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}"></script>
        <script>
        $(document).ajaxSend(function(e, xhr, options) {
            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
        });
    </script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">

    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="${root}/resources/css/slider.css">

    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <style>

        /* 토글 버튼 스타일 */
        .toggle-button {
            position: absolute;
            bottom: 10px;
            right: 10px;
            padding: 5px 10px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 5px;
            cursor: pointer;
            z-index: 10;
        }
    </style>
</head>

<body>
<!-- 중앙 컨테이너 -->
<jsp:include page="include/timer.jsp"/>
<jsp:include page="include/header.jsp"/>
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="include/navbar.jsp"/>
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="include/navbar.jsp"/>
            </div>
            <!--각 페이지의 콘텐츠-->
            <div id="content">
                <h1>대시보드</h1>
                <%-- 로그인하지 않은 사용자에게만 표시 --%>
                <sec:authorize access="isAnonymous()">
                    <div class="non-login-section">
                        <div class="service-info bg-green">
                            <div class="service-info-left">
                                <h3>서비스</h3>
                                <h2>혼자 공부하기 힘든 분들을 위한 스터디 서비스!</h2>
                                <p>다양한 학습 관리, 정보 제공, 취업 지원 기능을 통합하여 학습자가 효율적으로 자기계발과 목표 달성에 집중할 수 있도록 돕는 포괄적인 스터디 플랫폼을 제공합니다</p>
                            </div>
                            <div class="service-info-right flex-colum">
                                <button class="secondary-default">공부노트<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">캘린더<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">스터디 그룹<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">공부 자료<i class="bi bi-arrow-right"></i></button>
                                <button class="secondary-default">이력서 작성<i class="bi bi-arrow-right"></i></button>
                            </div>
                        </div>
                        <div class="iogin-info flex-colum bg-green">
                            <h3>지금부터<br> 함께 공부해봐요!</h3>
                            <button class="primary-default" onclick="location.href='${root}/Users/UsersLoginForm'">로그인
                            </button>
                            <button class="secondary-default" onclick="location.href='${root}/Users/Join'">회원가입</button>
                        </div>
                    </div>
                    <h2>주변에서 함께할 동료들을 찾으세요!</h2><br>
                    <sec:authorize access="isAnonymous()">
                        <div id="map-anonymous" style="width:100%; height:250px;"></div> <%-- 로그인 전 지도 컨테이너 --%>
                    </sec:authorize>
                    <script>
                        $(document).ready(function() {

                            initializeMapAnonymous();
                            getLocationAndDisplayOnAnonymousMap();

                            $.ajax({
                                url: '/studies/listOnAnonymousMap',
                                type: 'GET', // GET 방식으로 변경
                                dataType: 'json',
                                success: function (studyData1) {
                                    displayStudyMarkersAnonymous(mapAnonymous, studyData1);
                                },
                                error: function (xhr, status, error) {
                                    console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
                                    alert("스터디 정보를 가져오는데 실패했습니다.");
                                }
                            });
<%--                            <c:if test="${not empty studyList}">--%>
<%--                            displayStudyMarkersAnonymous(mapAnonymous, ${studyList}); // 스터디 마커 표시--%>
<%--                            </c:if>--%>

                            // 10초마다 위치 정보 업데이트
                            setInterval(getLocationAndDisplayOnAnonymousMap, 1000);

                            // 토글 버튼 생성 및 추가
                            var toggleButtonAnonymous = document.createElement('button');
                            toggleButtonAnonymous.id = 'toggleButtonAnonymous';
                            toggleButtonAnonymous.textContent = '지도 확대';
                            toggleButtonAnonymous.className = 'toggle-button';
                            document.getElementById('map-anonymous').appendChild(toggleButtonAnonymous);

                            // 토글 버튼 클릭 이벤트 리스너 등록
                            toggleButtonAnonymous.addEventListener('click', toggleAnonymousMapView);

                        });
                    </script>
                    <br>
                    <br>
                </sec:authorize>
            <%-- 로그인한 사용자에게만 표시 --%>
                <sec:authorize access="isAuthenticated()">
                    <div class="loginMain">
                        <div class="loginUserInfoLeft">
                            <div class="sceduler-area">
                                <div class="sceduler">
                                    달력 영역
                                </div>
                                <div class="todo">
                                    <h3>6월 15일</h3>
                                    <div class="achieve">
                                        <div class="todoTitle">달성도</div>
                                        <div class="gaugeBar">
                                            <progress id="progress" value="60" max="100"></progress>
                                        </div>
                                        <p class="percent">60%</p>
                                    </div>
                                    <div class="todoList">
                                        <div class="todoTitle">할 일</div>
                                        <ul class="todolist">
                                            <li>
                                                <input type="checkbox" id="todolist11" class="todo-checkbox">
                                                <label for="todolist11" class="todo-label">
                                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                                    자바 공부
                                                </label>
                                            </li>
                                            <li>
                                                <input type="checkbox" id="todolist22" class="todo-checkbox">
                                                <label for="todolist22" class="todo-label">
                                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                                    면접 준비
                                                </label>
                                            </li>
                                            <li>
                                                <input type="checkbox" id="todolist33" class="todo-checkbox">
                                                <label for="todolist33" class="todo-label">
                                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                                    UI 설계
                                                </label>
                                            </li>
                                            <li>
                                                <input type="checkbox" id="todolist44" class="todo-checkbox">
                                                <label for="todolist44" class="todo-label">
                                                        <span class="checkmark"><i
                                                                class="bi bi-check-square"></i></span>
                                                    자소서 작성
                                                </label>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="loginUserInfoRight">
                            <div class="studyTime">
                                <h2 class="">오늘의 공부 시간</h2>
                                <div>
                                    <div class="todoTitle">Total</div>
                                    <p id="totalstudytime">127시간</p>
                                </div>
                                <div>
                                    <div class="todoTitle">Today</div>
                                    <p id="todaystudytime">5시간</p>
                                </div>
                            </div>
                            <div class="userStudyGroup">
                                <div class="userStudyGroupTitle flex-between">
                                    <h3>공부하는 42조</h3>
                                    <div class="slide-button-group">
                                        <button class="slide-button" title="이전">
                                            <i class="bi bi-caret-left-fill"></i>
                                            <span class="hide">이전</span>
                                        </button>
                                        <button class="slide-button" title="다음">
                                            <i class="bi bi-caret-right-fill"></i>
                                            <span class="hide">다음</span>
                                        </button>
                                    </div>
                                </div>
                                <div class="userStudyGroupMember">
                                    <div class="memberItem">
                                        <div class="studyMemberProfile">
                                            <a class="profile" href="#">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </a>
                                        </div>
                                        <a href="#" class="memberName">Yejoon</a>
                                    </div>
                                    <div class="memberItem">
                                        <div class="studyMemberProfile">
                                            <a class="profile" href="#">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </a>
                                        </div>
                                        <a href="#" class="memberName">Jeayang</a>
                                    </div>
                                    <div class="memberItem">
                                        <div class="studyMemberProfile">
                                            <a class="profile" href="#">
                                                <div class="profile-img">
                                                    <img src="${root}/resources/images/manggom.png" alt="내 프로필">
                                                </div>
                                                <div class="status"><span class="status">접속중</span></div>
                                            </a>
                                        </div>
                                        <a href="#" class="memberName">Yujung</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </sec:authorize>
                <sec:authorize access="isAuthenticated()">
                    <div id="map-authenticated" style="width:100%; height:250px;"> </div> <%-- 로그인 후 지도 컨테이너 --%>
                </sec:authorize>
                <br>
                <br>
                <!--슬라이드 배너-->
                <div class="swiper-container">
                    <div class="swiper-wrapper">
                        <!--슬라이드 아이템들-->
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </dlv>
                        </div>
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </dlv>
                        </div>
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </dlv>
                        </div>
                        <div class="swiper-slide">
                            <dlv class="banner-item bgwhite" tabindex="0" onclick="">
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
                                <div class="banner-bottom flex-between">
                                    <div>
                                        <span class="banner-tag">면접</span>
                                        <span class="banner-tag">강남</span>
                                    </div>
                                    <button class="banner-like" aria-label="좋아요">
                                        <i class="bi bi-heart"></i>
                                    </button>
                                </div>
                            </dlv>
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

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>

    <%-- 로그인 성공 모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>알림</h4>
                <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
            </div>
            <div id="messageContent" class="modal-center">
                <%-- 메시지 내용이 여기에 표시됩니다. --%>
            </div>
            <div class="modal-bottom">
                <button type="button" class="modal-close" data-dismiss="modal">닫기</button>
            </div>
        </div>
    </div>

    <jsp:include page="include/footer.jsp"/>
</div>
<script>
    $(document).ready(function () {
        if ("${error}" !== "") {
            $("#messageContent").text("${error}");
            $('#modal-container').toggleClass('opaque'); //모달 활성화
            $('#modal-container').toggleClass('unstaged');
            $('#modal-close').focus();
        }

        if ("${msg}" !== "") {
            $("#messageContent").text("${msg}");
            $('#modal-container').toggleClass('opaque'); //모달 활성화
            $('#modal-container').toggleClass('unstaged');
            $('#modal-close').focus();
        }
    });
</script>
<script>
    var mapAnonymous;
    var mapAuthenticated;
    var marker;
    var markerAnonymous;
    var zoomLevel = 6;
    var isWideView = false;
    // 인포윈도우 객체 배열 (로그인 안 한 상태)
    var infowindowAnonymouses = [];

    // 인포윈도우 객체 배열 (로그인 상태)
    var infowindows = [];

    // 마커 이미지 생성
    var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 마커 이미지 URL
    var imageSize = new kakao.maps.Size(24, 35);
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);



    // 지도 생성 및 초기화 (로그인 전)
    function initializeMapAnonymous() {
        var mapContainer = document.getElementById('map-anonymous');
        var mapOption = {
            center: new kakao.maps.LatLng(37.49564, 127.0275), // 초기 지도 중심좌표 (비트캠프)
            level: 6 // 지도의 확대 레벨
        };
        mapAnonymous = new kakao.maps.Map(mapContainer, mapOption);

        // 지도 확대, 축소 컨트롤 생성 및 추가
        var zoomControlAnonymous = new kakao.maps.ZoomControl();
        mapAnonymous.addControl(zoomControlAnonymous, kakao.maps.ControlPosition.RIGHT);

        // 마커를 생성합니다
        markerAnonymous = new kakao.maps.Marker({
            position: mapAnonymous.getCenter()
        });
        markerAnonymous.setMap(mapAnonymous);
    }

    // 지도 생성 및 초기화 (로그인 후)
    function initializeMapAuthenticated() {
        var mapContainer = document.getElementById('map-authenticated');
        var mapOption = {
            center: new kakao.maps.LatLng(37.49564, 127.0275), // 초기 지도 중심좌표 (비트캠프)
            level: zoomLevel
        };
        mapAuthenticated = new kakao.maps.Map(mapContainer, mapOption);

        // 지도 확대, 축소 컨트롤 생성 및 추가
        var zoomControl = new kakao.maps.ZoomControl();
        mapAuthenticated.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        // 마커를 생성합니다
        marker = new kakao.maps.Marker({
            position: mapAuthenticated.getCenter()
        });
        marker.setMap(mapAuthenticated);

    }


    // 지도 확대/축소 토글 함수
    function toggleMapView() {
        var mapContainer = document.getElementById('map-authenticated');
        var toggleButton = document.getElementById('toggleButton');

        if (isWideView) {
            // 현재 확대 상태이면 축소
            getLocationAndDisplayOnMap();
            mapContainer.style.width = '100%';
            mapContainer.style.height = '250px';
            toggleButton.textContent = '창 확대';
        } else {
            // 현재 축소 상태이면 확대
            getLocationAndDisplayOnMap();
            mapContainer.style.width = '100%';
            mapContainer.style.height = '800px';
            toggleButton.textContent = '창 축소';
        }


        mapAuthenticated.relayout(); // 지도 크기 변경 후 relayout 호출

        isWideView = !isWideView; // 확대 상태 반전
    }

    function toggleAnonymousMapView() {
        var mapContainer = document.getElementById('map-anonymous');
        var toggleButton = document.getElementById('toggleButtonAnonymous');

        if (isWideView) {
            // 현재 확대 상태이면 축소
            getLocationAndDisplayOnAnonymousMap();
            mapContainer.style.width = '100%';
            mapContainer.style.height = '250px';
            toggleButton.textContent = '창 확대';
        } else {
            // 현재 축소 상태이면 확대
            getLocationAndDisplayOnAnonymousMap();
            mapContainer.style.width = '100%';
            mapContainer.style.height = '800px';
            toggleButton.textContent = '창 축소';
        }

        mapAnonymous.relayout();

        isWideView = !isWideView; // 확대 상태 반전
    }


    // 사용자 위치 가져오기 및 지도에 표시
    function getLocationAndDisplayOnMap() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;

                var locPosition = new kakao.maps.LatLng(lat, lon);
                marker.setPosition(locPosition);

                mapAuthenticated.setCenter(locPosition);
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

    // 사용자 위치 가져오기 및 지도에 표시
    function getLocationAndDisplayOnAnonymousMap() {
        if (navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var lat = position.coords.latitude;
                var lon = position.coords.longitude;

                var locPosition = new kakao.maps.LatLng(lat, lon);
                markerAnonymous.setPosition(locPosition);

                mapAnonymous.setCenter(locPosition);

            }, function(error) {
                console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
            });
        } else {
            // Geolocation을 사용할 수 없을 때 처리 로직
        }
    }

    // 위치 정보 서버 전송 함수
    function sendLocationToServer(latitude, longitude) {
        $.ajax({
            url: '/Users/updateLocation',  // 위치 정보 업데이트 요청을 처리할 컨트롤러 URL
            type: 'POST',
            data: { latitude: latitude, longitude: longitude },
        success: function(response) {
            console.log('위치 정보 업데이트 성공:', response);
        },
        error: function(xhr, status, error) {
            console.error('위치 정보 업데이트 실패:', error);
        }
    })
    }


    // 스터디 마커 표시 함수
    function displayStudyMarkers(map, studyData) {
        for (var i = 0; i < studyData.length; i++) {
            var study = studyData[i];
            var position = new kakao.maps.LatLng(study.latitude, study.longitude);
            var Removeable = true;

            // 마커 생성
            var marker = new kakao.maps.Marker({
                map: mapAuthenticated,
                position: position,
                title: study.study_title,
                image: markerImage // 마커 이미지 설정
            });

            // // 인포윈도우 생성 및 내용 설정
            // var infowindow = new kakao.maps.InfoWindow({
            //     position:position,
            //     content: '<div style="width:150px;text-align:center;padding:6px 0;">' +
            //         '<h3>' + study.study_title + '</h3>' +
            //         '<p>' + study.category + '</p>' +
            //         '<p>' +"♥ : " +study.likes_count + '</p>' +
            //         '<p>' + study.currentParticipants + '/' + study.capacity + '</p>' +
            //         '</div>',
            //     removable: Removeable
            // });

            // // 마커에 클릭 이벤트 리스너 등록
            // kakao.maps.event.addListener(marker, 'click', function() {
            //     // 인포윈도우 생성 및 내용 설정
            //     var infowindow = new kakao.maps.InfoWindow({
            //         position:position,
            //         content: '<div style="width:150px;text-align:center;padding:6px 0;">' +
            //             '<h3>' + study.study_title + '</h3>' +
            //             '<p>' + study.category + '</p>' +
            //             '<p>' +"♥ : " +study.likes_count + '</p>' +
            //             '<p>' + study.currentParticipants + '/' + study.capacity + '</p>' +
            //             '</div>',
            //         removable: Removeable
            //     });
            //     infowindow.open(mapAuthenticated, marker);
            // });
            //
            // kakao.maps.event.addListener(mapAuthenticated, 'zoom_changed', function() {
            //     // 열려있는 인포윈도우가 있다면 yAnchor 값을 다시 계산하여 위치 조정
            //     if (infowindow.getMap()) {
            //         var level = mapAuthenticated.getLevel();
            //         var yAnchor = -45 - (level * 5);
            //         infowindow.setOptions({ yAnchor: yAnchor });
            //     }
            // });




            // // 마커에 마우스아웃 이벤트 리스너 등록
            // kakao.maps.event.addListener(marker, '', function() {
            //     infowindow.close();
            // });

            // 인포윈도우 생성 및 배열에 저장
            var infowindow = new kakao.maps.InfoWindow({
                content: '<div style="width:150px;text-align:center;padding:6px 0;">' +
                    '<h3>' + study.studyTitle + '</h3>' +
                    '<p>' + study.category + '</p>' +
                    '<p>' + "♥ : " + study.likes_count + '</p>' +
                    '<p>' + study.currentParticipants + '/' + study.capacity + '</p>' +
                    '</div>',
                removable: Removeable,
                yAnchor: -45 // 인포윈도우를 마커 위쪽으로 이동
            });
            infowindows.push(infowindow);

            // 마커 클릭 이벤트 리스너 등록 (클로저 활용)
            (function(marker, infowindow) {
                kakao.maps.event.addListener(marker, 'click', function() {
                    // 다른 인포윈도우 닫기
                    infowindows.forEach(function(iw) {
                        iw.close();
                    });
                    infowindow.open(mapAuthenticated, marker);
                });
            })(marker, infowindow);

        }
    }

    // 스터디 마커 표시 함수
    function displayStudyMarkersAnonymous(map1, studyData1) {
        for (var j = 0; j < studyData1.length; j++) {
            var studys = studyData1[j];
            var position = new kakao.maps.LatLng(studys.latitude, studys.longitude);
            var Removeable = true;

            var markerAnonymous = new kakao.maps.Marker({
                map: mapAnonymous,
                position: position,
                title: studys.study_title,
                image: markerImage // 마커 이미지 설정
            });

            // 인포윈도우 생성 및 내용 설정
            var infowindow = new kakao.maps.InfoWindow({
                position: position,
                content: '<div style="width:150px;text-align:center;padding:6px 0;">' +
                    '<h3>' + studys.study_title + '</h3>' +
                    '<p>' + studys.category + '</p>' +
                    '<p>' +"♥ : " +studys.likes_count + '</p>' +
                    '<p>' + studys.currentParticipants + '/' + studys.capacity + '</p>' +
                    '</div>',
                removable: Removeable,
                yAnchor: -45
            });
            infowindowAnonymouses.push(infowindow);

            // // 마커에 클릭 이벤트 리스너 등록
            // kakao.maps.event.addListener(markerAnonymous, 'click', function() {
            //     // 지도 레벨에 따라 yAnchor 값을 동적으로 조절
            //     infowindowAnonymous.open(mapAnonymous, markerAnonymous);
            // });
            //
            // kakao.maps.event.addListener(mapAnonymous, 'zoom_changed', function() {
            //     // 열려있는 인포윈도우가 있다면 yAnchor 값을 다시 계산하여 위치 조정
            //     if (infowindowAnonymous.getMap()) {
            //         var level = mapAnonymous.getLevel();
            //         var yAnchor = -45 - (level * 5);
            //         infowindowAnonymous.setOptions({ yAnchor: yAnchor });
            //     }
            // });

            // // 마커에 마우스아웃 이벤트 리스너 등록
            // kakao.maps.event.addListener(markerAnonymous, 'mouseout', function() {
            //     infowindowAnonymous.close();
            // });

            // 마커 클릭 이벤트 리스너 등록 (클로저 활용)
            (function(marker, infowindow) {
                kakao.maps.event.addListener(marker, 'click', function() {
                    // 다른 인포윈도우 닫기
                    infowindowAnonymouses.forEach(function(iw) {
                        iw.close();
                    });
                    infowindow.open(mapAnonymous, marker);
                });
            })(markerAnonymous, infowindow);
        }
    }



    // 페이지 로드 시 지도 초기화 및 위치 정보 가져오기
    $(document).ready(function () {

        <sec:authorize access="isAuthenticated()">
        initializeMapAuthenticated();
        getLocationAndDisplayOnMap();

        $.ajax({
            url: '/studies/listOnMap',
            type: 'GET',
            dataType: 'json',
            success: function (studyData) {
                displayStudyMarkers(mapAuthenticated, studyData);
            },
            error: function (xhr, status, error) {
                console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
            }
        });

        // 1초마다 위치 정보 업데이트
        setInterval(getLocationAndDisplayOnMap, 1000);

        // 토글 버튼 생성 및 추가
        var toggleButton = document.createElement('button');
        toggleButton.id = 'toggleButton';
        toggleButton.textContent = '지도 확대';
        toggleButton.className = 'toggle-button';
        document.getElementById('map-authenticated').appendChild(toggleButton);

        // 토글 버튼 클릭 이벤트 리스너 등록
        toggleButton.addEventListener('click', toggleMapView);
        </sec:authorize>
    });

</script>


<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${root}/resources/js/slider.js"></script>
</body>
</html>