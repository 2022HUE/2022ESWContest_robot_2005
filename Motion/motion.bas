'******** 2족 보행로봇 초기 영점 프로그램 ********

'-*- coding: utf-8 -*-'

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER

DIM 곡선방향 AS BYTE

DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
'**************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 20  'ms

CONST 적외선AD포트  = 4


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
'************************************************



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************


TEMPO 230
'MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON



PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '안녕하세요

GOSUB All_motor_mode3





GOTO MAIN	'시리얼 수신 루틴으로 가기

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
시작음:
    TEMPO 220
    'MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    'MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************

전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90

    WAIT
    mode = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
고개중앙기본자세:
	SERVO 16, 73
	
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '********************************************
기본자세:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
기본자세2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    RETURN
    '******************************************
    '***********************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '******************ZERO G6A,100, 101, 102, 106, 100, 100
    ZERO G6B,102, 101, 100, 100, 100, 100
    ZERO G6C, 97, 100,  96, 100, 100, 100
    ZERO G6D,100, 103, 103, 104, 103, 100
    '*****************************
자이로ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    자이로ONOFF = 0
    RETURN

    '************************************************

    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
    '**********************************************


라인따라걸음:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 라인따라걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 라인따라걸음_4
    ENDIF


    '**********************

라인따라걸음_1: '왼발
    'HIGHSPEED SETON
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,106,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


라인따라걸음_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, 라인따라걸음_4
    IF A <> A_old THEN
라인따라걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF

    '*********************************

라인따라걸음_4: '오른발
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,102,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


라인따라걸음_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, 라인따라걸음_1
    IF A <> A_old THEN
라인따라걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF
    '*************************************

    GOTO 라인따라걸음_1

    '******************************************
전진달리기50:
    넘어진확인 = 0
    GOSUB All_motor_mode3
    보행COUNT = 0
    DELAY 50
    SPEED 6
    HIGHSPEED SETON



    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 146,  93, 98
        WAIT

        MOVE G6A,95,  82, 120, 120, 104
        MOVE G6D,104,  79, 147,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        GOTO 전진달리기50_2
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  82, 121, 120, 104
        MOVE G6A,104,  79, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        GOTO 전진달리기50_5
    ENDIF


    '**********************

전진달리기50_1:
    MOVE G6A,95,  97, 100, 120, 104
    MOVE G6D,104,  79, 148,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


전진달리기50_2:
    MOVE G6A,95,  77, 122, 120, 104
    MOVE G6D,104,  80, 148,  90,  100
    WAIT

전진달리기50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 161,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_3_stop

    ERX 4800,A, 전진달리기50_4
    IF A <> A_old THEN
전진달리기50_3_stop:

        MOVE G6D,90,  93, 116, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    '*********************************

전진달리기50_4:
    MOVE G6D,95,  97, 101, 120, 104
    MOVE G6A,104,  79, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


전진달리기50_5:
    MOVE G6D,95,  77, 123, 120, 104
    MOVE G6A,104,  80, 147,  90,  100
    WAIT


전진달리기50_6:
    MOVE G6D,103,  71, 146, 103,  100
    MOVE G6A, 95, 89, 160,  68, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진달리기50_6_stop
    ERX 4800,A, 전진달리기50_1
    IF A <> A_old THEN
전진달리기50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 146,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    GOTO 전진달리기50_1


연속전진:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 148,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 149,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO 연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 146,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10

        MOVE G6D, 90, 90, 122, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속전진_2	

    ENDIF


    '*******************************



연속전진_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 149,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 147,  69, 110
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_2
    IF A = 11 THEN
        GOTO 연속전진_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 102, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 154,  91, 106,100
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF
    '**********

연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 122, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

연속전진_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 147, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 149, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_4
    IF A = 11 THEN
        GOTO 연속전진_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 148,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 148,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF

연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 148,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO 연속전진_1
    '*******************************
    '*******************************


    '************************************************
한걸음걷기:
    보행속도 = 12
    좌우속도 = 4
    넘어진확인 = 0
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 100,  30,  80, 100, 100, 102
    MOVE G6C, 100,  30,  80, 100,  89, 100
    WAIT


    GOSUB Leg_motor_mode3
    HIGHSPEED SETON
    SPEED 10
    MOVE G6D,  90,  74, 144,  95, 110
    MOVE G6A, 108,  76, 146,  93, 96
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

    SPEED 12
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6A,108,  76, 147,  93,  96,100
    MOVE G6C,90
    MOVE G6B,110
    WAIT

    HIGHSPEED SETOFF
    GOTO 한걸음걷기_2	

한걸음걷기_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

한걸음걷기_3:
    ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 90,  56, 145, 115, 112
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,108,  76, 147, 93,  98
    MOVE G6A,90, 100, 145,  69, 108
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 한걸음걷기_4
    IF A = 11 THEN
        GOTO 한걸음걷기_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
한걸음걷기_4:
    SPEED 13
    MOVE G6A,95, 90, 120, 105, 111,100
    MOVE G6D,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ' SPEED 10
    '  GOSUB 기본자세2
    ' GOTO 한걸음걷기

    SPEED 10
    GOSUB 기본자세2
    RETURN

    '*******************************************************************************************************************************
한걸음걷기2:
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6A, 100,  76, 145,  93, 100, 100
    MOVE G6B, 100,  30,  80, 100, 100, 102
    MOVE G6C, 100,  30,  80, 100,  89, 100
    WAIT


    GOSUB Leg_motor_mode3
    HIGHSPEED SETON
    SPEED 10
    MOVE G6A,  90,  74, 144,  95, 110
    MOVE G6D, 108,  76, 146,  93, 96
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

    SPEED 12
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,108,  76, 147,  93,  96,100
    MOVE G6C,90
    MOVE G6B,110
    WAIT

    HIGHSPEED SETOFF
    GOTO 한걸음걷기2_2	

한걸음걷기2_2:
    MOVE G6D,110,  76, 147,  93, 100,100
    MOVE G6A,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

한걸음걷기2_3:
    ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6A, 90,  56, 145, 115, 112
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6A,108,  76, 147, 93,  98
    MOVE G6D,90, 100, 145,  69, 108
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 한걸음걷기2_4
    IF A = 11 THEN
        GOTO 한걸음걷기2_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
한걸음걷기2_4:
    SPEED 9
    MOVE G6D,95, 90, 120, 105, 111,100
    MOVE G6A,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    SPEED 6
    'GOSUB 기본자세2
    RETURN
    '*******************************************************
빠른횟수_전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT

    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 98
        MOVE G6D,101,  76, 146,  93, 95
        WAIT

        GOTO 빠른횟수_전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 146,  93, 98
        MOVE G6A,101,  76, 147,  93, 95
        WAIT

        GOTO 빠른횟수_전진종종걸음_4
    ENDIF


    '**********************

빠른횟수_전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 101
    MOVE G6D,104,  77, 146,  93,  99
    WAIT


빠른횟수_전진종종걸음_2:

    MOVE G6A,103,   73, 140, 103,  97
    MOVE G6D, 95,  85, 146,  85, 99
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 빠른횟수_전진종종걸음_2_stop

    ERX 4800,A, 빠른횟수_전진종종걸음_4
    IF A <> A_old THEN
빠른횟수_전진종종걸음_2_stop:
        MOVE G6D,95,  90, 124, 95, 101
        MOVE G6A,104,  76, 145,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        'GOSUB 안정화자세
        '  SPEED 5
        ' GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

빠른횟수_전진종종걸음_4:
    MOVE G6D,95,  95, 119, 100, 101
    MOVE G6A,104,  77, 147,  93,  99
    WAIT


빠른횟수_전진종종걸음_5:
    MOVE G6D,103,    73, 139, 103,  97
    MOVE G6A, 95,  85, 147,  85, 99
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 빠른횟수_전진종종걸음_5_stop

    ERX 4800,A, 빠른횟수_전진종종걸음_1
    IF A <> A_old THEN
