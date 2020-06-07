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
	/* position: relative; */
	height: 300px;
	width: 90%;
	margin-left: 30px;
	margin-top: 30px;
	border: 1px solid #996699;
	border-radius: 5px;
	/* 	top: 50px;
	left: 200px; */
}
.form-control{
	width: 70%;
}

#imageTable {
	position: relative;
	top: 100px;
	left: 200px;
}
</style>
<script src="../resources/js/jquery-1.12.1.min.js"></script>
<script type="text/javascript">

$(function(){ 
	$(".asd").on("click",".houseImg",function(){ // 방 이미지 클릭 시 마다 school과 선택한 방 사이의 경로를 찾아줌
		Alat = $(this).attr("ilat"); // 위도와 경도의 경우 해당 사이트 img태그에 ilat 속성으로 부여되어있어 attr로 추출
		Alng = $(this).attr("ilng");
		var center = new google.maps.LatLng(${defaultLat},${defaultLng}); // 유저의 학교(가입시 입력한) 위도 경도를 default로 한다. // 후에 session 정보통해 처리
		var pointA = new google.maps.LatLng(${defaultLat},${defaultLng}); // 학교
		var pointB = new google.maps.LatLng(parseFloat(Alat),parseFloat(Alng)); // 선택한 방 위치
		myOptions = {
		    zoom: 15,
		    center: center,
		    mapTypeId: google.maps.MapTypeId.ROADMAP
		}
	  var image = 'https://ifh.cc/g/INh8S.png';
	  var house_image = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png'; // 도착지 img
	  var school = { lat:${defaultLat},lng:${defaultLng}};
	  var house = { lat:parseFloat(Alat),lng:parseFloat(Alng)}; // 추출한 lat,lng가 string형식이므로 parseFloat()로 형변환
	  map = new google.maps.Map(document.getElementById('map-canvas'), myOptions); // map 생성
	  
	  var marker = new google.maps.Marker({position:house,map:map,title:"HOUSE",animation:google.maps.Animation.DROP,icon:house_image}); // marker 생성 
	  var marker = new google.maps.Marker({position:school,map:map,title:"My School!",animation:google.maps.Animation.DROP,icon:image}); // marker 생성
	  
	  google.maps.event.addListener(marker,'click',function() {
			  map.setZoom(12);
			  map.setCenter(marker.getPosition());
	 });
	    
	  directionsService = new google.maps.DirectionsService; // 길찾기 서비스 
	  directionsDisplay = new google.maps.DirectionsRenderer({ // 길찾기 서비스
	      map: map,
	      suppressMarkers: true
	    }),

	  outputAtoB = document.getElementById('a2b'),

	  // click on marker B to get route from A to B
	  calculateAndDisplayRoute(directionsService, directionsDisplay, pointA, pointB, outputAtoB); // 거리계산
	  
	  // 교통 수단 선택 // transit => 대중교통
	  var travelMode = document.getElementById("mode");
	  travelMode.addEventListener("change", function() {
	    calculateAndDisplayRoute(directionsService, directionsDisplay, pointA, pointB, outputAtoB);
	  });
	  
	  }) // end of .asd click
	
	$('#btn_place').click(function(){ // 학교와 방 사이의 경로 찾기와 주변 검색을 위한 코드
	      $.ajax({
	        	type : 'get',
	        	url : 'placeFindAjax.do', // controller mapping
	        	//contentType : 'application/x-www-form-urlencoded;charset=UTF-8',
	        	data : "placeSel="+$("select[name='place']").val(),  // 주변검색하려는 장소를 데이터로 전송
	        	success : function(placeArray){	// resultData 결과 받아 출력 // ajax 출력함수
	        		var center = new google.maps.LatLng(${defaultLat},${defaultLng}); // 유저의 학교(가입시 입력한) 위도 경도를 default로 한다. // 후에 session 정보통해 처리
	        		var pointA = new google.maps.LatLng(${defaultLat},${defaultLng}); // 학교
	        		var pointB = new google.maps.LatLng(parseFloat(Alat),parseFloat(Alng)); // 선택한 방 위치
	        		myOptions = {
	        		    zoom: 15,
	        		    center: center,
	        		    mapTypeId: google.maps.MapTypeId.ROADMAP // map type // ROADMAP => 기본지도
	        		}
	        	  var image = 'https://ifh.cc/g/INh8S.png'; 
	        	  var house_image = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png';
	        	  var school = { lat:${defaultLat},lng:${defaultLng}};
	        	  var house = { lat:parseFloat(Alat),lng:parseFloat(Alng)};
	        	  map = new google.maps.Map(document.getElementById('map-canvas'), myOptions); // map 생성 
	        	  
	        	  var marker_house = new google.maps.Marker({position:house,map:map,title:"HOUSE",animation:google.maps.Animation.DROP,icon:house_image}); // marker 생성
	        	  var marker_school = new google.maps.Marker({position:school,map:map,title:"My School!",animation:google.maps.Animation.DROP,icon:image}); // marker 생성
	        	  
	        	  var places = placeArray; // placeArray는 controller를 통해 가져온 [['title','lat','lng','zIndex','iconURL']] 형식의 데이터 구조
	        		
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
	        				          scaledSize: new google.maps.Size(25, 25),  // ICON 크기 조절 => scaledSize
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
	        			
	  	        	  directionsService = new google.maps.DirectionsService; //길찾기 서비스
		        	  directionsDisplay = new google.maps.DirectionsRenderer({map: map, suppressMarkers: true}); //길찾기 서비스
	        			
	        		  outputAtoB = document.getElementById('a2b')

	   	        	  // click on marker B to get route from A to B
	   	        	  calculateAndDisplayRoute(directionsService, directionsDisplay, pointA, pointB, outputAtoB);

	   	        	  var travelMode = document.getElementById("mode");
	   	        	  travelMode.addEventListener("change", function() {
	   	        	    calculateAndDisplayRoute(directionsService, directionsDisplay, pointA, pointB, outputAtoB);
	   	        	  });	
	   	        	  
	        	} // end of  ajax success 	
	        }) // end of ajax 
	}) // end of btn_place click

		  
	}) // end of jquery
	
