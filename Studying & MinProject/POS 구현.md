---
layout: post
title: 플레이데이터 프로젝트_1
comments: true
categories: [Think/Note]
tags: [Project]
---

<br>

# <center> Pos 시스템 구축  </center>
---

<br>

## 1. 프로젝트 개요 및 사용자 요구사항

<br>

<p> <b> POS(Point-of-Sale) 시스템을 구축하여 효율적 매출관리를 지원하며, 고객 경험을 개선하고 비즈니스 운영을 간소화 </b> </p>

<br>

---
* **계정**
> 관리자와 일반종업원 계정별로 접근 권한을 달리 부여 <br>
> 일반종업원은 시스템의 판매탭에만 접근 가능하며 관리자계정은 모든 시스템에 접근 가능<br>
> 로그인 화면에서 id,password를 입력작업을 통해 계정 구분

<br>

---

<br>

* **판매**
> 판매 화면에서 제품버튼을 클릭 시 판매목록에 클릭 한 제품이 추가되며, 가격란에 가격이 합산 되어 출력됨<br>
> 동일제품 중복클릭시 해당 제품이 판매리스트에 중복추가됨 <br>
> 제품 한 개당 하나의 판매번호를 가짐<br>
> '취소' 버튼을 통해 주문을 취소 할 수있으며 취소버튼 클릭시 추가 된 판매리스트 또한 초기화 됨 <br>
> 회원과 비회원 여부에 따라 적립/비적립 방식으로 결제 기능 수행 <br>
> 회원 결제의 경우, 회원번호 입력 후 구매금액에 따라 마일리지 적립됨


<br>

---

<br>

* **매출**
> 결제과정을 거쳐, 연결 된 DB에 저장된 판매 Data를 가져와 매출 요약 화면 구현<br>
> 판매 된 제품별 매출 그래프 구현<br>
> 해당 매장의 일,월별 매출 그래프 구현


<br>

---

<br>

* **재고**
> 해당 매장의 제품이 판매될때마다 연결된 DB에서 제품의 원재료 보유수량을 차감시킴<br>
> 재고 탭에서 원재료의 잔여수량을 실시간으로 확인 가능<br>
> 재고 탭에서 원재료 잔여수량 확인 후 발주버튼 통해 발주수량 입력 및 발주 기능

<br><br>

## 2. 프로젝트 모델 설계
---

<br>

#### 2.1 ERD 설계

![Alt text](/assets/img/erd.png)

<br>

#### 2.2 클래스 설계

![Alt text](/assets/img/class.png)

<br><br>

## 3. 구현 화면 및 코드
---

<br>

#### 3.1 판매탭 버튼별 기능
---

<br>

![Alt text](/assets/img/sellMain.png)

```java
// 화면구성 class

// String ame = "0001";
// String latte = "0002";
// String moca = "0003";
// String lemon = "0004";
// String bagel = "0005";
// String milk = "0006";
// String cake = "0007";
// String water = "0008";
// String beer = "0009";

// ArrayList list = new ArrayList() ;  // 제품버튼 클릭시 제품 고유번호(String)를 받는 ArrayList

public void actionPerformed(ActionEvent ev) {	// 액션 리스너
  if (ev.getSource() == bAmericano) {
    list.add(ame);  // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(ame);  
  }else if(ev.getSource() == bCafelatte) {
    list.add(latte);  // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(latte);
  }else if(ev.getSource() == bCafemoca) {
    list.add(moca); // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(moca);
  }else if(ev.getSource() == bLemonade) {
    list.add(lemon);  // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(lemon);
  }else if(ev.getSource() == bBagel) {
    list.add(bagel);  // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(bagel);
  }else if(ev.getSource() == bMilk) {
    list.add(milk); // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(milk);
  }else if(ev.getSource() == bCake) {
    list.add(cake); // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(cake);
  }else if(ev.getSource() == bWater) {
    list.add(water);  // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(water);
  }else if(ev.getSource() == bBeer) {
    list.add(beer); // 버튼 클릭시 해당 제품 고유번호 list에 추가
    p_List(beer);			
  }else if(ev.getSource() == bPayment) {  // 결제버튼 클릭시 작동
    int i = JOptionPane.showConfirmDialog(null, "적립 하십니까?");  // showConfirmDialog로 예/아니오( int 0 or 1) 값 받기
    if (i == 0) { // "예" 선택시
      String memberNum = JOptionPane.showInputDialog(null,"회원번호를 입력 하세요");  // 회원번호(String)값 입력받기
      MemberNum(memberNum);	// 회원번호 입력 메서드 실행
      Payment(); // 결제 메서드 실행
      JOptionPane.showMessageDialog(null, "결제 진행합니다..1");
      JOptionPane.showMessageDialog(null, "결제완료");
    } else if (i == 1) {  // "아니오" 선택시
      Payment();  // 결제 메서드 실행
      JOptionPane.showMessageDialog(null, "결제 진행합니다..2");
      JOptionPane.showMessageDialog(null, "결제완료");

    }
  }
}

```

