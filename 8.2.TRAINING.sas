/*PHẦN CODE NÀY PHÂN TÍCH VÀ XÂY MÔ HÌNH CHO TẬP TRAIN*/
/*---------------------------------------------------------------------------*/
LIBNAME DATA "/home/u64047063/8.HOME CREDIT";
OPTIONS MSTORED SASMSTORE=DATA;

PROC IMPORT DATAFILE="/home/u64047063/8.HOME CREDIT/Datasets/Home_Credit_new_TRAIN.csv" 
		OUT=DATA.TRAIN DBMS=CSV REPLACE;
	GETNAMES=YES;
RUN;
/*---------------------------------------------------------------------------*/


/*Phân chia điểm dữ liệu Good-Bad*/
DATA DATA.TRAIN;
	SET DATA.TRAIN;

	IF TARGET=0 THEN
		DO;
			GOOD=1;
			BAD=0;
		END;
	ELSE IF TARGET=1 THEN
		DO;
			GOOD=0;
			BAD=1;
		END;
RUN;
/*---------------------------------------------------------------------------*/


/*Xóa bớt đi một số columns không cần thiết*/
DATA DATA.TRAIN;
    SET DATA.TRAIN;
    DROP AMT_INCOME_TOTAL AMT_ANNUITY ENTRANCES_AVG LANDAREA_AVG NONLIVINGAREA_AVG
	AMT_REQ_CREDIT_BUREAU_YEAR REGION_POPULATION_RELATIVE 
	NAME_CONTRACT_TYPE FLAG_OWN_CAR FLAG_OWN_REALTY CNT_CHILDREN NAME_TYPE_SUITE 
	NAME_HOUSING_TYPE FLAG_WORK_PHONE FLAG_CONT_MOBILE FLAG_PHONE FLAG_EMAIL 
	WEEKDAY_APPR_PROCESS_START HOUR_APPR_PROCESS_START REG_REGION_NOT_LIVE_REGION 
	REG_REGION_NOT_WORK_REGION FLAG_DOCUMENT_2 FLAG_DOCUMENT_3 FLAG_DOCUMENT_4 
	FLAG_DOCUMENT_5 FLAG_DOCUMENT_6 FLAG_DOCUMENT_7 FLAG_DOCUMENT_8 
	FLAG_DOCUMENT_9 FLAG_DOCUMENT_10 FLAG_DOCUMENT_11 FLAG_DOCUMENT_12 
	FLAG_DOCUMENT_13 FLAG_DOCUMENT_14 FLAG_DOCUMENT_15 FLAG_DOCUMENT_16 
	FLAG_DOCUMENT_17 FLAG_DOCUMENT_18 FLAG_DOCUMENT_19 FLAG_DOCUMENT_20 
	FLAG_DOCUMENT_21 OBS_60_CNT_SOCIAL_CIRCLE DEF_60_CNT_SOCIAL_CIRCLE;
RUN;
/*---------------------------------------------------------------------------*/



/*5.Phân chia biến liên tục thành 20 bins*/
%CONT2(DATA.TRAIN, AMT_INCOME_TOTAL, 20);
%CONT2(DATA.TRAIN, AMT_ANNUITY, 20);
%CONT2(DATA.TRAIN, DAYS_BIRTH, 20);
%CONT2(DATA.TRAIN, DAYS_REGISTRATION, 20);
%CONT2(DATA.TRAIN, DAYS_ID_PUBLISH, 20);
%CONT2(DATA.TRAIN, ENTRANCES_AVG, 20);
%CONT2(DATA.TRAIN, LANDAREA_AVG, 20);
%CONT2(DATA.TRAIN, NONLIVINGAREA_AVG, 20);
%CONT2(DATA.TRAIN, DAYS_LAST_PHONE_CHANGE, 20);
%CONT2(DATA.TRAIN, AMT_REQ_CREDIT_BUREAU_YEAR, 20);
%CONT2(DATA.TRAIN, EXT_SOURCE_1, 20);
%CONT2(DATA.TRAIN, EXT_SOURCE_2, 20);
%CONT2(DATA.TRAIN, EXT_SOURCE_3, 20);
%CONT2(DATA.TRAIN, REGION_POPULATION_RELATIVE, 20);
/*---------------------------------------------------------------------------*/



