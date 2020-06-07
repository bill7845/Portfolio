package be.friend.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import be.friend.basic.Geocoding;
import be.friend.basic.PlaceDetail;
import be.friend.basic.PlaceFind;
import be.friend.basic.PlaceFindSecond;
import be.friend.basic.ReverseGeocoding;
import be.friend.basic.SchoolCraw;
import be.friend.basic.SeleniumTest;
import be.friend.dao.HouseDao;
import be.friend.domain.TestVO;
import be.friend.service.HouseService;

@Controller
@RequestMapping("/befriend/")
public class TestController {	
	
	String defaultSchool = ""; // 유저의 학교이름
	
	@Autowired
	private HouseService houseService;
		
	String userSchool ="";
		
	// 화면만 넘기는 메서드
	@RequestMapping("houseView.do")
	public void common() {  
	}
	
	// 메인page에서 방구하기 페이지로 넘어올때 실행
	// 초기실행 
	@RequestMapping(value="bf_room_first.do", method=RequestMethod.GET) 
	public ModelAndView common2(HttpSession session){ // session 값 갖고 올것
		
		String userEmail = (String)session.getAttribute("userEmail");
		
		TestVO vo = new TestVO();
		vo.setUserEmail(userEmail);
		
		defaultSchool = houseService.schoolCheck(vo);
		
		ModelAndView mv = new ModelAndView();
		Geocoding geo = new Geocoding(); // 학교이름 -> 위도,경도 반환 
		JSONObject resJs = geo.Gps(defaultSchool); // JSONObject로 위도,경도 값 받아옴
				
		// 위도,경도 값을 view로 보냄
		mv.addObject("defaultLat",resJs.get("lat"));
		mv.addObject("defaultLng",resJs.get("lng"));
		mv.addObject("defaultSchool",defaultSchool);
		mv.setViewName("befriend/bf_room_first"); // target view
		
		return mv;
	}
	
	
	// 방구하기 크롤링 
	@RequestMapping("sendHouseInfo.do") 
	public ModelAndView sendHouseInfo(TestVO testVO) { // first view에서 session 값 갖고 올것
		ModelAndView mv = new ModelAndView();
		
		Geocoding geo = new Geocoding(); // 학교이름 -> 위도,경도 반환 
		
		userSchool = testVO.getSchool();
		
		JSONObject resJs = geo.Gps(testVO.getSchool()); // JSONObject로 위도,경도 값 받아옴
		
		ReverseGeocoding geoReverse = new ReverseGeocoding(); // 위도,경도 -> 주소로 변환
		String addresMine = geoReverse.address(resJs.get("lat"),resJs.get("lng")); // 학교이름 -> 위도,경도 -> 주소
//		System.out.println(addresMine);

		SeleniumTest selenium = new SeleniumTest(); // new로 selenium 객체 생성 // @Service X
		ArrayList<ArrayList> result = selenium.crawl(testVO, addresMine); // 크롤링 해온 결과를 ArrayList안의 ArrayList 형태로 받아옴 // 크롤링클래스로 넘기는 인자는 VO와 ReverseGeocoding으로 변환시킨 주소임
		// ArryayList안의 ArrayList들을 원하는 형식에 맞게 꺼냄
		ArrayList price = result.get(0); 
		ArrayList addr = result.get(1);
		ArrayList img = result.get(2);
		ArrayList latMine = result.get(3);
		ArrayList lngMine = result.get(4);
		ArrayList subtext = result.get(5);
		ArrayList alltext = result.get(6);
		ArrayList bluebadge = result.get(7);
		ArrayList greenbadge = result.get(8);
		
//		System.out.println(result);
		
		// view로 ArrayList들을 넘김
		mv.addObject("defaultLat",resJs.get("lat")); // 유저의 학교 위도
		mv.addObject("defaultLng",resJs.get("lng")); // 유저의 학교  경도
		mv.addObject("price",price);
		mv.addObject("addr",addr);
		mv.addObject("img",img);
		mv.addObject("latMine",latMine);
		mv.addObject("lngMine",lngMine);
		mv.addObject("subtext",subtext);
		mv.addObject("alltext",alltext);
		mv.addObject("bluebadge",bluebadge);
		mv.addObject("greenbadge",greenbadge);
		
		mv.setViewName("befriend/bf_room_second");

		return mv;
	}
	
