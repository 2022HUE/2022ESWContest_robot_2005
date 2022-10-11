'******** 2¡∑ ∫∏«‡∑Œ∫ø √ ±‚ øµ¡° «¡∑Œ±◊∑• ********

'-*- coding: utf-8 -*-'

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ∫∏«‡º”µµ AS BYTE
DIM ¡¬øÏº”µµ AS BYTE
DIM ¡¬øÏº”µµ2 AS BYTE
DIM ∫∏«‡º¯º≠ AS BYTE
DIM «ˆ¿Á¿¸æ– AS BYTE
DIM π›¿¸√º≈© AS BYTE
DIM ∏≈ÕONOFF AS BYTE
DIM ¿⁄¿Ã∑ŒONOFF AS BYTE
DIM ±‚øÔ±‚æ’µ⁄ AS INTEGER
DIM ±‚øÔ±‚¡¬øÏ AS INTEGER

DIM ∞Óº±πÊ«‚ AS BYTE

DIM ≥—æÓ¡¯»Æ¿Œ AS BYTE
DIM ±‚øÔ±‚»Æ¿Œ»Ωºˆ AS BYTE
DIM ∫∏«‡»Ωºˆ AS BYTE
DIM ∫∏«‡COUNT AS BYTE

DIM ¿˚ø‹º±∞≈∏Æ∞™  AS BYTE

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

'**** ±‚øÔ±‚ºæº≠∆˜∆Æ º≥¡§ ****
CONST æ’µ⁄±‚øÔ±‚AD∆˜∆Æ = 0
CONST ¡¬øÏ±‚øÔ±‚AD∆˜∆Æ = 1
CONST ±‚øÔ±‚»Æ¿ŒΩ√∞£ = 20  'ms

CONST ¿˚ø‹º±AD∆˜∆Æ  = 4


CONST min = 61	'µ⁄∑Œ≥—æÓ¡≥¿ª∂ß
CONST max = 107	'æ’¿∏∑Œ≥—æÓ¡≥¿ª∂ß
CONST COUNT_MAX = 3


CONST ∏”∏Æ¿Ãµøº”µµ = 10
'************************************************



PTP SETON 				'¥‹¿ß±◊∑Ï∫∞ ¡°¥Î¡°µø¿€ º≥¡§
PTP ALLON				'¿¸√º∏≈Õ ¡°¥Î¡° µø¿€ º≥¡§

DIR G6A,1,0,0,1,0,0		'∏≈Õ0~5π¯
DIR G6D,0,1,1,0,1,1		'∏≈Õ18~23π¯
DIR G6B,1,1,1,1,1,1		'∏≈Õ6~11π¯
DIR G6C,0,0,0,0,1,0		'∏≈Õ12~17π¯

'************************************************

OUT 52,0	'∏”∏Æ LED ƒ—±‚
'***** √ ±‚º±æ '************************************************

∫∏«‡º¯º≠ = 0
π›¿¸√º≈© = 0
±‚øÔ±‚»Æ¿Œ»Ωºˆ = 0
∫∏«‡»Ωºˆ = 1
∏≈ÕONOFF = 0

'****√ ±‚¿ßƒ° ««µÂπÈ*****************************


TEMPO 230
'MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB ¿¸ø¯√ ±‚¿⁄ºº
GOSUB ±‚∫ª¿⁄ºº


GOSUB ¿⁄¿Ã∑ŒINIT
GOSUB ¿⁄¿Ã∑ŒMID
GOSUB ¿⁄¿Ã∑ŒON



PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" 'æ»≥Á«œººø‰

GOSUB All_motor_mode3





GOTO MAIN	'Ω√∏ÆæÛ ºˆΩ≈ ∑Á∆æ¿∏∑Œ ∞°±‚

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
Ω√¿€¿Ω:
    TEMPO 220
    'MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
¡æ∑·¿Ω:
    TEMPO 220
    'MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
ø°∑Ø¿Ω:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '¿¸∆˜∆Æº≠∫∏∏≈ÕªÁøÎº≥¡§

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ∏≈ÕONOFF = 0
    GOSUB Ω√¿€¿Ω			
    RETURN

    '************************************************
    '¿¸∆˜∆Æº≠∫∏∏≈ÕªÁøÎº≥¡§
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ∏≈ÕONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ¡æ∑·¿Ω	
    RETURN
    '************************************************
    '¿ßƒ°∞™««µÂπÈ
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '¿ßƒ°∞™««µÂπÈ
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

¿¸ø¯√ ±‚¿⁄ºº:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90

    WAIT
    mode = 0
    RETURN
    '************************************************
æ»¡§»≠¿⁄ºº:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
±‚∫ª¿⁄ºº:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
±‚∫ª¿⁄ºº2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN
    '******************************************	
¬˜∑«¿⁄ºº:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
æ…¿∫¿⁄ºº:
    GOSUB ¿⁄¿Ã∑ŒOFF
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
    '**** ¿⁄¿Ã∑Œ∞®µµ º≥¡§ ****
¿⁄¿Ã∑ŒINIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ¿⁄¿Ã∑Œ∞®µµ º≥¡§ ****
¿⁄¿Ã∑ŒMAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
¿⁄¿Ã∑ŒMID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
¿⁄¿Ã∑ŒMIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '******************ZERO G6A,100, 101, 102, 106, 100, 100
    ZERO G6B,102, 101, 100, 100, 100, 100
    ZERO G6C, 97, 100,  96, 100, 100, 100
    ZERO G6D,100, 103, 103, 104, 103, 100
    '*****************************
¿⁄¿Ã∑ŒON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ¿⁄¿Ã∑ŒONOFF = 1

    RETURN
    '***********************************************
¿⁄¿Ã∑ŒOFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ¿⁄¿Ã∑ŒONOFF = 0
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

∏”∏Æ¡¬øÏ¡ﬂæ”:
    SPEED ∏”∏Æ¿Ãµøº”µµ
    SERVO 11,100
    GOTO MAIN
    '*****************************************


∂Û¿Œµ˚∂Û∞…¿Ω:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ∂Û¿Œµ˚∂Û∞…¿Ω_1
    ELSE
        ∫∏«‡º¯º≠ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ∂Û¿Œµ˚∂Û∞…¿Ω_4
    ENDIF


    '**********************

∂Û¿Œµ˚∂Û∞…¿Ω_1: 'øﬁπﬂ
    'HIGHSPEED SETON
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,106,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