빠른횟수_전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 101
        MOVE G6D,104,  76, 144,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        ' GOSUB 안정화자세
        ' SPEED 5
        '  GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO 빠른횟수_전진종종걸음_1

    '-----------------------------------------------------------------

연속후진:
    넘어진확인 = 0
    보행속도 = 12
    좌우속도 = 4
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속후진_1	
    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,110,  76, 145,  93,  96
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속후진_2

    ENDIF


연속후진_1:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_2
    IF A <> A_old THEN
연속후진_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF
    '**********

연속후진_2:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, 연속후진_1
    IF A <> A_old THEN
연속후진_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF  	

    GOTO 연속후진_1
    '**********************************************

    '******************************************
횟수_전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 횟수_전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 횟수_전진종종걸음_4
    ENDIF


    '**********************

횟수_전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


횟수_전진종종걸음_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음_2_stop

    ERX 4800,A, 횟수_전진종종걸음_4
    IF A <> A_old THEN
횟수_전진종종걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

횟수_전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


횟수_전진종종걸음_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음_5_stop

    ERX 4800,A, 횟수_전진종종걸음_1
    IF A <> A_old THEN
횟수_전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO 횟수_전진종종걸음_1

    '******************************************

    '******************************************
전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_4
    ENDIF


    '**********************

전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


전진종종걸음_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

    ERX 4800,A, 전진종종걸음_4
    IF A <> A_old THEN
전진종종걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


전진종종걸음_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

    ERX 4800,A, 전진종종걸음_1
    IF A <> A_old THEN
전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

걷기:


    '*************************************
    
    

    '*********************************

    GOTO 전진종종걸음_1

    '******************************************
    '******************************************
    '******************************************
후진종종걸음:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,101
        MOVE G6C,101
        WAIT

        GOTO 후진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,101
        MOVE G6C,101
        WAIT

        GOTO 후진종종걸음_4
    ENDIF


    '**********************

후진종종걸음_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,116
    MOVE G6C,86
    WAIT



후진종종걸음_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_3_stop
    ERX 4800,A, 후진종종걸음_4
    IF A <> A_old THEN
후진종종걸음_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 101
        MOVE G6B,101
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

후진종종걸음_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,116
    MOVE G6B,86
    WAIT


후진종종걸음_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_6_stop

    ERX 4800,A, 후진종종걸음_1
    IF A <> A_old THEN  'GOTO 후진종종걸음_멈춤
후진종종걸음_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 101
        MOVE G6C,101
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO 후진종종걸음_1




    '******************************************


    '******************************************
    '******************************************

    '******************************************
    '*************************************

    '******************************************
곡선전진종종걸음:
    넘어진확인 = 0

    곡선방향 = 2
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음_4
    ENDIF



    '**********************

곡선전진종종걸음_1:
    SPEED 8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


곡선전진종종걸음_3:
    SPEED 8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,곡선전진종종걸음_4_0

    IF A = 20 THEN
        곡선방향 = 3
    ELSEIF A = 43 THEN
        곡선방향 = 1
    ELSEIF A = 11 THEN
        곡선방향 = 2
    ELSE  '정지
        GOTO 곡선전진종종걸음_3멈춤
    ENDIF

곡선전진종종걸음_4_0:

    IF  곡선방향 = 1 THEN'왼쪽

    ELSEIF  곡선방향 = 3 THEN'오른쪽
        HIGHSPEED SETOFF
        SPEED 8
        MOVE G6D,103,   71, 140, 105,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음_1

    ENDIF



    '*********************************

곡선전진종종걸음_4:
    SPEED 8
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


곡선전진종종걸음_6:
    SPEED 8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,곡선전진종종걸음_1_0

    IF A = 20 THEN
        곡선방향 = 3
    ELSEIF A = 43 THEN
        곡선방향 = 1
    ELSEIF A = 11 THEN
        곡선방향 = 2
    ELSE  '정지
        GOTO 곡선전진종종걸음_6멈춤
    ENDIF

곡선전진종종걸음_1_0:

    IF  곡선방향 = 1 THEN'왼쪽
        HIGHSPEED SETOFF
        SPEED 8
        MOVE G6A,103,   71, 140, 105,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음_4
    ELSEIF 곡선방향 = 3 THEN'오른쪽


    ENDIF



    GOTO 곡선전진종종걸음_1
    '******************************************
    '******************************************
    '*********************************
곡선전진종종걸음_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세
    GOTO MAIN	
    '******************************************
곡선전진종종걸음_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세
    GOTO MAIN	
    '******************************************

    '************************************************
오른쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 109, 100
    MOVE G6A,105,  78, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  82, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  78, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  78, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************
    '*************

왼쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 109, 100 ' before 95, 90, 125, 100, 104, 100
    MOVE G6D,105,  78, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  82, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  78, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  78, 145,  93, 100, 100
    GOSUB All_motor_mode3
    GOTO RX_EXIT

    '**********************************************
    '******************************************
오른쪽옆으로70연속:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽옆으로70연속_loop:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6D, 102,  76, 145, 95, 100, 100
    MOVE G6A,83,  78, 140,  98, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  76, 145,  95, 100, 100
    MOVE G6A,98,  76, 145,  95, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  95, 100, 100
    MOVE G6D,100,  76, 145,  95, 100, 100
    WAIT


    '  ERX 4800, A ,오른쪽옆으로70연속_loop
    '    IF A = A_OLD THEN  GOTO 오른쪽옆으로70연속_loop
    '오른쪽옆으로70연속_stop:
    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************

왼쪽옆으로70연속:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽옆으로70연속_loop:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 95, 100, 100
    MOVE G6D,83,  78, 140,  98, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  95, 100, 100
    MOVE G6D,98,  76, 145,  95, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  95, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '   ERX 4800, A ,왼쪽옆으로70연속_loop	
    '    IF A = A_OLD THEN  GOTO 왼쪽옆으로70연속_loop
    '왼쪽옆으로70연속_stop:

    GOSUB 기본자세2

    GOTO RX_EXIT

    '**********************************************
    '************************************************

왼쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

왼쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 17
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 8
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 11
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 9
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 17
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 8
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 11
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 14
    GOSUB 기본자세2


    GOTO RX_EXIT

    '**********************************************
오른쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 17
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,98,  79, 146,  93, 100, 100
        WAIT


        SPEED 8
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,98,  68, 146,  108, 100, 100
        WAIT

        SPEED 11
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,102  71, 146,  105, 100, 100
        WAIT
        SPEED 9
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,103,  76, 147,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,98,  79, 146,  93, 100, 100
        WAIT


        SPEED 8
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,98,  65, 146,  108, 100, 100
        WAIT

        SPEED 11
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,88,  58, 146,  110, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,88,  85, 131, 98, 104
        MOVE G6A,105,  77, 145,  93,  100
        WAIT

    ENDIF
    SPEED 14
    GOSUB 기본자세2

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
왼쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2
    GOTO RX_EXIT
    '**********************************************
오른쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
왼쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
오른쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    GOTO RX_EXIT
    '**********************************************
왼쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    'DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,왼쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴45_LOOP
    '
    GOTO RX_EXIT

    '**********************************************
오른쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
	MOVE G6B, 100, 180,  80,  ,  ,  
	MOVE G6C, 100, 180,  80,  ,  ,  

오른쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,오른쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴45_LOOP
    '
    GOTO RX_EXIT
    '**********************************************
왼쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2
    '  DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,왼쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴60_LOOP

    GOTO RX_EXIT

    '**********************************************
오른쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
오른쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,오른쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴60_LOOP

    GOTO RX_EXIT
    '****************************************
팔들고오른쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
	MOVE G6B, 100, 180,  80,  ,  ,  
	MOVE G6C, 100, 180,  80,  ,  ,  

