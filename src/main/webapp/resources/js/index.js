
const skipnavLink = document.querySelector('#skipnav a');
skipnavLink.addEventListener('focus', function () {
    const skipnav = document.querySelector('#skipnav');
    skipnav.style.opacity = 1;
});

skipnavLink.addEventListener('blur', function () {
    const skipnav = document.querySelector('#skipnav');
    skipnav.style.opacity = 0;
});

//화면 위치에 따라 TOP 버튼 보이게
window.addEventListener("scroll", function () {
    if (window.scrollY > 500) {
        document.querySelector('.top').style.display = "block";
    } else {
        document.querySelector('.top').style.display = "none";
    }
});

//화면 스크롤에 따라 top버튼 보이게
document.querySelector(".top").addEventListener("click", function () {
    window.scrollTo({ top: 0, behavior: 'smooth' });
});

//화면 너비에 따라 메인메뉴 숨김처리
window.addEventListener("resize", function () {
    if (window.matchMedia("(min-width: 1200px)").matches) {
        document.querySelector('.m-menu-area').style.display = "none";
    }
});

//축소된 메인메뉴 확장 
document.querySelectorAll(".menu-open").forEach(function (menuOpen) {
    menuOpen.addEventListener("click", function () {
        let lnb = document.querySelector('.m-menu-area');
        if (lnb.style.display === 'none') {
            lnb.style.display = 'block';
        } else {
            lnb.style.display = 'none';
        }
    });
});

//메인메뉴 내의 drop-down 메뉴 버튼 처리
document.querySelectorAll('.menu-area .tertiary-default').forEach(function (tertiaryDefault) {
    tertiaryDefault.addEventListener("click", function () {
        this.closest('.menu-area').nextElementSibling.classList.toggle('hidden');

        // Toggle the icon class
        var icon = this.querySelector('i');
        if (icon.classList.contains('bi-chevron-up')) {
            icon.classList.remove('bi-chevron-up');
            icon.classList.add('bi-chevron-down');
        } else if (icon.classList.contains('bi-chevron-down')) {
            icon.classList.remove('bi-chevron-down');
            icon.classList.add('bi-chevron-up');
        } else if (icon.classList.contains('bi-dash-lg')) {
            icon.classList.remove('bi-dash-lg');
            icon.classList.add('bi-plus-lg');
        } else if (icon.classList.contains('bi-plus-lg')) {
            icon.classList.remove('bi-plus-lg');
            icon.classList.add('bi-dash-lg');
        }
    });
});
//메인메뉴 내의 drop-down 메뉴 처리
document.querySelectorAll('.menu-area .menu-text').forEach(function (menuText) {
    menuText.addEventListener("click", function () {
        this.closest('.menu-area').nextElementSibling.classList.toggle('hidden');

        // Toggle the icon class
        var icon = this.closest('.menu-area').querySelector('.tertiary-default i');
        if (icon.classList.contains('bi-chevron-up')) {
            icon.classList.remove('bi-chevron-up');
            icon.classList.add('bi-chevron-down');
        } else if (icon.classList.contains('bi-chevron-down')) {
            icon.classList.remove('bi-chevron-down');
            icon.classList.add('bi-chevron-up');
        } else if (icon.classList.contains('bi-dash-lg')) {
            icon.classList.remove('bi-dash-lg');
            icon.classList.add('bi-plus-lg');
        } else if (icon.classList.contains('bi-plus-lg')) {
            icon.classList.remove('bi-plus-lg');
            icon.classList.add('bi-dash-lg');
        }
    });
});

//타이머 키고 끄기
function timerOpen() {
    document.querySelector('#timer').style.display = "block";
    document.querySelector('#container').style.display = "none";
    document.querySelector('footer').style.display = "none";
}

function timeStop() {
    document.querySelector('#timer').style.display = "none";
    document.querySelector('#container').style.display = "";
    document.querySelector('footer').style.display = "";
}

//프로필 선택 알림창
document.querySelectorAll('.profile').forEach(function (profileOpen) {
    profileOpen.addEventListener("click", function () {
        this.nextElementSibling.classList.toggle('hidden');
    })
});

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

        if (this.checked) {
            icon.className = 'bi bi-check-square';
        } else {
            icon.className = 'bi bi-square';
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

//가입신청 모달
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

$("#file").on('change',function(){
    let fileName = $("#file").val();
    $(".upload-name").val(fileName);
});

let h = 0;
let m = 0;
let s = 0;
let time;

$('#time-start').click(function (){
    time=setInterval(function (){
        s++;
        s = s>9 ? s : '0'+s;
        $('#timSec').text(s);
        if(s>59){
            m++;
            m = m>9 ? m : '0'+m;
            $('#timeMin').text(m);
            s=0;
            $('#timeSec').text('00');
        }
        if(m>59){
            h++;
            h = h>9 ? h : '0'+h;
            $('#timeHour').text(h);
            h=0;
            $('#timeMin').text('00');
        }
    },1000);
})

$('#time-stop').click(function (){
    clearInterval(time);
})