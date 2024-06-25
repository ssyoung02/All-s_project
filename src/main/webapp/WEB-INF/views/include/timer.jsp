<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/>


<div id="timer">
    <div class="modal-text flex-between">
        <button class="timer-close" aria-label="타이머 닫기" onclick="timeStop()"><i class="bi bi-x-lg"></i></button>
    </div>
    <div class="time-area flex-row">
        <p id="timeHour">00</p>:
        <p id="timeMin">00</p>:
        <p id="timeSec">00</p>
        <div class="time-button flex-row">
            <!-- 타이머 컨트롤 버튼 -->
            <button id="time-stop" class="primary-default" onclick="endTimer()">그만하기</button>
            <button id="time-pause" class="primary-default" onclick="pauseTimer()">잠시쉬기</button>
            <button id="time-start" class="primary-default" onclick="startTimer()" style="display: block">공부시작</button>
            <button id="time-reStart" class="primary-default" onclick="timeReStart()" style="display: none">다시시작</button>
        </div>
    </div>

    <%--  모달 --%>
    <div id="modal-container" class="modal unstaged">
        <div class="modal-overlay">
        </div>
        <div class="modal-contents">
            <div class="modal-text flex-between">
                <h4>타이머 기록</h4>
                <button id="modal-close" class="modal-close-x" aria-label="닫기" onclick="timerAllClose()"><i class="bi bi-x-lg"></i></button>
            </div>
            <div id="messageContent" class="modal-center timer-content">
                <textarea class="timer-recode" placeholder="공부 내용을 입력해주세요" required maxlength="20" oninput="countCharacters(this)"></textarea>
                <div id="charCount">0 / 20</div>
            </div>
            <div class="modal-bottom">
                <button type="button" class="button-disabled" data-dismiss="modal" onclick="timerAllClose()">취소</button>
                <button type="button" class="primary-default" data-dismiss="modal" onclick="updateMemo()">기록</button>
            </div>
        </div>
    </div>
    <script>
        $(document).ajaxSend(function (e, xhr, options) {
            xhr.setRequestHeader('X-CSRF-TOKEN', $('meta[name="_csrf"]').attr('content'));
        });
    </script>
</div>

<script>
    let h = 0;
    let m = 0;
    let s = 0;
    let time;

    function startTimer(){
        console.log('userIdx: '+${userVo.userIdx});
        console.log('metaname: '+$('meta[name="_csrf"]'))
        clearInterval(time); // 기존 타이머가 있을 경우 중지

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
        $('#time-start').hide();
        $('#time-reStart').show();

        $.ajax({
            method: 'POST',
            url: '/include/start',
            data: {
                user_idx: ${userVo.userIdx},
            },
            beforeSend: function(xhr) {
                xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
            },
            success: function(response) {
                console.log('타이머 시작 성공:', response);
            },
            error: function(xhr, status, error) {
                console.error('타이머 시작 실패:', error);
            }
        })
    }

    function pauseTimer() {
        clearInterval(time);
        console.log(${userVo.userIdx});
        console.log('일시정지');

        $.post('/include/pause', { userIdx: ${userVo.userIdx} });
    }

    function endTimer() {
        $('.timer-recode').val("");
        modalOpen();


        const studyTime = calculateStudyTime(); // 타이머에서 계산된 공부 시간

        // CSRF 토큰 가져오기
        const csrfHeader = $("meta[name='_csrf_header']").attr("content");
        const csrfToken = $("meta[name='_csrf']").attr("content");

        $.ajax({
            method: 'POST',
            url: '/include/end',
            data: {
                userIdx: ${userVo.userIdx},
                studyTime: studyTime
            },
            beforeSend: function(xhr) {
                if (csrfHeader && csrfToken) {
                    xhr.setRequestHeader(csrfHeader, csrfToken);
                }
            },
            success: function() {
                alert('시간이 기록되었습니다.');
            },
            error: function(xhr, status, error) {
                console.error('타이머 종료 실패:', error);
                console.error('상태:', status);
                console.error('응답 텍스트:', xhr.responseText);
            }
        });




        clearInterval(time);
        h=0;
        m=0;
        s=0;
        $('#timeSec').text('00');
        $('#timeMin').text('00');
        $('#timeHour').text('00');
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
        const memo = $('.timer-recode').text();
        $.post('/include/updateMemo', { userIdx: ${userVo.userIdx}, memo: memo }, function () {
            alert('메모가 작성되었습니다.');
            madalClose();
            timeStop();
        });
    }

</script>