∂Û¿Œµ˚∂Û∞…¿Ω_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0

        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ∂Û¿Œµ˚∂Û∞…¿Ω_4
    IF A <> A_old THEN
∂Û¿Œµ˚∂Û∞…¿Ω_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF

    '*********************************

∂Û¿Œµ˚∂Û∞…¿Ω_4: 'ø¿∏•πﬂ
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,102,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


∂Û¿Œµ˚∂Û∞…¿Ω_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ∂Û¿Œµ˚∂Û∞…¿Ω_1
    IF A <> A_old THEN
∂Û¿Œµ˚∂Û∞…¿Ω_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF
    '*************************************

    GOTO ∂Û¿Œµ˚∂Û∞…¿Ω_1

    '******************************************
¿¸¡¯¥ﬁ∏Æ±‚50:
    ≥—æÓ¡¯»Æ¿Œ = 0
    GOSUB All_motor_mode3
    ∫∏«‡COUNT = 0
    DELAY 50
    SPEED 6
    HIGHSPEED SETON



    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 146,  93, 98
        WAIT

        MOVE G6A,95,  82, 120, 120, 104
        MOVE G6D,104,  79, 147,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        GOTO ¿¸¡¯¥ﬁ∏Æ±‚50_2
    ELSE
        ∫∏«‡º¯º≠ = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  82, 121, 120, 104
        MOVE G6A,104,  79, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        GOTO ¿¸¡¯¥ﬁ∏Æ±‚50_5
    ENDIF


    '**********************

¿¸¡¯¥ﬁ∏Æ±‚50_1:
    MOVE G6A,95,  97, 100, 120, 104
    MOVE G6D,104,  79, 148,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


¿¸¡¯¥ﬁ∏Æ±‚50_2:
    MOVE G6A,95,  77, 122, 120, 104
    MOVE G6D,104,  80, 148,  90,  100
    WAIT

¿¸¡¯¥ﬁ∏Æ±‚50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 161,  68, 102
    WAIT

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO RX_EXIT
    ENDIF

    ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO ¿¸¡¯¥ﬁ∏Æ±‚50_3_stop

    ERX 4800,A, ¿¸¡¯¥ﬁ∏Æ±‚50_4
    IF A <> A_old THEN
¿¸¡¯¥ﬁ∏Æ±‚50_3_stop:

        MOVE G6D,90,  93, 116, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    '*********************************

¿¸¡¯¥ﬁ∏Æ±‚50_4:
    MOVE G6D,95,  97, 101, 120, 104
    MOVE G6A,104,  79, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


¿¸¡¯¥ﬁ∏Æ±‚50_5:
    MOVE G6D,95,  77, 123, 120, 104
    MOVE G6A,104,  80, 147,  90,  100
    WAIT


¿¸¡¯¥ﬁ∏Æ±‚50_6:
    MOVE G6D,103,  71, 146, 103,  100
    MOVE G6A, 95, 89, 160,  68, 102
    WAIT

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO RX_EXIT
    ENDIF
    ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO ¿¸¡¯¥ﬁ∏Æ±‚50_6_stop
    ERX 4800,A, ¿¸¡¯¥ﬁ∏Æ±‚50_1
    IF A <> A_old THEN
¿¸¡¯¥ﬁ∏Æ±‚50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 146,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    GOTO ¿¸¡¯¥ﬁ∏Æ±‚50_1


ø¨º”¿¸¡¯:
    ∫∏«‡COUNT = 0
    ∫∏«‡º”µµ = 13
    ¡¬øÏº”µµ = 4
    ≥—æÓ¡¯»Æ¿Œ = 0

    GOSUB Leg_motor_mode3

    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1

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


        GOTO ø¨º”¿¸¡¯_1	
    ELSE
        ∫∏«‡º¯º≠ = 0

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


        GOTO ø¨º”¿¸¡¯_2	

    ENDIF


    '*******************************



ø¨º”¿¸¡¯_1:

    ETX 4800,11 '¡¯«‡ƒ⁄µÂ∏¶ ∫∏≥ø
    SPEED ∫∏«‡º”µµ

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 149,  93,  96
    WAIT


    SPEED ¡¬øÏº”µµ
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 147,  69, 110
    WAIT


    SPEED ∫∏«‡º”µµ

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ø¨º”¿¸¡¯_2
    IF A = 11 THEN
        GOTO ø¨º”¿¸¡¯_2
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
        GOSUB ±‚∫ª¿⁄ºº2

        GOTO RX_EXIT
    ENDIF
    '**********

ø¨º”¿¸¡¯_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 122, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

ø¨º”¿¸¡¯_3:
    ETX 4800,11 '¡¯«‡ƒ⁄µÂ∏¶ ∫∏≥ø

    SPEED ∫∏«‡º”µµ

    MOVE G6D, 86,  56, 147, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED ¡¬øÏº”µµ
    MOVE G6D,110,  76, 149, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ∫∏«‡º”µµ

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ø¨º”¿¸¡¯_4
    IF A = 11 THEN
        GOTO ø¨º”¿¸¡¯_4
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
        GOSUB ±‚∫ª¿⁄ºº2

        GOTO RX_EXIT
    ENDIF

ø¨º”¿¸¡¯_4:
    'øﬁπﬂµÈ±‚10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 148,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO ø¨º”¿¸¡¯_1
    '*******************************
    '*******************************


    '************************************************
«—∞…¿Ω∞»±‚:
    ∫∏«‡º”µµ = 12
    ¡¬øÏº”µµ = 4
    ≥—æÓ¡¯»Æ¿Œ = 0
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
    GOTO «—∞…¿Ω∞»±‚_2	

«—∞…¿Ω∞»±‚_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

«—∞…¿Ω∞»±‚_3:
    ETX 4800,13 '¡¯«‡ƒ⁄µÂ∏¶ ∫∏≥ø

    SPEED ∫∏«‡º”µµ

    MOVE G6D, 90,  56, 145, 115, 112
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED ¡¬øÏº”µµ
    MOVE G6D,108,  76, 147, 93,  98
    MOVE G6A,90, 100, 145,  69, 108
    WAIT

    SPEED ∫∏«‡º”µµ

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, «—∞…¿Ω∞»±‚_4
    IF A = 11 THEN
        GOTO «—∞…¿Ω∞»±‚_4
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
        ' 		GOSUB ±‚∫ª¿⁄ºº2

        ' 		GOTO RX_EXIT
    ENDIF
