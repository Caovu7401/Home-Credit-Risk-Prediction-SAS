/*PHẦN CODE NÀY PHÂN TÍCH VÀ XÂY MÔ HÌNH CHO TẬP VALID*/
/*---------------------------------------------------------------------------*/
LIBNAME DATA "/home/u64047063/8.HOME CREDIT";
OPTIONS MSTORED SASMSTORE=DATA;

PROC IMPORT DATAFILE="/home/u64047063/8.HOME CREDIT/Datasets/Home_Credit_new_VALID.csv" 
		OUT=DATA.VALID DBMS=CSV REPLACE;
	GETNAMES=YES;
RUN;
/*---------------------------------------------------------------------------*/


/*Phân chia điểm dữ liệu Good-Bad*/
DATA DATA.VALID;
	SET DATA.VALID;

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
DATA DATA.VALID;
    SET DATA.VALID;
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



/*Thêm các cột đã chia bins vào dữ liệu*/
DATA DATA.VALID;
	SET DATA.VALID;
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
DATA DATA.VALID;
    set DATA.VALID;
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
DATA DATA.VALID;
    set DATA.VALID;
    if NAME_FAMILY_STATUS in ('Civil marriage', 'Married', 'Separated') 
    then NAME_FAMILY_STATUS = 'Married Group';
RUN;
/*----------------------------------------------------------------------------------*/


/*Đổi tên một số giá trị trong biến NAME_INCOME_TYPE thành các nhóm*/
DATA DATA.VALID;
    set DATA.VALID;
    if NAME_INCOME_TYPE in ('Maternity leave', 'State servant', 'Pensioner', 'Student') 
    then NAME_INCOME_TYPE = 'Stuble Subsidy';
    if NAME_INCOME_TYPE in ('Commercial associate', 'Businessman') 
    then NAME_INCOME_TYPE = 'Business';
RUN;
/*----------------------------------------------------------------------------------*/


/*12.Thêm các giá trị WOE vào dữ liệu*/
DATA DATA.VALID;
	SET DATA.VALID;
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
DATA NEW_VALID;
	SET DATA.VALID (KEEP = WOE_DAYS_BIRTH WOE_DAYS_REGISTRATION WOE_DAYS_ID_PUBLISH 
	WOE_DAYS_LAST_PHONE_CHANGE WOE_EXT_SOURCE_1 WOE_EXT_SOURCE_2 WOE_EXT_SOURCE_3  
	WOE_CODE_GENDER WOE_NAME_INCOME_TYPE WOE_NAME_EDUCATION_TYPE 
	WOE_NAME_FAMILY_STATUS WOE_REGION_RATING_CLIENT_W_CITY WOE_REG_CITY_NOT_LIVE_CITY 
	WOE_REG_CITY_NOT_WORK_CITY WOE_ORGANIZATION_TYPE GOOD); 
RUN;
/*----------------------------------------------------------------------------------*/



/* Chuyển đổi một số column từ dạng chuỗi sang dạng số */
DATA NEW_VALID;
    SET NEW_VALID;
    WOE_RATING_CLIENT_CITY = INPUT(WOE_REGION_RATING_CLIENT_W_CITY, BEST8.); 
    WOE_REG_NOT_LIVE_CITY = INPUT(WOE_REG_CITY_NOT_LIVE_CITY, BEST8.); 
    WOE_REG_NOT_WORK_CITY = INPUT(WOE_REG_CITY_NOT_WORK_CITY, BEST8.); 

    /* Loại bỏ các cột cũ */
    DROP WOE_REGION_RATING_CLIENT_W_CITY WOE_REG_CITY_NOT_LIVE_CITY WOE_REG_CITY_NOT_WORK_CITY;
RUN;



/*9.GÁN ĐIỂM THEO CÁC HỆ SỐ ĐÃ ĐƯỢC ƯỚC LƯỢNG*/
PROC SCORE DATA=NEW_VALID TYPE=PARMS SCORE=NEW_TRAIN_PARAM OUT=NEW_VALID_OUTPUT;
	VAR WOE_DAYS_BIRTH 
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
		WOE_ORGANIZATION_TYPE;
RUN;



DATA NEW_VALID_OUTPUT;
	SET NEW_VALID_OUTPUT;
	SCORE=ROUND(EXP(GOOD2)/(1+EXP((GOOD2)))*1000);
RUN;



/*CHẠY MACRO TÍNH TOÁN GINI*/
%NRUNBOOKP(NEW_VALID_OUTPUT, SCORE, GOOD, SCOREF.);


	
	


