팔들고오른쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,오른쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴45_LOOP
    '
    GOTO RX_EXIT
    '************************************************
팔들고왼쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 100, 180,  80,  ,  ,  
	MOVE G6C, 100, 180,  80,  ,  ,  
	
팔들고왼쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    'DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,왼쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴45_LOOP
    '
    GOTO RX_EXIT
    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세

    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON

    RETURN


    '**********************************************
앞으로일어나기:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 기본자세
    넘어진확인 = 1

    '******************************
    DELAY 200
    GOSUB 자이로ON
    RETURN

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
    '**********************************************

머리왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    GOTO MAIN

머리왼쪽45도:
    SPEED 머리이동속도
    SERVO 11,55
    GOTO MAIN

머리왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,40
    GOTO MAIN

머리왼쪽90도:
    SPEED 머리이동속도
    SERVO 11,10
    GOTO MAIN

머리오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,130
    GOTO MAIN

머리오른쪽45도:
    SPEED 머리이동속도
    SERVO 11,145
    GOTO MAIN	

머리오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    GOTO MAIN

머리오른쪽90도:
    SPEED 머리이동속도
    SERVO 11,190
    GOTO MAIN

머리좌우중앙:
    SPEED 머리이동속도
    SERVO 11,100
    GOTO MAIN

머리상하정면:
    SPEED 머리이동속도
    SERVO 11,100	' 이거 머임? 왜 상하인데 11이야
    SPEED 5
    GOSUB 기본자세
    GOTO MAIN

    '******************************************

앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    'GOSUB SOUND_PLAY_CHK
    PRINT "SND 16 !"
    'GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN


    '******************************************

    ' ************************************************
적외선거리센서확인:

    적외선거리값 = AD(적외선AD포트)

    IF 적외선거리값 > 50 THEN '50 = 적외선거리값 = 25cm
        'MUSIC "C"
        DELAY 200
    ENDIF




    RETURN

    '******************************************


    '**********************************************
집고왼쪽턴10:

    SPEED 5
    MOVE G6A,97,  86, 145,  75, 103, 100
    MOVE G6D,97,  66, 145,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  75, 101, 100
    MOVE G6D,94,  66, 145,  95, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
집고오른쪽턴10:

    SPEED 5
    MOVE G6A,97,  66, 145,  95, 103, 100
    MOVE G6D,97,  86, 145,  75, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  95, 101, 100
    MOVE G6D,94,  86, 145,  75, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
    '**********************************************
집고왼쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  96, 145,  65, 105, 100
    MOVE G6D,95,  56, 145,  105, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  65, 105, 100
    MOVE G6D,93,  56, 145,  105, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
집고오른쪽턴20:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  56, 145,  105, 105, 100
    MOVE G6D,95,  96, 145,  65, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  105, 105, 100
    MOVE G6D,93,  96, 145,  65, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
집고왼쪽턴45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  59, 105, 100
    MOVE G6D,95,  46, 145,  119, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  59, 105, 100
    MOVE G6D,93,  46, 145,  119, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  89, 100
    MOVE G6D,100,  76, 145,  89, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT

    '**********************************************
집고오른쪽턴45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  119, 105, 100
    MOVE G6D,95,  106, 145,  59, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  119, 105, 100
    MOVE G6D,93,  106, 145,  59, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  89, 100
    MOVE G6D,100,  76, 145,  89, 100
    WAIT
    GOSUB Leg_motor_mode1
    GOTO RX_EXIT
    '**********************************************
집고왼쪽턴60:

    SPEED 15
    MOVE G6A,95,  116, 145,  45, 105, 100
    MOVE G6D,95,  36, 145,  125, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  45, 105, 100
    MOVE G6D,90,  36, 145,  125, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '**********************************************
집고오른쪽턴60:

    SPEED 15
    MOVE G6A,95,  36, 145,  125, 105, 100
    MOVE G6D,95,  116, 145,  45, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  125, 105, 100
    MOVE G6D,90,  116, 145,  45, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT

    '************************************************

집고오른쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

집고오른쪽턴3_LOOP:
    MOVE G6B, 143, 10, 60,	  ,	  ,
    MOVE G6C, 143, 10, 60,	  ,   ,
    WAIT
    DELAY 3
    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 12
        MOVE G6A,102,  73, 145,  93, 100, 100
        MOVE G6D,102,  79, 145,  93, 100, 100
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,102,  84, 145,  78, 100, 100
        MOVE G6D,102,  68, 145,  108, 100, 100
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 6
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT
    ELSE
        보행순서 = 0
        SPEED 12
        MOVE G6A,102,  73, 145,  93, 100, 100
        MOVE G6D,102,  79, 145,  93, 100, 100
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,102,  88, 145,  78, 100, 100
        MOVE G6D,102,  65, 145,  108, 100, 100
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT
        SPEED 6
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT
    ENDIF
    SPEED 10
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOTO RX_EXIT
    '*************************************************

집고왼쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

집고왼쪽턴3_LOOP:
    MOVE G6B, 143, 10, 60,	  ,	  ,
    MOVE G6C, 143, 10, 60,	  ,   ,
    WAIT
    DELAY 3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 12
        MOVE G6D,102,  73, 145,  93, 100, 100
        MOVE G6A,102,  79, 145,  93, 100, 100
        WAIT

        SPEED 5
        MOVE G6D,102,  84, 145,  78, 100, 100
        MOVE G6A,102,  68, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 6
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 12
        MOVE G6D,102,  73, 145,  93, 100, 100
        MOVE G6A,102,  79, 145,  93, 100, 100
        WAIT


        SPEED 5
        MOVE G6D,102,  88, 145,  78, 100, 100
        MOVE G6A,102,  65, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 6
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 10
    '    GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOTO RX_EXIT


    '************************************************
    '************************************************

안전구역:
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 4 !"
    GOSUB SOUND_PLAY_CHK
    RETURN

확진구역:
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 5 !"
    GOSUB SOUND_PLAY_CHK
    RETURN

동쪽:
    SPEED 10
    MOVE G6C, 190, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 0 !"
    GOSUB SOUND_PLAY_CHK
    DELAY 500
    PRINT "SOUND 0 !"
    DELAY 10
    GOSUB 기본자세2
    RETURN

서쪽:
    SPEED 10
    MOVE G6B, 190, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 1 !"
    GOSUB SOUND_PLAY_CHK
    DELAY 500
    PRINT "SOUND 1 !"
    DELAY 10
    GOSUB 기본자세2	
    RETURN
남쪽:
    SPEED 10
    MOVE G6B, 30, 30, 80
    MOVE G6C, 30, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 2 !"
    GOSUB SOUND_PLAY_CHK
    DELAY 500
    PRINT "SOUND 2 !"
    DELAY 10
    GOSUB 기본자세2
    RETURN
북쪽:
    SPEED 10
    MOVE G6B, 190, 30, 80
    MOVE G6C, 190, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 3 !"
    DELAY 500
    PRINT "SOUND 3 !"
    DELAY 10
    GOSUB SOUND_PLAY_CHK
    GOSUB 기본자세2
    RETURN
    '******************************************

A지역:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 0 !"
    RETURN
B지역:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 1 !"
    RETURN
C지역:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 2 !"
    RETURN
D지역:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 3 !"
    RETURN

전방하향110도:
    SPEED 3
    SERVO 16, 110

    RETURN
    '******************************************
전방하향105도:
    SPEED 3
    SERVO 16, 105

    RETURN
    '******************************************
전방하향100도:
    SPEED 3
    SERVO 16, 100

    RETURN
    '******************************************
전방하향97도:
    SPEED 3
    SERVO 16, 97

    RETURN
    '******************************************
전방하향95도:
    SPEED 3
    SERVO 16, 95

    RETURN
    '******************************************
전방하향90도:

    SPEED 3
    SERVO 16, 92

    RETURN
    '******************************************
