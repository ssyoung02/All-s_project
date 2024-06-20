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
<c:set var="userVo" value="${sessionScope.userVo}"/> <%-- 세션에서 userVo 가져오기 --%>
<script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
<html>
<head>
  <title>Title</title>
  <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
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

    function updatePost(idx) {
      event.preventDefault(); // 폼 제출을 막음
      oEditors.getById["editorTxt"].exec("UPDATE_CONTENTS_FIELD", []); // 스마트 에디터의 내용을 업데이트

      let title = document.getElementById('title-post').value;
      let content = document.getElementById('editorTxt').value;
      $.ajax({
        url: '/studyReferences/updatePost',
        type: 'POST',
        headers: {
          'X-CSRF-TOKEN': $('meta[name="_csrf"]').attr('content') // CSRF 토큰 헤더 설정
        },
        data: {referenceIdx: idx, title: title, content: content},
        success: function(response) {
          alert("글 수정이 완료되었습니다.");
          location.href ="/studyReferences/referencesRead?referenceIdx="+idx
        },
        error: function() {
          alert("글 수정에 실패하였습니다.");
        }
      });
    }

  </script>
</head>
<body>
<jsp:include page="../include/header.jsp"/>
<!-- 중앙 컨테이너 -->
<div id="container">
  <section class="mainContaner">
    <!-- 메뉴 영역 -->
    <nav>
      <jsp:include page="../include/navbar.jsp"/>
    </nav>
    <!-- 본문영역 -->
    <main>
      <h1>공부자료</h1>

      <h3>글수정하기</h3>

      <form id="writeForm" onsubmit="submitPost(event);">
        <div class="container">
          <input type="text" id="title-post" class="title-post" name="title" value="${studyReferencesEntity.title}">
          <div class="private-post-container">
            <input type="checkbox" class="private-post" name="privatePost">게시글 비공개
          </div>

          <!-- naver smart editor api -->
          <div id="smarteditor">
                        <textarea name="editorTxt" id="editorTxt" rows="20" cols="110"
                                  >${studyReferencesEntity.content}</textarea>
          </div>
          <div class="button-container">
            <button type="reset" class="cancel-button" onclick="location.href='/StudyReferences/referencesRead?referenceIdx=' + ${studyReferencesEntity.referenceIdx}">취소</button>
            <button type="button" class="write-button" onclick="updatePost(${studyReferencesEntity.referenceIdx})">수정</button>
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
