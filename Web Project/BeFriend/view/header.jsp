<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
    <style type="text/css">
    	#profile{
    		width : 40px;
    		height : 40px;
    		cursor : pointer;
    	}
    	#myPage{
		    width:335px;height:201px;background:url("../resources/img/usergroup_bg.png");
		    position:absolute;left:-110px;
  			top:-500px;z-index:15;padding:40px 0 0 30px;
		}
		a{
			cursor: pointer;		
		}
    </style>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script type="text/javascript">
	$(function(){
		$("#myPage").hide();
		
		$("#profile").click(function(){
			$("#myPage").css({"top":"70px", "left":"1058px"});
			$("#myPage").toggle();
		});
	});

</script>    
</head>
<body>
<!--::header part start::-->
    <header class="main_menu">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-12">
                    <nav class="navbar navbar-expand-lg navbar-light">
                        <a class="navbar-brand" href="main.do"> <img src="../resources/img/befriend_logo.png" alt="logo"> </a>
                        <button class="navbar-toggler" type="button" data-toggle="collapse"
                            data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                            aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>
                        <div class="collapse navbar-collapse main-menu-item justify-content-end"
                            id="navbarSupportedContent">
                            <ul class="navbar-nav">
                                <li class="nav-item">
                                    <a class="nav-link" href="groupList.do">스터디</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="bf_travel.do">여행</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="side.do">취미공유</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link" href="bf_room_first.do">방구하기</a>
                                <li class="nav-item dropdown">
                                    <a class="nav-link dropdown-toggle" href="blog.html" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                                           	고객센터
                                    </a>
                                    <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                                        <a class="dropdown-item" href="single-blog.html">Single blog</a>
                                        <a class="dropdown-item" href="elements.html">Elements</a>
                                    </div>
                                </li>
                                <c:choose>
									<c:when test="${empty sessionScope.userEmail }">
										<li class="nav-item">
		                                    <a class="nav-link" href="login.do">로그인</a>
		                                </li>
									</c:when>
									<c:otherwise>
										<li class="nav-item">
											<img id="profile" alt="userImg" src="../resources/upload/${sessionScope.userEmail }.png">
		                                </li>
										<li class="nav-item">
		                                    <a class="nav-link" href="logout.do">로그아웃</a>
		                                </li>
									</c:otherwise>
								</c:choose>
                            </ul>
                        </div>
                    </nav>
                </div>
            </div>
        </div>
    </header>
    <c:if test="${!empty sessionScope.userEmail }">
    <div id="myPage">
        <table>
        	<tr>
        		<td>가입 그룹</td>
        	</tr>
       		<c:forEach var="gl" items="${sessionScope.userJoinGroup }">
        	<tr>
        		<td><a href="groupMain.do?g_id=${gl.j_group_id }">${gl.group.g_name }</a></td>
        	</tr>
			</c:forEach>
        </table>
    </div>
    </c:if>
</body>
</html>