전방하향85도:

    SPEED 3
    SERVO 16, 85

    RETURN
    '******************************************
전방하향80도:

    SPEED 3
    SERVO 16, 80

    RETURN
    '******************************************
전방하향75도:
    SPEED 3
    SERVO 16, 76

    RETURN
    '******************************************
전방하향70도:
    SPEED 3
    SERVO 16, 73

    RETURN
    '******************************************
전방하향65도:
    SPEED 3
    SERVO 16, 69

    RETURN
    '******************************************
전방하향60도:

    SPEED 3
    SERVO 16, 65

    RETURN

    '******************************************
전방하향55도:

    SPEED 3
    SERVO 16, 59

    RETURN

    '******************************************
전방하향50도:
    SPEED 3
    SERVO 16, 54

    RETURN
    '******************************************

전방하향45도:
    SPEED 3
    SERVO 16, 50
    
    RETURN
    '******************************************
전방하향40도:
    SPEED 3
    SERVO 16, 45

    RETURN
    '******************************************
전방하향35도:
    SPEED 3
    SERVO 16, 40
    RETURN

    '******************************************
전방하향30도:

    SPEED 3
    SERVO 16, 36

    RETURN
    '******************************************
전방하향25도:
    SPEED 3
    SERVO 16, 30

    RETURN
    '******************************************
전방하향20도:
    SPEED 3
    SERVO 16, 26

    RETURN
    '******************************************
전방하향18도:

    SPEED 3
    SERVO 16, 22
    
    RETURN
    '******************************************
전방하향10도:

    SPEED 3
    SERVO 16, 10

    RETURN
    '******************************************

양팔벌리기:
    'MOVE G6A, 101,  83, 128,  96,  99, 100
    'MOVE G6D, 100,  79, 128, 100,  99, 100
    MOVE G6B, 107, 101, 100, 100, 100, 101
    MOVE G6C, 107, 101, 100, 100, 100, 100
    WAIT


    RETURN

잡기기본자세:
    MOVE G6B, 90, 80, 80, 90, 100, 101
    MOVE G6C, 90, 80, 80, 90, 100, 100
    WAIT

    RETURN


양팔앞으로:
    SPEED 4
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT

    'DELAY 10
    'GOSUB 기본자세2
    RETURN

양팔앞으로왼쪽걷기:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT

    DELAY 3

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100


    GOSUB All_motor_mode3
    GOTO RX_EXIT


    '******************************************	
양팔앞으로오른쪽걷기:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT

    DELAY 3

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3
    GOTO RX_EXIT




물건집기:
    GOSUB All_motor_mode3
    GOSUB 자이로OFF
    SPEED 8  'before 2
    MOVE G6A, 100, 150, 30,   150, 100,	
    MOVE G6D, 100, 150, 30,   150, 100,
    MOVE G6B, 140, 30, 80,	  ,	  ,
    MOVE G6C, 140, 30, 80,	  ,   ,
    WAIT

    DELAY 50
    GOTO 물건집기_2

물건집기_2:
    ETX 4800, 46
    SPEED 4  'before 4
    'DELAY 20
    MOVE G6A, 100, 150, 30,   150, 100,	
    MOVE G6D, 100, 150, 30,   150, 100,
    MOVE G6B, 150, 10, 60,	  ,	  ,
    MOVE G6C, 150, 10, 60,	  ,   ,
    WAIT

    DELAY 20
    GOTO 물건집기_3
물건집기_3:
    ETX 4800, 46
    SPEED 8   'before 4
    MOVE G6A,100, 76,  145,    93,  100, 100
    MOVE G6D,100, 76,  145,    93,  100, 100
    MOVE G6B, 150, 10, 60,	  ,	  ,
    MOVE G6C, 150, 10, 60,	  ,   ,
    WAIT

    'DELAY 20
    GOTO 물건집기_4
물건집기_4:
    ETX 4800, 46
    SPEED 8  'before 4
    MOVE G6A,100, 76,  145,    93,  100, 100
    MOVE G6D,100, 76,  145,    93,  100, 100
    MOVE G6B, 160
    MOVE G6C, 160
    WAIT

    RETURN
    '******************************************
집고왼쪽옆으로:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 185, 10, 60,	  ,	  ,
    MOVE G6C, 185, 10, 60,	  ,   ,
    WAIT

    DELAY 3

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100


    GOSUB All_motor_mode3
    GOTO RX_EXIT


    '******************************************	
집고오른쪽옆으로:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 185, 10, 60,	  ,	  ,
    MOVE G6C, 185, 10, 60,	  ,   ,
    WAIT

    DELAY 3

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3
    GOTO RX_EXIT

집고오른쪽옆으로2:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

집고오른쪽옆으로2_LOOP:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    MOVE G6B, 185, 10, 60,	  ,	  ,
    MOVE G6C, 185, 10, 60,	  ,   ,
    WAIT

    SPEED 13
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT


    '  ERX 4800, A ,오른쪽옆으로70연속_loop
    '    IF A = A_OLD THEN  GOTO 오른쪽옆으로70연속_loop
    '오른쪽옆으로70연속_stop:
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT
    '**********************************************

집고왼쪽옆으로2:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
집고왼쪽옆으로2_LOOP:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    MOVE G6B, 185, 10, 60,	  ,	  ,
    MOVE G6C, 185, 10, 60,	  ,   ,
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '   ERX 4800, A ,왼쪽옆으로70연속_loop	
    '    IF A = A_OLD THEN  GOTO 왼쪽옆으로70연속_loop
    '왼쪽옆으로70연속_stop:

    'GOSUB 기본자세
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT

    '******************************************

    '******************************************
우유깍잡기왼쪽옆으로:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    '   MOVE G6B, 175, 10, 60,	  ,	  ,
    '  MOVE G6C, 175, 10, 60,	  ,   ,
    WAIT

    DELAY 3

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100


    GOSUB All_motor_mode3
    GOTO RX_EXIT

우유깍잡기오른쪽옆으로:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    '   MOVE G6B, 175, 10, 60,	  ,	  ,
    '  MOVE G6C, 175, 10, 60,	  ,   ,
    '   MOVE G6B, 175, 10, 60,	  ,	  ,
    '  MOVE G6C, 175, 10, 60,	  ,   ,
    WAIT

    DELAY 3

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3
    GOTO RX_EXIT


물건놓기:
    GOSUB All_motor_mode3
    GOSUB 자이로OFF
    MOVE G6B, 145, , ,
    MOVE G6C, 145, , ,
    WAIT

    MOVE G6B, 140, 10, 60,	  ,	  ,
    MOVE G6C, 140, 10, 60,	  ,   ,
    WAIT

    GOTO 물건놓기_2	
물건놓기_2:
    ETX 4800, 47
    MOVE G6A, 100, 150, 30,   150, 100,	
    MOVE G6D, 100, 150, 30,   150, 100,
    MOVE G6B, 150, , ,
    MOVE G6C, 150, , ,
    WAIT

    GOTO 물건놓기_3
물건놓기_3:
    ETX 4800, 47
    MOVE G6B, , 30, 90
    MOVE G6C, , 30, 90
    WAIT

    GOTO 물건놓기_4
물건놓기_4:
    ETX 4800, 47
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOSUB 기본자세
    RETURN

집고전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    'HIGHSPEED SETON
    MOVE G6B, 160, 10, 50
    MOVE G6C, 160, 10, 50


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        'MOVE G6B,100
        'MOVE G6C,100
        WAIT

        GOTO 집고전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        'MOVE G6B,100
        'MOVE G6C,100
        WAIT

        GOTO 집고전진종종걸음_4
    ENDIF


    '**********************

집고전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    'MOVE G6B, 85
    'MOVE G6C,115
    WAIT


집고전진종종걸음_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

    ERX 4800,A, 집고전진종종걸음_4
    IF A <> A_old THEN