<br>

#### 3.2 판매탭 기능별 method 구현
---

<br>

* **비회원 결제 메서드**

```java
public void InsertPayment1(ArrayList payment) throws Exception {  //판매탭에서 입력받은 제품 고유번호를 인자로

  Connection con = DriverManager.getConnection(url, user, pass);  // oracle 연결 객체 생성
  PreparedStatement st2 = null; // 연결통로

  for (int i = 0; i < payment.size(); i++) {  // ArrayList에 담겨있는 제품의 개수 만큼 반복문 실행
      String sql2 ="INSERT INTO SELL  (SELLNO, ENO, PNO, SELLCOUNT, SELLDATE)   VALUES  (SEQ_SELLNO.nextval,'A1111',   '"+payment.get(i)+"'  , 1, sysdate)"  ;    // 받아온 제품리스트를 제품 고유번호에 따라 연결된 DB에 입력하는 sql문장
      st2 = con.prepareStatement(sql2);

      st2.executeUpdate();  // 연결 실행
    }
  con.commit();
  st2.close();
  con.close();
}
```

<br>

* **회원번호 method**

```java
// 받아온 회원번호를 판매모델의 전역변수로 설정해줌

String memberNum;

public void InsertMemberNum(String memberNum) throws Exception {
  this.memberNum = memberNum;
}
```

<br>

* **회원결제 method**

```java

public void InsertPayment(ArrayList payment) throws Exception { //판매탭에서 입력받은 제품 고유번호를 인자로

		Connection con = DriverManager.getConnection(url, user, pass);
		PreparedStatement st2 = null;
		PreparedStatement st3 = null;
		PreparedStatement st4 = null;

    // Sell 테이블 sql
		for (int i = 0; i < payment.size(); i++) {  // ArrayList에 담겨있는 제품의 개수 만큼 반복문 실행
				String sql2 ="INSERT INTO SELL  (SELLNO, CNO , ENO, PNO, SELLCOUNT, SELLDATE)   VALUES  (SEQ_SELLNO.nextval, ?, 'A1111',   '"+payment.get(i)+"'  , 1, sysdate)"  ;  // 받아온 제품리스트를 제품 고유번호에 따라 연결된 DB에 입력하는 sql문장

				st2 = con.prepareStatement(sql2);
				st2.setString(1,memberNum); // 1번째 ?에 회원번호(전역변수로 설정 된 회원번호) 입력

				st2.executeUpdate();  
				st2.close();

        // 마일리지 sql
        // 회원가입되어있는 CUSTOMER테이블의 고객 마일리지 업데이트
				String sql3 = "UPDATE CUSTOMER SET CSTAMP = (select * from (SELECT (sum(P.PPRICE *0.05) over(partition by CNO)) MILIEGE FROM PRODUCT P, SELL S WHERE (P.PNO = S.PNO) AND CNO = ?)where rownum = 1) WHERE CNO = ?";

				st3 = con.prepareStatement(sql3);

				st3.setString(1, memberNum);  // 1번째 ?에 회원번호(전역변수로 설정 된 회원번호) 입력
				st3.setString(2, memberNum);  // 2번째 ?에 회원번호(전역변수로 설정 된 회원번호) 입력

				st3.executeUpdate();
				st3.close();

			// 원재료sql
      // 판매 제품에 따라 해당 제품의 원재료 차감
				String sql4 = "UPDATE ORIGINAL SET OCOUNT= OCOUNT-1 WHERE ONO = (SELECT O.ONO FROM PRODUCT P , ORIGINAL O WHERE (P.ONO = O.ONO) AND PNO = '"+payment.get(i)+"')";

				st4 = con.prepareStatement(sql4);

				st4.executeUpdate();
				st4.close();
			}
		con.commit();
		con.close();
	}
```

<br>

* **판매탭 화면목록 출력 method**