/*PROC các format*/
PROC FORMAT;
	/* DAYS_BIRTH */
	VALUE DAYS_BIRTHF LOW--23197='[01] LOW--23197' 
	-23197<--19681='[02] -23197<--19681' -19681<--17216='[03] -19681<--17216' 
	-17216<--13139='[04] -17216<--13139' -13139<--11006='[05] -13139<--11006' 
	-11006<-HIGH='[06] -11006<-HIGH';
RUN;


PROC FORMAT;
	/* DAYS_REGISTRATION */
	VALUE DAYS_REGISTRATIONF LOW--9932='[01] LOW--9932' 
	-9932<--9019='[02] -9932<--9019' -9019<--6101='[03] -9019<--6101' 
	-6101<--686='[04] -6101<--686' -686<-HIGH='[05] -686<-HIGH';
RUN;

PROC FORMAT;
	/* DAYS_ID_PUBLISH */
	VALUE DAYS_ID_PUBLISHF LOW--4565='[01] LOW--4565' 
	-4565<--4170='[02] -4565<--4170' -4170<--2950='[03] -4170<--2950' 
	-2950<--1717='[04] -2950<--1717' -1717<-HIGH='[05] -1717<-HIGH';
RUN;

PROC FORMAT;
	/* DAYS_LAST_PHONE_CHANGE */
	VALUE DAYS_LAST_PHONE_CHANGEF LOW--2160='[01] LOW--2160' 
	-2160<--1425='[02] -2160<--1425' -1425<--1056='[03] -1425<--1056'
	-1056<--755='[04] -1056<--755' -755<-HIGH='[05] 755<-HIGH';
RUN;

PROC FORMAT;
	/* EXT_SOURCE_1 */
	VALUE EXT_SOURCE_1F LOW-37.836='[01] LOW-37.836' 
		37.836<-45.663='[02] 37.836<-45.663' 45.663<-53.49='[03] 45.663<-53.49' 
		53.49<-61.111='[04] 53.49<-61.111' 61.111<-68.972='[05] 61.111<-68.972' 
		68.972<-77.375='[06] 68.972<-77.375' 77.375<-HIGH='[07] 77.375<-HIGH';
RUN;

PROC FORMAT;
	/* EXT_SOURCE_2 */
	VALUE EXT_SOURCE_2F LOW-12.817='[01] LOW-12.817' 12.817<-21.191='[02] 12.817<-21.191' 
	21.191<-39.021='[03] 21.191<-39.021' 39.021<-47.752='[04] 39.021<-47.752' 
	47.752<-60.778='[05] 47.752<-60.778' 60.778<-64.568='[06] 60.778<-64.568' 
	64.568<-70.053='[07] 64.568<-70.053' 70.053<-HIGH='[08] 70.053<-HIGH';
RUN;

PROC FORMAT;
	/* EXT_SOURCE_3 */
	VALUE EXT_SOURCE_3F LOW-32.016='[01] LOW-32.016' 32.016<-45.969='[02] 32.016<-45.969' 
	45.969<-49.927='[03] 45.969<-49.927' 49.927<-57.268='[04] 49.927<-57.268'
	57.268<-66.906='[05] 57.268<-66.906' 66.906<-HIGH='[06] 66.906<-HIGH';
RUN;
/*----------------------------------------------------------------------------------*/



