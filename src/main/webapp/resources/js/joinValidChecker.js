// function checkDuplicate() {
//     const username = $("#username").val();
//     $.ajax({
//         url: "/Users/checkDuplicate",
//         type: "POST",
//         data: { username: username },
//         success: function(response) {
//             if (response === 0) {
//                 $("#usernameCheckResult").text("사용 가능한 아이디입니다.");
//                 $("#usernameCheckResult").removeClass("error").addClass("success");
//             } else {
//                 $("#usernameCheckResult").text("이미 사용 중인 아이디입니다.");
//                 $("#usernameCheckResult").removeClass("success").addClass("error");
//             }
//
//         },
//         error: function() { // AJAX 요청 실패 시
//             $("#usernameCheckResult").text("중복 확인 중 오류가 발생했습니다.");
//             $("#usernameCheckResult").removeClass("success").addClass("error");
//         }
//     });
// }
//
// $("#registerForm").submit(function(event) {
//     const password = $("#password").val();
//     const password2 = $("#password2").val();
//
//     if (password !== password2) {
//         $("#passwordCheckResult").text("비밀번호가 일치하지 않습니다.");
//         $("#passwordCheckResult").removeClass("success").addClass("error");
//         event.preventDefault(); // 폼 제출 방지
//     } else {
//         // 비밀번호가 일치하면 password2 필드 제거 후 제출
//         $("#password2").remove();
//         $("#passwordCheckResult").remove(); // 오류 메시지 제거
//         this.submit(); // 폼 제출
//     }
// });
// $(document).ready(function() {
//     // 회원가입 결과 메시지 처리 (모달 표시)
//     <c:if test="${not empty error}">
//         $("#messageContent").text("${error}");
//         $("#messageModal").modal("show");
//     </c:if>
// });