```java
public ArrayList PaymentList(String pno) throws Exception { //

  con = DriverManager.getConnection(url, user, pass);
  PreparedStatement st = null;
  ResultSet rs = null;

  // 판매탭에서 입력 받아 온 제품 고유번호에 맞게 DB에서 정보를 Select
  String sql = "SELECT PNO pno, PNAME pname,  PPRICE price FROM PRODUCT WHERE PNO = ? "  ;

  ArrayList data = new ArrayList(); // select해온 정보를 입력받을 ArrayList data 생성
  st = con.prepareStatement(sql);
  st.setString(1, pno); // sql문의 1번째 ?에 판매탭에서 입력받아온 제품고유번호 입력
  rs = st.executeQuery();

  if(rs.next()) { // data에 제품번혼,제품이름,가격을 차례로 입력받음
    data.add(rs.getString("pno"));  
    data.add(rs.getString("pname"));
    data.add(rs.getInt("price"));
  }

  rs.close();
  st.close();
  con.close();
  return data;
}
```

<br><br>

#### 3.3 로그인 기능 구현
---

<br>

![Alt text](/assets/img/login.png)

```java


```



<br><br>

#### 3.4 로그인 기능별 method구현
---

<br>

```java

public Login LoginCheck(String id, String pass ) throws Exception{	// 로그인탭에서 id,pass를 입력받아 인자로
			// DB연결
			Login vo = new Login();	//로그인 정보 연결객체(vo) 생성

			con = DriverManager.getConnection(url, user, passwd);  


					String sql = "SELECT EID FROM EMPLOYEE WHERE EID = ?";  //연결된 DB에서 입력받은 id값을 이용하여 직원정보 SELECT

					// 전송객체
					PreparedStatement st = con.prepareStatement(sql);
					st.setString(1, id); // SQL문의 첫번째 ?에 로그인화면에서 입력받은 id 입력

          //전송
					ResultSet rs = st.executeQuery();
					if(rs.next()) {
					vo.setEID(rs.getString("EID"));	//DB에서 가져온 직원정보를 로그인탭으로 전송
					}

					String sql2 = "select EPASS FROM EMPLOYEE WHERE EPASS = ?"; //연결된 DB에서 입력받은 pass값을 이용해 직원정보 SELECT

          //전송객체
					PreparedStatement st1 = con.prepareStatement(sql2);
					st1.setString(1, pass);  // SQL문의 첫번째 ?에 로그인화면에서 입력받은 pass 입력

        	//전송
					ResultSet rs2 = st1.executeQuery();
					if(rs2.next()) {
					vo.setEPASS(rs2.getString("EPASS")); //DB에서 가져온 직원정보를 로그인탭으로 전송
					}

					rs.close();
					rs2.close();				
					st.close();
					st1.close();
          con.close();

					return vo; // vo클래스를 통해 정보 전송
		}
	}
```

<br><br>

#### 3.5 재고탭 구현
---

<br>

![Alt text](/assets/img/balju.png)

<br><br>

#### 3.6 재고탭 기능별 method
---

<br>

```java
public ArrayList SearchStock() throws Exception{  // DB의 원자재 잔여수량을 확인하기 위한 메서드  //확인한 재고를 ArrayList에 담아 전송
  Connection con = DriverManager.getConnection(url, user, pass);

      String sql = "SELECT ONO, ONAME, OCOUNT FROM ORIGINAL";  //원재료 테이블에서 원재료번호, 원재료이름, 원재료 갯수 출력

      ArrayList list = new ArrayList();
      PreparedStatement st = con.prepareStatement(sql);
      ResultSet rs = st.executeQuery();

      while(rs.next()) {
         ArrayList data = new ArrayList();
         data.add(rs.getString("ONO"));
         data.add(rs.getString("ONAME"));
         data.add(rs.getInt("OCOUNT"));
         list.add(data);
      }

      st.close();
      con.close();
      return list;      
}



public Stock InsertBalju(String vNum, int a) throws Exception{  // 발주테이블에 데이터를 삽입하기 위한 메소드

  Stock vo = new Stock();
  Connection con = DriverManager.getConnection(url, user, pass);

  String sql = "Insert into BALJU(BALJUNO, BALJUDATE, BALJUCOUNT, BNUMBER,ONO) VALUES (VALJU_SEQ.NEXTVAL, SYSDATE, ?, 'B1111',?)";  //		발주를 했을때 입력된 발주정보를 삽입하기 위한 쿼리문


      PreparedStatement st = con.prepareStatement(sql);
      st.setInt(1,a); //원재료 갯수 삽입
      st.setString(2, vNum); // 원재료 번호 삽입
      ResultSet rs = st.executeQuery();

      st.close();
      con.close();

      return vo;

}
```

<br><br>

#### 3.7 매출탭 구현
---

<br>

![Alt text](/assets/img/sale.png)