/*Thêm các cột đã chia bins vào dữ liệu*/
DATA DATA.TRAIN;
	SET DATA.TRAIN;
	GRP_DAYS_BIRTH = PUT(DAYS_BIRTH, DAYS_BIRTHF.);
	GRP_DAYS_REGISTRATION = PUT(DAYS_REGISTRATION, DAYS_REGISTRATIONF.);
	GRP_DAYS_ID_PUBLISH = PUT(DAYS_ID_PUBLISH, DAYS_ID_PUBLISHF.);
	GRP_DAYS_LAST_PHONE_CHANGE = PUT(DAYS_LAST_PHONE_CHANGE, DAYS_LAST_PHONE_CHANGEF.);
	GRP_EXT_SOURCE_1 = PUT(EXT_SOURCE_1, EXT_SOURCE_1F.);
	GRP_EXT_SOURCE_2 = PUT(EXT_SOURCE_2, EXT_SOURCE_2F.);
	GRP_EXT_SOURCE_3 = PUT(EXT_SOURCE_3, EXT_SOURCE_3F.);
RUN;
/*----------------------------------------------------------------------------------*/



/*Đổi tên một số giá trị trong biến ORGANIZATION_TYPE thành các nhóm*/
DATA DATA.TRAIN;
    set DATA.TRAIN;
    if ORGANIZATION_TYPE in ('Cleaning', 'Security', 'Restaurant', 'Construction', 
    						'Transport: type 3', 'Transport: type 4', 'Postal') 
    then ORGANIZATION_TYPE = 'low service';
    if ORGANIZATION_TYPE in ('Transport: type 1', 'Transport: type 2', 'Services', 'Telecom', 
    						 'Insurance', 'Mobile', 'Legal Services', 'Hotel', 'Advertising', 
    						 'Electricity') 
    then ORGANIZATION_TYPE = 'high service';    
    if ORGANIZATION_TYPE in ('Industry: type 1', 'Industry: type 10', 'Industry: type 11', 
                             'Industry: type 12', 'Industry: type 13', 'Industry: type 2', 
                             'Industry: type 3', 'Industry: type 4', 'Industry: type 5', 
                             'Industry: type 6', 'Industry: type 7', 'Industry: type 8', 
                             'Industry: type 9', 'Agriculture') 
    then ORGANIZATION_TYPE = 'manufacture';
    if ORGANIZATION_TYPE in ('Trade: type 1', 'Trade: type 2', 'Trade: type 3', 'Trade: type 4', 
                             'Trade: type 5', 'Trade: type 6', 'Trade: type 7', 'Bank', 'Housing', 
                             'Business Entity Type 1', 'Business Entity Type 2', 'Business Entity Type 3', 'Realtor') 
    then ORGANIZATION_TYPE = 'business';
    if ORGANIZATION_TYPE in ('Culture', 'Emergency', 'Government', 'Medicine', 'Military', 'University', 
                             'Security Ministries', 'Kindergarten', 'Religion', 'Police', 'School') 
    then ORGANIZATION_TYPE = 'Society';
    if ORGANIZATION_TYPE in ('Other', 'Self-employed') then ORGANIZATION_TYPE = 'Other';
RUN;
/*----------------------------------------------------------------------------------*/


/*Đổi tên một số giá trị trong biến NAME_FAMILY_STATUS thành các nhóm*/
DATA DATA.TRAIN;
    set DATA.TRAIN;
    if NAME_FAMILY_STATUS in ('Civil marriage', 'Married', 'Separated') 
    then NAME_FAMILY_STATUS = 'Married Group';
RUN;
/*----------------------------------------------------------------------------------*/


/*Đổi tên một số giá trị trong biến NAME_INCOME_TYPE thành các nhóm*/
DATA DATA.TRAIN;
    set DATA.TRAIN;
    if NAME_INCOME_TYPE in ('Maternity leave', 'State servant', 'Pensioner', 'Student') 
    then NAME_INCOME_TYPE = 'Stuble Subsidy';
    if NAME_INCOME_TYPE in ('Commercial associate', 'Businessman') 
    then NAME_INCOME_TYPE = 'Business';
RUN;
/*----------------------------------------------------------------------------------*/



