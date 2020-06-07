<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<!-- Required meta tags -->

<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">
<title>BeFriend</title>
<link rel="icon" href="../resources/img/favicon.png">
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="../resources/css/bootstrap.min.css">
<!-- animate CSS -->
<link rel="stylesheet" href="../resources/css/animate.css">
<!-- owl carousel CSS -->
<link rel="stylesheet" href="../resources/css/owl.carousel.min.css">
<!-- themify CSS -->
<link rel="stylesheet" href="../resources/css/themify-icons.css">
<!-- flaticon CSS -->
<link rel="stylesheet" href="../resources/css/flaticon.css">
<!-- font awesome CSS -->
<link rel="stylesheet" href="../resources/css/magnific-popup.css">
<!-- swiper CSS -->
<link rel="stylesheet" href="../resources/css/slick.css">
<link rel="stylesheet" href="../resources/css/all.css">
<!-- style CSS -->
<link rel="stylesheet" href="../resources/css/style.css">
<link rel="stylesheet" href="../resources/css/styleA.css">
<style type="text/css">
#map-canvas {
	position: relative;
	height: 300px;
	width: 100%;
	border: 1px solid #996699;
	border-radius: 5px;
	top: 50px;
	left: 0px;
}

.form-control {
	width: 70%;
}
.lds-heart {
  display: inline-block;
  position: relative;
  width: 64px;
  height: 64px;
  transform: rotate(45deg);
  transform-origin: 32px 32px;
}
.lds-heart div {
  top: 23px;
  left: 19px;
  position: absolute;
  width: 26px;
  height: 26px;
  background: red;
  animation: lds-heart 1.2s infinite cubic-bezier(0.215, 0.61, 0.355, 1);
}
.lds-heart div:after,
.lds-heart div:before {
  content: " ";
  position: absolute;
  display: block;
  width: 26px;
  height: 26px;
  background: red;
}
.lds-heart div:before {
  left: -17px;
  border-radius: 50% 0 0 50%;
}
.lds-heart div:after {
  top: -17px;
  border-radius: 50% 50% 0 0;
}
@keyframes lds-heart {
  0% {
    transform: scale(0.95);
  }
  5% {
    transform: scale(1.1);
  }
  39% {
    transform: scale(0.85);
  }
  45% {
    transform: scale(1);
  }
  60% {
    transform: scale(0.95);
  }
  100% {
    transform: scale(0.9);
  }
}
#dialog-background {
          display: block;
          position: fixed;
          top: 0; left: 0;
          width: 100%; height: 100%;
          background: rgba(0,0,0,.3);
          z-index: 10;
      }