집고전진종종걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        'MOVE G6C, 100
        'MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

집고전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    'MOVE G6C, 85
    'MOVE G6B,115
    WAIT


집고전진종종걸음_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

    ERX 4800,A, 집고전진종종걸음_1
    IF A <> A_old THEN
집고전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        'MOVE G6B, 100
        'MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

물건집고전진:
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    'GOSUB 전방하향18도
    'DELAY 20
    SPEED 6
    GOSUB All_motor_mode3
    MOVE G6B, 160, 10, 50
    MOVE G6C, 160, 10, 50
    WAIT

    DELAY 20
    'HIGHSPEED SETON

    SPEED 6
    MOVE G6D,  90,  74, 144,  95, 110
    MOVE G6A, 108,  76, 146,  93, 96
    WAIT

    SPEED 8
    MOVE G6D,90, 90, 120, 102, 110,100
    MOVE G6A,108,  76, 147,  93,  96,100
    WAIT

    'HIGHSPEED SETOFF
    GOTO 물건집고전진_2	

물건집고전진_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 102, 107,100
    WAIT

물건집고전진_3:
    'ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 90,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  90,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,108,  76, 147, 90,  98
    MOVE G6A,90, 100, 142,  69, 108
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 물건집고전진_4
    IF A = 11 THEN
        GOTO 물건집고전진_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
물건집고전진_4:
    SPEED 9
    MOVE G6A,95, 90, 120, 102, 111,100
    MOVE G6D,108,  76, 146,  93,  96,100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    RETURN

집고전진:
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    'GOSUB 전방하향18도
    'DELAY 20
    SPEED 10
    GOSUB All_motor_mode3
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT

    DELAY 20
    'HIGHSPEED SETON

    SPEED 10
    MOVE G6D,  90,  74, 142,  94, 109
    MOVE G6A, 108,  76, 144,  93, 96
    WAIT

    SPEED 12
    MOVE G6D,90, 90, 118, 101, 109,99
    MOVE G6A,108,  76, 145,  92,  96,100
    WAIT

    'HIGHSPEED SETOFF
    GOTO 집고전진_2	

집고전진_2:
    MOVE G6A,110,  76, 145,  93, 100,100
    MOVE G6D,96, 90, 118, 101, 106,99
    WAIT

집고전진_3:
    'ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 90,  56, 143, 114, 109
    MOVE G6A,108,  76, 145,  89,  95
    WAIT

    SPEED 좌우속도
    MOVE G6D,108,  76, 145, 89,  97
    MOVE G6A,90, 100, 140,  68, 107
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 집고전진_4
    IF A = 11 THEN
        GOTO 집고전진_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
집고전진_4:
    SPEED 13
    MOVE G6A,95, 90, 118, 101, 110,99
    MOVE G6D,108,  76, 144,  92,  95,99
    WAIT

    SPEED 11
    MOVE G6A,100,  76, 143,  92, 99, 100
    MOVE G6D,100,  76, 143,  92, 99, 100
    WAIT

    GOTO RX_EXIT
    '*******************
횟수_집고후진:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    'HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        GOTO 횟수_집고후진_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        GOTO 횟수_집고후진_4
    ENDIF

    '*******************************************

횟수_집고후진_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT



횟수_집고후진_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_집고후진_3_stop
    ERX 4800,A, 횟수_집고후진_4
    IF A <> A_old THEN
횟수_집고후진_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        'SPEED 15
        '        GOSUB 안정화자세
        '       HIGHSPEED SETOFF
        '      SPEED 5
        '     GOSUB 기본자세2

        '   DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

횟수_집고후진_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT


횟수_집고후진_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_집고후진_6_stop

    ERX 4800,A, 횟수_집고후진_1
    IF A <> A_old THEN  'GOTO 횟수_집고후진_멈춤
횟수_집고후진_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        'SPEED 15
        '        GOSUB 안정화자세
        '       HIGHSPEED SETOFF
        '      SPEED 5
        '     GOSUB 기본자세2

        '  DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO 횟수_집고후진_1


우유깍놓기_1:
    SPEED 4
    MOVE G6B, 190, 20, 60
    MOVE G6C, 190, 20, 60
    WAIT

    'DELAY 10
    'GOSUB 기본자세2
    RETURN

우유깍놓기_2:
    SPEED 4
    MOVE G6B, 150, 20, 60
    MOVE G6C, 150, 20, 60
    WAIT

    'DELAY 10
    'GOSUB 기본자세2
    RETURN

우유깍잡기_1:
    SPEED 4
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT

    'DELAY 10
    'GOSUB 기본자세2
    RETURN
    'GOTO RX_EXIT

우유깍잡기_2:
    SPEED 4
    MOVE G6B, 150, 10, 50
    MOVE G6C, 150, 10, 50
    WAIT

    'DELAY 10
    'GOSUB 기본자세2
    RETURN
    ' GOTO RX_EXIT

우유깍잡기_3:
    SPEED 4
    MOVE G6B, 130, 10, 50
    MOVE G6C, 130, 10, 50
    WAIT

    'DELAY 10
    'GOSUB 기본자세2
    RETURN
    'GOTO RX_EXIT
    '*****************************************************
우유깍잡기오른쪽돌기1:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

우유깍잡기오른쪽돌기1_LOOP:
    '  MOVE G6B, 190, 10, 50
    ' MOVE G6C, 190, 10, 50  ,   ,
    WAIT
    DELAY 3
    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 12
        MOVE G6A,102,  73, 145,  93, 100, 100
        MOVE G6D,102,  79, 145,  93, 100, 100
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,102,  84, 145,  78, 100, 100
        MOVE G6D,102,  68, 145,  108, 100, 100
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 6
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT
    ELSE
        보행순서 = 0
        SPEED 12
        MOVE G6A,102,  73, 145,  93, 100, 100
        MOVE G6D,102,  79, 145,  93, 100, 100
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 5
        MOVE G6A,102,  88, 145,  78, 100, 100
        MOVE G6D,102,  65, 145,  108, 100, 100
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT
        SPEED 6
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT
    ENDIF
    SPEED 10
    'GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOTO RX_EXIT
    '*************************************************

우유깍잡기왼쪽돌기1:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

우유깍잡기왼쪽돌기1_LOOP:
    '   MOVE G6B, 190, 10, 50
    '  MOVE G6C, 190, 10, 50
    WAIT
    DELAY 3

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 12
        MOVE G6D,102,  73, 145,  93, 100, 100
        MOVE G6A,102,  79, 145,  93, 100, 100
        WAIT

        SPEED 5
        MOVE G6D,102,  84, 145,  78, 100, 100
        MOVE G6A,102,  68, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 6
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 12
        MOVE G6D,102,  73, 145,  93, 100, 100
        MOVE G6A,102,  79, 145,  93, 100, 100
        WAIT


        SPEED 5
        MOVE G6D,102,  88, 145,  78, 100, 100
        MOVE G6A,102,  65, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 6
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 10
    '    GOSUB 기본자세2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOTO RX_EXIT


우유깍잡기걷기_1:
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    'GOSUB 전방하향18도
    'DELAY 20
    SPEED 6
    GOSUB All_motor_mode3
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT

    DELAY 20
    'HIGHSPEED SETON

    SPEED 6
    MOVE G6D,  90,  74, 144,  94, 109
    MOVE G6A, 108,  76, 146,  93, 96
    WAIT

    SPEED 8
    MOVE G6D,90, 90, 120, 101, 109,99
    MOVE G6A,108,  76, 147,  92,  96,100
    WAIT

    'HIGHSPEED SETOFF
    GOTO 우유깍잡기걷기_1_2	

우유깍잡기걷기_1_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

우유깍잡기걷기_1_3:
    'ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED 좌우속도
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유깍잡기걷기_1_4
    IF A = 11 THEN
        GOTO 우유깍잡기걷기_1_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