/*6.Phân tích WOE cho các biến cả liên tục lẫn phân loại*/ 
%CHARACT(DATA.TRAIN, GRP_DAYS_BIRTH, $30.);
%CHARACT(DATA.TRAIN, GRP_DAYS_REGISTRATION, $30.);
%CHARACT(DATA.TRAIN, GRP_DAYS_ID_PUBLISH, $30.);
%CHARACT(DATA.TRAIN, GRP_DAYS_LAST_PHONE_CHANGE, $30.);
%CHARACT(DATA.TRAIN, GRP_EXT_SOURCE_1, $30.);
%CHARACT(DATA.TRAIN, GRP_EXT_SOURCE_2, $30.);
%CHARACT(DATA.TRAIN, GRP_EXT_SOURCE_3, $30.);

%CHARACT(DATA.TRAIN, CODE_GENDER, $30.); 
%CHARACT(DATA.TRAIN, NAME_INCOME_TYPE, $30.); 
%CHARACT(DATA.TRAIN, NAME_EDUCATION_TYPE, $30.); 
%CHARACT(DATA.TRAIN, NAME_FAMILY_STATUS, $30.); 
%CHARACT(DATA.TRAIN, REGION_RATING_CLIENT_W_CITY, $30.); 
%CHARACT(DATA.TRAIN, REG_CITY_NOT_LIVE_CITY, $30.); 
%CHARACT(DATA.TRAIN, REG_CITY_NOT_WORK_CITY, $30.); 
%CHARACT(DATA.TRAIN, ORGANIZATION_TYPE, $30.); 


/*----------------------------------------------------------------------------------*/

%WOECHARACT1(DATA.TRAIN, GRP_DAYS_BIRTH);
%WOECHARACT1(DATA.TRAIN, GRP_DAYS_REGISTRATION);
%WOECHARACT1(DATA.TRAIN, GRP_DAYS_ID_PUBLISH);
%WOECHARACT1(DATA.TRAIN, GRP_DAYS_LAST_PHONE_CHANGE);
%WOECHARACT1(DATA.TRAIN, GRP_EXT_SOURCE_1);
%WOECHARACT1(DATA.TRAIN, GRP_EXT_SOURCE_2);
%WOECHARACT1(DATA.TRAIN, GRP_EXT_SOURCE_3);

%WOECHARACT1(DATA.TRAIN, CODE_GENDER); 
%WOECHARACT1(DATA.TRAIN, NAME_INCOME_TYPE); 
%WOECHARACT1(DATA.TRAIN, NAME_EDUCATION_TYPE); 
%WOECHARACT1(DATA.TRAIN, NAME_FAMILY_STATUS); 
%WOECHARACT1(DATA.TRAIN, REGION_RATING_CLIENT_W_CITY); 
%WOECHARACT1(DATA.TRAIN, REG_CITY_NOT_LIVE_CITY ); 
%WOECHARACT1(DATA.TRAIN, REG_CITY_NOT_WORK_CITY ); 
%WOECHARACT1(DATA.TRAIN, ORGANIZATION_TYPE); 
/*----------------------------------------------------------------------------------*/
 

/*PROC các giá trị WOE*/
PROC FORMAT;
	/* GRP_DAYS_BIRTH */
	VALUE $GRP_DAYS_BIRTHW '[01] LOW--23197 '=0.653 '[02] -23197<--19681'=0.399 
		'[03] -19681<--17216'=0.16 '[04] -17216<--13139'=-0.018 
		'[05] -13139<--11006'=-0.239 '[06] -11006<-HIGH '=-0.396;
RUN;

PROC FORMAT;
	/* GRP_DAYS_REGISTRATION */
	VALUE $GRP_DAYS_REGISTRATIONW '[01] LOW--9932 '=0.409 
		'[02] -9932<--9019'=0.273 '[03] -9019<--6101'=0.095 
		'[04] -6101<--686 '=-0.075 '[05] -686<-HIGH '=-0.206;
RUN;

PROC FORMAT;
	/* GRP_DAYS_ID_PUBLISH */
	VALUE $GRP_DAYS_ID_PUBLISHW '[01] LOW--4565 '=0.323 '[02] -4565<--4170'=0.245 
		'[03] -4170<--2950'=0.043 '[04] -2950<--1717'=-0.107 
		'[05] -1717<-HIGH '=-0.232;
