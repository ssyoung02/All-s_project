<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <link rel="stylesheet" href="${root}/resources/css/chat.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="http://localhost:82/socket.io/socket.io.js"></script>
    <script src="https://code.jquery.com/jquery-1.11.1.js"></script>
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
                    <button class="send-button">전송</button>
                </div>
            </div>
            <!-- JavaScript -->
            <script>
                $(document).ready(function () {
                    var socket = io("http://localhost:82");

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
                        var messageInput = $("#messageInput");
                        var message = messageInput.val().trim();
                        if (message === "") return;

                        var studyIdx = getQueryParam('studyIdx');

                        var csrfToken = $("meta[name='_csrf']").attr("content");
                        var csrfHeader = $("meta[name='_csrf_header']").attr("content");

                        $.ajax({
                            type: 'POST',
                            url: '${root}/studyGroup/sendMessage',
                            data: {
                                message: message,
                                userName: '${userVo.name}',
                                studyIdx: studyIdx
                            },
                            beforeSend: function (xhr) {
                                if (csrfToken && csrfHeader) {
                                    xhr.setRequestHeader(csrfHeader, csrfToken);
                                }
                            },
                            success: function (response) {
                                console.log('Message sent successfully');
                                messageInput.val('');
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

                    $("#messageInput").keydown(function (event) {
                        if (event.key === 'Enter' && !event.shiftKey) {
                            event.preventDefault();
                            $(".send-button").click();
                        }
                    });

                    $(".send-button").click(function () {
                        sendMessage();
                    });

                    socket.on("send_msg", function (data) {
                        addMessageToChat(data);
                    });
                });
            </script>
        </main>
    </section>
</div>
</body>
</html>
