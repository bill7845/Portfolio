# < DACON - 따릉이 수요예측 모델링 >

<br>

<b> 분석파일(ipynb)가 잘 열리지 않는다면! => [여기](https://nbviewer.jupyter.org/github/bill7845/Portfolio/blob/master/Analysis_%EB%8D%B0%EC%9D%B4%EC%BD%98_%EB%94%B0%EB%A6%89%EC%9D%B4%EC%88%98%EC%9A%94%EC%98%88%EC%B8%A1/%EB%94%B0%EB%A6%89%EC%9D%B4_%EC%88%98%EC%9A%94_%EC%98%88%EC%B8%A1.ipynb) </b>

<br>

### < 모델링 목적 >
* 주어진 데이터(2017년 4월 1일부터, 5월 31일까지 시간별로 서울시 따릉이 대여수와 기상상황 데이터)를 바탕으로 1시간 후의 따릉이 대여수 예측

<br>

### < 데이터 명세 >
  * id : 고유 아이디
  * hour : 시간
  * hour_bef_temperature : 한 시간 전 온도
  * hour_bef_precipitation : 한 시간 전 강수여부
  * hour_bef_windspeed : 한 시간 전 바람세기
  * hour_bef_humidity : 한 시간 전 습도
  * hour_bef_visibility : 한 시간 전 시야
  * hour_bef_ozone : 한 시간 전 오존 농도
  * hour_bef_pm10 : 한 시간 전 미세먼지 농도
  * hour_bef_pm2.5 : 한 시간 전 초미세먼지 농도
  * hour_bef_count : 한 시간 전 대여량
  
  * 데이터 출처 : https://dacon.io/competitions/open/235576/data/
  
<br>

### < EDA 및 결측치,이상치 처리 과정 >

1. 데이터 체크 
    * 학습데이터 shape 1459 x 11 
    
![info_편집](https://user-images.githubusercontent.com/35517797/86532563-fb4b9e00-bf05-11ea-8702-fdfd62f283a1.PNG)


2. 결측치 확인
 * 기온, 강수여부, 습도, 풍속, 습도, 가시거리, 오존농도, 미세먼지농도, 초미세먼지농도 열에 결측값 존재.
 * 현재 각 feature의 data type은 모두 numeric이며 강수여부와 hour의 경우 범주형으로 간주하고 One-hot 인코딩을 통해 변경함.
 
![info_체크](https://user-images.githubusercontent.com/35517797/86532675-c12ecc00-bf06-11ea-822d-06487db40d8e.PNG)

3. Target 분포
 * 정규화,표준화나 로그를 씌어 분포의 형태를 바꾸어 보는것도 고려해 볼 것.
![타겟 분포_편집](https://user-images.githubusercontent.com/35517797/86533402-ca6e6780-bf0b-11ea-9096-4e056701e767.PNG)

4. 시간대 분포
 * 시간대의 경우 균등 분포 되어있음
 * 시간대에 따른 target(대여횟수)의 합계,평균을 보면 각 시간별로 확연한 차이를 보이며 출,퇴근 시간대에 특히 급증하는 경향을 보임.
![시간대 분포_편집](https://user-images.githubusercontent.com/35517797/86533542-e9212e00-bf0c-11ea-8b98-80bb2a964c6f.PNG)

5. Target / Feature 상관관계
![타겟 피처간 회귀직선_편집](https://user-images.githubusercontent.com/35517797/86533699-dfe49100-bf0d-11ea-9013-199ec742ea93.PNG)


6. 결측치 대체
 * <b> 결측치 대체 ver_1 </b>
 * 시간대별 평균치로 대체
 * 기상 관련 feature들이므로 각 시간대별 평균값으로 대체함.
 
 <br>
 
 * <b> 결측치 대체 ver_2 </b>
 * 기상상황은 시간대 뿐만 아니라 강수여부에 큰 영향을 받음.
 * 따라서, 강수여부 + 시간대별 평균값으로 각 결측치를 대체.
![강수여부별_편집](https://user-images.githubusercontent.com/35517797/86534327-829f0e80-bf12-11ea-8cd9-bddb7afa338a.PNG)

7. 이상치 제거
 * 각 시간대별 대여횟수의 이상치를 탐지 & 제거해줌
 * 당일 자전거 대회등의 행사나 기상재해등으로 인한 이상치 발생으로 추정.
 * 각 시간대별 대여횟수가 IQR을 벗어나는 데이터를 이상치로 간주하고 제거함.
![이상치_편집](https://user-images.githubusercontent.com/35517797/86534376-06f19180-bf13-11ea-8786-7a9b79e4913d.PNG)

<br>

### 모델링 , 평가

* 총 7가지 회귀 모델 사용
 * `LinearRegression` , `Ridge` , `Lasso` , `ElasticNet` , `RandomForestRegressor` , `XGBRegressor` , `LGBMRegressor`
* RMSE를 평가지표로 함.
* 각 결측치 대체, 이상치 대체법을 적용/비적용하여 GridSearch로 최적 파라미터 서치 및 학습.
* 가장 높은 성능을 보인 RandomForestRegressor를 최종 모델로 선택.
![랜프_디프_편집](https://user-images.githubusercontent.com/35517797/86535572-41136100-bf1c-11ea-9bf0-eabe12640de7.PNG)
![랜프_시각화_편집](https://user-images.githubusercontent.com/35517797/86535574-45d81500-bf1c-11ea-9abc-aabc4d25a11e.PNG)
![최종순위_편집](https://user-images.githubusercontent.com/35517797/86535575-483a6f00-bf1c-11ea-9149-d296bb2160b0.PNG)