RUN;

PROC FORMAT;
	/* GRP_DAYS_LAST_PHONE_CHANGE */
	VALUE $GRP_DAYS_LAST_PHONE_CHANGEW '[01] LOW--2160 '=0.426 
		'[02] -2160<--1425'=0.257 '[03] -1425<--1056'=0.118 
		'[04] -1056<--755 '=-0.045 '[05] 755<-HIGH '=-0.165;
RUN;

PROC FORMAT;
	/* GRP_EXT_SOURCE_1 */
	VALUE $GRP_EXT_SOURCE_1W '[01] LOW-37.836 '=-0.155 '[02] 37.836<-45.663'=0.011 
		'[03] 45.663<-53.49 '=0.244 '[04] 53.49<-61.111 '=0.385 
		'[05] 61.111<-68.972'=0.544 '[06] 68.972<-77.375'=0.84 
		'[07] 77.375<-HIGH '=1.167;
RUN;

PROC FORMAT;
	/* GRP_EXT_SOURCE_2 */
	VALUE $GRP_EXT_SOURCE_2W '[01] LOW-12.817 '=-1.158 
		'[02] 12.817<-21.191'=-0.662 '[03] 21.191<-39.021'=-0.403 
		'[04] 39.021<-47.752'=-0.121 '[05] 47.752<-60.778'=0.13 
		'[06] 60.778<-64.568'=0.318 '[07] 64.568<-70.053'=0.555 
		'[08] 70.053<-HIGH '=0.936;
RUN;

PROC FORMAT;
	/* GRP_EXT_SOURCE_3 */
	VALUE $GRP_EXT_SOURCE_3W '[01] LOW-32.016 '=-0.491 
		'[02] 32.016<-45.969'=-0.139 '[03] 45.969<-49.927'=0.157 
		'[04] 49.927<-57.268'=0.384 '[05] 57.268<-66.906'=0.591 
		'[06] 66.906<-HIGH '=0.877;
RUN;

PROC FORMAT;
	/* CODE_GENDER */
	VALUE $CODE_GENDERW 'F'=0.155 'M'=-0.251;
RUN;

PROC FORMAT;
	/* NAME_INCOME_TYPE */
	VALUE $NAME_INCOME_TYPEW 'Business '=0.069 'Stuble Subsidy '=0.413 
		'Unemployed '=-1.917 'Working '=-0.184;
RUN;

PROC FORMAT;
	/* NAME_EDUCATION_TYPE */
	VALUE $NAME_EDUCATION_TYPEW 'Academic degree '=1.227 'Higher education '=0.43 
		'Incomplete higher '=-0.05 'Lower secondary '=-0.32 
		'Secondary / secondary special'=-0.111;
RUN;

PROC FORMAT;
	/* NAME_FAMILY_STATUS */
	VALUE $NAME_FAMILY_STATUSW 'Married Group '=0.024 
		'Single / not married'=-0.222 'Widow '=0.388;
RUN;

PROC FORMAT;
    /* REGION_RATING_CLIENT_W_CITY */
    VALUE REGION_RATING_CLIENT_W_CITYW  1 = 0.537 2 = 0.022 3 = -0.385;
RUN;

PROC FORMAT;
    /* REG_CITY_NOT_LIVE_CITY */
    VALUE REG_CITY_NOT_LIVE_CITYW  0 = 0.05 1 = -0.469;
RUN;

PROC FORMAT;
    /* REG_CITY_NOT_WORK_CITY */
    VALUE REG_CITY_NOT_WORK_CITYW  0 = 0.105 1 = -0.298;
RUN;

PROC FORMAT;
	/* ORGANIZATION_TYPE */
	VALUE $ORGANIZATION_TYPEW 'Other '=0.102 'Society '=0.287 'business '=-0.121 
		'high service '=0.123 'low service '=-0.328 'manufacture '=-0.137;
RUN;
/*----------------------------------------------------------------------------------*/