우유깍잡기걷기_1_4:
    SPEED 9
    MOVE G6A,95, 90, 120, 101, 110,99
    MOVE G6D,108,  76, 146,  92,  95,99
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  92, 99, 100
    MOVE G6D,100,  76, 145,  92, 99, 100
    WAIT

    RETURN

    '*******************************************
우유깍잡기걷기_2:
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    'GOSUB 전방하향18도
    'DELAY 20
    SPEED 6
    GOSUB All_motor_mode3
    MOVE G6B, 150, 10, 50
    MOVE G6C, 150, 10, 50
    WAIT

    DELAY 20
    'HIGHSPEED SETON

    SPEED 6
    MOVE G6D,  90,  74, 144,  94, 109
    MOVE G6A, 108,  76, 146,  93, 96
    WAIT

    SPEED 8
    MOVE G6D,90, 90, 120, 101, 109,99
    MOVE G6A,108,  76, 147,  92,  96,100
    WAIT

    'HIGHSPEED SETOFF
    GOTO 우유깍잡기걷기_2_2	

우유깍잡기걷기_2_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

우유깍잡기걷기_2_3:
    'ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED 좌우속도
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유깍잡기걷기_2_4
    IF A = 11 THEN
        GOTO 우유깍잡기걷기_2_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
우유깍잡기걷기_2_4:
    SPEED 9
    MOVE G6A,95, 90, 120, 101, 110,99
    MOVE G6D,108,  76, 146,  92,  95,99
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  92, 99, 100
    MOVE G6D,100,  76, 145,  92, 99, 100
    WAIT

    RETURN
    '*******************************************
우유깍잡기걷기_3:
    보행속도 = 8
    좌우속도 = 4
    넘어진확인 = 0

    'GOSUB 전방하향18도
    'DELAY 20
    SPEED 6
    GOSUB All_motor_mode3
    MOVE G6B, 130, 10, 50
    MOVE G6C, 130, 10, 50
    WAIT

    DELAY 20
    'HIGHSPEED SETON

    SPEED 6
    MOVE G6D,  90,  74, 144,  94, 109
    MOVE G6A, 108,  76, 146,  93, 96
    WAIT

    SPEED 8
    MOVE G6D,90, 90, 120, 101, 109,99
    MOVE G6A,108,  76, 147,  92,  96,100
    WAIT

    'HIGHSPEED SETOFF
    GOTO 우유깍잡기걷기_3_2	

우유깍잡기걷기_3_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

우유깍잡기걷기_3_3:
    'ETX 4800,13 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED 좌우속도
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, 우유깍잡기걷기_3_4
    IF A = 11 THEN
        GOTO 우유깍잡기걷기_3_4
        '    ELSE
        '    	MOVE G6A, 90, 100, 100, 115, 110,100
        ' 		MOVE G6D,112,  76, 146,  93,  96,100
        ' 		MOVE G6B,90
        ' 		MOVE G6C,110
        ' 		WAIT
        ' 		HIGHSPEED SETOFF
        ' 		SPEED 8

        ' 		MOVE G6D, 106,  76, 146,  93,  96,100		
        ' 		MOVE G6A,  88,  71, 152,  91, 106,100
        ' 		MOVE G6C, 100
        ' 		MOVE G6B, 100
        ' 		WAIT	
        ' 		SPEED 8
        ' 		GOSUB 기본자세2

        ' 		GOTO RX_EXIT
    ENDIF
우유깍잡기걷기_3_4:
    SPEED 9
    MOVE G6A,95, 90, 120, 101, 110,99
    MOVE G6D,108,  76, 146,  92,  95,99
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  92, 99, 100
    MOVE G6D,100,  76, 145,  92, 99, 100
    WAIT

    RETURN

    '******************************************
계단왼발오르기1cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,114,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,114,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 55, 130, 140, 114,
    MOVE G6D,114,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 75, 100, 155, 100,
    MOVE G6D,95,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 114, 90, 90, 155,100,
    MOVE G6D,95,  100, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6A, 114, 90, 110, 130,95,
    MOVE G6D,90,  95, 90,  145, 108
    MOVE G6B,140,50
    MOVE G6C,140,30
    WAIT

    SPEED 10
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOTO RX_EXIT
    '****************************************

계단오른발오르기1cm:
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 155, 100,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOTO RX_EXIT

    '******************************************
계단오른발내리기1cm:
    
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    '오른발 완전 집어넣기 ''''
    SPEED 5
    MOVE G6A, 100, 110,  112, 92,  101, 100
    MOVE G6D,  100,  112, 112, 92, 101, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '왼발목 왼쪽으로
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  85,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT 	

    '오른발 거의발목까지   집어넣기
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT 	

    '오른발 거의  집어넣기
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  105, 63, 119, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 집어넣기
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  15, 139, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '왼무릎수직 최종들기
    SPEED 2
    MOVE G6A, 112, 110,  112, 77,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '왼무릎 많이들기
    SPEED 1
    MOVE G6A, 112, 125,  102, 65,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT	

    '왼무릎 들기
    SPEED 5
    MOVE G6A, 108, 140,  92, 82,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '시험 오른발로 지탱하고 내려가는 동작
    SPEED 5
    MOVE G6A, 105, 140,  92, 102,  81, 100
    MOVE G6D,  95,  15, 169, 149, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '왼발 , 오른발 세우기
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  81, 100
    MOVE G6D,  95,  35, 149, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 거의 수직으로 세우기 ';';'
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  96, 100
    MOVE G6D,  100,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 발목 왼쪽으로 기울이기
    SPEED 5
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  105,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 무릎과 상체 숙이기
    SPEED 3
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  110,  45, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 무릎 약간 올리기
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  110,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 무릎 약간 올리기 (오른발 발목 중심 잡기)
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 앞으로 갖고오기
    SPEED 3
    MOVE G6A, 97, 105,  103, 132,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 앞으로 갖고오기 2
    SPEED 3
    MOVE G6A, 97, 110,  97, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 앞으로 갖고오기 3
    SPEED 3
    MOVE G6A, 97, 110,  107, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 내리기1
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 내리기2
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  107,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT

    '오른발 내리기3
    SPEED 3
    MOVE G6A, 97, 55,  149, 136,  96, 100
    MOVE G6D,  107,  55, 149, 139, 104, 100
    MOVE G6B, 101,  36,  85, 100, 30, 101
    MOVE G6C,  99,  32,  92, 100,  30, 100
    WAIT


    SPEED 4
    GOSUB 기본자세''검수 대상

    RETURN
    '******************************************
계단왼발내리기1cm:
    
	GOSUB All_motor_mode3

    '왼발 완전 집어넣기 ''''
    SPEED 5
    MOVE G6D, 100, 110,  112, 92,  101, 100
    MOVE G6A,  100,  112, 112, 92, 101, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발목 왼쪽으로
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  85,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    '왼발 거의발목까지   집어넣기
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    '왼발 거의  집어넣기
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  105, 63, 119, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 집어넣기
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  15, 139, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '오른무릎수직 최종들기
    SPEED 2
    MOVE G6D, 112, 110,  112, 77,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '오른무릎 많이들기
    SPEED 1
    MOVE G6D, 112, 125,  102, 65,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT	

    '오른무릎 들기
    SPEED 5
    MOVE G6D, 108, 140,  92, 82,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '시험 왼발로 지탱하고 내려가는 동작
    SPEED 5
    MOVE G6D, 105, 140,  92, 102,  81, 100
    MOVE G6A,  95,  15, 169, 149, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '오른발 , 왼발 세우기
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  81, 100
    MOVE G6A,  95,  35, 149, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 거의 수직으로 세우기 ';';'
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  96, 100
    MOVE G6A,  100,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 발목 왼쪽으로 기울이기
    SPEED 5
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  105,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 무릎과 상체 숙이기
    SPEED 3
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  110,  45, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 무릎 약간 올리기
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  110,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 무릎 약간 올리기 (왼발 발목 중심 잡기)
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 앞으로 갖고오기
    SPEED 3
    MOVE G6D, 97, 105,  103, 132,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 앞으로 갖고오기 2
    SPEED 3
    MOVE G6D, 97, 110,  97, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 앞으로 갖고오기 3
    SPEED 3
    MOVE G6D, 97, 110,  107, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 내리기1
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 내리기2
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  107,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '왼발 내리기3
    SPEED 3
    MOVE G6D, 97, 55,  149, 136,  96, 100
    MOVE G6A,  107,  55, 149, 139, 104, 100
    MOVE G6C, 101,  36,  85, 100, 30, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB 기본자세''검수 대상

    RETURN

    '******************************************