«—∞…¿Ω∞»±‚_4:
    SPEED 13
    MOVE G6A,95, 90, 120, 105, 111,100
    MOVE G6D,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ' SPEED 10
    '  GOSUB ±‚∫ª¿⁄ºº2
    ' GOTO «—∞…¿Ω∞»±‚

    SPEED 10
    GOSUB ±‚∫ª¿⁄ºº2
    RETURN

    '*******************************************************************************************************************************
«—∞…¿Ω∞»±‚2:
    ∫∏«‡º”µµ = 8
    ¡¬øÏº”µµ = 4
    ≥—æÓ¡¯»Æ¿Œ = 0
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
    GOTO «—∞…¿Ω∞»±‚2_2	

«—∞…¿Ω∞»±‚2_2:
    MOVE G6D,110,  76, 147,  93, 100,100
    MOVE G6A,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

«—∞…¿Ω∞»±‚2_3:
    ETX 4800,13 '¡¯«‡ƒ⁄µÂ∏¶ ∫∏≥ø

    SPEED ∫∏«‡º”µµ

    MOVE G6A, 90,  56, 145, 115, 112
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED ¡¬øÏº”µµ
    MOVE G6A,108,  76, 147, 93,  98
    MOVE G6D,90, 100, 145,  69, 108
    WAIT

    SPEED ∫∏«‡º”µµ

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, «—∞…¿Ω∞»±‚2_4
    IF A = 11 THEN
        GOTO «—∞…¿Ω∞»±‚2_4
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
        ' 		GOSUB ±‚∫ª¿⁄ºº2

        ' 		GOTO RX_EXIT
    ENDIF
«—∞…¿Ω∞»±‚2_4:
    SPEED 9
    MOVE G6D,95, 90, 120, 105, 111,100
    MOVE G6A,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    SPEED 6
    'GOSUB ±‚∫ª¿⁄ºº2
    RETURN
    '*******************************************************
∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω:
    GOSUB All_motor_mode3
    ∫∏«‡COUNT = 0
    SPEED 7
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT

    HIGHSPEED SETON


    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1
        MOVE G6A,95,  76, 147,  93, 98
        MOVE G6D,101,  76, 146,  93, 95
        WAIT

        GOTO ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1
    ELSE
        ∫∏«‡º¯º≠ = 0
        MOVE G6D,95,  76, 146,  93, 98
        MOVE G6A,101,  76, 147,  93, 95
        WAIT

        GOTO ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_4
    ENDIF


    '**********************

∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1:
    MOVE G6A,95,  90, 125, 100, 101
    MOVE G6D,104,  77, 146,  93,  99
    WAIT


∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_2:

    MOVE G6A,103,   73, 140, 103,  97
    MOVE G6D, 95,  85, 146,  85, 99
    WAIT

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0

        GOTO RX_EXIT
    ENDIF

    ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_2_stop

    ERX 4800,A, ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_4
    IF A <> A_old THEN
∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_2_stop:
        MOVE G6D,95,  90, 124, 95, 101
        MOVE G6A,104,  76, 145,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        'GOSUB æ»¡§»≠¿⁄ºº
        '  SPEED 5
        ' GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_4:
    MOVE G6D,95,  95, 119, 100, 101
    MOVE G6A,104,  77, 147,  93,  99
    WAIT


∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_5:
    MOVE G6D,103,    73, 139, 103,  97
    MOVE G6A, 95,  85, 147,  85, 99
    WAIT


    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO RX_EXIT
    ENDIF

    ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_5_stop

    ERX 4800,A, ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1
    IF A <> A_old THEN
∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_5_stop:
        MOVE G6A,95,  90, 125, 95, 101
        MOVE G6D,104,  76, 144,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        ' GOSUB æ»¡§»≠¿⁄ºº
        ' SPEED 5
        '  GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO ∫¸∏•»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1

    '-----------------------------------------------------------------

ø¨º”»ƒ¡¯:
    ≥—æÓ¡¯»Æ¿Œ = 0
    ∫∏«‡º”µµ = 12
    ¡¬øÏº”µµ = 4
    GOSUB Leg_motor_mode3



    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1

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

        GOTO ø¨º”»ƒ¡¯_1	
    ELSE
        ∫∏«‡º¯º≠ = 0

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


        GOTO ø¨º”»ƒ¡¯_2

    ENDIF


ø¨º”»ƒ¡¯_1:
    ETX 4800,12 '¡¯«‡ƒ⁄µÂ∏¶ ∫∏≥ø
    SPEED ∫∏«‡º”µµ

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED ¡¬øÏº”µµ
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ø¨º”»ƒ¡¯_2
    IF A <> A_old THEN
ø¨º”»ƒ¡¯_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB ±‚∫ª¿⁄ºº2
        GOTO RX_EXIT
    ENDIF
    '**********

ø¨º”»ƒ¡¯_2:
    ETX 4800,12 '¡¯«‡ƒ⁄µÂ∏¶ ∫∏≥ø
    SPEED ∫∏«‡º”µµ
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED ¡¬øÏº”µµ
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, ø¨º”»ƒ¡¯_1
    IF A <> A_old THEN
ø¨º”»ƒ¡¯_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB ±‚∫ª¿⁄ºº2
        GOTO RX_EXIT
    ENDIF  	

    GOTO ø¨º”»ƒ¡¯_1
    '**********************************************

    '******************************************
»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω:
    GOSUB All_motor_mode3
    ∫∏«‡COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1
    ELSE
        ∫∏«‡º¯º≠ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_4
    ENDIF


    '**********************

»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0

        GOTO RX_EXIT
    ENDIF

    ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_2_stop

    ERX 4800,A, »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_4
    IF A <> A_old THEN
»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO RX_EXIT
    ENDIF

    ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_5_stop

    ERX 4800,A, »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1
    IF A <> A_old THEN
»Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω_1

    '******************************************

    '******************************************
¿¸¡¯¡æ¡æ∞…¿Ω:
    GOSUB All_motor_mode3
    ∫∏«‡COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ∫∏«‡º¯º≠ = 0 THEN
        ∫∏«‡º¯º≠ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ¿¸¡¯¡æ¡æ∞…¿Ω_1
    ELSE
        ∫∏«‡º¯º≠ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ¿¸¡¯¡æ¡æ∞…¿Ω_4
    ENDIF


    '**********************

¿¸¡¯¡æ¡æ∞…¿Ω_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


