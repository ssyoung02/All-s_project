<%--
  Created by IntelliJ IDEA.
  User: yujung
  Date: 6/16/24
  Time: 10:59 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
<html>
<head>
    <title>Title</title>
    <style>
        h1 {
            font-weight: 600;
            font-size: 36px;
            color: #263238;
        }

        h3 {
            font-weight: 600;
            font-size: 24px;
            color: #212121;
        }

        .container {
            border: 1px solid #a2b18a;
            width: 980px;
            height: auto;
            border-radius: 10px;
            padding: 20px;
            box-sizing: border-box;
        }

        .title-post {
            font-size: 32px;
            margin-top: 20px;
            margin-left: 20px;
            border: 1px solid white;
            border-bottom: 2px solid #d9d9d9;
            display: block;
            width: calc(100% - 40px);
        }

        .private-post-container {
            margin: 20px 0 20px 20px;
            font-size: 16px;
            color: #212121;
        }

        .private-post {
            margin-right: 10px;
        }

        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }

        .cancel-button, .write-button {
            border: 1px solid #a2b18a;
            border-radius: 4px;
            color: #a2b18a;
            width: 94px;
            height: 48px;
            font-size: 16px;
            font-weight: 400;
            margin-left: 15px;
        }

        .cancel-button:hover, .write-button:hover {
            background-color: #a2b18a;
            color: white;
        }

        #smarteditor {
            margin-left: 20px; /* 오른쪽으로 살짝 이동 */
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script type="text/javascript" src="/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
    <script>
        let oEditors = [];

        function smartEditor() {
            console.log("Naver Smart Editor 초기화");
            nhn.husky.EZCreator.createInIFrame({
                oAppRef: oEditors,
                elPlaceHolder: "editorTxt",
                sSkinURI: "/resources/smarteditor/SmartEditor2Skin.html",
                fCreator: "createSEditor2",
                htParams: {
                    bUseToolbar: true,
                    bUseVerticalResizer: false,
                    bUseModeChanger: false
                }
            });
        }

        $(document).ready(function () {
            smartEditor();
        });

        function submitPost(event) {
            event.preventDefault(); // 폼 제출을 막음
            oEditors.getById["editorTxt"].exec("UPDATE_CONTENTS_FIELD", []); // 스마트 에디터의 내용을 업데이트

            let content = document.getElementById("editorTxt").value;
            let title = document.querySelector('.title-post').value;
            let privatePost = document.querySelector('.private-post').checked;

            if (content === '') {
                alert("내용을 입력해주세요");
                oEditors.getById["editorTxt"].exec("FOCUS");
                return false;
            }

            // AJAX를 사용하여 폼 데이터를 서버로 전송
            $.ajax({
                url: '/StudyReferences/referencesWrite',
                type: 'POST',
                data: {
                    title: title,
                    content: content,
                    isPrivate: privatePost
                },
                success: function(response) {
                    alert("글 작성이 완료되었습니다.");
                    location.href ="/StudyReferences/referencesSite?referenceIdx="+response
                },
                error: function() {
                    alert("글 작성에 실패하였습니다.");
                }
            });
        }

    </script>
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section>
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp"/>
        </nav>
        <!-- 본문영역 -->
        <main>
            <h1>공부자료</h1>

            <h3>글쓰기</h3>

            <form id="writeForm" onsubmit="submitPost(event);">
                <div class="container">
                    <input type="text" class="title-post" name="title" placeholder="제목을 입력해주세요" required>
                    <div class="private-post-container">
                        <input type="checkbox" class="private-post" name="privatePost">게시글 비공개
                    </div>

                    <!-- naver smart editor api -->
                    <div id="smarteditor">
                        <textarea name="editorTxt" id="editorTxt" rows="20" cols="110"
                                  placeholder="내용을 입력해주세요"></textarea>
                    </div>
                    <div class="button-container">
                        <button type="reset" class="cancel-button" onclick="location.href='referencesList'">취소</button>
                        <button type="submit" class="write-button">작성</button>
                    </div>
                </div>
            </form>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp"/>
</div>
<jsp:include page="../include/timer.jsp"/>
</body>
</html>
