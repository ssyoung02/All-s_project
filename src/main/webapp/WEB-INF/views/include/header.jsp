<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="userVoUpdatedProfile" value="${sessionScope.userVoUpdated}"/>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<%--<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>--%>
<%--<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />--%>
<!-- 헤더 영역 -->
<header>
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <script>

        $(document).ready(function () {
            // 서버에서 사용자 정보 가져오기
            $.ajax({
                url: "${root}/Users/userLocation",
                type: "GET",
                headers: {
                    "${_csrf.headerName}": "${_csrf.token}"
                },
                xhrFields: {
                    withCredentials: true
                },
                success: function (userData) {
                    console.log(userData);
                    var lat = userData.latitude;
                    var lon = userData.longitude;
                    console.log("latitude:", lat, "longitude:", lon);
                    fetchWeather(lat, lon);
                },
                error: function () {
                    console.error("사용자 정보를 가져오는 데 실패했습니다.");
                    fetchWeather(); // 기본 위치로 날씨 정보 가져오기 (서울)
                }
            });
        });

        function fetchWeather(lat, lon) {
            var url = "${root}/weather";
            if (lat && lon && lat !== 0 && lon !== 0) { // 위도 경도 값이 0이 아닌 경우에만 사용
                lat = Number(lat.toFixed(6)); // 숫자형으로 변환
                lon = Number(lon.toFixed(6)); // 숫자형으로 변환
                url += "?lat=" + lat + "&lon=" + lon;
            } else {
                url += "?lat=37.5665&lon=126.9780"; // 서울의 위도 경도 (기본값)
            }

            $.ajax({
                headers: {
                    "${_csrf.headerName}": "${_csrf.token}"
                },
                url: url,
                xhrFields: {
                    withCredentials: true
                },
                beforeSend: function (xhr) {
                    console.log("Weather API Request URL:", url); // 요청 URL 출력
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function (response) {
                    var iconUrl = response.icon;
                    //var locationName = response.location;
                    //var weatherInfo = '<img src="' + iconUrl + '" alt="Weather Icon"> '+ locationName + " "+ Math.round(response.temperature) + "°C";
                    //("#weatherInfo").html(weatherInfo);
                    var temperature = Math.round(response.temperature);
                    var googleMapsApiKey = response.googleMapsApiKey;
                    // Reverse Geocoding API 호출
                    // URL 객체 생성
                    var url = new URL("https://maps.googleapis.com/maps/api/geocode/json?");
                    url.searchParams.append("latlng", lat + "," + lon);
                    url.searchParams.append("key", googleMapsApiKey);

                    $.ajax({
                        url: url.toString(),
                        success: function (geocodingResponse) {
                            var locationName = response.name; // OpenWeatherMap API 응답의 name 값을 기본으로 사용

                            if (geocodingResponse.status === "OK" && geocodingResponse.results.length > 1) {
                                var addressComponents = geocodingResponse.results[1].address_components;

                                // "sublocality_level_2" 타입 우선 검색 (동 이름)
                                var localityComponent = addressComponents.find(component => component.types.includes("sublocality_level_2"));

                                if (!localityComponent) {
                                    // "sublocality_level_2" 타입이 없으면 "sublocality_level_1" 타입 검색 (구 이름)
                                    localityComponent = addressComponents.find(component => component.types.includes("sublocality_level_1"));
                                }

                                if (!localityComponent) {
                                    // "sublocality_level_1" 타입도 없으면 "sublocality" 타입 검색 (일반적인 지역 이름)
                                    localityComponent = addressComponents.find(component => component.types.includes("sublocality"));
                                }

                                if (localityComponent) {
                                    locationName = localityComponent.long_name; // 지역 이름으로 업데이트
                                }
                            } else {
                                console.error("Geocoding failed:", geocodingResponse.status);
                            }

                            var weatherInfo = '<img src="' + iconUrl + '" alt="Weather Icon"> ' + locationName + " " + temperature + "°C";
                            $("#weatherInfo").html(weatherInfo);
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.error("Geocoding AJAX Error:", textStatus, errorThrown);

                            // Geocoding API 호출 실패 시에도 OpenWeatherMap API 응답의 name 값 사용
                            var weatherInfo = '<img src="' + iconUrl + '" alt="Weather Icon"> ' + response.name + " " + temperature + "°C";
                            $("#weatherInfo").html(weatherInfo);
                        }
                    });
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    console.error("AJAX Error:", textStatus, errorThrown);
                    $("#weatherInfo").text("날씨 정보를 가져오지 못했습니다.");
                }
            });
        }
    </script>

    <style>
        /* Delete button style */
        .delete-btn {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 1px 1px; /* 패딩 조정 */
            margin-left: 5px; /* 좌측 여백 줄임 */
            cursor: pointer;
            font-size: 12px;
        }

        .delete-btn:hover {
            background-color: #c82333;
        }

        .delete-btn i {
            margin-right: 3px; /* 아이콘과 텍스트 사이 간격 줄임 */
        }

        .new-mark {
            transition: color 0.3s ease;
            color: initial; /* 기본 색상 */
        }

        .new-mark.alert {
            color: red !important; /* 경고 시 색상 */
        }
    </style>

    <!--스킵 내비게이션-->
    <div id="skipnav">
        <a href="#content">본문 바로가기</a>
    </div>
    <div class="logoarea">
        <!-- 로고 이미지 -->
        <a href="${root}/main"><img class="logo" src="${root}/resources/images/logo.png" style="width:100%" alt="all's 로고"/></a>
    </div>

    <div class="r-header">
        <div id="topmenu">
            <%-- 로그인한 사용자에게만 정보 표시 --%>
            <sec:authorize access="isAuthenticated()">
                <%-- 관리자 권한을 가진 사용자에게만 표시 --%>
                <script>
                    $(document).ready(function () {
                        $.ajax({
                            url: "${root}/Users/isAdmin",
                            method: "GET",
                            success: function (isAdmin) {
                                if (isAdmin) {
                                    $('.manager-page').show();
                                }
                            }
                        });
                    });
                </script>
                <%-- 관리자 권한을 가진 사용자에게만 표시 --%>
                <a class="manager-page" href="${root}/admin/websiteInfo" style="display: none;"><i
                        class="bi bi-gear"></i>관리자</a>
            </sec:authorize>
            <!-- 날씨 정보 링크 -->
            <a class="weather" href="#">
                <!--<i class="bi bi-cloud-moon"></i> -->
                <span id="weatherInfo">날씨 정보 불러오는 중...</span>
            </a>
            <%-- 로그인한 사용자에게만 정보 표시 --%>
            <sec:authorize access="isAuthenticated()">
                <!-- 프로필 링크 -->
                <a class="profile" href="#">
                    <div class="profile-img">
                        <c:choose>
                            <c:when test="${not empty userVoUpdatedProfile}">
                                <img src="${userVoUpdatedProfile}?t=${System.currentTimeMillis()}" alt="Profile Image">
                            </c:when>
                            <c:otherwise>
                                <img src="${userVo.profileImage}?t=${System.currentTimeMillis()}"
                                     onerror="this.onerror=null; this.src='${root}/resources/profileImages/${userVo.profileImage}';"
                                     alt="Profile Image">
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <span class="new-mark"  id="newMark"><i class="bi bi-circle-fill"></i></span>
                </a>
                <!-- 알림 영역 -->
                <div class="alarm flex-colum hidden">
                    <div>
                        <div class="profile-img">
                            <c:choose>
                                <c:when test="${not empty userVoUpdatedProfile}">
                                    <img src="${userVoUpdatedProfile}?t=${System.currentTimeMillis()}"
                                         alt="Profile Image">
                                </c:when>
                                <c:otherwise>
                                    <img src="${userVo.profileImage}?t=${System.currentTimeMillis()}"
                                         onerror="this.onerror=null; this.src='${root}/resources/profileImages/${userVo.profileImage}';"
                                         alt="Profile Image">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <p class="profile-username">
                                ${userVo.name}
                            <img id="user-grade-icon" src="" style="width: 15px; height: 15px">
                        </p>
                    </div>
                    <div class="alarmList">
                        <h3>알림 내역</h3>
                        <ul id="alarmList">
                            <!-- 여기에서 알림 항목이 동적으로 추가될 것입니다 -->
                        </ul>
                    </div>
                    <!-- 로그아웃 버튼 -->
                    <form method="POST" action="${root}/Users/logout">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button class="secondary-default" type="submit">로그아웃</button>
                    </form>
                </div>
            </sec:authorize>
        </div>
        <!-- 모바일 사이즈 메뉴 -->
        <div class="m-size-nav">
            <button class="secondary-default menu-open">
                <i class="bi bi-list"></i>
                <span class="hide">메뉴 열기</span>
            </button>
            <!-- 공부 시작 버튼 -->
            <!-- 로그인하지 않은 경우 -->
            <sec:authorize access="isAnonymous()">
                <button class="m-timestart button-disabled timestart" onclick="alert('로그인 후 이용해주세요')">공부 시작</button>
            </sec:authorize>
            <!-- 로그인한 경우 -->
            <sec:authorize access="isAuthenticated()">
                <button class="m-timestart primary-default" onclick="timerOpen()">공부 시작</button>
            </sec:authorize>
        </div>
    </div>
    <meta name="_csrf" content="${_csrf.token}">
    <meta name="_csrf_header" content="${_csrf.headerName}">
</header>
<script>
    $(document).ready(function () {
        const csrfToken = $("meta[name='_csrf']").attr("content");
        const csrfHeader = $("meta[name='_csrf_header']").attr("content");

        // 페이지 로드 시 및 매 3초마다 알림을 가져옴
        getAlarm();
        setInterval(() => {
            getAlarm();
        }, 3000);

        function getAlarm() {
            $.ajax({
                type: "POST",
                url: "/studyGroup/getAlarmInfo",
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function (res) {
                    console.log(res); // 응답 데이터 출력
                    var alarmList = $("#alarmList");
                    alarmList.empty();  // 기존 알림 목록 비우기

                    if (res && res.length > 0) {
                        var msg = "";
                        for (var i = 0; i < res.length; i++) {
                            var link = '';
                            var text = res[i].alarmMessage;
                            if (res[i].notifyType === 'STUDY_INVITE') {
                                link = '/studyGroup/studyGroupManagerMember?studyIdx=' + res[i].studyIdx;
                            } else if (res[i].notifyType === 'NEW_COMMENT') {
                                link = '/studyReferences/referencesRead?referenceIdx=' + res[i].referenceIdx;
                            }
                            msg += '<li>' +
                                '<a class="dropdown-item" id="' + res[i].notificationIdx + '" href="' + link + '">' + text + '</a>' +
                                '<button class="delete-btn" data-notification-idx="' + res[i].notificationIdx + '">삭제</button>' +
                                '</li>';
                        }
                        alarmList.html(msg);

                        changeNewMarkColor(true); // 알림이 있을 때 색 변경

                        // 삭제 버튼 클릭 이벤트 핸들러
                        $(".delete-btn").on("click", function (e) {
                            e.preventDefault();
                            var notificationIdx = $(this).data("notification-idx");
                            deleteNotification(notificationIdx);
                        });

                    } else {
                        alarmList.html("<li style='margin-left:20px;'>알람이 없습니다.</li>");
                        changeNewMarkColor(false); // 알림이 없을 때 기본 색상으로 변경
                    }
                },
                error: function (xhr, status, error) {
                    console.error("알림을 가져오는 동안 오류가 발생했습니다: ", error);
                }
            });
        }

        function deleteNotification(notificationIdx) {
            $.ajax({
                type: "POST",
                url: "/studyGroup/deleteNotification/" + notificationIdx,
                beforeSend: function (xhr) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                },
                success: function (response) {
                    if (response.success) {
                        // 성공적으로 삭제된 경우 알림 다시 가져오기
                        getAlarm();
                    }
                },
                error: function (xhr, status, error) {
                    console.error("알림 삭제 중 오류가 발생했습니다: ", error);
                }
            });
        }

        function changeNewMarkColor(hasAlarm) {
            var newMark = $("#newMark");

            if (hasAlarm) {
                newMark.addClass("alert");
            } else {
                newMark.removeClass("alert");
                newMark.text(""); // 내용을 비움
            }
        }
    });
</script>
    <script>
        document.addEventListener("DOMContentLoaded", function() {
        fetchUserGradeIcon();
    });

        function fetchUserGradeIcon() {
        const userIdx = ${userVo.userIdx}; // 여기서 userVo.userIdx가 정확히 렌더링되고 있는지 확인합니다.
        fetch(`/include/userGrades?user_idx=${userVo.userIdx}`)
        .then(response => {
        if (response.ok) {
        return response.text();
    } else {
        throw new Error('Network response was not ok.');
    }
    })
        .then(gradeIcon => {
        console.log('Received gradeIcon:', gradeIcon); // 응답 데이터를 로그에 출력합니다.
        document.getElementById('user-grade-icon').src = gradeIcon+".png";
    })
        .catch(error => console.error('Error fetching user grade icon:', error));
    }
</script>