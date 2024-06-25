<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스터디그룹 채팅</title>
    <!-- CSRF 메타 태그 -->
    <meta name="_csrf" content="${_csrf.token}"/>
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
    <!-- CSS 링크 -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <style>
        .chat-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-top: 20px;
            overflow: hidden;
        }

        .chat-header {
            width: 400px;
            text-align: center;
            padding: 5px;
            background-color: #f0f0f0;
            border-bottom: 1px solid #ccc;
        }

        .chat-messages {
            width: 400px;
            margin-top: 20px;
            overflow-y: auto;
            max-height: calc(100vh - 200px);
            display: flex;
            flex-direction: column-reverse;
        }

        .message {
            display: flex;
            flex-direction: column;
            margin-bottom: 10px;
            align-items: flex-start;
        }

        .message.right {
            align-items: flex-end;
        }

        .message .name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .message .bubble {
            padding: 10px;
            border-radius: 10px;
            background-color: #f2f2f2;
            border: 1px solid #ccc;
            max-width: 70%;
        }

        .input-container {
            display: flex;
            align-items: center;
            position: fixed;
            bottom: 0;
            background-color: #f0f0f0;
            padding: 10px;
            width: 100%;
        }

        textarea {
            flex: 1;
            margin-right: 10px;
            height: 40px;
            resize: none;
        }

        .chat-input {
            width: 100%;
            margin-top: auto;
            margin-bottom: 20px;
        }

        main {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
</head>
<body>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <!-- 본문 영역 -->
        <main>
            <!-- 채팅 컨테이너 -->
            <div class="chat-container">
                <!-- 채팅 헤더 - 스터디 그룹 제목 -->
                <div class="chat-header">
                    <h1>${study.descriptionTitle}</h1>
                </div>
                <!-- 멤버 목록 -->
                <div class="members-list">
                    <h3>스터디 멤버</h3>
                    <div class="members">
                        <div class="member">
                            <p>
                                <c:forEach var="member" items="${members}" varStatus="loop">
                                    ${member.name}
                                    <c:if test="${not loop.last}"> </c:if>
                                </c:forEach>
                            </p>
                        </div>
                    </div>
                </div>
                <!-- 채팅 메시지 영역 -->
                <div id="chatMessages" class="chat-messages">
                    <c:forEach var="message" items="${messages}">
                        <div class="message ${message.userName == userVo.name ? 'right' : 'left'}">
                            <span class="name">${message.userName}</span>
                            <div class="bubble">
                                <p>${message.messageContent}</p>
                                <span class="regDate">${message.messageRegdate}</span>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
            <!-- 채팅 입력창 -->
            <div class="chat-input">
                <div class="input-container">
                    <textarea id="messageInput" placeholder="메시지를 입력하세요." cols="40" rows="1"></textarea>
                    <button class="send-button" onclick="sendMessage()">전송</button>
                </div>
            </div>
            <!-- JavaScript -->
            <script>
                function scrollChatToBottom() {
                    var chatMessages = document.getElementById('chatMessages');
                    chatMessages.scrollTop = chatMessages.scrollHeight;
                }

                window.onload = function () {
                    scrollChatToBottom();
                };

                function addMessageToChat(message) {
                    var chatMessages = document.getElementById('chatMessages');
                    var newMessageHTML = '<div class="message ' + (message.userName == '${userVo.name}' ? 'right' : 'left')
                        + '"><span class="name">' + message.userName + '</span><div class="bubble"><p>' + message.messageContent + '</p><span class="regDate">' + message.messageRegdate + '</span></div></div>';
                    chatMessages.insertAdjacentHTML('afterbegin', newMessageHTML);
                    scrollChatToBottom();
                }

                function getQueryParam(param) {
                    var urlParams = new URLSearchParams(window.location.search);
                    return urlParams.get(param);
                }

                function sendMessage() {
                    var messageInput = document.getElementById('messageInput');
                    var message = messageInput.value.trim();
                    if (message === "") return;

                    var studyIdx = getQueryParam('studyIdx'); // URL에서 studyIdx 가져오기

                    var csrfToken = $("meta[name='_csrf']").attr("content");
                    var csrfHeader = $("meta[name='_csrf_header']").attr("content");

                    $.ajax({
                        type: 'POST',
                        url: '${root}/studyGroup/sendMessage',
                        data: {
                            message: message,
                            studyIdx: studyIdx
                        },
                        beforeSend: function(xhr) {
                            if (csrfToken && csrfHeader) {
                                xhr.setRequestHeader(csrfHeader, csrfToken);
                            }
                        },
                        success: function (response) {
                            console.log('Message sent successfully');
                            messageInput.value = ''; // 입력창 비우기
                            addMessageToChat({
                                messageContent: message,
                                userName: '${userVo.name}',
                                messageRegdate: new Date().toISOString().slice(0, 19).replace('T', ' ')
                            });
                        },
                        error: function (xhr, status, error) {
                            console.error('Failed to send message: ' + xhr.responseText);
                        }
                    });
                }

                document.getElementById('messageInput').addEventListener('keydown', function (event) {
                    if (event.key === 'Enter' && !event.shiftKey) {
                        event.preventDefault();
                        sendMessage();
                    }
                });
            </script>
        </main>
    </section>
</div>
</body>
</html>
