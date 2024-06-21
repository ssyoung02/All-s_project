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
        madalClose();
        timeStop();
    }
}

function timeReStart(){
    let time;

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
}