<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath}"/>
<c:set var="userVo" value="${sessionScope.userVo}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>캘린더 > All's</title>
    <!-- 필요한 CSS 및 JavaScript 라이브러리 및 파일들 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="${root}/resources/js/common.js" charset="UTF-8" defer></script>

    <script src="${root}/resources/js/fullcalendar/core/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/daygrid/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/timegrid/index.global.js"></script>
    <script src="${root}/resources/js/fullcalendar/list/index.global.js"></script>

    <script>
        // 전역 변수
        let currentModalId = null;
        let calendar; // 전역 변수로 선언

        // 캘린더 일정 색상 옵션
        const colors = ["#f06292", "#ba68c8", "#9575cd", "#7986cb", "#64b5f6", "#4fc3f7", "#4dd0e1", "#4db6ac", "#81c784", "#aed581", "#ffb74d", "#ff8a65",
            "#e91e63", "#9c27b0" ];

        document.addEventListener('DOMContentLoaded', function () {
            var calendarEl = document.getElementById('calendar');

            // FullCalendar 설정
            calendar = new FullCalendar.Calendar(calendarEl, {
                customButtons: {
                    addButton: {
                        text: '일정 추가',
                        click: function () {
                            openModal('scheduleModal', '일정 추가', '추가', 'addScheduleForm');
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
                eventOverlap: false, // 이벤트 겹침 방지
                events: function (fetchInfo, successCallback, failureCallback) {
                    $.ajax({
                        url: "${root}/calendar/events",
                        type: "GET",
                        headers: {
                            "${_csrf.headerName}": "${_csrf.token}"
                        },
                        success: function (response) {
                            const events = response.map(event => ({
                                id: event.scheduleIdx,
                                title: event.title,
                                start: event.start,
                                end: event.end,
                                allDay: event.allDay === 1,
                                color: event.backgroundColor,
                                extendedProps: { // 추가 데이터 전달
                                    description: event.description,
                                    location: event.location,
                                    reminder: event.reminder,
                                    calIdx: event.calIdx,
                                    userIdx: event.userIdx
                                }
                            }));
                            successCallback(events);
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
                    // 일정 클릭 시 모달 열기 및 데이터 설정
                    openModal('viewScheduleModal', '일정 상세 및 수정', '수정', 'editScheduleForm', info.event);
                    $('#deleteButton').data('event-id', info.event.id); // 삭제 버튼에 event id 설정
                }
            });

            calendar.render();

            // "일정 추가" 버튼 클릭 이벤트 핸들러 (document에 위임)
            $(document).on('click', '#addButton', function () {
                openModal('scheduleModal', '일정 추가', '추가', 'addScheduleForm');
            });

            // 모달 닫기 버튼 및 오버레이 클릭 이벤트 핸들러
            $(document).on('click', '#modal-close, #view-modal-close, .modal-overlay', function () {
                const $modal = $(this).closest('.modal');
                $modal.removeClass('opaque').addClass('unstaged');

                // 현재 닫힌 모달이 일정 추가/수정 모달인 경우에만 캘린더 갱신
                if (currentModalId === 'scheduleModal' || currentModalId === 'viewScheduleModal') {
                    calendar.refetchEvents();
                    $('#' + currentModalId + ' form')[0].reset();
                }
            });
            // 월/주/일 전환 버튼 클릭 이벤트 핸들러
            $('#btnMonth, #btnWeek, #btnList').click(function() {
                const viewName = this.id === 'btnMonth' ? 'dayGridMonth' : (this.id === 'btnWeek' ? 'timeGridWeek' : 'listDay');
                calendar.changeView(viewName);

                // 버튼 스타일 업데이트
                $('#calendar-header .fc-button').removeClass('fc-button-active');
                $(this).addClass('fc-button-active');

                // 월/주/일 버튼 배경색 및 글자색 설정
                $('#btnMonth, #btnWeek, #btnList').css('background-color', 'white').css('color', '#3B593F');
                $(this).css('background-color', '#3B593F').css('color', 'white');
            });

            // 일정 삭제 버튼 클릭 이벤트 처리
            $(document).on('click', '#deleteButton', function () {
                const eventId = $(this).data('event-id');
                if (confirm("정말로 이 일정을 삭제하시겠습니까?")) {
                    $.ajax({
                        url: "${root}/calendar/deleteSchedule/" + eventId,
                        type: "POST",
                        headers: {
                            "${_csrf.headerName}": "${_csrf.token}"
                        },
                        data: {
                            _method: 'DELETE'
                        },
                        success: function (response) {
                            if (response && response.result === 'success') {
                                alert("일정이 삭제되었습니다.");
                                $('#viewScheduleModal').removeClass('opaque').addClass('unstaged'); // 모달 닫기
                                calendar.refetchEvents(); // 캘린더 갱신
                            } else {
                                alert("일정 삭제에 실패했습니다. 다시 시도해주세요.");
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.error('Error deleting schedule:', errorThrown);
                            alert('일정 삭제 중 오류가 발생했습니다.');
                        }
                    });
                }
            });

            // 모달 열기 함수
            function openModal(modalId, titleText, submitButtonText, formId, eventData = null) {
                currentModalId = modalId; // 현재 열린 모달 ID 저장

                // 모달 제목 설정
                $('#' + modalId + ' h3').text(titleText);
                // 제출 버튼 텍스트 설정
                $('#' + modalId + ' button[type="submit"]').text(submitButtonText);

                // 폼 초기화 (추가 모달인 경우에만)
                const form = document.getElementById(formId);

                if (form && formId === 'addScheduleForm') {
                    form.reset();
                } else if (formId === 'editScheduleForm') {
                    const scheduleIdx = eventData.id;
                    //수정할 데이터 불러오기
                    $.ajax({
                        url: "${root}/calendar/event/" + scheduleIdx,
                        type: "GET",
                        headers: {
                            "${_csrf.headerName}": "${_csrf.token}" // CSRF 토큰 헤더 추가
                        },
                        success: function (response) {
                            if (response) {
                                $('#' + formId + ' #editScheduleId').val(response.scheduleIdx); // 수정 모달의 hidden input에 scheduleIdx 설정
                                $('#editTitle').val(response.title); // 수정 모달의 제목 input에 title 설정
                                $('#editDescription').val(response.description); // 수정 모달의 내용 textarea에 description 설정
                                $('#editStartDate').val(response.start.split('T')[0]); // 수정 모달의 시작 날짜 input에 start 설정
                                $('#editStartTime').val(response.start.split('T')[1] || ''); // 수정 모달의 시작 시간 input에 start 설정
                                $('#editEndDate').val(response.end ? response.end.split('T')[0] : ''); // 수정 모달의 종료 날짜 input에 end 설정 (null 체크)
                                $('#editEndTime').val(response.end ? response.end.split('T')[1] || '' : ''); // 수정 모달의 종료 시간 input에 end 설정 (null 체크)
                                $('#editReminder').val(response.reminder || ''); // 수정 모달의 알림 input에 reminder 설정 (null 체크)
                                $('#editLocation').val(response.location || ''); // 수정 모달의 장소 input에 location 설정 (null 체크)
                                $('#editBackgroundColorInput').val(response.backgroundColor); // 수정 모달의 배경색 input에 backgroundColor 설정 (null 체크)
                                // allDay 값 확인 후 라디오 버튼 설정
                                const allDayValue = response.allDay ? '1' : '0';
                                $('#editScheduleForm').find('input[name="allDay"][value="' + allDayValue + '"]').prop('checked', true);
                            } else {
                                alert("일정 데이터를 불러오는 중 오류가 발생했습니다.");
                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
                            console.error(errorThrown);
                            alert("일정 데이터를 불러오는 중 오류가 발생했습니다.");
                        }
                    });
                }
                // 색상 선택 버튼 생성 (추가 및 수정 모달 모두에서 동작하도록 수정)
                const colorPicker = $('#' + modalId + ' .color-picker');
                colorPicker.empty(); // 기존 버튼 제거

            colors.forEach(color => {
                const button = $('<button>').attr('type', 'button')
                    .addClass('color-button')
                    .css('background-color', color);

                if (eventData && eventData.backgroundColor === color) {
                    button.addClass('selected');
                }

                button.click(() => {
                    colorPicker.find('.selected').removeClass('selected');
                    button.addClass('selected');
                    $('#' + (modalId === 'scheduleModal' ? 'backgroundColorInput' : 'editBackgroundColorInput')).val(color); // ID 값 수정
                });

                colorPicker.append(button);
            });

                // 모달 열기
                $('#' + modalId)
                    .removeClass('unstaged')
                    .addClass('opaque')
                    .css('display', 'block');
            }

            // 모달 닫기 버튼 클릭 이벤트 핸들러 수정
            $('#modal-close').click(function () {
                $('#scheduleModal')
                    .removeClass('opaque')
                    .addClass('unstaged')
                    .css('display', 'none'); // display 속성을 none으로 변경
            });

            $('#view-modal-close').click(function () {
                $('#viewScheduleModal')
                    .removeClass('opaque')
                    .addClass('unstaged')
                    .css('display', 'none'); // display 속성을 none으로 변경
            });
        });
        // 폼 제출 이벤트 처리 (추가 및 수정)
        $(document).on('submit', '#addScheduleForm, #editScheduleForm', function (event) {
            event.preventDefault();

            const formId = $(this).attr('id');
            const isEdit = formId === 'editScheduleForm';
            const url = isEdit ? "${root}/calendar/updateSchedule" : "${root}/calendar/addSchedule";

            // 시작 및 종료 날짜/시간 가져오기
            const startDate = $("#" + (isEdit ? "editStartDate" : "startDate")).val();
            const startTime = $("#" + (isEdit ? "editStartTime" : "startTime")).val();
            const endDate = $("#" + (isEdit ? "editEndDate" : "endDate")).val();
            const endTime = $("#" + (isEdit ? "editEndTime" : "endTime")).val();

            // 종일 여부
            const allDay = $(this).find('input[name="allDay"]:checked').val() === '1';

            let start = startDate + 'T00:00:00'; // 기본적으로 시작 시간은 00:00:00으로 설정
            let end = endDate ? endDate + 'T00:00:00' : null; // 종료 날짜가 있으면 기본적으로 00:00:00으로 설정

            if (!allDay) { // 종일이 아닌 경우에만 시간 설정
                start = startTime ? startDate + 'T' + startTime : start;
                end = endDate && endTime ? endDate + 'T' + endTime : end;
            }

            // 유효성 검사: 시작 날짜가 종료 날짜보다 이전인지 확인
            if (end && start > end) {
                alert("시작 날짜는 종료 날짜보다 이전일 수 없습니다.");
                return;
            }

            // 입력 값 가져오기
            let formData = $(this).serialize();
            formData += "&start=" + start + (end ? "&end=" + end : ""); // start, end 값 추가

                $.ajax({
                    url: url,
                    type: "POST",
                    contentType: 'application/x-www-form-urlencoded; charset=UTF-8',
                    headers: {
                        "${_csrf.headerName}": "${_csrf.token}"
                    },
                    data: formData,
                    success: function (response) {
                        if (response && response.result === 'success') {
                            alert(isEdit ? "일정이 수정되었습니다." : "일정이 추가되었습니다.");
                            $('#' + (isEdit ? 'viewScheduleModal' : 'scheduleModal')).removeClass('opaque').addClass('unstaged');
                            calendar.refetchEvents();
                            if (response.refetch) { // refetch 값 확인 후 캘린더 갱신
                                calendar.refetchEvents();
                            }
                        } else {
                            alert((isEdit ? "일정 수정" : "일정 추가") + "에 실패했습니다: " + response.error);
                        }
                    },
                    error: function (jqXHR, textStatus, errorThrown) {
                        console.error(errorThrown);
                        alert((isEdit ? "일정 수정" : "일정 추가") + " 중 오류가 발생했습니다.");
                    }
                });
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
            <div id="calendar-container">
                <div id="calendar-header">
                    <button id="btnMonth" class="fc-button fc-button-primary">월</button>
                    <button id="btnWeek" class="fc-button fc-button-primary">주</button>
                    <button id="btnList" class="fc-button fc-button-primary">일</button>
                </div>
                <div id='calendar' style="position: relative"></div>
            </div>

            <%--콘텐츠 끝--%>

            <%-- 일정 추가 모달 --%>
            <div id="scheduleModal" class="modal unstaged">
                <div class="modal-overlay"></div>
                <div class="modal-contents">
                    <div class="modal-text flex-between">
                        <h3>일정 추가</h3>
                        <button id="modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i></button>
                    </div>
                    <form id="addScheduleForm">
                        <div class="modal-inputbox">
                            <label for="title" class="modal-label">일정 제목<span class="essential">*</span></label>
                            <div class="modal-input">
                                <input type="text" id="title" name="title" required maxlength="20">
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label for="description" class="modal-label">일정 내용</label>
                            <div class="modal-input">
                                <textarea id="description" name="description" maxlength="255"></textarea>
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label for="location" class="modal-label">장소</label>
                            <div class="modal-input">
                                <input type="text" id="location" name="location">
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label for="startDate" class="modal-label">시작 날짜<span class="essential">*</span></label>
                            <div class="modal-input">
                                <input type="date" id="startDate" name="startDate" required>
                                <input type="time" id="startTime" name="startTime">
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label for="endDate" class="modal-label">종료 날짜</label>
                            <div class="modal-input">
                                <input type="date" id="endDate" name="endDate">
                                <input type="time" id="endTime" name="endTime">
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label for="reminder" class="modal-label">알림</label>
                            <div class="modal-input">
                                <input type="datetime-local" id="reminder" name="reminder">
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label class="modal-label">종일 여부<span class="essential">*</span></label>
                            <div class="modal-input">
                                <input type="radio" id="allDayYes" name="allDay" value="1">
                                <label for="allDayYes">예</label>
                                <input type="radio" id="allDayNo" name="allDay" value="0" checked>
                                <label for="allDayNo">아니오</label>
                            </div>
                        </div>
                        <div class="modal-inputbox">
                            <label class="modal-label">배경색<span class="essential">*</span></label>
                            <div class="color-picker">
                            </div>
                            <input type="hidden" id="backgroundColorInput" name="backgroundColor" value="#A2B18A">
                        </div>
                    </form>
                    <button class="primary-default" type="submit" form="addScheduleForm">추가</button>
                </div>
            </div>

            <div id="viewScheduleModal" class="modal unstaged">
                <div class="modal-overlay"></div>
                <div class="modal-contents">
                    <div class="modal-text flex-between">
                        <h3>일정 상세 및 수정</h3>
                        <button id="view-modal-close" class="modal-close" aria-label="닫기"><i class="bi bi-x-lg"></i>
                        </button>
                    </div>
                    <div id="scheduleDetails">
                        <form id="editScheduleForm">
                            <input type="hidden" id="editScheduleId" name="scheduleIdx">
                            <div class="inputbox">
                                <label for="editTitle">일정 제목<span class="essential">*</span></label>
                                <input type="text" id="editTitle" name="title" required maxlength="20">
                            </div>
                            <div class="inputbox">
                                <label for="editDescription">일정 내용</label>
                                <textarea id="editDescription" name="description" maxlength="255"></textarea>
                            </div>
                            <div class="inputbox">
                                <label for="editLocation">장소</label>
                                <input type="text" id="editLocation" name="location">
                            </div>
                            <div class="inputbox flex-between">
                                <div class="date-time">
                                    <label for="editStartDate">시작 날짜<span class="essential">*</span></label>
                                    <input type="date" id="editStartDate" name="startDate" required>
                                    <input type="time" id="editStartTime" name="startTime">
                                </div>
                                <div class="date-time">
                                    <label for="editEndDate">종료 날짜</label>
                                    <input type="date" id="editEndDate" name="endDate">
                                    <input type="time" id="editEndTime" name="endTime">
                                </div>
                            </div>
                            <div class="inputbox">
                                <label for="editReminder">알림</label>
                                <input type="datetime-local" id="editReminder" name="reminder">
                            </div>
                            <div class="inputbox">
                                <label>종일 여부<span class="essential">*</span></label>
                                <div class="radio-group">
                                    <input type="radio" id="editAllDayYes" name="allDay" value="1">
                                    <label for="editAllDayYes">예</label>
                                    <input type="radio" id="editAllDayNo" name="allDay" value="0">
                                    <label for="editAllDayNo">아니오</label>
                                </div>
                            </div>
                            <div class="inputbox">
                                <label>배경색<span class="essential">*</span></label>
                                <div class="color-picker">
                                </div>
                                <input type="hidden" id="editBackgroundColorInput" name="backgroundColor"
                                       value="#A2B18A">
                            </div>
                            <button class="primary-default" type="submit">수정</button>
                            <button class="primary-default" id="deleteButton" type="button">삭제</button>
                        </form>
                    </div>
                </div>
            </div>
        </main>
    </section>
</div>
<jsp:include page="../include/footer.jsp"/>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>