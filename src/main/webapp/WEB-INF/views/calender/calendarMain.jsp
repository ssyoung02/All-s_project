<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
      <style>
        html, body {
              margin: 0;
              padding: 0;
              font-family: Arial, Helvetica Neue, Helvetica, sans-serif;
              font-size: 14px;
            }

        #calendar {
              max-width: 1100px;
              margin: 40px auto;
            }
        /* 모달 스타일 */
        .modal {
              display: none; /* 기본적으로 숨김 */
              position: fixed;
              z-index: 1;
              overflow: auto;
              background-color: rgba(0, 0, 0, 0.4);
            }

        .modal-contents {
              background-color: #fefefe;
              margin: 15% auto;
              padding: 20px;
              border: 1px solid #888;
            }

        .color-button {
              width: 30px;
              height: 30px;
              border-radius: 50%;
              border: none;
              margin: 5px;
              cursor: pointer;
            }
        .color-button.selected { /* 선택된 버튼 스타일 */
              border: 2px solid gray; /* 테두리 추가 */
            }
      </style>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>캘린더 > All's</title>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
      <link rel="stylesheet" href="${root}/resources/css/common.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
      <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
      <script src="${root}/resources/js/index.js"></script> <%-- index.js 먼저 로드 --%>
      <script src="${root}/resources/js/common.js" charset="UTF-8" defer></script>sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
      <title>Calendar</title>
      <script src="${root}/resources/js/fullcalendar/core/index.global.js"></script>
      <script src="${root}/resources/js/fullcalendar/daygrid/index.global.js"></script>
      <script>
    document.addEventListener('DOMContentLoaded', function () {
        var calendarEl = document.getElementById('calendar');

        var calendar = new FullCalendar.Calendar(calendarEl, {
            customButtons: {
                addButton: {
                    text: '일정 추가',
                    click: function () {
                        // 모달 열기
                        $('#scheduleModal').removeClass('unstaged').addClass('opaque');
                    }
                }
            },
            headerToolbar: {
                left: 'prev,next today',
                center: 'title',
                right: 'addButton'
            },
            timeZone: 'UTC',
            initialView: 'dayGridMonth',
            editable: true,
            selectable: true,
            events: function (fetchInfo, successCallback, failureCallback) {
                $.ajax({
                    url: "${root}/calendar/events",
                    type: "GET",
                    headers: {
                        "${_csrf.headerName}": "${_csrf.token}" // CSRF 토큰 헤더 추가
                    },
                    success: function (response) {
                        // 서버에서 받아온 응답 데이터를 FullCalendar 이벤트 형식에 맞게 변환
                        const events = response.map(event => ({
                            id: event.scheduleIdx,     // 이벤트 ID 설정
                            title: event.title,
                            start: event.start,
                            end: event.end,
                            allDay: event.allDay === 1, // 1이면 true, 0이면 false로 변환
                            color: event.backgroundColor
                        }));
                        successCallback(events); // 변환된 이벤트 데이터 설정
                    },
                    error: function(jqXHR, textStatus, errorThrown) {
                        console.error('Error fetching events:', errorThrown); // 에러 메시지 출력
                        failureCallback(errorThrown);
                        alert('이벤트를 불러오는 중 오류가 발생했습니다.');
                    }
                });
            },

            locale: 'ko',
            eventClick: function(info) {
                alert('Event: ' + info.event.title);
            }
        });

        calendar.render();


        // 캘린더 일정 색상 옵션 (10가지 색상)
        const colors = ["#f06292", "#ba68c8", "#9575cd", "#7986cb", "#64b5f6", "#4fc3f7", "#4dd0e1", "#4db6ac", "#81c784", "#aed581"];

        // 색상 선택 버튼 생성
        const colorPicker = document.querySelector('.color-picker');
        colors.forEach(color => {
            const button = document.createElement('button');
            button.type = 'button';
            button.classList.add('color-button');
            button.style.backgroundColor = color;
            button.addEventListener('click', () => {
                // 기존 선택된 버튼의 스타일 초기화
                const selectedButton = colorPicker.querySelector('.selected');
                if (selectedButton) {
                    selectedButton.classList.remove('selected');
                }

                document.getElementById('backgroundColorInput').value = color;
                button.classList.add('selected'); // 선택된 버튼에 selected 클래스 추가
            });
            colorPicker.appendChild(button);
        });

        // 모달 닫기 버튼 클릭 이벤트 핸들러
        document.getElementById('modal-close').addEventListener('click', function () {
            // 모달 닫기
            $('#scheduleModal').removeClass('opaque').addClass('unstaged');
        });

        // 폼 제출 이벤트 처리
        $("#addScheduleForm").submit(function (event) {
            event.preventDefault(); // 기본 폼 제출 방지

            // 입력 값 가져오기 (calIdx 추가)
            const title = $("#title").val();
            const description = $("#description").val();
            const location = $("#location").val();
            const startDate = $("#startDate").val();
            const startTime = $("#startTime").val();
            const endDate = $("#endDate").val();
            const endTime = $("#endTime").val();
            const reminder = $("#reminder").val();
            const allDay = $('input[name="allDay"]:checked').val();
            const backgroundColor = $("#backgroundColorInput").val();
            const calIdx = "${userIdx}"; // JSP 변수를 통해 user_idx 값 가져오기
            const userIdx = "${userIdx}";

            // 날짜 및 시간 문자열 조합 (ISO 8601 형식)
            const start = startDate + 'T' + startTime;
            const end = (endDate && endTime) ? endDate + 'T' + endTime : null;

            // 유효성 검사 (필요에 따라 추가)
            if (!title) {
                alert("일정 제목을 입력해주세요.");
                return;
            }
            if (!startDate || !startTime) {
                alert("시작 날짜와 시간을 입력해주세요.");
                return;
            }
            if (endDate && !endTime) {
                alert("종료 시간을 입력해주세요.");
                return;
            }
            if (!backgroundColor) {
                alert("배경색을 선택해주세요.");
                return;
            }

            // AJAX 요청으로 서버에 데이터 전송
            $.ajax({
                url: "${root}/calendar/addSchedule",
                type: "POST",
                headers: {
                    "${_csrf.headerName}": "${_csrf.token}" // CSRF 토큰 헤더 추가
                },
                data: {
                    title: title,
                    description: description,
                    location: location,
                    start: start,
                    end: end,
                    reminder: reminder,
                    allDay: allDay,
                    backgroundColor: backgroundColor,
                    calIdx: calIdx, // calIdx 추가
                    userIdx: userIdx // userIdx 추가
                },
                success: function (response) {
                    // 성공적으로 일정 추가 후 처리 (모달 닫기, 캘린더 새로고침 등)
                    alert("일정이 성공적으로 추가되었습니다.");
                    $('#scheduleModal').removeClass('opaque').addClass('unstaged');
                    calendar.refetchEvents(); // 캘린더 새로고침
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    // 오류 처리 (예: alert("일정 추가 중 오류가 발생했습니다."))
                    console.error(errorThrown);
                    alert("일정 추가 중 오류가 발생했습니다.");
                }
            });
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
            <div id='calendar' style="position: relative;">

            </div>
          </div>

          <%--콘텐츠 끝--%>

          <%-- 일정 추가 모달--%>
          <div id="scheduleModal" class="modal unstaged">
            <div class="modal-overlay"></div>
            <div class="modal-contents">
              <div class="modal-text flex-between">
                <h3>일정 추가</h3>
                <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
              </div>
              <form id="addScheduleForm">
                <div class="inputbox">
                  <label for="title">일정 제목<span class="essential">*</span></label>
                  <input type="text" id="title" name="title" required maxlength="20">
                </div>
                <div class="inputbox">
                  <label for="description">일정 내용</label>
                  <textarea id="description" name="description" maxlength="255"></textarea>
                </div>
                <div class="inputbox">
                  <label for="location">장소</label>
                  <input type="text" id="location" name="location">
                </div>
                <div class="inputbox flex-between">
                  <div class="date-time">
                    <label for="startDate">시작 날짜<span class="essential">*</span></label>
                    <input type="date" id="startDate" name="startDate" required>
                    <input type="time" id="startTime" name="startTime" required>
                  </div>
                  <div class="date-time">
                    <label for="endDate">종료 날짜</label>
                    <input type="date" id="endDate" name="endDate">
                    <input type="time" id="endTime" name="endTime">
                  </div>
                </div>
                <div class="inputbox">
                  <label for="reminder">알림</label>
                  <input type="datetime-local" id="reminder" name="reminder">
                </div>
                <div class="inputbox">
                  <label>종일 여부<span class="essential">*</span></label>
                  <div class="radio-group">
                    <input type="radio" id="allDayYes" name="allDay" value="1">
                    <label for="allDayYes">예</label>
                    <input type="radio" id="allDayNo" name="allDay" value="0" checked>
                    <label for="allDayNo">아니오</label>
                  </div>
                </div>
                <div class="inputbox">
                  <label>배경색<span class="essential">*</span></label>
                  <div class="color-picker">
                  </div>
                  <input type="hidden" id="backgroundColorInput" name="backgroundColor" value="#A2B18A">
                </div>
                <button class="primary-default" type="submit">추가</button>
              </form>
            </div>
          </div>
        </main>
      </section>
      <!--푸터-->
      <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>