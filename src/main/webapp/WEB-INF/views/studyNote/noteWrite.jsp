<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글쓰기 > 내 공부노트 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css?after">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <script type="text/javascript" src="/resources/smarteditor/js/HuskyEZCreator.js" charset="utf-8"></script>
    <script>
        let oEditors = [];
        function smartEditor() {
            console.log("Naver Smart Editor 초기화");
            nhn.husky.EZCreator.createInIFrame({
                oAppRef: oEditors,
                headers: {
                    'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
                },
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
        function isContentEmpty(content) {
            // 실제 텍스트가 비어있는지 검사
            return $('<div>').html(content).text().trim() === '';
        }

        function submitPost(event) {
            event.preventDefault(); // 폼 제출을 막음
            console.log("submitPost 함수 호출됨");

            oEditors.getById["editorTxt"].exec("UPDATE_CONTENTS_FIELD", []); // 스마트 에디터의 내용을 업데이트
            let content = document.getElementById("editorTxt").value;
            let title = document.querySelector('.title-post').value;
            let privatePost = document.querySelector('.private-post').checked;

            if (title.trim() === '') {
                alert("제목을 입력해주세요");
                document.querySelector('.title-post').focus();
                return false;
            }

            if (isContentEmpty(content)) {
                alert("내용을 입력해주세요");
                oEditors.getById["editorTxt"].exec("FOCUS");
                return false;
            }
            // AJAX를 사용하여 폼 데이터를 서버로 전송
            $.ajax({
                url: '/studyNote/noteWrite',
                type: 'POST',
                data: {
                    title: title,
                    content: content,
                    isPrivate: privatePost
                },
                beforeSend: function (xhr) {
                    xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                },
                success: function (response) {
                    alert("글 작성이 완료되었습니다.");
                    location.href = "${root}/studyNote/noteRead?referenceIdx=" + response
                },
                error: function () {
                    alert("글 작성에 실패하였습니다.");
                }
            });
        }
    </script>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp" />
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp" />
        </nav>
        <!-- 본문 영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp" />
            </div>
            <!--각 페이지의 콘텐츠-->
                <h1>내 공부노트</h1>

                <!--본문 콘텐츠-->
                <h4 class="s-header">글쓰기</h4>

                <!-- <div class="maxcontent"> -->
                <form id="writeForm" onsubmit="submitPost(event);">
                    <div class="post-area">
                        <input type="text" class="title-post" name="title" placeholder="제목을 입력해주세요" required>
                        <ul class="todolist">
                            <!-- 태그 항목 -->
                            <li>
                                <input type="checkbox" id="public" class="todo-checkbox">
                                <label for="public" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                    비밀글
                                    <span class="private-mark"><i class=""></i></span>
                                </label>
                            </li>
                        </ul>
                        <!-- naver smart editor api -->
                        <div id="smarteditor">
                        <textarea name="editorTxt" id="editorTxt" style="width: 100%; height: 30em;"
                                  placeholder="내용을 입력해주세요"></textarea>
                        </div>
                        <div class="buttonBox">
                            <button type="reset" class="updatebutton secondary-default" onclick="location.href='${root}/studyNote/noteList'">취소</button>
                            <button type="submit" class="updatebutton primary-default">작성</button>
                        </div>
                    </div>
                </form>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp"/>
</div>
</body>
</html>
