//배너 좋아요 버튼 선택
document.querySelectorAll('.banner-like').forEach(function (button) {
    button.addEventListener('click', function () {
        const icon = this.querySelector('i');
        if (icon.classList.contains('bi-heart')) {
            icon.classList.remove('bi-heart');
            icon.classList.add('bi-heart-fill');
        } else {
            icon.classList.remove('bi-heart-fill');
            icon.classList.add('bi-heart');
        }
    });
});

//게시글 좋아요 버튼 선택
document.querySelectorAll('.board-like').forEach(function (button) {
    button.addEventListener('click', function () {
        const icon = this.querySelector('i');
        if (icon.classList.contains('bi-heart')) {
            icon.classList.remove('bi-heart');
            icon.classList.add('bi-heart-fill');
        } else {
            icon.classList.remove('bi-heart-fill');
            icon.classList.add('bi-heart');
        }
    });
});

//커스텀 체크박스 이벤트
const checkboxes = document.querySelectorAll('.todo-checkbox');

checkboxes.forEach(checkbox => {
    checkbox.addEventListener('change', function () {
        const label = this.nextElementSibling;
        const icon = label.querySelector('.checkmark > i');
        const privateIcon = label.querySelector('.private-mark > i');

        if (this.checked) {
            icon.className = 'bi bi-check-square';
            if (privateIcon) {
                privateIcon.className = 'bi bi-lock-fill';
            }
        } else {
            icon.className = 'bi bi-square';
            if (privateIcon) {
                privateIcon.className = '';
            }
        }
    });

    // 체크박스에 포커스 이벤트
    checkbox.addEventListener('focus', function () {
        const label = this.nextElementSibling;
        label.style.border = '1px solid #a3b18a';
    });

    // 포커스를 벗어난 경우 border 제거
    checkbox.addEventListener('blur', function () {
        const label = this.nextElementSibling;
        label.style.border = 'none';
    });
});

// 커스텀 파일 업로드 이벤트
const fileuploads = document.querySelectorAll('.customfile');

fileuploads.forEach(fileup => {
    // 체크박스에 포커스 이벤트
    fileup.addEventListener('focus', function () {
        const filebox = this.closest('.file-item');
        filebox.style.border = '1px solid #a3b18a';
        filebox.style.boxShadow = '0 3px 3px rgba(0, 0, 0, 0.3)';
    });

    // 포커스를 벗어난 경우 border 제거
    fileup.addEventListener('blur', function () {
        const filebox = this.closest('.file-item');
        filebox.style.border = '1px solid #3b593f';
        filebox.style.boxShadow = 'none';
    });
});

// 커스텀 이미지 업로드 이벤트
const imguploads = document.querySelectorAll('#imageChange');

imguploads.forEach(imgup => {
    // 체크박스에 포커스 이벤트
    imgup.addEventListener('focus', function () {
        const imgbox = this.closest('.imgbox');
        imgbox.style.border = '2px solid #a3b18a';
        imgbox.style.boxShadow = '0 3px 3px rgba(0, 0, 0, 0.3)';
    });

    // 포커스를 벗어난 경우 border 제거
    imgup.addEventListener('blur', function () {
        const imgbox = this.closest('.imgbox');
        imgbox.style.border = '1px solid #3b593f';
        imgbox.style.boxShadow = 'none';
    });
});

//모달
function modalOpen() {
    let modalContainer = document.getElementById('modal-container');
    modalContainer.classList.toggle('opaque'); // 모달 활성화
    modalContainer.classList.toggle('unstaged');
    document.getElementById('modal-close').focus();
}

function madalClose(){
    let modalContainer = document.getElementById('modal-container');
    modalContainer.classList.toggle('opaque'); // 모달 활성화
    modalContainer.classList.toggle('unstaged');
    document.getElementById('modal-close').focus();
}


//캘린더 모달
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
                success: function (response) {
                    successCallback(response); // 캘린더에 이벤트 데이터 설정
                },
                error: function () {
                    failureCallback();
                }
            });
        },
        locale: 'ko'
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
            document.getElementById('backgroundColorInput').value = color;
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
                userIdx: userIdx  // userIdx 추가
            },
            success: function (response) {
                // 성공적으로 일정 추가 후 처리 (모달 닫기, 캘린더 새로고침 등)
                $('#scheduleModal').removeClass('opaque').addClass('unstaged');
                calendar.refetchEvents(); // 캘린더 새로고침
            },
            error: function () {
                // 오류 처리 (예: alert("일정 추가 중 오류가 발생했습니다."))
            }
        });
    });
});