#heart{
	 z-index: 100;
}
</style>
<!-- 요청 완료시 실행할 콜벡 메서드 지정해야함  // &callback=initMap -->
<script src="../resources/js/jquery-1.12.1.min.js"></script>
<script type="text/javascript">
$(function(){ // 지역별 학교리스트 selectbox // 동적 
	
	 $("#btn").click(function(event){
		 	$("#dialog-background").show();
	        $("#heart").show();
	        $("#optionForm").submit();
	 });
	
	 $("#heart").hide();
	 $("#dialog-background").hide();
	
	$('.hell').click(function(){ // .hell 클릭 시 마다 ajax로 지역별 대학 리스트 실시간 크롤링
	      $.ajax({
	        	type : 'get',
	        	url : 'schoolSelect.do', // controller mapping
	        	//contentType : 'application/x-www-form-urlencoded;charset=UTF-8',
	        	data : "city="+$(this).val() ,  // 유저가 선택한 지역을 데이터로 전송
	        	success : function(resultData){	// ajax 후 출력 함수	  // resultData 결과 받아 출력
	        		$('#schoolMine').children("option").remove(); // 기존 select box 초기화
	        		for(var i=0; i<resultData.length; i++){
	        			 var option = "<option value='" + resultData[i]+"'>"+resultData[i]+"</option>";
	        			 $('#schoolMine').append(option);
	        		}	        			
	        	} 	
	        })
	});
	$("select[name='place']").val("${select}");	
	
	$('#btn').addClass('spinner');
})
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 		    var map;
			function initMap() { // map 초기화 함수 // callback 함수에 의해 이 함수가 가장 먼저 실행된다.
					var center = new google.maps.LatLng(${defaultLat},${defaultLng}); // 유저의 학교(가입시 입력한) 위도 경도를 default로 한다. // 후에 session 정보통해 처리
					myOptions = {
				      zoom: 15,
				      center: center,
				      mapTypeId: google.maps.MapTypeId.ROADMAP // 지도 type 결정 // ROADMAP => 기본지도
					}

			  var image = 'https://ifh.cc/g/INh8S.png' // School img
			  var school = { lat: ${defaultLat} , lng: ${defaultLng}}; 
			  map = new google.maps.Map(document.getElementById('map-canvas'), myOptions); // map 생성 함수 
			  var marker_school = new google.maps.Marker(
					  {position: school,
					   map: map,
					   title:"My School!",
					   animation: google.maps.Animation.DROP,
					   icon:image
					  }); // marker생성 함수
			  
			  // 학교 주변 검색을 위한 코드
			  <c:if test="${!empty placeArray}"> // 주변 검색창의 값의 있을 경우에만 실행 위해서
				var places = ${placeArray}; // placeArray는 controller를 통해 가져온 [['title','lat','lng','zIndex','iconURL']] 형식의 데이터 구조
					var shape = {
					          coords: [1, 1, 1, 20, 18, 20, 18, 1],
					          type: 'poly'
					        };
					var markers = [];
					for (var i = 0; i < places.length; i++) {
				          var place = places[i];
				          var marker = new google.maps.Marker({
				            position: {lat: place[1], lng: place[2]},
				            map: map,
				            icon: {
						          url: place[4],
						          scaledSize: new google.maps.Size(25, 25), // ICON 크기 조절 => scaledSize
						          origin: new google.maps.Point(0, 0),
						          anchor: new google.maps.Point(0, 32)
						        },
				            shape: shape,
				            title: place[0],
				            zIndex: place[3]
				          });
				          markers.push(marker);
				          
				         				          
				        }
					for(var j=0; j< markers.length; j++){
					
				          markers[j].addListener('click', function() {
				        	  	 var idx = 0; 
				        	  	 for(var k=0; k<markers.length; k++){
				        	  		 if(markers[k] == this) { idx=k; break; }
				        	  	 }
					        	  new google.maps.InfoWindow({
				                  content: places[idx][0]
				                }).open(map,this);
				          })
					}
				</c:if>

}
		          

				
</script>
<!-- api 호출 시 callback 함수로 initMap() 호출  -->
<script async defer
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCD6_OljOx_t2AfEE40wH0ZLrEwtLWT2fs&libraries=places&callback=initMap"></script>
</head>
<body>

	<jsp:include page="header.jsp"></jsp:include>
	<div class="body-form">

		<div class="navbar-side">
			<div>
				<div class="in-out">
					<h4 style="text-align: center; margin: 30px">지역 선택</h4>
					<input type="button" class='hell' value="서울특별시" /> <input
						type="button" class='hell' value="6대 광역시" /> <input type="button"
						class='hell' value="경기도" /> <input type="button" class='hell'
						value="충청도" /> <input type="button" class='hell' value="전라도" />
					<input type="button" class='hell' value="경상도" /> <input
						type="button" class='hell' value="제주도" />
				</div>
			</div>
		</div>

		<div>
			<div class="container w-100"
				style="background-color: #f8f8f8; height: 700px; content-align: center; margin: 0px;">


				<form id="optionForm" action="sendHouseInfo.do" method="get">
					<div class="row opt" style="padding: 90px; margin: -90px;">
						<div class="col-lg-2">
							<h4>학교 선택</h4>
							<select id='schoolMine' name="school" class="form-control"
								style="width: 95%">
								<option value="${defaultSchool}">My School</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>보증금 최소</h4>

							<select class="form-control" name="depositMin">
								<option value="0">0만</option>
								<option value="100">100만</option>
								<option value="500">500만</option>
								<option value="1000">1000만</option>
								<option value="2000">2000만</option>
								<option value="3000">3000만</option>
								<option value="4000">4000만</option>
								<option value="5000">5000만</option>
								<option value="10000">1,000만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>보증금 최대</h4>
							<select class="form-control" name="depositMax">
								<option value="99999">무제한</option>
								<option value="0">0만</option>
								<option value="100">100만</option>
								<option value="500">500만</option>
								<option value="1000">1000만</option>
								<option value="2000">2000만</option>
								<option value="3000">3000만</option>
								<option value="4000">4000만</option>
								<option value="5000">5000만</option>
								<option value="10000">1,000만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>월세 최소</h4>
							<select class="form-control" name="monthMin">
								<option value="0">0만</option>
								<option value="0">10만</option>
								<option value="20">20만</option>
								<option value="30">30만</option>
								<option value="40">40만</option>
								<option value="50">50만</option>
								<option value="60">60만</option>
								<option value="70">70만</option>
								<option value="80">80만</option>
								<option value="90">90만</option>
								<option value="100">100만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>월세 최대</h4>
							<select class="form-control" name="monthMax">
								<option value="99999">무제한</option>
								<option value="0">0만</option>
								<option value="0">10만</option>
								<option value="20">20만</option>
								<option value="30">30만</option>
								<option value="40">40만</option>
								<option value="50">50만</option>
								<option value="60">60만</option>
								<option value="70">70만</option>
								<option value="80">80만</option>
								<option value="90">90만</option>
								<option value="100">100만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>입력 완료</h4>
							<input type='button' value='선택완료' id='btn'
								class="btn btn-primary">
						</div>
					</div>
				</form>
				<div id="heart" class="lds-heart" style="position:absolute; margin-left:450px; margin-top:100px;"><div></div></div>  <!-- ####################################################################################  -->
				<form action="placeFind.do" method="post">
					<select class="form-control" name='place'
						style="width: 133px; margin-left: 15px; margin-top: 10px;">
						<option value="" disabled selected hidden>주변 검색</option>
						<option value="bank">은행</option>
						<option value="subway_station">지하철역</option>
						<option value="bus_station">버스 정류장</option>
						<option value="supermarket">편의점</option>
						<option value="park">공원</option>
						<option value="church">교회</option>
						<option value="hospital">병원</option>
						<option value="movie_theater">영화관</option>
						<option value="pharmacy">약국</option>
						<option value="restaurant">레스토랑</option>
					</select> <input type="submit" value="검색" id='btn_place'
						class="btn btn-primary" style="margin-left: 40px; width: 75px;">
				</form>

				<div id="map-canvas"></div>

			</div>
		</div>

		</div>
		<div id="dialog-background"></div>
		<!-- jquery plugins here-->
		<!-- jquery -->
		<!-- popper js -->
		<script src="../resources/js/popper.min.js"></script>
		<!-- bootstrap js -->
		<script src="../resources/js/bootstrap.min.js"></script>
		<!-- easing js -->
		<script src="../resources/js/jquery.magnific-popup.js"></script>
		<!-- swiper js -->
		<script src="../resources/js/swiper.min.js"></script>
		<!-- swiper js -->
		<script src="../resources/js/masonry.pkgd.js"></script>
		<!-- particles js -->
		<script src="../resources/js/owl.carousel.min.js"></script>
		<script src="../resources/js/jquery.counterup.min.js"></script>
		<script src="../resources/js/waypoints.min.js"></script>
		<script src="../resources/js/owl.carousel2.thumbs.min.js"></script>
		<!-- swiper js -->
		<script src="../resources/js/slick.min.js"></script>
		<!-- custom js -->
		<script src="../resources/js/custom.js"></script>
</body>

</html>