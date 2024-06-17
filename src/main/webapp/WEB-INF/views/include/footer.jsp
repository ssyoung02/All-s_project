<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
</head>
<body>
    <footer>
        <button class="secondary-default top">
            <i class="bi bi-caret-up-fill"></i>
            <span>TOP</span>
        </button>
        <div class="teammember">
            <div class="logo">
                <p>made by</p>
                <img class="footerlogo" src="${root}/resources/images/logo.png" style="width:8em" alt="all's 로고"/>
            </div>
            <div class="madeby">
                <ul>
                    <li>전상민</li>
                    <li><a href="#"> github</a></li>
                    <li><a href="#"> notion</a>
                    </li>
                </ul>
            </div>
            <div class="madeby">
                <ul>
                    <li>신지현</li>
                    <li><a href="#">github</a></li>
                    <li><a href="#">notion</a>
                    </li>
                </ul>
            </div>
            <div class="madeby">
                <ul>
                    <li>송예준</li>
                    <li><a href="#">github</a></li>
                    <li><a href="#">notion</a>
                    </li>
                </ul>
            </div>
            <div class="madeby">
                <ul>
                    <li>최재원</li>
                    <li><a href="#">github</a></li>
                    <li><a href="#">notion</a>
                    </li>
                </ul>
            </div>
            <div class="madeby">
                <ul>
                    <li>손유정</li>
                    <li><a href="#">github</a></li>
                    <li><a href="#">tstory</a>
                    </li>
                </ul>
            </div>
            <div class="madeby">
                <ul>
                    <li>조서영</li>
                    <li><a href="#">github</a></li>
                    <li><a href="#">notion</a>
                    </li>
                </ul>
            </div>
        </div>
        <p>© 2021 All Rights Reserved</div>
    </footer>
</body>
</html>
<footer>
    <button class="secondary-default top">
        <i class="bi bi-caret-up-fill"></i>
        <span>TOP</span>
    </button>
    <div class="teammember">
        <div class="logo">
            <p>made by</p>
            <img class="footerlogo" src="${root}/resources/images/logo.png" style="width:8em" alt="all's 로고"/>
        </div>
        <div class="madeby">
            <ul>
                <li>전상민</li>
                <li><a href="#"> github</a></li>
                <li><a href="#"> notion</a>
                </li>
            </ul>
        </div>
        <div class="madeby">
            <ul>
                <li>신지현</li>
                <li><a href="#">github</a></li>
                <li><a href="#">notion</a>
                </li>
            </ul>
        </div>
        <div class="madeby">
            <ul>
                <li>송예준</li>
                <li><a href="#">github</a></li>
                <li><a href="#">notion</a>
                </li>
            </ul>
        </div>
        <div class="madeby">
            <ul>
                <li>최재원</li>
                <li><a href="#">github</a></li>
                <li><a href="#">notion</a>
                </li>
            </ul>
        </div>
        <div class="madeby">
            <ul>
                <li>손유정</li>
                <li><a href="#">github</a></li>
                <li><a href="#">tstory</a>
                </li>
            </ul>
        </div>
        <div class="madeby">
            <ul>
                <li>조서영</li>
                <li><a href="#">github</a></li>
                <li><a href="#">notion</a>
                </li>
            </ul>
        </div>
    </div>
    <p>© 2021 All Rights Reserved</div>
</footer>