¿¸¡¯¡æ¡æ∞…¿Ω_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0

        GOTO RX_EXIT
    ENDIF

    ' ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    'IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO ¿¸¡¯¡æ¡æ∞…¿Ω_2_stop

    ERX 4800,A, ¿¸¡¯¡æ¡æ∞…¿Ω_4
    IF A <> A_old THEN
¿¸¡¯¡æ¡æ∞…¿Ω_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

¿¸¡¯¡æ¡æ∞…¿Ω_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


¿¸¡¯¡æ¡æ∞…¿Ω_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    IF ≥—æÓ¡¯»Æ¿Œ = 1 THEN
        ≥—æÓ¡¯»Æ¿Œ = 0
        GOTO RX_EXIT
    ENDIF

    ' ∫∏«‡COUNT = ∫∏«‡COUNT + 1
    ' IF ∫∏«‡COUNT > ∫∏«‡»Ωºˆ THEN  GOTO ¿¸¡¯¡æ¡æ∞…¿Ω_5_stop

    ERX 4800,A, ¿¸¡¯¡æ¡æ∞…¿Ω_1
    IF A <> A_old THEN
¿¸¡¯¡æ¡æ∞…¿Ω_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB æ»¡§»≠¿⁄ºº
        SPEED 5
        GOSUB ±‚∫ª¿⁄ºº2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

∞»±‚:


    '*************************************

    '*********************************

    GOTO ¿¸¡¯¡æ¡æ∞…¿Ω_1

    '************************************************
ø¿∏•¬ ø∑¿∏∑Œ20: '****
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
    'GOSUB ±‚∫ª¿⁄ºº2
    MOVE G6A,100,  78, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************
    '*************

øﬁ¬ ø∑¿∏∑Œ20: '****
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
    'GOSUB ±‚∫ª¿⁄ºº2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  78, 145,  93, 100, 100
    GOSUB All_motor_mode3
    GOTO RX_EXIT

    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
µ⁄∑Œ¿œæÓ≥™±‚:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ¿⁄¿Ã∑ŒOFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB ±‚∫ª¿⁄ºº

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
    GOSUB ±‚∫ª¿⁄ºº

    ≥—æÓ¡¯»Æ¿Œ = 1

    DELAY 200
    GOSUB ¿⁄¿Ã∑ŒON

    RETURN


    '**********************************************
æ’¿∏∑Œ¿œæÓ≥™±‚:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ¿⁄¿Ã∑ŒOFF

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
    GOSUB ±‚∫ª¿⁄ºº
    ≥—æÓ¡¯»Æ¿Œ = 1

    '******************************
    DELAY 200
    GOSUB ¿⁄¿Ã∑ŒON
    RETURN

    '******************************************

    '******************************************

æ’µ⁄±‚øÔ±‚√¯¡§:
    FOR i = 0 TO COUNT_MAX
        A = AD(æ’µ⁄±‚øÔ±‚AD∆˜∆Æ)	'±‚øÔ±‚ æ’µ⁄
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ±‚øÔ±‚»Æ¿ŒΩ√∞£
    NEXT i

    IF A < MIN THEN
        GOSUB ±‚øÔ±‚æ’
    ELSEIF A > MAX THEN
        GOSUB ±‚øÔ±‚µ⁄
    ENDIF

    RETURN
    '**************************************************
±‚øÔ±‚æ’:
    A = AD(æ’µ⁄±‚øÔ±‚AD∆˜∆Æ)
    'IF A < MIN THEN GOSUB æ’¿∏∑Œ¿œæÓ≥™±‚
    IF A < MIN THEN
        ETX  4800,16
        GOSUB µ⁄∑Œ¿œæÓ≥™±‚

    ENDIF
    RETURN

±‚øÔ±‚µ⁄:
    A = AD(æ’µ⁄±‚øÔ±‚AD∆˜∆Æ)
    'IF A > MAX THEN GOSUB µ⁄∑Œ¿œæÓ≥™±‚
    IF A > MAX THEN
        ETX  4800,15
        GOSUB æ’¿∏∑Œ¿œæÓ≥™±‚
    ENDIF
    RETURN
    '**************************************************
¡¬øÏ±‚øÔ±‚√¯¡§:
    FOR i = 0 TO COUNT_MAX
        B = AD(¡¬øÏ±‚øÔ±‚AD∆˜∆Æ)	'±‚øÔ±‚ ¡¬øÏ
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ±‚øÔ±‚»Æ¿ŒΩ√∞£
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB ±‚∫ª¿⁄ºº	
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
Number_Play: '  BUTTON_NO = º˝¿⁄¥Î¿‘


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
¿˚ø‹º±∞≈∏Æºæº≠»Æ¿Œ:

    ¿˚ø‹º±∞≈∏Æ∞™ = AD(¿˚ø‹º±AD∆˜∆Æ)

    IF ¿˚ø‹º±∞≈∏Æ∞™ > 50 THEN '50 = ¿˚ø‹º±∞≈∏Æ∞™ = 25cm
        'MUSIC "C"
        DELAY 200
    ENDIF




    RETURN

    '******************************************

    '******************************************
∞Ë¥‹øﬁπﬂø¿∏£±‚3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 40, 115, 160, 114,
    MOVE G6D,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 70, 100, 160, 100,
    MOVE G6D,80,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 113, 90, 80, 160,95,
    MOVE G6D,70,  95, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,75,  90, 165,  70, 105
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
    GOSUB ±‚∫ª¿⁄ºº

    GOTO RX_EXIT
    '****************************************

∞Ë¥‹ø¿∏•πﬂø¿∏£±‚3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 15
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  73, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 40, 115, 160, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 70, 100, 160, 100,
    MOVE G6A,80,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 80, 160,95,
    MOVE G6A,70,  95, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,75,  90, 165,  70, 105
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
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    GOSUB ±‚∫ª¿⁄ºº

    GOTO RX_EXIT
<<<<<<< HEAD
<<<<<<< HEAD
    '************************************************
=======
'************************************************
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
    '************************************************
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
∞Ë¥‹øﬁπﬂø¿∏£±‚1cm:
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

∞Ë¥‹ø¿∏•πﬂø¿∏£±‚1cm:
    GOSUB All_motor_mode3
<<<<<<< HEAD
=======
    GOSUB All_motor_mode3
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)

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
    '********************************************	