샤삭샤삭:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 13
    'HIGHSPEED로 안 하면 뒤로 감... 미친놈인 듯
    'HIGHSPEED SETON
    '..... 이거 하면 다음 모션들까지 다 개빨라지는데 복귀를 어떻게 하는지 모르겠음


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 샤삭샤삭1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 샤삭샤삭4
    ENDIF


    '**********************

샤삭샤삭1: '왼발
    'HIGHSPEED SETON
    MOVE G6D,104,  77, 147, 93, 100
    MOVE G6A,95,  95, 143,  94,  102
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT
샤삭샤삭2:

    MOVE G6A,99,    75, 146, 97,  98
    MOVE G6D, 95,  77, 147,  90, 100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

    ERX 4800,A, 샤삭샤삭4
    IF A <> A_old THEN
샤삭샤삭_2_stop:
        MOVE G6D,95,  87, 143, 97, 102
        MOVE G6A,104,  76, 145,  92,  100
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

샤삭샤삭4: '오른발
    MOVE G6A,104,  77, 147, 93, 100
    MOVE G6D,95,  95, 143,  94,  102
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

샤삭샤삭5:
    MOVE G6D,99,    75, 146, 97,  98
    MOVE G6A, 95,  77, 147,  93, 100
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

    ERX 4800,A, 샤삭샤삭1
    IF A <> A_old THEN
샤삭샤삭5_stop:
        MOVE G6A,95,  87, 143, 97, 102
        MOVE G6D,104,  76, 145,  92,  100
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
		GOTO 샤삭샤삭1
    '******************************************

횟수_샤삭샤삭:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 13
    'HIGHSPEED로 안 하면 뒤로 감... 미친놈인 듯
    'HIGHSPEED SETON
    '..... 이거 하면 다음 모션들까지 다 개빨라지는데 복귀를 어떻게 하는지 모르겠음


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 샤삭샤삭1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 샤삭샤삭4
    ENDIF


    '**********************

횟수_샤삭샤삭1: '왼발
    'HIGHSPEED SETON
    MOVE G6D,104,  77, 147, 93, 100
    MOVE G6A,95,  95, 143,  94,  102
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT
횟수_샤삭샤삭2:

    MOVE G6A,99,    75, 146, 97,  98
    MOVE G6D, 95,  77, 147,  90, 100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_샤삭샤삭_2_stop

    ERX 4800,A, 횟수_샤삭샤삭4
    IF A <> A_old THEN
횟수_샤삭샤삭_2_stop:
        MOVE G6D,104,  77, 147, 93, 100
        MOVE G6A,95,  95, 143,  94,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

횟수_샤삭샤삭4: '오른발
    MOVE G6A,104,  77, 147, 93, 100
    MOVE G6D,95,  95, 143,  94,  102
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

횟수_샤삭샤삭5:
    MOVE G6D,99,    75, 146, 97,  98
    MOVE G6A, 95,  77, 147,  93, 100
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_샤삭샤삭5_stop

    ERX 4800,A, 횟수_샤삭샤삭1
    IF A <> A_old THEN
횟수_샤삭샤삭5_stop:
        MOVE G6A,104,  77, 147, 93, 100
        MOVE G6D,95,  95, 143,  94,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
		GOTO 샤삭샤삭1
		
	'*****************************************
뒤로샤삭샤삭:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 13
    'HIGHSPEED로 안 하면 뒤로 감... 미친놈인 듯
    'HIGHSPEED SETON
    '..... 이거 하면 다음 모션들까지 다 개빨라지는데 복귀를 어떻게 하는지 모르겠음


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 뒤로샤삭샤삭1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 뒤로샤삭샤삭4
    ENDIF


    '**********************

뒤로샤삭샤삭1: '왼발
    'HIGHSPEED SETON
    MOVE G6D,104,  76, 147,  93,  100
    MOVE G6A,95,  80, 140, 94, 102
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT
뒤로샤삭샤삭2:

    MOVE G6A,99,   75, 140, 90,  98
    MOVE G6D, 95,  73, 147,  96, 100
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

    ERX 4800,A, 뒤로샤삭샤삭4
    IF A <> A_old THEN
뒤로샤삭샤삭_2_stop:
        MOVE G6D,95,  82, 135, 93, 104
        MOVE G6A,96,  78, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

뒤로샤삭샤삭4: '오른발
    MOVE G6A,104,  76, 147,  93,  100
    MOVE G6D,95,  80, 140, 94, 104
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

뒤로샤삭샤삭5:
    MOVE G6D,99,   75, 140, 90,  98
    MOVE G6A, 95,  73, 147,  96, 100
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

    ERX 4800,A, 뒤로샤삭샤삭1
    IF A <> A_old THEN
뒤로샤삭샤삭5_stop:
        MOVE G6A,95,  82, 135, 93, 104
        MOVE G6D,96,  78, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
		GOTO 뒤로샤삭샤삭1

	'**************************************
장애물차기:

    '안정화자세
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT

    SPEED 4
    '왼쪽으로 무게 중심 옮기기(왼발목,오른발목 왼쪽으로 기울이기)
    MOVE G6A, 108,  76, 146,  93,  96
    MOVE G6D,  88,  74, 144,  95, 110
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT

    SPEED 10
    '오른발 들기
    MOVE G6A,112,  79, 147,  93,  96,100
    MOVE G6D, 90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 10
    '오른발 차기
    MOVE G6A,112,  76, 147,  93,  96,100
    MOVE G6D, 90, 80, 120, 130, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    RETURN

    '******************************************
장애물왼쪽앞치우기:

    '무릎 굽히기
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,100,  23,  90,
    MOVE G6C,100,  23,  90, ,20
    WAIT

    DELAY 300

    '왼팔 뻗기
    SPEED 15
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,140, 50,  90,
    MOVE G6C,100,  23,  90
    WAIT


    SPEED 5
    '발 모으기
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  65,  85
    MOVE G6C,130,  50,  85
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT


    '발 조금 모으기
    'test
    SPEED 5	
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  80, 150,  25, 162, 115
    MOVE G6B,160, 65,  75,
    MOVE G6C,120,  50,  90
    WAIT

    '허리 접기
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,179, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT

    '팔 접기
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,159, 30,  75,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETON

    '왼팔꿈치 움직이기
    '170
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,169, 10,  65,
    '    MOVE G6C,120, 50,  90
    '    WAIT

    '왼팔꿈치 움직이기test
    '170
    SPEED 10	
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,170, 10,  30,
    MOVE G6C,120,  50,  90
    WAIT

    '왼팔꿈치 움직이기test2
    '170
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 25,  30,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    DELAY 500

    '왼팔꿈치 움직이기 밖으로빼기
    '170
    SPEED 10
    MOVE G6A,  70, 165,  25, 162, 135
    MOVE G6D,  70, 165,  25, 162, 135
    MOVE G6B,170, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT


    '왼팔꿈치 움직이기
    '160
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 10,  60,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETOFF

    '발 조금 모으기

    SPEED 5
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  80, 150,  25, 162, 115
    MOVE G6B,170, 65,  70,
    MOVE G6C,120,  50,  90
    WAIT

    '발 모으기
    SPEED 5
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85
    MOVE G6C,130,  50,  85,,20
    WAIT

    '안정화자세
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT

    RETURN
    
    '******************************************
