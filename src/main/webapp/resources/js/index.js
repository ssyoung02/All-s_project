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

//가입신청 모달
function modalOpen() {
    let modalContainer = document.getElementById('modal-container');
    modalContainer.classList.toggle('opaque'); // 모달 활성화
    modalContainer.classList.toggle('unstaged');
    document.getElementById('modal-close').focus();
}

function modalClose(){
    let modalContainer = document.getElementById('modal-container');
    modalContainer.classList.toggle('opaque'); // 모달 활성화
    modalContainer.classList.toggle('unstaged');
    document.getElementById('modal-close').focus();
}



$("#file").on('change',function(){
    let fileName = $("#file").val();
    $(".upload-name").val(fileName);
});