∞Ë¥‹øﬁπﬂ≥ª∏Æ±‚3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT
<<<<<<< HEAD
<<<<<<< HEAD

<<<<<<< HEAD
    ' øﬁπﬂ ªÏ¬¶ µÈ±‚
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	
	' øﬁπﬂ ªÏ¬¶ µÈ±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======

    ' øﬁπﬂ ªÏ¬¶ µÈ±‚
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  76, 145,  93,  94
    WAIT

    ' ø©±‚±Ó¡¯ ø√∂Û∞°±‚ πˆ¿¸∞˙ ∂»∞∞¿Ω

<<<<<<< HEAD
    ' ø©±‚±Ó¡¯ ø√∂Û∞°±‚ πˆ¿¸∞˙ ∂»∞∞¿Ω

    GOSUB Leg_motor_mode2

    'øﬁπﬂ ∏π¿Ã µÈ±‚
<<<<<<< HEAD
=======
    GOSUB Leg_motor_mode2

<<<<<<< HEAD

>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'øﬁπﬂ ∏π¿Ã µÈ±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    'øﬁπﬂ æ’ πÊ«‚¿∏∑Œ ≥ª∏Æ±‚ + ø¿∏•π´∏≠ ±¡»˜±‚ + æÁº’ µ⁄∑Œ «œ±‚
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'øﬁπﬂ æ’ πÊ«‚¿∏∑Œ ≥ª∏Æ±‚ + ø¿∏•π´∏≠ ±¡»˜±‚ + æÁº’ µ⁄∑Œ «œ±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    'øﬁπﬂ æ’ πÊ«‚¿∏∑Œ ≥ª∏Æ±‚ + ø¿∏•π´∏≠ ±¡»˜±‚ + æÁº’ µ⁄∑Œ «œ±‚
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    'øﬁπ´∏≠ ∆Óƒ°±‚ + ø¿∏•π´∏≠ ¥ı ±¡»˜±‚ + ø¿∏•º’ æ’¿∏∑Œ «œ±‚
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'øﬁπ´∏≠ ∆Óƒ°±‚ + ø¿∏•π´∏≠ ¥ı ±¡»˜±‚ + ø¿∏•º’ æ’¿∏∑Œ «œ±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    'øﬁπ´∏≠ ∆Óƒ°±‚ + ø¿∏•π´∏≠ ¥ı ±¡»˜±‚ + ø¿∏•º’ æ’¿∏∑Œ «œ±‚
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************
<<<<<<< HEAD
<<<<<<< HEAD

<<<<<<< HEAD
    'øﬁπ´∏≠ ¡∂±› ¥ı ∆Óƒ°∏Èº≠ ∫∏∆¯ ≥™∞°±‚ + ø¿∏•π´∏≠ ¡∂±› ∆Ï±‚ + øﬁ∆» æ’¿∏∑Œ ø¿∏•∆» µ⁄∑Œ
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	
	'øﬁπ´∏≠ ¡∂±› ¥ı ∆Óƒ°∏Èº≠ ∫∏∆¯ ≥™∞°±‚ + ø¿∏•π´∏≠ ¡∂±› ∆Ï±‚ + øﬁ∆» æ’¿∏∑Œ ø¿∏•∆» µ⁄∑Œ
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======

    'øﬁπ´∏≠ ¡∂±› ¥ı ∆Óƒ°∏Èº≠ ∫∏∆¯ ≥™∞°±‚ + ø¿∏•π´∏≠ ¡∂±› ∆Ï±‚ + øﬁ∆» æ’¿∏∑Œ ø¿∏•∆» µ⁄∑Œ
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD

    'øﬁπ´∏≠ »Æ ∆Ï±‚ + ø¿∏•πﬂ µ⁄∑Œ «œ∏Èº≠ ª©±‚ + ∆» æ’µ⁄ ¡∂±› ¥ı ≈©∞‘
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======

<<<<<<< HEAD
	'øﬁπ´∏≠ »Æ ∆Ï±‚ + ø¿∏•πﬂ µ⁄∑Œ «œ∏Èº≠ ª©±‚ + ∆» æ’µ⁄ ¡∂±› ¥ı ≈©∞‘
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    'øﬁπ´∏≠ »Æ ∆Ï±‚ + ø¿∏•πﬂ µ⁄∑Œ «œ∏Èº≠ ª©±‚ + ∆» æ’µ⁄ ¡∂±› ¥ı ≈©∞‘
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    'øﬁ¥Ÿ∏Æ ∞°∏∏»˜ µŒ±‚ + ø¿∏•¥Ÿ∏Æ ±¡»˜∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'øﬁ¥Ÿ∏Æ ∞°∏∏»˜ µŒ±‚ + ø¿∏•¥Ÿ∏Æ ±¡»˜∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    'øﬁ¥Ÿ∏Æ ∞°∏∏»˜ µŒ±‚ + ø¿∏•¥Ÿ∏Æ ±¡»˜∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    'øﬁπﬂ ¡ˆ≈ «œ±‚ + ø¿∏•π´∏≠ ∆Ï∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚±‚
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'øﬁπﬂ ¡ˆ≈ «œ±‚ + ø¿∏•π´∏≠ ∆Ï∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    'øﬁπﬂ ¡ˆ≈ «œ±‚ + ø¿∏•π´∏≠ ∆Ï∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚±‚
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    'ø¿∏•πﬂ ∞≈¿« ≥ª∏Æ±‚
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'ø¿∏•πﬂ ∞≈¿« ≥ª∏Æ±‚
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    'ø¿∏•πﬂ ∞≈¿« ≥ª∏Æ±‚
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '±‚∫ª¿⁄ºº
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
	'±‚∫ª¿⁄ºº
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
=======
    '±‚∫ª¿⁄ºº
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB ±‚∫ª¿⁄ºº

    GOTO RX_EXIT
    '************************************************
∞Ë¥‹ø¿∏•πﬂ≥ª∏Æ±‚3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6D,  80, 30, 155, 150, 114,
    MOVE G6A,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6D,  80, 30, 175, 150, 114,
    MOVE G6A,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 20, 150, 150, 110
    MOVE G6A,110,  155, 35,  120,94
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6D,100, 30, 150, 150, 100
    MOVE G6A,100,  155, 70,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 140,  85,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6D,114, 75, 130, 120, 94
    MOVE G6A,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6D,112, 80, 130, 110, 94
    MOVE G6A,80,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB ±‚∫ª¿⁄ºº

    GOTO RX_EXIT

    '******************************************