장애물오른쪽앞치우기:

	'

    '무릎 굽히기
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,100,  65,  35,
    MOVE G6C,100,  65,  35, ,20
    WAIT
    
    '팔 앞으로 
    SPEED 5
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6B,90,  65,  30,
    MOVE G6C,140,  65,  30, ,20
    WAIT

    DELAY 300

    '왼팔 뻗기
    SPEED 15
    MOVE G6A, 98, 165,  27, 131,  101, 100
    MOVE G6D, 98, 165,  27, 131,  101, 100
    MOVE G6C,140, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    DELAY 300


    SPEED 5
    '발 모으기
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6C,140, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    DELAY 300

    '발 조금 모으기
    'test
    SPEED 5	
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  83, 150,  25, 162, 115
    MOVE G6C,160, 25,  90,
    MOVE G6B,90,  35,  90
    WAIT

    '허리 접기
    'SPEED 10	
    SPEED 5
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,179, 65,  70,
    MOVE G6B,90,  45,  90
    WAIT



    '팔 접기
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,159, 30,  75,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETON

    '왼팔꿈치 움직이기
    '170
    ' SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,169, 10,  65,
    '    MOVE G6C,120, 50,  90
    '    WAIT

    '왼팔꿈치 움직이기test
    '170
    SPEED 10	
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,170, 10,  30,
    MOVE G6B,90,  45,  90
    WAIT

    '왼팔꿈치 움직이기test2
    '170
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 25,  30,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    DELAY 500

    '왼팔꿈치 움직이기 밖으로빼기
    '170
    SPEED 10
    MOVE G6A,  70, 165,  25, 152, 135
    MOVE G6D,  70, 165,  25, 152, 135
    MOVE G6C,170, 65,  70,
    MOVE G6B,90,  45,  90
    WAIT


    '왼팔꿈치 움직이기
    '160
    'SPEED 10	
    '    MOVE G6A,  70, 165,  25, 162, 135
    '    MOVE G6D,  70, 165,  25, 162, 135
    '    MOVE G6B,160, 10,  60,
    '    MOVE G6C,120,  50,  90
    '    WAIT

    HIGHSPEED SETOFF

    '발 조금 모으기

    SPEED 5
    MOVE G6A,  80, 150,  25, 162, 115
    MOVE G6D,  83, 150,  25, 162, 115
    MOVE G6C,170, 65,  70,
    MOVE G6B,115,  50,  90
    WAIT

    '발 모으기
    SPEED 5
    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,120,  40,  85
    MOVE G6C,120,  40,  85,,20
    WAIT

    '안정화자세
    SPEED 5
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90
    MOVE G6C,100,  35,  90
    WAIT

    RETURN

	'******************************************

MAIN: '라벨설정

    ETX 4800, 200 ' 동작 멈춤 확인 송신 값

MAIN_2:

    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 	 라벨, 2이면 key2로... 가는문
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32


    IF A > 100 AND A < 110 THEN
        BUTTON_NO = A - 100
        GOSUB Number_Play
        'GOSUB SOUND_PLAY_CHK
        GOSUB GOSUB_RX_EXIT


    ELSEIF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

KEY1:
    ETX  4800,1

    ' 보행횟수 = 2
    GOSUB 왼쪽턴10
    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

    보행횟수 = 1
    GOTO 횟수_전진종종걸음

    GOTO RX_EXIT
    '***************

KEY3:
    ETX 4800, 3
    ' GOTO 왼쪽옆으로20
    GOSUB 오른쪽턴10
    GOTO RX_EXIT
KEY4:
    ETX 4800, 4
    GOSUB 왼쪽옆으로20
    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    'J = AD(적외선AD포트)	'적외선거리값 읽기
    'ETX 4800, J
    'BUTTON_NO = J
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    'GOSUB GOSUB_RX_EXIT
    GOSUB 머리좌우중앙

    GOTO RX_EXIT
    '***************
KEY6:
    ETX 4800, 6
    GOSUB 오른쪽옆으로20
    GOTO RX_EXIT
KEY7:
    ETX 4800, 7
    GOSUB 팔들고왼쪽턴45
    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB 연속후진
    GOTO RX_EXIT
    '***************
KEY9:
    ETX 4800, 9
    GOSUB 팔들고오른쪽턴45
    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX 4800, 10
    GOSUB 고개중앙기본자세
    GOTO RX_EXIT
    '***************
KEY11: ' ▲
    ETX  4800,11

    GOTO 집고전진
    GOTO RX_EXIT

    '***************
KEY12: ' ▼
    ETX  4800,12

    GOSUB 물건놓기
    GOTO RX_EXIT
    '***************
KEY13: '▶
    ETX  4800,13
    'GOSUB 전방하향90도
    GOSUB 집고오른쪽턴45

    GOTO RX_EXIT
    '**************
KEY14: ' ◀
    ETX  4800,14
    GOSUB 집고왼쪽턴45
    GOTO RX_EXIT


    GOTO RX_EXIT
    '***************
KEY15: 'A
    ETX 4800, 15
    GOSUB 샤삭샤삭
    GOTO RX_EXIT
KEY16: ' POWER
    ETX  4800,16

    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB 앉은자세	
    GOSUB 종료음

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A

    '**** RX DATA Number Sound ********
    BUTTON_NO = A
    GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK


    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB 고개중앙기본자세
        GOSUB 자이로ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX 4800, 17
    GOSUB 머리왼쪽45도
    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX 4800, 18
    GOSUB 우유깍잡기왼쪽옆으로
    GOTO RX_EXIT
    '***************
KEY19: 'P2
    ETX 4800, 19
    GOSUB  계단오른발내리기1cm
    GOTO RX_EXIT
    '***************
KEY20: 'B
    ETX 4800, 20
    GOSUB 뒤로샤삭샤삭
    GOTO RX_EXIT
    '***************
KEY21: ' △
    ETX  4800,21
    GOSUB 전방하향70도

    GOTO RX_EXIT
    '***************
KEY22: ' *
    ETX 4800, 22
    '  GOTO 오른쪽턴3
    'GOTO 오른쪽턴20
    ' GOTO 집고오른쪽턴45
    GOTO 계단왼발오르기1cm
    GOTO RX_EXIT
    '***************
KEY23: 'G
    ETX 4800, 23
    GOSUB 우유깍잡기오른쪽옆으로
    GOTO RX_EXIT
    '***************
KEY24: '#
    ETX 4800, 24
    GOSUB 계단오른발오르기1cm
    GOTO RX_EXIT
    '***************
KEY25: 'P1
    ETX 4800, 25
    ' GOTO 집고왼쪽턴45
    ' GOTO 왼쪽턴3
    'GOTO 왼쪽턴20
    GOSUB 계단왼발내리기1cm
    GOTO RX_EXIT
    '***************
KEY26: ' ■
    ETX  4800,26

    'SPEED 5
    GOSUB 물건집기
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX 4800, 27
    GOTO 머리오른쪽45도
    GOTO RX_EXIT
    '***************
KEY28: ' ◁
    ETX 4800, 28
    GOSUB 전방하향45도
    GOTO RX_EXIT
    '***************
KEY29: ' □
    ETX 4800, 29
    GOSUB 장애물왼쪽앞치우기
    GOTO RX_EXIT
    '***************
KEY30: ' ▷
    ETX 4800, 30
    GOSUB 전방하향30도
    GOTO RX_EXIT
    '***************
KEY31: ' ▽
    ETX 4800, 31
    GOSUB 장애물오른쪽앞치우기
    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX 4800, 32
    GOSUB 전방하향100도
    GOTO RX_EXIT
    '***************