<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디그룹 채팅</title>
    <!-- CSS 링크 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <style>
        /* 기존 CSS 스타일링 유지 */
        .chat-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 20px;
        }
        /* 기존 CSS 스타일링 유지 */
        .chat-header {
            width: 100%;
            text-align: center;
            padding: 10px;
            background-color: #f0f0f0;
            border-bottom: 1px solid #ccc;
        }
        /* 기존 CSS 스타일링 유지 */
        .chat-messages {
            width: 80%;
            margin-top: 20px;
            overflow-y: auto; /* 채팅 메시지가 많을 경우 스크롤 표시 */
            max-height: 60vh; /* 최대 높이 설정 */
        }
        /* 기존 CSS 스타일링 유지 */
        .message {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        /* 기존 CSS 스타일링 유지 */
        .message .bubble {
            padding: 10px;
            border-radius: 10px;
            background-color: #f2f2f2;
            border: 1px solid #ccc;
            max-width: 70%;
        }
        /* 기존 CSS 스타일링 유지 */
        .message .right {
            align-self: flex-end;
        }
        /* 기존 CSS 스타일링 유지 */
        .message .left {
            align-self: flex-start;
        }
        /* 기존 CSS 스타일링 유지 */
        .input-container {
            display: flex;
            align-items: center;
            position: sticky;
            bottom: 0;
            background-color: #f0f0f0;
            padding: 10px;
            width: 100%;
        }
        /* 기존 CSS 스타일링 유지 */
        textarea {
            flex: 1;
            margin-right: 10px;
        }
    </style>
</head>
<body>

<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContaner">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp"/>
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!-- 채팅 컨테이너 -->
            <div class="chat-container">
                <!-- 채팅 헤더 - 스터디 그룹 제목 -->
                <div class="chat-header">
                    <h1>${study.studyTitle}</h1>
                </div>
                <!-- 멤버 목록 -->
                <div class="members-list">
                    <h3>스터디 멤버</h3>
                    <div class="members">
                        <c:forEach var="member" items="${members}">
                            <div class="member">
                                <img src="${root}/resources/images/${member.profile_image}" alt="프로필 이미지">
                                <p>${member.name}</p>
                            </div>
                        </c:forEach>
                    </div>
                </div>
                <!-- 채팅 메시지 영역 -->
                <div id="chatMessages" class="chat-messages">
                    <c:forEach var="message" items="${messages}">
                        <div class="message">
                            <div class="bubble ${message.userId == sessionScope.user.userId ? 'right' : 'left'}">
                                <p>${message.messageContent}</p>
                                <span class="regDate">${message.messageRegdate}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <!-- 채팅 입력창 -->
                <div class="chat-input">
                    <div class="input-container">
                        <textarea id="messageInput" placeholder="메시지를 입력하세요." cols="40" rows="2"></textarea>
                        <button class="send-button" onclick="sendMessage()">전송</button>
                    </div>
                </div>
            </div>

            <!-- JavaScript -->
            <script>
                // 채팅 메시지 영역으로 스크롤을 자동으로 이동하는 함수
                function scrollChatToBottom() {
                    var chatMessages = document.getElementById('chatMessages');
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                }

                // 페이지 로드 후 최하단으로 스크롤 이동
                window.onload = function() {
                    scrollChatToBottom();
                };

                // 메시지 전송 함수
                function sendMessage() {
                    var message = document.getElementById('messageInput').value;
                    // 여기서 message를 서버로 보내는 AJAX 요청을 할 수 있음
                    // 예시: jQuery를 이용한 AJAX 요청
                    $.ajax({
                        type: 'POST',
                        url: '${root}/studyGroup/sendMessage',
                        data: { message: message },
                        success: function(response) {
                            // 성공 시 처리할 로직
                            console.log('메시지 전송 성공');
                            // 새 메시지를 추가한 후 스크롤을 최하단으로 이동
                            var chatMessages = document.getElementById('chatMessages');
                            var newMessageHTML = '<div class="message"><div class="bubble right"><p>' + message + '</p><span class="regDate">방금</span></div></div>';
                            chatMessages.innerHTML += newMessageHTML;
                            scrollChatToBottom();
                            // textarea 비우기
                            document.getElementById('messageInput').value = '';
                        },
                        error: function(xhr, status, error) {
                            // 에러 처리 로직
                            console.error('메시지 전송 실패: ' + error);
                        }
                    });
                }
            </script>
        </main>
    </section>
</div>

</body>
</html>