/*12.Thêm các giá trị WOE vào dữ liệu*/
DATA DATA.TRAIN;
	SET DATA.TRAIN;
	WOE_DAYS_BIRTH=INPUT(PUT(GRP_DAYS_BIRTH, $GRP_DAYS_BIRTHW.), COMMA30.);	
	WOE_DAYS_REGISTRATION=INPUT(PUT(GRP_DAYS_REGISTRATION, $GRP_DAYS_REGISTRATIONW.), COMMA30.);
	WOE_DAYS_ID_PUBLISH=INPUT(PUT(GRP_DAYS_ID_PUBLISH, $GRP_DAYS_ID_PUBLISHW.), COMMA30.);	
	WOE_DAYS_LAST_PHONE_CHANGE=INPUT(PUT(GRP_DAYS_LAST_PHONE_CHANGE, $GRP_DAYS_LAST_PHONE_CHANGEW.), COMMA30.); 
	WOE_EXT_SOURCE_1=INPUT(PUT(GRP_EXT_SOURCE_1, $GRP_EXT_SOURCE_1W.), COMMA30.);	
	WOE_EXT_SOURCE_2=INPUT(PUT(GRP_EXT_SOURCE_2, $GRP_EXT_SOURCE_2W.), COMMA30.);	
	WOE_EXT_SOURCE_3=INPUT(PUT(GRP_EXT_SOURCE_3, $GRP_EXT_SOURCE_3W.), COMMA30.);
	WOE_CODE_GENDER=INPUT(PUT(CODE_GENDER, $CODE_GENDERW.), COMMA30.);
	WOE_NAME_INCOME_TYPE=INPUT(PUT(NAME_INCOME_TYPE, $NAME_INCOME_TYPEW.), COMMA30.);
	WOE_NAME_EDUCATION_TYPE=INPUT(PUT(NAME_EDUCATION_TYPE, $NAME_EDUCATION_TYPEW.), COMMA30.);
	WOE_NAME_FAMILY_STATUS=INPUT(PUT(NAME_FAMILY_STATUS, $NAME_FAMILY_STATUSW.), COMMA30.);
	WOE_REGION_RATING_CLIENT_W_CITY = PUT(REGION_RATING_CLIENT_W_CITY, REGION_RATING_CLIENT_W_CITYW.);
    WOE_REG_CITY_NOT_LIVE_CITY = PUT(REG_CITY_NOT_LIVE_CITY, REG_CITY_NOT_LIVE_CITYW.);
    WOE_REG_CITY_NOT_WORK_CITY = PUT(REG_CITY_NOT_WORK_CITY, REG_CITY_NOT_WORK_CITYW.);
	WOE_ORGANIZATION_TYPE=INPUT(PUT(ORGANIZATION_TYPE, $ORGANIZATION_TYPEW.), COMMA30.);
RUN;
/*----------------------------------------------------------------------------------*/


/*Tách ra dữ liệu mới*/
DATA NEW_TRAIN;
	SET DATA.TRAIN (KEEP = WOE_DAYS_BIRTH WOE_DAYS_REGISTRATION WOE_DAYS_ID_PUBLISH 
	WOE_DAYS_LAST_PHONE_CHANGE WOE_EXT_SOURCE_1 WOE_EXT_SOURCE_2 WOE_EXT_SOURCE_3  
	WOE_CODE_GENDER WOE_NAME_INCOME_TYPE WOE_NAME_EDUCATION_TYPE 
	WOE_NAME_FAMILY_STATUS WOE_REGION_RATING_CLIENT_W_CITY WOE_REG_CITY_NOT_LIVE_CITY 
	WOE_REG_CITY_NOT_WORK_CITY WOE_ORGANIZATION_TYPE GOOD); 
RUN;
/*----------------------------------------------------------------------------------*/