∞Ë¥‹ø¿∏•πﬂ≥ª∏Æ±‚1cm:

    GOSUB All_motor_mode3

    'ø¿∏•πﬂ øœ¿¸ ¡˝æÓ≥÷±‚ ''''
    SPEED 5
    MOVE G6A, 100, 110,  112, 92,  101, 100
    MOVE G6D,  100,  112, 112, 92, 101, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ∏Ò øﬁ¬ ¿∏∑Œ
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  85,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    'ø¿∏•πﬂ ∞≈¿«πﬂ∏Ò±Ó¡ˆ   ¡˝æÓ≥÷±‚
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    'ø¿∏•πﬂ ∞≈¿«  ¡˝æÓ≥÷±‚
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  105, 63, 119, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ ¡˝æÓ≥÷±‚
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  15, 139, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπ´∏≠ºˆ¡˜ √÷¡æµÈ±‚
    SPEED 2
    MOVE G6A, 112, 110,  112, 77,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπ´∏≠ ∏π¿ÃµÈ±‚
    SPEED 1
    MOVE G6A, 112, 125,  102, 65,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT	

    'øﬁπ´∏≠ µÈ±‚
    SPEED 5
    MOVE G6A, 108, 140,  92, 82,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'Ω√«Ë ø¿∏•πﬂ∑Œ ¡ˆ≈ «œ∞Ì ≥ª∑¡∞°¥¬ µø¿€
    SPEED 5
    MOVE G6A, 105, 140,  92, 102,  81, 100
    MOVE G6D,  95,  15, 169, 149, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ , ø¿∏•πﬂ ººøÏ±‚
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  81, 100
    MOVE G6D,  95,  35, 149, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ ∞≈¿« ºˆ¡˜¿∏∑Œ ººøÏ±‚ ';';'
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  96, 100
    MOVE G6D,  100,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ πﬂ∏Ò øﬁ¬ ¿∏∑Œ ±‚øÔ¿Ã±‚
    SPEED 5
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  105,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ π´∏≠∞˙ ªÛ√º º˜¿Ã±‚
    SPEED 3
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  110,  45, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ π´∏≠ æ‡∞£ ø√∏Æ±‚
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  110,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ π´∏≠ æ‡∞£ ø√∏Æ±‚ (ø¿∏•πﬂ πﬂ∏Ò ¡ﬂΩ… ¿‚±‚)
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ æ’¿∏∑Œ ∞Æ∞Ìø¿±‚
    SPEED 3
    MOVE G6A, 97, 105,  103, 132,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ æ’¿∏∑Œ ∞Æ∞Ìø¿±‚ 2
    SPEED 3
    MOVE G6A, 97, 110,  97, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ æ’¿∏∑Œ ∞Æ∞Ìø¿±‚ 3
    SPEED 3
    MOVE G6A, 97, 110,  107, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ ≥ª∏Æ±‚1
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ ≥ª∏Æ±‚2
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  107,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ ≥ª∏Æ±‚3
    SPEED 3
    MOVE G6A, 97, 55,  149, 136,  96, 100
    MOVE G6D,  107,  55, 149, 139, 104, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB ±‚∫ª¿⁄ºº''∞Àºˆ ¥ÎªÛ

    ETX 4800, 254

    RETURN
<<<<<<< HEAD
<<<<<<< HEAD
    '****************************************
∞Ë¥‹øﬁπﬂ≥ª∏Æ±‚1cm:    

	GOSUB All_motor_mode3

    'øﬁπﬂ øœ¿¸ ¡˝æÓ≥÷±‚ ''''
    SPEED 5
    MOVE G6D, 100, 110,  112, 92,  101, 100
    MOVE G6A,  100,  112, 112, 92, 101, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ∏Ò øﬁ¬ ¿∏∑Œ
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  85,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    'øﬁπﬂ ∞≈¿«πﬂ∏Ò±Ó¡ˆ   ¡˝æÓ≥÷±‚
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    'øﬁπﬂ ∞≈¿«  ¡˝æÓ≥÷±‚
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  105, 63, 119, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ ¡˝æÓ≥÷±‚
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  15, 139, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•π´∏≠ºˆ¡˜ √÷¡æµÈ±‚
    SPEED 2
    MOVE G6D, 112, 110,  112, 77,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•π´∏≠ ∏π¿ÃµÈ±‚
    SPEED 1
    MOVE G6D, 112, 125,  102, 65,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT	

    'ø¿∏•π´∏≠ µÈ±‚
    SPEED 5
    MOVE G6D, 108, 140,  92, 82,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'Ω√«Ë øﬁπﬂ∑Œ ¡ˆ≈ «œ∞Ì ≥ª∑¡∞°¥¬ µø¿€
    SPEED 5
    MOVE G6D, 105, 140,  92, 102,  81, 100
    MOVE G6A,  95,  15, 169, 149, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'ø¿∏•πﬂ , øﬁπﬂ ººøÏ±‚
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  81, 100
    MOVE G6A,  95,  35, 149, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ ∞≈¿« ºˆ¡˜¿∏∑Œ ººøÏ±‚ ';';'
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  96, 100
    MOVE G6A,  100,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ πﬂ∏Ò øﬁ¬ ¿∏∑Œ ±‚øÔ¿Ã±‚
    SPEED 5
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  105,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ π´∏≠∞˙ ªÛ√º º˜¿Ã±‚
    SPEED 3
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  110,  45, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ π´∏≠ æ‡∞£ ø√∏Æ±‚
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  110,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ π´∏≠ æ‡∞£ ø√∏Æ±‚ (øﬁπﬂ πﬂ∏Ò ¡ﬂΩ… ¿‚±‚)
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ æ’¿∏∑Œ ∞Æ∞Ìø¿±‚
    SPEED 3
    MOVE G6D, 97, 105,  103, 132,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ æ’¿∏∑Œ ∞Æ∞Ìø¿±‚ 2
    SPEED 3
    MOVE G6D, 97, 110,  97, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ æ’¿∏∑Œ ∞Æ∞Ìø¿±‚ 3
    SPEED 3
    MOVE G6D, 97, 110,  107, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ ≥ª∏Æ±‚1
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ ≥ª∏Æ±‚2
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  107,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    'øﬁπﬂ ≥ª∏Æ±‚3
    SPEED 3
    MOVE G6D, 97, 55,  149, 136,  96, 100
    MOVE G6A,  107,  55, 149, 139, 104, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB ±‚∫ª¿⁄ºº''∞Àºˆ ¥ÎªÛ

    ETX 4800, 254

    RETURN

	'****************************************

