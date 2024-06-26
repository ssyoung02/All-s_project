// 타이머 키고 끄기
function timerOpen() {
    document.querySelector('#timer').style.display = "block";
    document.querySelector('#container').style.display = "none";
    document.querySelector('footer').style.display = "none";
    document.querySelector('header').style.display = "none";
}

function timeStop() {
    document.querySelector('#timer').style.display = "none";
    document.querySelector('#container').style.display = "";
    document.querySelector('footer').style.display = "";
    document.querySelector('header').style.display = "";
}

function countCharacters(textarea) {
    const charCount = textarea.value.length;
    document.getElementById('charCount').innerText = `${charCount} / 20`;
}

function timerAllClose(){
    let timerClose = confirm("공부 내용을 기록하지 않겠습니까?");
    if(timerClose){
        timermadalClose();
        timeStop();
    }
}

//타이머 모달
function timermodalOpen() {
    let modalContainer = document.getElementById('modal-container');
    modalContainer.classList.toggle('opaque'); // 모달 활성화
    modalContainer.classList.toggle('unstaged');
    document.getElementById('modal-close').focus();
}

function timermadalClose(){
    let modalContainer = document.getElementById('modal-container');
    modalContainer.classList.toggle('opaque'); // 모달 활성화
    modalContainer.classList.toggle('unstaged');
    location.reload();
}

//시간 설정
let h = 0;
let m = 0;
let s = 0;
let time;

function timeReStart(){
    time = setInterval(function () {
        s++;
        s = s > 9 ? s : '0' + s;
        $('#timeSec').text(s);
        if (s > 59) {
            m++;
            m = m > 9 ? m : '0' + m;
            $('#timeMin').text(m);
            s = 0;
            $('#timeSec').text('00');
        }
        if (m > 59) {
            h++;
            h = h > 9 ? h : '0' + h;
            $('#timeHour').text(h);
            m = 0;
            $('#timeMin').text('00');
        }
    }, 1000);
}


//ajax 영역
const hiddentext = $('#hiddent').val();

//csrf토큰 변수 저장
const csrfHeader = $("meta[name='_csrf_header']").attr("content");
const csrfToken = $("meta[name='_csrf']").attr("content");

function startTimer(){
    console.log('userIdx: '+hiddentext);
    console.log('metaname: '+$('meta[name="_csrf"]'))
    clearInterval(time); // 기존 타이머가 있을 경우 중지
    h=0;
    m=0;
    s=0;
    $('#timeSec').text('00');
    $('#timeMin').text('00');
    $('#timeHour').text('00');

    timeReStart()

    $('#time-start').hide();
    $('#time-reStart').show();

    $.ajax({
        method: 'POST',
        url: '/include/start',
        contentType: "application/json",
        data: JSON.stringify({
            user_idx: hiddentext
        }),
        beforeSend: function(xhr) {
            if (csrfHeader && csrfToken) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
                console.log("토큰은 전송됨")
            }
        },
        success: function(response) {
            console.log('타이머 시작 성공:', response);
        },
        error: function(xhr, status, error) {
            console.error('타이머 시작 실패:', error);
            console.error('응답 텍스트:', xhr.responseText);
        }
    })
}

function pauseTimer() {
    clearInterval(time);
    let study_time = calculateStudyTime();

    $.ajax({
        method: 'POST',
        url: '/include/pause',
        data: {
            userIdx: hiddentext,
            study_time: study_time
        },
        beforeSend: function(xhr) {
            if (csrfHeader && csrfToken) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
                console.log("토큰은 전송됨")
            }
        },
        success: function(response) {
            console.log('타이머 일시정지 성공:', response);
        },
        error: function(xhr, status, error) {
            console.error('타이머 일시정지 실패:', error);
            console.error('응답 텍스트:', xhr.responseText);
        }
    })
}

function endTimer() {
    pauseTimer();
    clearInterval(time);
    $('.timer-recode').val("");
    timermodalOpen();
    h=0;
    m=0;
    s=0;
    $('#timeSec').text('00');
    $('#timeMin').text('00');
    $('#timeHour').text('00');

    $('#time-start').show();
    $('#time-reStart').hide();

    return;
}

function calculateStudyTime() {
    const timeHour = parseInt($('#timeHour').text()); // 시간
    const timeMin = parseInt($('#timeMin').text());   // 분
    const timeSec = parseInt($('#timeSec').text());   // 초

    console.log((timeHour * 3600) + (timeMin * 60) + timeSec);
    // 시간, 분, 초를 초 단위로 변환하여 합산
    return (timeHour * 3600) + (timeMin * 60) + timeSec;
}

function updateMemo() {
    const memo = $('.timer-recode').val();

    $.ajax({
        method: 'POST',
        url: '/include/updateMemo',
        data: {
            user_idx: hiddentext,
            memo: memo
        },
        beforeSend: function(xhr) {
            if (csrfHeader && csrfToken) {
                xhr.setRequestHeader(csrfHeader, csrfToken);
                console.log("토큰은 전송됨")
            }
        },
        success: function(response) {
            console.log('메모 저장 성공:', response);
            alert('메모가 작성되었습니다.');
            timermadalClose();
            timeStop();
        },
        error: function(xhr, status, error) {
            console.error('메모 저장 실패:', error);
            console.error('응답 텍스트:', xhr.responseText);
        }
    })
}

