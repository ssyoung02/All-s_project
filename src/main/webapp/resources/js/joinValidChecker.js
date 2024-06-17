$("#registerForm").submit(function(event) {
    const password = $("#password").val();
    const password2 = $("#password2").val();

    if (password !== password2) {
        $("#passwordCheckResult").text("비밀번호가 일치하지 않습니다.");
        event.preventDefault(); // 폼 제출 방지
    } else {
        // 비밀번호가 일치하면 password2 필드 제거 후 제출
        $("#password2").remove();
        $("#passwordCheckResult").remove(); // 오류 메시지 제거
        this.submit(); // 폼 제출
    }
});

//close modal
document.querySelectorAll(".modal-close").forEach(function (modalClose) {
    modalClose.addEventListener("click", function () {
        document.getElementById('modal-container').classList.toggle('opaque');

        document.getElementById('modal-container').addEventListener('transitionend', function(e){
            this.classList.toggle('unstaged');
            this.removeEventListener('transitionend',arguments.callee);
        });
    });
});