stair_right_down:

=======
   	'****************************************
=======
    '****************************************
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)

stair_right_down:
    GOSUB All_motor_mode3
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
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
stair_left_down:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
<<<<<<< HEAD
<<<<<<< HEAD
    MOVE G6D,108,  76, 145,  93,  94
=======
    MOVE G6D,108,  77, 146,  93,  94
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
    MOVE G6D,108,  76, 145,  93,  94
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  76, 145,  93,  94
    WAIT
<<<<<<< HEAD
<<<<<<< HEAD

    'ø©±‚±Ó¡¯ ø√∂Û∞°±‚ πˆ¿¸∞˙ ∂»∞∞¿Ω

    GOSUB Leg_motor_mode2

    'øﬁπﬂ ∏π¿Ã µÈ±‚
    'æ» ∞«µÂ∏≤
    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    'øﬁπﬂ æ’ πÊ«‚¿∏∑Œ ≥ª∏Æ±‚ + ø¿∏•π´∏≠ ±¡»˜±‚ + æÁº’ µ⁄∑Œ «œ±‚
    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    'øﬁπ´∏≠ ∆Óƒ°±‚ + ø¿∏•π´∏≠ ¥ı ±¡»˜±‚ + ø¿∏•º’ æ’¿∏∑Œ «œ±‚
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 15, 135, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,30
    MOVE G6C,150,70
    WAIT

    '****************************

    'øﬁπ´∏≠ ¡∂±› ¥ı ∆Óƒ°∏Èº≠ ∫∏∆¯ ≥™∞°±‚ + ø¿∏•π´∏≠ ¡∂±› ∆Ï±‚ + øﬁ∆» æ’¿∏∑Œ ø¿∏•∆» µ⁄∑Œ
    SPEED 8
    MOVE G6A,104, 25, 135, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,150,30
    MOVE G6C,120,70
    WAIT

    'øﬁπ´∏≠ »Æ ∆Ï±‚ + ø¿∏•πﬂ µ⁄∑Œ «œ∏Èº≠ ª©±‚ + ∆» æ’µ⁄ ¡∂±› ¥ı ≈©∞‘
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,30
    MOVE G6C,120,70
    WAIT

    'øﬁ¥Ÿ∏Æ ∞°∏∏»˜ µŒ±‚ + ø¿∏•¥Ÿ∏Æ ±¡»˜∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    'øﬁπﬂ ¡ˆ≈ «œ±‚ + ø¿∏•π´∏≠ ∆Ï∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  70, 90,  150,114
    WAIT

    'ø¿∏•πﬂ ∞≈¿« ≥ª∏Æ±‚
    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,150,30
    MOVE G6C,120,70
    WAIT

    '±‚∫ª¿⁄ºº
    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
=======
    SPEED 8
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,114,  78, 146,  93,  94
=======
	
	'ø©±‚±Ó¡¯ ø√∂Û∞°±‚ πˆ¿¸∞˙ ∂»∞∞¿Ω
	
=======

    'ø©±‚±Ó¡¯ ø√∂Û∞°±‚ πˆ¿¸∞˙ ∂»∞∞¿Ω

>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    GOSUB Leg_motor_mode2

    'øﬁπﬂ ∏π¿Ã µÈ±‚
    'æ» ∞«µÂ∏≤
    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
    WAIT

    GOSUB Leg_motor_mode2

    'øﬁπﬂ æ’ πÊ«‚¿∏∑Œ ≥ª∏Æ±‚ + ø¿∏•π´∏≠ ±¡»˜±‚ + æÁº’ µ⁄∑Œ «œ±‚±‚
    SPEED 7
    MOVE G6A,  95, 10, 170, 148, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    'øﬁπ´∏≠ ∆Óƒ°±‚ + ø¿∏•π´∏≠ ¥ı ±¡»˜±‚ + ø¿∏•º’ æ’¿∏∑Œ «œ±‚
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 10, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    'øﬁπ´∏≠ ¡∂±› ¥ı ∆Óƒ°∏Èº≠ ∫∏∆¯ ≥™∞°±‚ + ø¿∏•π´∏≠ ¡∂±› ∆Ï±‚ + øﬁ∆» æ’¿∏∑Œ ø¿∏•∆» µ⁄∑Œ
    SPEED 8
    MOVE G6A,100, 15, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    'øﬁπ´∏≠ »Æ ∆Ï±‚ + ø¿∏•πﬂ µ⁄∑Œ «œ∏Èº≠ ª©±‚ + ∆» æ’µ⁄ ¡∂±› ¥ı ≈©∞‘
    SPEED 10
<<<<<<< HEAD
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

<<<<<<< HEAD
    SPEED 4
    GOSUB ±‚∫ª¿⁄ºº
=======
    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
=======
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    'øﬁ¥Ÿ∏Æ ∞°∏∏»˜ µŒ±‚ + ø¿∏•¥Ÿ∏Æ ±¡»˜∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
>>>>>>> 9df3388 (Comment: Í≥ÑÎã®ÏôºÎ∞úÎÇ¥Î¶¨Í∏∞3cm, stair_left_down Ï£ºÏÑù Ï∂îÍ∞Ä)
    WAIT

    'øﬁπﬂ ¡ˆ≈ «œ±‚ + ø¿∏•π´∏≠ ∆Ï∏Èº≠ æ’¿∏∑Œ ∞°¡Æø¿±‚
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    'ø¿∏•πﬂ ∞≈¿« ≥ª∏Æ±‚
    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    '±‚∫ª¿⁄ºº
    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)

    SPEED 4
    GOSUB ±‚∫ª¿⁄ºº

    GOTO RX_EXIT

    '******************************************


MAIN: '∂Û∫ßº≥¡§

    ETX 4800, 200 ' µø¿€ ∏ÿ√„ »Æ¿Œ º€Ω≈ ∞™

MAIN_2:

    GOSUB æ’µ⁄±‚øÔ±‚√¯¡§
    GOSUB ¡¬øÏ±‚øÔ±‚√¯¡§
    GOSUB ¿˚ø‹º±∞≈∏Æºæº≠»Æ¿Œ


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** ¿‘∑¬µ» A∞™¿Ã 0 ¿Ã∏È MAIN ∂Û∫ß∑Œ ∞°∞Ì
    '**** 1¿Ã∏È 	 ∂Û∫ß, 2¿Ã∏È key2∑Œ... ∞°¥¬πÆ