	//지역별 학교
	@RequestMapping("schoolSelect.do")
	@ResponseBody // 비동기 통신 위해 // return 시 반드시 있어야함
	public ArrayList schoolSelect(String city) { // url Query로 받아온 city
		
		String userCity = city; // 유저의 지역 받아옴
		
		SchoolCraw schoolCraw = new SchoolCraw(); // 지역별 학교명 크롤링
		Map resSelectBox = schoolCraw.crawSchool(); // Map<String,ArrayList> 형식으로 받아옴
		
		 // 지역별 학교를 각 ArrayList에 담음
		 ArrayList seoulList = new ArrayList();
		 ArrayList sixList = new ArrayList();
		 ArrayList gunggiList = new ArrayList();
		 ArrayList gangwonList = new ArrayList();
		 ArrayList chungcheongList = new ArrayList();
		 ArrayList jeonlaList = new ArrayList(); 
		 ArrayList geongsangList = new ArrayList();
		 ArrayList jejuList = new ArrayList();
		
		 seoulList = (ArrayList) resSelectBox.get("seoul"); 
		 sixList = (ArrayList) resSelectBox.get("six");
		 gunggiList = (ArrayList) resSelectBox.get("gunggi");
		 gangwonList = (ArrayList) resSelectBox.get("gangwon");
		 chungcheongList = (ArrayList) resSelectBox.get("chungcheong");
		 jeonlaList = (ArrayList) resSelectBox.get("jeonla");
		 geongsangList = (ArrayList) resSelectBox.get("geongsang");
		 jejuList = (ArrayList) resSelectBox.get("jeju");
		 
		 // view로 보낼 결과 ArrayList 생성
		 ArrayList resList = new ArrayList();
		 
		 if(userCity.equals("서울특별시")) {
			 resList = (ArrayList) resSelectBox.get("seoul");
			 System.out.println(resList);
		 }else if (userCity.equals("6대 광역시")) {
			 resList = (ArrayList) resSelectBox.get("six");
		 }else if (userCity.equals("경기도")) {
			 resList = (ArrayList) resSelectBox.get("gunggi");
		 }else if (userCity.equals("충청도")) {
			 resList = (ArrayList) resSelectBox.get("chungcheong");
		 }else if (userCity.equals("전라도")) {
			 resList = (ArrayList) resSelectBox.get("jeonla");
		 }else if (userCity.equals("경상도")) {
			 resList = (ArrayList) resSelectBox.get("geongsang");
		 }else if (userCity.equals("제주도")) {
			 resList = (ArrayList) resSelectBox.get("jeju");
		 }
		 
		 return resList;
	}
	
	// 주변검색 
	@RequestMapping("placeFind.do")
	public ModelAndView placeFind(TestVO vo) {
		
		Geocoding geo = new Geocoding(); // 장소명 => 위도,경도 반환 클래스
		JSONObject resJs = geo.Gps(defaultSchool); // JSONObject로 반환
		
		double lat = (double) resJs.get("lat"); // JSONObject에서 lat만 parsing
		double lng = (double) resJs.get("lng"); // JSONObject에서 lat만 parsing
		
		PlaceFind place = new PlaceFind(); // 위도,경도,검색대상을 통해 주변검색 반환 클래스
		ArrayList<ArrayList> placeArray = place.placeFind(lat, lng, vo); // ArrayList<ArrayList>형식으로 반환 // 위도,경도,검색대상을 인자로 함
		
		ModelAndView mv = new ModelAndView();
		
		mv.addObject("placeArray",placeArray);
		// 위도,경도 값을 view로 보냄
		mv.addObject("defaultLat",resJs.get("lat"));
		mv.addObject("defaultLng",resJs.get("lng"));
		mv.addObject("select", vo.getPlace());
		
		mv.setViewName("befriend/bf_room_first");
		
		return mv;
	}
		
	// 길찾기 + 주변검색 
	@RequestMapping("placeFindAjax.do")
	@ResponseBody
	public ArrayList<ArrayList> placeAjax(String placeSel){ // url Query로 가져온 검색대상
		
		Geocoding geo = new Geocoding(); // 장소명 => 위도,경도 반환 클래스
		JSONObject resJs = geo.Gps(userSchool); //userSchool은 전역변수로 설정해놓은 유저의 defaultSchool //JSONObject로 위도,경도에 대한 정보 반환
		
		// JSON parsing
		double lat = (double) resJs.get("lat");
		double lng = (double) resJs.get("lng");
		
		PlaceFindSecond place = new PlaceFindSecond();
		ArrayList<ArrayList> placeArray = place.placeFind(lat, lng, placeSel);
		System.out.println(placeArray);
		
		return placeArray;
	}
}