/* Chuyển đổi một số column từ dạng chuỗi sang dạng số */
DATA NEW_TRAIN;
    SET NEW_TRAIN;
    WOE_RATING_CLIENT_CITY = INPUT(WOE_REGION_RATING_CLIENT_W_CITY, BEST8.); 
    WOE_REG_NOT_LIVE_CITY = INPUT(WOE_REG_CITY_NOT_LIVE_CITY, BEST8.); 
    WOE_REG_NOT_WORK_CITY = INPUT(WOE_REG_CITY_NOT_WORK_CITY, BEST8.); 

    /* Loại bỏ các cột cũ */
    DROP WOE_REGION_RATING_CLIENT_W_CITY WOE_REG_CITY_NOT_LIVE_CITY WOE_REG_CITY_NOT_WORK_CITY;
RUN;



/*KIỂM TRA TƯƠNG QUAN (PEARSON) GIỮA CÁC BIẾN WOE*/
PROC CORR DATA=NEW_TRAIN NOPROB NOSIMPLE;
	VAR 
	WOE_DAYS_BIRTH WOE_DAYS_REGISTRATION WOE_DAYS_ID_PUBLISH 
	WOE_DAYS_LAST_PHONE_CHANGE WOE_EXT_SOURCE_1 WOE_EXT_SOURCE_2 WOE_EXT_SOURCE_3  
	WOE_CODE_GENDER WOE_NAME_INCOME_TYPE WOE_NAME_EDUCATION_TYPE 
	WOE_NAME_FAMILY_STATUS WOE_RATING_CLIENT_CITY WOE_REG_NOT_LIVE_CITY 
	WOE_REG_NOT_WORK_CITY WOE_ORGANIZATION_TYPE GOOD; 
RUN;



/*TRAINING MÔ HÌNH*/
PROC LOGISTIC DATA=NEW_TRAIN DESCENDING NAMELEN=30 OUTEST=NEW_TRAIN_PARAM;
	MODEL GOOD= 
		WOE_DAYS_BIRTH 
		WOE_DAYS_REGISTRATION 
		WOE_DAYS_ID_PUBLISH 
		WOE_DAYS_LAST_PHONE_CHANGE 
		WOE_EXT_SOURCE_1 
		WOE_EXT_SOURCE_2 
		WOE_EXT_SOURCE_3 
		WOE_CODE_GENDER 
		WOE_NAME_INCOME_TYPE 
		WOE_NAME_EDUCATION_TYPE 
		WOE_NAME_FAMILY_STATUS 
		WOE_RATING_CLIENT_CITY 
		WOE_REG_NOT_LIVE_CITY 
		WOE_REG_NOT_WORK_CITY 
		WOE_ORGANIZATION_TYPE 
		/SELECTION=STEPWISE SLENTRY=0.05 SLSTAY=0.05;
	OUTPUT OUT=NEW_TRAIN_OUTPUT /*TRAIN_OUTPUT*/ PREDICTED=SCORE;
RUN;



DATA NEW_TRAIN_OUTPUT;
	SET NEW_TRAIN_OUTPUT;
	SCORE=ROUND(SCORE*1000);
RUN; 


/*CHIA ĐIỂM THÀNH 20 PHẦN*/
%CONT2(NEW_TRAIN_OUTPUT,SCORE,20); 



PROC FORMAT;
	/* SCORE */
	VALUE SCOREF LOW-789='[01] LOW-789' 789<-832='[02] 789<-832' 
		832<-858='[03] 832<-858' 858<-877='[04] 858<-877' 877<-891='[05] 877<-891' 
		891<-904='[06] 891<-904' 904<-914='[07] 904<-914' 914<-923='[08] 914<-923' 
		923<-931='[09] 923<-931' 931<-938='[10] 931<-938' 938<-945='[11] 938<-945' 
		945<-951='[12] 945<-951' 951<-956='[13] 951<-956' 956<-961='[14] 956<-961' 
		961<-966='[15] 961<-966' 966<-970='[16] 966<-970' 970<-975='[17] 970<-975' 
		975<-979='[18] 975<-979' 979<-985='[19] 979<-985' 985<-HIGH='[20] 985<-HIGH';
RUN;



/*CHẠY MACRO TÍNH TOÁN GINI*/
%NRUNBOOKP(NEW_TRAIN_OUTPUT, SCORE, GOOD, SCOREF.);





