<<<<<<< HEAD
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32
=======
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY16,KEY19,KEY22,KEY25

>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)

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
        GOSUB ±‚∫ª¿⁄ºº

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN ∂Û∫ß∑Œ ∞°±‚
    '*******************************************

KEY1:
    ETX  4800,1

    ' ∫∏«‡»Ωºˆ = 2
    GOSUB ∞Ë¥‹øﬁπﬂø¿∏£±‚1cm
    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

    ∫∏«‡»Ωºˆ = 6
    GOTO »Ωºˆ_¿¸¡¯¡æ¡æ∞…¿Ω

    GOTO RX_EXIT
    '***************

KEY3:
    ETX 4800, 3
    ' GOTO øﬁ¬ ø∑¿∏∑Œ20
    GOSUB ∞Ë¥‹ø¿∏•πﬂø¿∏£±‚1cm
    GOTO RX_EXIT
KEY4:
    ETX 4800, 4
    GOSUB øﬁ¬ ø∑¿∏∑Œ20
    '  GOTO πÆø≠±‚øﬁ¬ 3
    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    'J = AD(¿˚ø‹º±AD∆˜∆Æ)	'¿˚ø‹º±∞≈∏Æ∞™ ¿–±‚
    'ETX 4800, J
    'BUTTON_NO = J
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    'GOSUB GOSUB_RX_EXIT
    GOSUB ∏”∏Æ¡¬øÏ¡ﬂæ”

    GOTO RX_EXIT
    '***************
KEY6:
    ETX 4800, 6
    GOSUB ø¿∏•¬ ø∑¿∏∑Œ20
    GOTO RX_EXIT
KEY7:
    ETX 4800, 7
    GOSUB ∞Ë¥‹øﬁπﬂ≥ª∏Æ±‚3cm
    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB ø¨º”»ƒ¡¯
    GOTO RX_EXIT
    '***************
KEY9:
    ETX 4800, 9
    GOSUB ∞Ë¥‹ø¿∏•πﬂ≥ª∏Æ±‚3cm
    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX 4800, 10
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
<<<<<<< HEAD
KEY11: ' °„
    ETX  4800,11

    GOTO ±‚∫ª¿⁄ºº
    GOTO RX_EXIT

    '***************
KEY12: ' °Â
    ETX  4800,12

    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY13: '¢∫
    ETX  4800,13
    'GOSUB ¿¸πÊ«œ«‚90µµ
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '**************
KEY14: ' ¢∏
    ETX  4800,14
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT


    GOTO RX_EXIT
    '***************
KEY15: 'A
    ETX 4800, 15
    GOSUB ±‚∫ª¿⁄ºº
=======
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
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
    GOSUB æ…¿∫¿⁄ºº	
    GOSUB ¡æ∑·¿Ω

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ∏≈ÕONOFF = 1  THEN
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


    IF  A = 16 THEN 	'¥ŸΩ√ ∆ƒøˆπˆ∆∞¿ª ¥≠∑Øæﬂ∏∏ ∫π±Õ
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB ±‚∫ª¿⁄ºº2
        GOSUB ¿⁄¿Ã∑ŒON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
<<<<<<< HEAD
KEY17: ' C
    ETX 4800, 17
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX 4800, 18
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY19: 'P2
    ETX 4800, 19
    GOSUB stair_right_down
    GOTO RX_EXIT
    '***************
KEY20: 'B
    ETX 4800, 20
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY21: ' °‚
    ETX  4800,21
    GOSUB ±‚∫ª¿⁄ºº

=======
KEY19: 'P2
    ETX 4800, 19
    GOSUB  ∞Ë¥‹ø¿∏•πﬂ≥ª∏Æ±‚1cm
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
    GOTO RX_EXIT
    '***************
KEY22: ' *
    ETX 4800, 22
<<<<<<< HEAD
    'GOSUB ±‚∫ª¿⁄ºº
    GOSUB ∞Ë¥‹øﬁπﬂ≥ª∏Æ±‚1cm
    GOTO RX_EXIT
    '***************
KEY23: 'G
    ETX 4800, 23
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY24: '#
    ETX 4800, 24
    GOSUB  ∞Ë¥‹ø¿∏•πﬂ≥ª∏Æ±‚1cm
    GOTO RX_EXIT
=======
    '  GOTO ø¿∏•¬ ≈œ3
    'GOTO ø¿∏•¬ ≈œ20
    ' GOTO ¡˝∞Ìø¿∏•¬ ≈œ45
    GOTO stair_left_down
    GOTO RX_EXIT
    '***************
<<<<<<< HEAD
'KEY24: '#
 '   ETX 4800, 24
 '   GOSUB ∞Ë¥‹øﬁπﬂ≥ª∏Æ±‚1cm
 '   GOTO RX_EXIT
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
=======
    'KEY24: '#
    '   ETX 4800, 24
    '   GOSUB ∞Ë¥‹øﬁπﬂ≥ª∏Æ±‚1cm
    '   GOTO RX_EXIT
>>>>>>> 1af3458 (Chore: stair_left_down Í∞í ÏàòÏ†ï)
    '***************
KEY25: 'P1
    ETX 4800, 25
    ' GOTO ¡˝∞Ìøﬁ¬ ≈œ45
    ' GOTO øﬁ¬ ≈œ3
    'GOTO øﬁ¬ ≈œ20
<<<<<<< HEAD
    GOSUB stair_left_down
    GOTO RX_EXIT
    '***************
KEY26: ' °·
    ETX  4800,26

    'SPEED 5
    'GOSUB ª˛ªËª˛ªË
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX 4800, 27
    GOTO ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY28: ' ¢∑
    ETX 4800, 28
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY29: ' °‡
    ETX 4800, 29
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY30: ' ¢π
    ETX 4800, 30
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************
KEY31: ' °‰
    ETX 4800, 31
    GOSUB ±‚∫ª¿⁄ºº
    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX 4800, 32
    GOSUB ±‚∫ª¿⁄ºº
=======
    GOSUB stair_right_down
>>>>>>> f684033 (Add: Í≥ÑÎã® ÌååÏùº Ï∂îÍ∞Ä)
    GOTO RX_EXIT
    '***************
