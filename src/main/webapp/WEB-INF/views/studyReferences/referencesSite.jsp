<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>공부 사이트 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>

    <script>
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
            <div id="content">
                <h1>공부 사이트</h1>

                <%--사이트 목록--%>
                <h3 class="siteTitle">개발환경 관련 사이트</h3>
                <div class="siteList">
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/01.%20eclipse.png" alt="Eclipse">
                            </div>
                            <h3>Eclipse</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/02.%20intellij.png" alt="IntelliJ">
                            </div>
                            <h3>IntelliJ</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/03.%20mysql.png" alt="MySQL">
                            </div>
                            <h3>MySQL</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/04.%20vscode.png" alt="VS Code">
                            </div>
                            <h3>VS Code</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/05.%20gitbash.png" alt="Git Bash">
                            </div>
                            <h3>Git Bash</h3>
                        </a>
                    </div>
                </div>
                <h3 class="siteTitle">개발자 공부 관련 사이트</h3>
                <div class="siteList">
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/06.%20github.png" alt="Eclipse">
                            </div>
                            <h3>Git Hub</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/07.%20kakaotech.png" alt="IntelliJ">
                            </div>
                            <h3>kakao Tech</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/08.%20ouahan.png" alt="MySQL">
                            </div>
                            <h3>우아한형제들 기술블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/09.%20carrot.png" alt="VS Code">
                            </div>
                            <h3>당근태크 블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/10.%20kurly.png" alt="Git Bash">
                            </div>
                            <h3>컬리 기술블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/11.%20banksalad.png" alt="Git Bash">
                            </div>
                            <h3>뱅크샐러드 블로그</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/12.%20line.png" alt="Git Bash">
                            </div>
                            <h3>LINE Enginearing</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/13.%20nhncloud.png" alt="Git Bash">
                            </div>
                            <h3>NHN Cloud</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/14.%20aws.png" alt="Git Bash">
                            </div>
                            <h3>W3C schools</h3>
                        </a>
                    </div>
                    <div class="siteItem">
                        <a href="#">
                            <div class="img-container">
                                <img src="/resources/images/15.%20mdn.png" alt="Git Bash">
                            </div>
                            <h3>mdn wec docs</h3>
                        </a>
                    </div>
                </div>

            </div>
            <%--콘텐츠 끝--%>
        </main>
    </section>
    <!--푸터-->
    <jsp:include page="../include/footer.jsp" />
</div>
</body>
</html>