function initMap() {  // 지도 초기화 함수 // 페이지가 새로 로딩되면 이 함수가 자동으로 callback됨 // 주석 bf_room_first 참조
				var center = new google.maps.LatLng(${defaultLat},${defaultLng}); // 유저의 학교(가입시 입력한) 위도 경도를 default로 한다. // 후에 session 정보통해 처리
				myOptions = {
			      zoom: 15,
			      center: center,
			      mapTypeId: google.maps.MapTypeId.ROADMAP
				}	
		  var image = 'https://ifh.cc/g/INh8S.png'
	      var school = { lat: ${defaultLat} , lng: ${defaultLng}};
		  var map = new google.maps.Map(document.getElementById('map-canvas'), myOptions);
		  var marker = new google.maps.Marker({position: school, map: map, title:"My School!",animation: google.maps.Animation.DROP, icon:image});
		  
		  /* var marker = new google.maps.Marker({position: school, map: map, title:"My School!",animation: google.maps.Animation.DROP, icon:image}); */

		  directionsService = new google.maps.DirectionsService;
		  directionsDisplay = new google.maps.DirectionsRenderer({
		      map: map
		    }),
	
		  outputAtoB = document.getElementById('a2b')
		}

function calculateAndDisplayRoute(directionsService, directionsDisplay, pointA, pointB, outputTxt) {
		  var selectedMode = "TRANSIT" 
		  directionsService.route({
		    origin: pointA,
		    destination: pointB,
		    unitSystem: google.maps.UnitSystem.METRIC,
		    travelMode: google.maps.TravelMode[selectedMode]
		  }, function(response, status) {
		    if (status == google.maps.DirectionsStatus.OK) {
		      directionsDisplay.setDirections(response);
	
		      outputTxt.innerHTML = Math.round(directionsDisplay.getDirections().routes[directionsDisplay.getRouteIndex()].legs[0].distance.value / 1000) + "Km";
		    } else {
		      window.alert('Directions request failed due to ' + status);
		    }
		  });
		}

