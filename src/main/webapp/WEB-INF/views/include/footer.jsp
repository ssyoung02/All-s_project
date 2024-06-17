<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath }"/>
<c:set var="userVo" value="${SPRING_SECURITY_CONTEXT.authentication.principal }"/>
<c:set var="auth" value="${SPRING_SECURITY_CONTEXT.authentication.authorities }" />

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
