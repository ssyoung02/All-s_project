<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head><sec:csrfMetaTags /> <%-- CSRF 토큰 자동 포함 --%>
    <title>접근 거부</title>
</head>
<body>
<h2>접근 거부</h2>
<p>해당 페이지에 접근할 권한이 없습니다.</p>
</body>
</html>