</script>
<!-- 요청 완료시 실행할 콜벡 메서드 지정해야함  // &callback=initMap -->
<script async defer
	src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCD6_OljOx_t2AfEE40wH0ZLrEwtLWT2fs&libraries=places&callback=initMap"></script>
</head>
<body>

	<jsp:include page="header.jsp"></jsp:include>
	<!-- statr-->
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
				style="background-color: #f8f8f8; height: 300px; content-align: center;">
				<form action="sendHouseInfo.do" method="get">
					<div class="row opt" style="">
						<div class="col-lg-2">
							<h4>학교 선택</h4>
							<select id='schoolMine' name="school" class="form-control" style="width:95%">
								<option value="${defaultSchool}">My School</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>보증금 최소</h4>
							<select class="form-control" name="depositMin" value="보증금 최소">
								<option value="0">0만</option>
								<option value="100">100만</option>
								<option value="500">500만</option>
								<option value="1000">1000만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>보증금 최대</h4>
							<select class="form-control" name="depositMax" value='보증금 최대'>
								<option value="0">0만</option>
								<option value="100">100만</option>
								<option value="500">500만</option>
								<option value="1000">1000만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>월세 최소</h4>
							<select class="form-control" name="monthMin" value="월세 최소">
								<option value="0">0만</option>
								<option value="0">10만</option>
								<option value="40">40만</option>
								<option value="50">50만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>월세 최대</h4>
							<select class="form-control" name="monthMax" value='월세 최대'>
								<option value="9999">무제한</option>
								<option value="0">0만</option>
								<option value="60">60만</option>
								<option value="70">70만</option>
							</select>
						</div>
						<div class="col-lg-2">
							<h4>입력 완료</h4>
							<input type='submit' value='선택완료' id='btn' class="btn btn-primary">
						</div>
					</div>
				</form>

				<form action="placeFindAjax.do" method="post">
					<select class="form-control"  name='place' style="width:133px; margin-left:1px; margin-top:10px;">
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
					</select> <input type="button" value="검색" id='btn_place' class="btn btn-primary" style="margin-left:40px; width:75px;">
				</form>

				<div id="map-canvas"></div>

			</div>
				<!-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  -->
			<div>
				<aside id="output" style="margin-top:200px; margin-left:100px">
					<h5>Distance</h5>
					<b> 학교까지의 거리 </b><span id="a2b"></span>
				</aside>
			</div> 
			<br><br>
			<div style="margin-top: 10px; margin-left: 30px;">
				<c:forEach var="i" begin="0" end="5">
					<div class="card asd"
						style="border: 1px solid gold; float: left; width: 33%; height:340px;">
						<img src="https://${img.get(i)}" text-align=center; alt="post"
							class="houseImg" width=170px; height=100px; cursor=pointer;
							ilat="${latMine.get(i)}" ilng="${lngMine.get(i)}" />
						<div class="card-body">
							<span class="card-text">${greenbadge.get(i)}</span>
							<span class="card-title"><h4>${price.get(i)}</h4></span>
							<p class="card-title">${addr.get(i)}</p>
	 						<p class="card-text">${subtext.get(i)}</p>
							<p class="card-text">${bluebadge.get(i)}</p>
						</div>
					</div>
				</c:forEach>
			</div>

			<%--                      <div id="imageTable" class="media post_item">
                     <c:forEach var="i" begin="0" end="4">
                     	<img src="https://${img.get(i)}" alt="post" class="houseImg" ilat="${latMine.get(i)}" ilng="${lngMine.get(i)}")>
                     		<div class="media-body">
                            	<h4>${price.get(i)}</h4>
                           		<p>${alltext.get(i)}</p>
                        	</div>
                     </c:forEach>
                     </div> --%>

		</div>

	</div>





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