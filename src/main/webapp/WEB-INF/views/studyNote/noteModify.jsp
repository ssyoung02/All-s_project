<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글 수정 > 내 공부노트 > 공부 > All's</title>
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
            return $('<div>').html(content).text().trim() === '';
        }

        function updatePost(event, idx) {
            console.log("updatePost 함수 호출됨");

            event.preventDefault(); // 폼 제출을 막음
            oEditors.getById["editorTxt"].exec("UPDATE_CONTENTS_FIELD", []); // 스마트 에디터의 내용을 업데이트

            let title = document.querySelector('.title-post').value;
            let content = document.getElementById('editorTxt').value;
            let isPrivate = document.getElementsByName("isPrivate")[0].checked;

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

            let $frm = $("#writeForm")[0];
            let formData = new FormData($frm);
            formData.append("content", formData.get("editorTxt"));
            formData.append("uploadFile", $("#file")[0].files[0]);
            formData.append("isPrivate", isPrivate);
            formData.append("referenceIdx", idx);

            $.ajax({
                url: '/studyNote/updatePost',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                beforeSend: function(xhr) {
                    xhr.setRequestHeader($("meta[name='_csrf_header']").attr("content"), $("meta[name='_csrf']").attr("content"));
                },
                success: function(response) {
                    if(response === 10){
                        alert("파일 용량은 5MB를 초과할 수 없습니다.");
                        return false;
                    } else if(response === 11){
                        alert("이미지 파일만 저장할 수 있습니다.");
                        return false;
                    } else {
                        alert("글 수정이 완료되었습니다.");
                        location.href = "${root}/studyNote/noteRead?referenceIdx=" + idx;
                    }
                },
                error: function() {
                    alert("글 수정에 실패하였습니다.");
                }
            });
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('removeFileButton').addEventListener('click', function() {
                console.log("파일 삭제");

                let fileInput = document.getElementById('file');
                fileInput.value = ''; // 파일 입력 요소 초기화

                let uploadFileInput = document.getElementById('uploadFile');
                uploadFileInput.value = '첨부파일'; // 표시되는 텍스트 초기화
            });
        });

    </script>
</head>
<body>
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
    <section class="mainContainer">
        <!-- 메뉴 영역 -->
        <nav>
            <jsp:include page="../include/navbar.jsp"/>
        </nav>
        <!-- 본문영역 -->
        <main>
            <!--모바일 메뉴 영역-->
            <div class="m-menu-area" style="display: none;">
                <jsp:include page="../include/navbar.jsp" />
            </div>
            <!--각 페이지의 콘텐츠-->
            <h1>공부자료</h1>

            <!--본문 콘텐츠-->
            <h4 class="s-header">글수정</h4>

            <form id="writeForm" onsubmit="updatePost(event, ${studyReferencesEntity.referenceIdx});">
                <!-- form 태그의 onsubmit 이벤트를 통해 updatePost 함수가 호출됩니다. -->
                <div class="post-area">
                    <input type="text" id="title-post" class="title-post" name="title" value="${studyReferencesEntity.title}">

                    <ul class="todolist">
                        <li>
                            <c:if test="${studyReferencesEntity.isPrivate}">
                                <input type="checkbox" id="public" class="todo-checkbox" name="isPrivate" checked="checked">
                                <label for="public" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-check-square"></i></span>
                                    비밀글
                                    <span class="private-mark"><i class="bi bi-lock-fill"></i></span>
                                </label>
                            </c:if>
                            <c:if test="${not studyReferencesEntity.isPrivate}">
                                <input type="checkbox" id="public" class="todo-checkbox" name="isPrivate">
                                <label for="public" class="todo-label">
                                    <span class="checkmark"><i class="bi bi-square"></i></span>
                                    비밀글
                                    <span class="private-mark"><i class=""></i></span>
                                </label>
                            </c:if>
                        </li>
                    </ul>

                    <!-- naver smart editor api -->
                    <div id="smarteditor">
                        <textarea name="editorTxt" id="editorTxt" style="width: 100%; height: 30em;">${studyReferencesEntity.content}</textarea>
                    </div>

                    <ul class="taglist">
                        <!-- 태그 항목 -->
                        <li>
                            <p class="tag-title">첨부파일</p>
                            <c:if test="${not empty studyReferencesEntity.fileName}">
                                <input id="uploadFile" class="upload-name" value="${studyReferencesEntity.fileName}" name="uploadFile" readonly>
                            </c:if>
                            <c:if test="${empty studyReferencesEntity.fileName}">
                                <input id="uploadFile" class="upload-name" value="첨부파일" placeholder="첨부파일" name="uploadFile" readonly>
                            </c:if>
                            <label for="file">파일찾기</label>
                            <input type="file" id="file" name="uploadFile">
                            <button type="button" class="secondary-default" id="removeFileButton">파일삭제</button>
                        </li>
                    </ul>

                    <div class="buttonBox">
                        <button type="reset" class="updatebutton secondary-default" onclick="location.href='${root}/studyNote/noteList'">취소</button>
                        <button type="submit" class="updatebutton primary-default">수정</button>
                        <!-- submit 버튼의 onclick 속성을 제거하고, type="submit"을 설정하여 폼 제출을 트리거합니다. -->
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
