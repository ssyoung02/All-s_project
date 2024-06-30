<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="root" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>멤버 관리 > 관리 > 스터디그룹 > 내 스터디 > 스터디 > 공부 > All's</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="${root}/resources/css/common.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${root}/resources/js/common.js" charset="UTF-8" defer></script>
    <sec:csrfMetaTags />
</head>
<body>
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
                <h1>내 스터디</h1>
                <!--탭 메뉴-->
                <div class="tapMenu">
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerInfo?studyIdx=${studyGroup.studyIdx}">스터디 정보</a>
                    </div>
                    <div class="tapItem tapSelect">
                        <a href="${root}/studyGroup/studyGroupManagerMember?studyIdx=${studyGroup.studyIdx}">멤버 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerSchedule?studyIdx=${studyGroup.studyIdx}">일정 관리</a>
                    </div>
                    <div class="tapItem">
                        <a href="${root}/studyGroup/studyGroupManagerManagement?studyIdx=${studyGroup.studyIdx}">스터디 관리</a>
                    </div>
                </div>
                <!--탭 메뉴 끝-->

                <table class="manager-table">
                    <caption style="opacity: 0">스터디 멤버 관리표. 강제 탈퇴 및 가입 승인이 가능합니다</caption>
                    <thead>
                    <tr>
                        <th scope="col">멤버명</th>
                        <th scope="col">멤버등급</th>
                        <th scope="col">가입날짜</th>
                        <th scope="col">신청서 내용</th>
                        <th scope="col">관리</th>
                    </tr>
                    </thead>
                    <tbody>
                    <!-- 스터디 리더를 먼저 출력 -->
                    <c:forEach var="member" items="${members}">
                        <c:if test="${member.role == 'LEADER'}">
                            <tr class="tableList">
                                <td>${member.userName}</td>
                                <td>리더</td>
                                <td>${member.createdAt}</td>
                                <td>${member.joinReason}</td>
                                <td></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    <!-- 그 외의 멤버들을 출력 -->
                    <c:forEach var="member" items="${members}">
                        <c:if test="${member.role != 'LEADER'}">
                            <tr class="tableList">
                                <td>${member.userName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${member.status == 'PENDING'}">가입대기</c:when>
                                        <c:when test="${member.status == 'ACCEPTED'}">일반멤버</c:when>
                                        <c:otherwise>거절함</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${member.createdAt}</td>
                                <td>${member.joinReason}</td>
                                <td>
                                    <c:if test="${member.status == 'PENDING'}">
                                        <button class="primary-default approve-btn" data-user-idx="${member.userIdx}">가입 승인</button>
                                        <button class="secondary-default reject-btn" data-user-idx="${member.userIdx}">승인 거절</button>
                                    </c:if>
                                    <c:if test="${member.status == 'REJECTED'}">
                                        <button class="secondary-default delete-btn" data-user-idx="${member.userIdx}">삭제</button>
                                    </c:if>
                                    <c:if test="${member.status == 'ACCEPTED'}">
                                        <button class="secondary-default remove-btn" data-user-idx="${member.userIdx}">회원탈퇴</button>
                                    </c:if>
                                </td>
                            </tr>
                        </c:if>
                    </c:forEach>
                    </tbody>
                </table>

                <script>
                    $(document).ready(function() {
                        $('.approve-btn').on('click', function() {
                            var userIdx = $(this).data('user-idx');
                            updateMemberStatus(userIdx, 'ACCEPTED', '가입 승인 되었습니다.');
                        });

                        $('.reject-btn').on('click', function() {
                            var userIdx = $(this).data('user-idx');
                            updateMemberStatus(userIdx, 'REJECTED', '가입 승인을 거절하였습니다.');
                        });

                        $('.delete-btn').on('click', function() {
                            var userIdx = $(this).data('user-idx');
                            removeMember(userIdx, '멤버가 삭제되었습니다.');
                        });

                        $('.remove-btn').on('click', function() {
                            var userIdx = $(this).data('user-idx');
                            removeMember(userIdx, '회원 탈퇴가 완료되었습니다.');
                        });
                    });

                    function updateMemberStatus(userIdx, status, message) {
                        var csrfHeaderName = '${_csrf.headerName}';
                        var csrfToken = '${_csrf.token}';

                        $.ajax({
                            url: status === 'ACCEPTED' ? '${root}/studyGroup/approveMember' : '${root}/studyGroup/rejectMember',
                            type: 'POST',
                            data: {
                                studyIdx: ${studyGroup.studyIdx},
                                userIdx: userIdx
                            },
                            beforeSend: function(xhr) {
                                xhr.setRequestHeader(csrfHeaderName, csrfToken);
                            },
                            success: function(response) {
                                if (response.success) {
                                    alert(message);
                                    location.reload();
                                } else {
                                    alert(response.message);
                                }
                            },
                            error: function(jqXHR, textStatus, errorThrown) {
                                console.error('Error updating member status:', errorThrown);
                                alert('멤버 상태 업데이트 중 오류가 발생했습니다.');
                            }
                        });
                    }

                    function removeMember(userIdx, message) {
                        var csrfHeaderName = '${_csrf.headerName}';
                        var csrfToken = '${_csrf.token}';

                        if (confirm('정말로 이 멤버를 삭제하시겠습니까?')) {
                            $.ajax({
                                url: '${root}/studyGroup/removeMember',
                                type: 'POST',
                                data: {
                                    studyIdx: ${studyGroup.studyIdx},
                                    userIdx: userIdx
                                },
                                beforeSend: function(xhr) {
                                    xhr.setRequestHeader(csrfHeaderName, csrfToken);
                                },
                                success: function(response) {
                                    if (response.success) {
                                        alert(message);
                                        location.reload();
                                    } else {
                                        alert(response.message);
                                    }
                                },
                                error: function(jqXHR, textStatus, errorThrown) {
                                    console.error('Error removing member:', errorThrown);
                                    alert('멤버 삭제 중 오류가 발생했습니다.');
                                }
                            });
                        }
                    }
                </script>
            </div>
            <!--콘텐츠 끝-->
        </main>
    </section>
</div>
<!--푸터-->
<jsp:include page="../include/timer.jsp" />
<jsp:include page="../include/footer.jsp" />
</body>
</html>
