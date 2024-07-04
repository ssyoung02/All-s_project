<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디 정보 > 관리 > 스터디그룹 > 내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoMapApiKey}&libraries=clusterer,services"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <script>

        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
        });

        var mapStudyGroupCreate;
        var marker;
        var markers = []; // 마커 배열

        var zoomLevel = 6;
        var isWideView = false;

        // 인포윈도우 객체 배열 (로그인 상태)
        var infowindows = [];

        var clusterer = new kakao.maps.MarkerClusterer({
            map: mapStudyGroupCreate, // 클러스터러를 적용할 지도 객체
            averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
            minLevel: 8 // 클러스터 할 최소 지도 레벨
        });
        var latlng; // latlng 변수를 전역 변수로 선언

        // 마커 이미지 생성
        var imageSrc = 'https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png'; // 마커 이미지 URL
        var imageSize = new kakao.maps.Size(24, 35);
        var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);


        // 지도 생성 및 초기화 (로그인 후)
        function initializeMapStudyGroupCreate() {
            var mapContainer = document.getElementById('map-studyGroupCreate');
            var mapOption = {
                center: new kakao.maps.LatLng(37.49564, 127.0275), // 초기 지도 중심좌표 (비트캠프)
                level: zoomLevel
            };
            mapStudyGroupCreate = new kakao.maps.Map(mapContainer, mapOption);

            // 지도 확대, 축소 컨트롤 생성 및 추가
            var zoomControl = new kakao.maps.ZoomControl();
            mapStudyGroupCreate.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

            // 초기 위치 가져오기 및 지도 중심 설정
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;

                    var locPosition = new kakao.maps.LatLng(lat, lon);
                    mapStudyGroupCreate.setCenter(locPosition); // 지도 중심을 현재 위치로 설정
                }, function(error) {
                    console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
                });
            } else {
                // Geolocation을 사용할 수 없을 때 처리 로직
            }

            // 마커를 생성합니다
            marker = new kakao.maps.Marker({
                position: mapStudyGroupCreate.getCenter()
            });
            marker.setMap(mapStudyGroupCreate);

            // 마커 클러스터러 생성 (지도 초기화 후)
            clusterer = new kakao.maps.MarkerClusterer({
                map: mapStudyGroupCreate,
                averageCenter: true,
                minLevel: 8
            });
            // 주소-좌표 변환 객체를 생성합니다
            var geocoder = new kakao.maps.services.Geocoder();
            // 기존 인포윈도우 변수 선언
            var currentInfowindow = null;


            // 마커 클릭 이벤트 리스너 등록
            kakao.maps.event.addListener(mapStudyGroupCreate, 'click', function(mouseEvent) {
                // 클릭한 위도, 경도 정보를 가져옵니다
                latlng = mouseEvent.latLng;
                // 기존 인포윈도우 닫기
                if (currentInfowindow) {
                    currentInfowindow.close();
                }

                var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
                message += '경도는 ' + latlng.getLng() + ' 입니다';
                console.log(message);

                // 주소-좌표 변환 객체를 이용하여 좌표를 주소로 변환
                geocoder.coord2Address(latlng.getLng(), latlng.getLat(), function(result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var address = result[0].address.address_name;

                        // 기존 마커 제거
                        if (marker) {
                            marker.setMap(null);
                        }

                        // 마커 생성 및 표시
                        marker = new kakao.maps.Marker({
                            position: latlng,
                            map: mapStudyGroupCreate
                        });

                        // 인포윈도우 생성 및 표시
                        currentInfowindow = new kakao.maps.InfoWindow({ // currentInfowindow에 할당
                            content: '<div style="width:fit-content; height:30px; text-align:center; align-content: center; padding:8px 20px;">' + address + '</div>',
                            removable: true
                        });
                        currentInfowindow.open(mapStudyGroupCreate, marker);

                        // Input 요소에 값 설정
                        $('#latitudeInput').val(latlng.getLat());
                        $('#longitudeInput').val(latlng.getLng());
                    } else {
                        console.error('주소 변환 실패:', status);
                    }
                });
            });

        }

        // 사용자 위치 가져오기 및 지도에 표시
        function getLocationAndDisplayOnMapOnce() {
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

        // 사용자 위치 가져오기 그러나 마커기준맵 중앙정렬 X
        function getLocationAndDisplayOnMap() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function (position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;

                    var locPosition = new kakao.maps.LatLng(lat, lon);

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
            var mapContainer = document.getElementById('map-studyGroupCreate');
            var toggleButton = document.getElementById('toggleButton');

            if (isWideView) {
                // 현재 확대 상태이면 축소

                mapContainer.style.width = '100%';
                mapContainer.style.height = '250px';
                toggleButton.textContent = '🔍창 확대';

            } else {
                // 현재 축소 상태이면 확대
                mapContainer.style.width = '100%';
                mapContainer.style.height = '800px';
                toggleButton.textContent = '🔍창 축소';
            }
            // 지도 크기 변경 후 relayout 호출 (setTimeout을 사용하여 렌더링 후 호출)
            setTimeout(function () {
                mapStudyGroupCreate.relayout();
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


        // 현재 위치로 지도 이동 함수
        function moveToCurrentLocation() {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;

                    var locPosition = new kakao.maps.LatLng(lat, lon);
                    marker.setPosition(locPosition);
                    mapStudyGroupCreate.panTo(locPosition); // panTo 메서드 사용
                    // mapStudyGroupCreate.setCenter(locPosition); // 지도 중심을 현재 위치로 설정
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

            initializeMapStudyGroupCreate();
            getLocationAndDisplayOnMapOnce();
            $.ajax({
                url: '/studies/listOnMap',
                type: 'GET',
                dataType: 'json',
                success: function (studyData) {
                    displayStudyMarkers(mapStudyGroupCreate, studyData);
                },
                error: function (xhr, status, error) {
                    console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
                }
            });
            // 1초마다 위치 정보 업데이트
            setInterval(getLocationAndDisplayOnMap, 1000);

            // 토글 버튼 1 생성 및 추가 (지도 확대/축소)
            var toggleButton = document.createElement('button');
            toggleButton.id = 'toggleButton';
            toggleButton.textContent = "🔍창 확대";
            toggleButton.className = 'toggle-button-map';
            toggleButton.type = "button"; // type 속성을 button으로 변경
            document.getElementById('map-studyGroupCreate').appendChild(toggleButton);

            // 토글 버튼 클릭 이벤트 리스너 등록
            toggleButton.addEventListener('click', toggleMapView);


            function searchCafesNearMapCenter(map) {

                var locPosition = latlng;
                mapStudyGroupCreate.setCenter(locPosition);

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
                        content: '<div style="width:170px;text-align:center;padding:10px 0; border-radius: 20px;">' +
                            '<h4>' + cafe.place_name + '</h4>' +
                            '<p>' + cafe.address_name + '</p>' +
                            '<p>' + cafe.phone + '</p>' +
                            '<a href="' + cafe.place_url + '" target="_blank" class="btn btn-primary" style="background-color: #dbe0d2;color: #000000;padding: 5px;border-radius: 5px;font-size: 10px;">상세 정보</a>' +
                            '</div>',
                        removable: true,
                        yAnchor: -45 // 인포윈도우를 마커 아래쪽으로 이동
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
            let cafeMarkerSearchButton = document.getElementById('cafeMarkerSearchButton');
            // 토글 버튼 클릭 이벤트 처리
            cafeMarkerSearchButton.addEventListener('click', function () {
                var mapContainer = document.getElementById('map-studyGroupCreate');
                if (cafeMarkerSearchButton.textContent == '마커 주변 카페 보기☕') {
                    clusterer.clear();
                    infowindows.forEach(function (iw) {
                        iw.close();
                    });
                    infowindows=[];
                    searchCafesNearMapCenter(mapStudyGroupCreate);
                    mapStudyGroupCreate.setLevel(3); // 지도 확대 레벨 설정
                    mapContainer.style.width = '100%';
                    mapContainer.style.height = '800px';
                    toggleButton.textContent = '🔍창 축소';

                    // 지도 크기 변경 후 relayout 호출 (setTimeout을 사용하여 렌더링 후 호출)
                    setTimeout(function () {
                        mapStudyGroupCreate.relayout();
                        // 딜레이 후 화면 중심을 지도 중심으로 이동
                        setTimeout(function () {
                            window.scrollTo({
                                top: mapContainer.offsetTop - (window.innerHeight - mapContainer.offsetHeight) / 2,
                                left: mapContainer.offsetLeft - (window.innerWidth - mapContainer.offsetWidth) / 2,
                                behavior: 'smooth'
                            });
                        }, 500); // 0.5초 후에 실행 (딜레이 시간 조절 가능)
                    }, 500); // 0.5초 후에 relayout 호출 (transition 시간과 동일하게 설정)

                    cafeMarkerSearchButton.textContent = '주변 스터디 보기📗';
                } else if (cafeMarkerSearchButton.textContent == '주변 스터디 보기📗') {
                    clusterer.clear();
                    infowindows.forEach(function (iw) {
                        iw.close();
                    });
                    infowindows=[];
                    $.ajax({
                        url: '/studies/listOnMap',
                        type: 'GET',
                        dataType: 'json',
                        success: function (studyData) {
                            displayStudyMarkers(mapStudyGroupCreate, studyData);
                        },
                        error: function (xhr, status, error) {
                            console.error('스터디 정보를 가져오는 중 오류가 발생했습니다.', error);
                        }
                    });
                    mapStudyGroupCreate.setLevel(zoomLevel); // 기본 확대 레벨로 복원

                    mapContainer.style.width = '100%';

                    mapStudyGroupCreate.relayout();
                    cafeMarkerSearchButton.textContent = '마커 주변 카페 보기☕';
                }
            });
        });


        <%session.removeAttribute("error");%> <%-- 오류 메시지 제거 --%>
    </script>

    <script>
        function modalOpen() {
            document.getElementById('modal-container').classList.remove('unstaged');
        }

        function modalClose() {
            document.getElementById('modal-container').classList.add('unstaged');
        }
        // 이미지 미리보기 함수 추가
        function previewImage(event) {
            var reader = new FileReader();
            reader.onload = function() {
                var output = document.getElementById('profilePreview');
                output.src = reader.result;
            };
            reader.readAsDataURL(event.target.files[0]);
        }
        function updateStudyGroup() {
            var formData = new FormData();
            formData.append('studyIdx', ${studyGroup.studyIdx});
            formData.append('descriptionTitle', document.getElementsByName('descriptionTitle')[0].value);
            formData.append('description', document.getElementsByName('description')[0].value);
            formData.append('category', document.querySelector('input[name="category"]:checked').value);
            formData.append('age', document.querySelector('input[name="age"]:checked').value);
            formData.append('gender', document.querySelector('input[name="gender"]:checked').value);
            formData.append('studyOnline', document.querySelector('input[name="studyOnline"]:checked').value);

            var imageFile = document.getElementById('imageChange').files[0];
            if (imageFile) {
                formData.append('image', imageFile);
            }

            var latitude = document.getElementById('latitudeInput').value;
            var longitude = document.getElementById('longitudeInput').value;
            formData.append('latitude', latitude);
            formData.append('longitude', longitude);

            $.ajax({
                url: '${root}/studyGroup/updateStudyGroup',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader('${_csrf.headerName}', '${_csrf.token}');
                },
                success: function(response) {
                    if (response.success) {
                        alert('스터디가 수정되었습니다.');
                        location.reload();
                    } else {
                        alert('스터디 수정에 실패했습니다: ' + response.message);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    console.error('Error updating study group:', errorThrown);
                    alert('스터디 수정 중 오류가 발생했습니다.');
                }
            });
        }

        // 사용자 위치 가져오기
        $(document).ready(function () {
            if (navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    var lat = position.coords.latitude;
                    var lon = position.coords.longitude;

                    // 폼에 hidden input 추가
                    $('<input>').attr({
                        type: 'hidden',
                        id: 'latitude',
                        name: 'latitude',
                        value: lat
                    }).appendTo('#updateForm');
                    $('<input>').attr({
                        type: 'hidden',
                        id: 'longitude',
                        name: 'longitude',
                        value: lon
                    }).appendTo('#updateForm');
                }, function(error) {
                    console.error('위치 정보를 가져오는 중 오류가 발생했습니다.', error);
                });
            }
        });

    </script>
</head>
<body>
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
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
                <h1>스터디</h1>
                <%--탭 메뉴--%>
                <div class="tapMenu">
                    <div class="tapItem tapSelect">
                        <a href="${root}/studyGroup/studyGroupManagerInfo?studyIdx=${studyGroup.studyIdx}">스터디 정보</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerMember?studyIdx=${studyGroup.studyIdx}">멤버 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerSchedule?studyIdx=${studyGroup.studyIdx}">일정 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerManagement?studyIdx=${studyGroup.studyIdx}">스터디 관리</a>
                    </div>
                </div>
                <%--탭 메뉴 끝--%>
                <%--탭 상세--%>
                <div id="updateForm">
                    <input type="hidden" name="studyIdx" value="${studyGroup.studyIdx}" />
                    <div class="tabInfo">
                        <div class="webInfo-itemfull">
                            <dt>스터디명</dt>
                            <dd><input class="manager-studyName" name="descriptionTitle" value="${studyGroup.descriptionTitle}" title="스터디명" disabled></dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>설 명</dt>
                            <dd>
                                <textarea name="description" placeholder="스터디를 설명할 문장을 입력해주세요" title="설명">${studyGroup.description}</textarea>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>프로필</dt>
                            <dd class="profile-chage">
                                <input type="file" id="imageChange" onchange="previewImage(event)">
                                <label for="imageChange" class="imgbox">
                                    <i class="bi bi-plus-lg"></i>
                                    <img id="profilePreview" src="${studyGroup.image}" alt="스터디 그룹 프로필" width="100px" height="100px">
                                </label>
                                <div class="profile-change">
                                    <p>우리 스터디를 표현할 아이콘을 등록해주세요.</p>
                                    <p>(300px X 300px / 500kb 미만)</p>
                                </div>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>지역</dt>
                            <dd>
                                <div id="map-studyGroupCreate"
                                     style="width:100%; height:250px;border-radius: 5px; margin: 1em 0"> <%-- 로그인 후 지도 컨테이너 --%>
                                    <div class="map-search-container">
                                        <button type="button" id="cafeMarkerSearchButton" class="toggle-button-map">마커 주변 카페 보기☕</button>
                                        <button type="button" id="myLocationButton" class="toggle-button-map">내 위치로 가기📍</button> <%-- 버튼 추가 --%>
                                    </div>
                                </div><br>
                                <input type="hidden" id="latitudeInput" name="latitude" value="">
                                <input type="hidden" id="longitudeInput" name="longitude" value="">
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>모집분야</dt>
                            <dd>
                                <input type="radio" id="interview" name="category" value="면접"
                                       <c:if test="${studyGroup.category eq '면접'}">checked</c:if>>
                                <label for="interview">면접</label>
                                <input type="radio" id="introduction" name="category" value="자소서"
                                       <c:if test="${studyGroup.category eq '자소서'}">checked</c:if>>
                                <label for="introduction">자소서</label>
                                <input type="radio" id="certificate" name="category" value="자격증"
                                       <c:if test="${studyGroup.category eq '자격증'}">checked</c:if>>
                                <label for="certificate">자격증</label>
                                <input type="radio" id="studyGroup" name="category" value="스터디"
                                       <c:if test="${studyGroup.category eq '스터디'}">checked</c:if>>
                                <label for="studyGroup">스터디</label>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>연령대</dt>
                            <dd>
                                <ul class="todolist">
                                    <!-- 할 일 항목 -->
                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '20대')}">
                                            <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대" checked="checked">
                                            <label for="twenty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                20대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '20대')}">
                                            <input type="checkbox" id="twenty" class="todo-checkbox" name="age" value="20대">
                                            <label for="twenty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                20대
                                            </label>
                                        </c:if>
                                    </li>
                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '30대')}">
                                            <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대" checked="checked">
                                            <label for="thirty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                30대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '30대')}">
                                            <input type="checkbox" id="thirty" class="todo-checkbox" name="age" value="30대">
                                            <label for="thirty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                30대
                                            </label>
                                        </c:if>
                                    </li>

                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '40대')}">
                                            <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대" checked="checked">
                                            <label for="forty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                40대
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '40대')}">
                                            <input type="checkbox" id="forty" class="todo-checkbox" name="age" value="40대">
                                            <label for="forty" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                40대
                                            </label>
                                        </c:if>
                                    </li>

                                    <li>
                                        <c:if test="${fn:contains(studyGroup.age, '연령무관')}">
                                            <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관" checked="checked">
                                            <label for="allAge" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                                연령무관
                                            </label>
                                        </c:if>
                                        <c:if test="${!fn:contains(studyGroup.age, '연령무관')}">
                                            <input type="checkbox" id="allAge" class="todo-checkbox" name="age" value="연령무관">
                                            <label for="allAge" class="todo-label">
                                                <span class="checkmark"><i class="bi bi-square"></i></span>
                                                연령무관
                                            </label>
                                        </c:if>
                                    </li>
                                </ul>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>성별</dt>
                            <dd>
                                <input id="male" class="gender" name="gender" type="radio" value="남자"
                                       <c:if test="${studyGroup.gender eq '남자'}">checked</c:if>>
                                <label for="male">남자</label>
                                <input id="female" class="gender" name="gender" type="radio" value="여자"
                                       <c:if test="${studyGroup.gender eq '여자'}">checked</c:if>>
                                <label for="female">여자</label>
                                <input id="allGender" class="gender" name="gender" type="radio" value="성별무관"
                                       <c:if test="${studyGroup.gender eq '성별무관'}">checked</c:if>>
                                <label for="allGender">남여모두</label>
                            </dd>
                        </div>
                        <div class="webInfo-itemfull">
                            <dt>온/오프라인</dt>
                            <dd>
                                <input id="online" name="studyOnline" type="radio" value="true"
                                       <c:if test="${studyGroup.studyOnline}">checked</c:if>>
                                <label for="online">온라인</label>
                                <input id="offline" name="studyOnline" type="radio" value="false"
                                       <c:if test="${!studyGroup.studyOnline}">checked</c:if>>
                                <label for="offline">오프라인</label>
                            </dd>
                        </div>
                    </div>
                    <div class="board-bottom">
                        <button type="button" class="secondary-default" onclick="location.href='${root}/studyGroupMain?studyIdx=${studyGroup.studyIdx}'">취소</button>
                        <button type="button" class="primary-default" onclick="modalOpen()">수정</button>
                    </div>
                </div>
            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
    <jsp:include page="../include/timer.jsp" />
    <%-- 오류 메세지 모달 --%>
    <div id="modal-container" class="modal unstaged" onclick="modalCloseBack()">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>확인 메세지</h4>
                <button class="modal-close-x" aria-label="닫기" onclick="modalClose()"><i class="bi bi-x-lg"></i></button>
            </div>
            <div class="modal-center">
                스터디 관리 정보를 변경하겠습니까?
            </div>
            <div class="modal-bottom">
                <button class="secondary-default" onclick="modalClose()">취소</button>
                <button type="button" class="modal-close" data-dismiss="modal" onclick="updateStudyGroup()">확인</button>
            </div>
        </div>
    </div>
</div>

</body>
</html>
