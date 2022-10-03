'******** 2Á· º¸Çà·Îº¿ ÃÊ±â ¿µÁ¡ ÇÁ·Î±×·¥ ********

'-*- coding: utf-8 -*-'

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM º¸Çà¼Óµµ AS BYTE
DIM ÁÂ¿ì¼Óµµ AS BYTE
DIM ÁÂ¿ì¼Óµµ2 AS BYTE
DIM º¸Çà¼ø¼­ AS BYTE
DIM ÇöÀçÀü¾Ð AS BYTE
DIM ¹ÝÀüÃ¼Å© AS BYTE
DIM ¸ðÅÍONOFF AS BYTE
DIM ÀÚÀÌ·ÎONOFF AS BYTE
DIM ±â¿ï±â¾ÕµÚ AS INTEGER
DIM ±â¿ï±âÁÂ¿ì AS INTEGER

DIM °î¼±¹æÇâ AS BYTE

DIM ³Ñ¾îÁøÈ®ÀÎ AS BYTE
DIM ±â¿ï±âÈ®ÀÎÈ½¼ö AS BYTE
DIM º¸ÇàÈ½¼ö AS BYTE
DIM º¸ÇàCOUNT AS BYTE

DIM Àû¿Ü¼±°Å¸®°ª  AS BYTE

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

'**** ±â¿ï±â¼¾¼­Æ÷Æ® ¼³Á¤ ****
CONST ¾ÕµÚ±â¿ï±âADÆ÷Æ® = 0
CONST ÁÂ¿ì±â¿ï±âADÆ÷Æ® = 1
CONST ±â¿ï±âÈ®ÀÎ½Ã°£ = 20  'ms

CONST Àû¿Ü¼±ADÆ÷Æ®  = 4


CONST min = 61	'µÚ·Î³Ñ¾îÁ³À»¶§
CONST max = 107	'¾ÕÀ¸·Î³Ñ¾îÁ³À»¶§
CONST COUNT_MAX = 3


CONST ¸Ó¸®ÀÌµ¿¼Óµµ = 10
'************************************************



PTP SETON 				'´ÜÀ§±×·ìº° Á¡´ëÁ¡µ¿ÀÛ ¼³Á¤
PTP ALLON				'ÀüÃ¼¸ðÅÍ Á¡´ëÁ¡ µ¿ÀÛ ¼³Á¤

DIR G6A,1,0,0,1,0,0		'¸ðÅÍ0~5¹ø
DIR G6D,0,1,1,0,1,1		'¸ðÅÍ18~23¹ø
DIR G6B,1,1,1,1,1,1		'¸ðÅÍ6~11¹ø
DIR G6C,0,0,0,0,1,0		'¸ðÅÍ12~17¹ø

'************************************************

OUT 52,0	'¸Ó¸® LED ÄÑ±â
'***** ÃÊ±â¼±¾ð '************************************************

º¸Çà¼ø¼­ = 0
¹ÝÀüÃ¼Å© = 0
±â¿ï±âÈ®ÀÎÈ½¼ö = 0
º¸ÇàÈ½¼ö = 1
¸ðÅÍONOFF = 0

'****ÃÊ±âÀ§Ä¡ ÇÇµå¹é*****************************


TEMPO 230
'MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB Àü¿øÃÊ±âÀÚ¼¼
GOSUB ±âº»ÀÚ¼¼


GOSUB ÀÚÀÌ·ÎINIT
GOSUB ÀÚÀÌ·ÎMID
GOSUB ÀÚÀÌ·ÎON



PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '¾È³çÇÏ¼¼¿ä

GOSUB All_motor_mode3





GOTO MAIN	'½Ã¸®¾ó ¼ö½Å ·çÆ¾À¸·Î °¡±â

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
½ÃÀÛÀ½:
    TEMPO 220
    'MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
Á¾·áÀ½:
    TEMPO 220
    'MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
¿¡·¯À½:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: 'ÀüÆ÷Æ®¼­º¸¸ðÅÍ»ç¿ë¼³Á¤

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ¸ðÅÍONOFF = 0
    GOSUB ½ÃÀÛÀ½			
    RETURN

    '************************************************
    'ÀüÆ÷Æ®¼­º¸¸ðÅÍ»ç¿ë¼³Á¤
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ¸ðÅÍONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB Á¾·áÀ½	
    RETURN
    '************************************************
    'À§Ä¡°ªÇÇµå¹é
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    'À§Ä¡°ªÇÇµå¹é
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

Àü¿øÃÊ±âÀÚ¼¼:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
<<<<<<< HEAD
<<<<<<< HEAD

=======
    
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
=======

>>>>>>> 5f3e757 (Chore: ìƒ¤ì‚­ìƒ¤ì‚­ ëª¨ì…˜ ìˆ˜ì •)
    WAIT
    mode = 0
    RETURN
    '************************************************
¾ÈÁ¤È­ÀÚ¼¼:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
±âº»ÀÚ¼¼:
<<<<<<< HEAD
<<<<<<< HEAD

=======
	
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
=======

>>>>>>> 5f3e757 (Chore: ìƒ¤ì‚­ìƒ¤ì‚­ ëª¨ì…˜ ìˆ˜ì •)
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
±âº»ÀÚ¼¼2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN
    '******************************************	
Â÷·ÇÀÚ¼¼:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
¾ÉÀºÀÚ¼¼:
    GOSUB ÀÚÀÌ·ÎOFF
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
    '**** ÀÚÀÌ·Î°¨µµ ¼³Á¤ ****
ÀÚÀÌ·ÎINIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ÀÚÀÌ·Î°¨µµ ¼³Á¤ ****
ÀÚÀÌ·ÎMAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
ÀÚÀÌ·ÎMID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
ÀÚÀÌ·ÎMIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '******************ZERO G6A,100, 101, 102, 106, 100, 100
    ZERO G6B,102, 101, 100, 100, 100, 100
    ZERO G6C, 97, 100,  96, 100, 100, 100
    ZERO G6D,100, 103, 103, 104, 103, 100
    '*****************************
ÀÚÀÌ·ÎON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ÀÚÀÌ·ÎONOFF = 1

    RETURN
    '***********************************************
ÀÚÀÌ·ÎOFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ÀÚÀÌ·ÎONOFF = 0
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


¶óÀÎµû¶ó°ÉÀ½:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ¶óÀÎµû¶ó°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ¶óÀÎµû¶ó°ÉÀ½_4
    ENDIF


    '**********************

¶óÀÎµû¶ó°ÉÀ½_1: '¿Þ¹ß
    'HIGHSPEED SETON
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,106,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


¶óÀÎµû¶ó°ÉÀ½_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ¶óÀÎµû¶ó°ÉÀ½_4
    IF A <> A_old THEN
¶óÀÎµû¶ó°ÉÀ½_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF

    '*********************************

¶óÀÎµû¶ó°ÉÀ½_4: '¿À¸¥¹ß
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,102,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


¶óÀÎµû¶ó°ÉÀ½_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ¶óÀÎµû¶ó°ÉÀ½_1
    IF A <> A_old THEN
¶óÀÎµû¶ó°ÉÀ½_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF
    '*************************************

    GOTO ¶óÀÎµû¶ó°ÉÀ½_1

    '******************************************
ÀüÁø´Þ¸®±â50:
    ³Ñ¾îÁøÈ®ÀÎ = 0
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    DELAY 50
    SPEED 6
    HIGHSPEED SETON



    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 146,  93, 98
        WAIT

        MOVE G6A,95,  82, 120, 120, 104
        MOVE G6D,104,  79, 147,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        GOTO ÀüÁø´Þ¸®±â50_2
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  82, 121, 120, 104
        MOVE G6A,104,  79, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        GOTO ÀüÁø´Þ¸®±â50_5
    ENDIF


    '**********************

ÀüÁø´Þ¸®±â50_1:
    MOVE G6A,95,  97, 100, 120, 104
    MOVE G6D,104,  79, 148,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


ÀüÁø´Þ¸®±â50_2:
    MOVE G6A,95,  77, 122, 120, 104
    MOVE G6D,104,  80, 148,  90,  100
    WAIT

ÀüÁø´Þ¸®±â50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 161,  68, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁø´Þ¸®±â50_3_stop

    ERX 4800,A, ÀüÁø´Þ¸®±â50_4
    IF A <> A_old THEN
ÀüÁø´Þ¸®±â50_3_stop:

        MOVE G6D,90,  93, 116, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    '*********************************

ÀüÁø´Þ¸®±â50_4:
    MOVE G6D,95,  97, 101, 120, 104
    MOVE G6A,104,  79, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


ÀüÁø´Þ¸®±â50_5:
    MOVE G6D,95,  77, 123, 120, 104
    MOVE G6A,104,  80, 147,  90,  100
    WAIT


ÀüÁø´Þ¸®±â50_6:
    MOVE G6D,103,  71, 146, 103,  100
    MOVE G6A, 95, 89, 160,  68, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF
    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁø´Þ¸®±â50_6_stop
    ERX 4800,A, ÀüÁø´Þ¸®±â50_1
    IF A <> A_old THEN
ÀüÁø´Þ¸®±â50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 146,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    GOTO ÀüÁø´Þ¸®±â50_1


¿¬¼ÓÀüÁø:
    º¸ÇàCOUNT = 0
    º¸Çà¼Óµµ = 13
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    GOSUB Leg_motor_mode3

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1

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


        GOTO ¿¬¼ÓÀüÁø_1	
    ELSE
        º¸Çà¼ø¼­ = 0

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


        GOTO ¿¬¼ÓÀüÁø_2	

    ENDIF


    '*******************************
<<<<<<< HEAD
<<<<<<< HEAD

=======
 
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
=======

>>>>>>> 5f3e757 (Chore: ìƒ¤ì‚­ìƒ¤ì‚­ ëª¨ì…˜ ìˆ˜ì •)


¿¬¼ÓÀüÁø_1:

    ETX 4800,11 'ÁøÇàÄÚµå¸¦ º¸³¿
    SPEED º¸Çà¼Óµµ

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 149,  93,  96
    WAIT


    SPEED ÁÂ¿ì¼Óµµ
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 147,  69, 110
    WAIT


    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ¿¬¼ÓÀüÁø_2
    IF A = 11 THEN
        GOTO ¿¬¼ÓÀüÁø_2
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
        GOSUB ±âº»ÀÚ¼¼2

        GOTO RX_EXIT
    ENDIF
    '**********

¿¬¼ÓÀüÁø_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 122, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

¿¬¼ÓÀüÁø_3:
    ETX 4800,11 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 86,  56, 147, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,110,  76, 149, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ¿¬¼ÓÀüÁø_4
    IF A = 11 THEN
        GOTO ¿¬¼ÓÀüÁø_4
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
        GOSUB ±âº»ÀÚ¼¼2

        GOTO RX_EXIT
    ENDIF

¿¬¼ÓÀüÁø_4:
    '¿Þ¹ßµé±â10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 148,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO ¿¬¼ÓÀüÁø_1
    '*******************************
    '*******************************


    '************************************************
ÇÑ°ÉÀ½°È±â:
    º¸Çà¼Óµµ = 12
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0
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
    GOTO ÇÑ°ÉÀ½°È±â_2	

ÇÑ°ÉÀ½°È±â_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

ÇÑ°ÉÀ½°È±â_3:
    ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 145, 115, 112
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 147, 93,  98
    MOVE G6A,90, 100, 145,  69, 108
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ÇÑ°ÉÀ½°È±â_4
    IF A = 11 THEN
        GOTO ÇÑ°ÉÀ½°È±â_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
ÇÑ°ÉÀ½°È±â_4:
    SPEED 13
    MOVE G6A,95, 90, 120, 105, 111,100
    MOVE G6D,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ' SPEED 10
    '  GOSUB ±âº»ÀÚ¼¼2
    ' GOTO ÇÑ°ÉÀ½°È±â

    SPEED 10
    GOSUB ±âº»ÀÚ¼¼2
    RETURN

    '*******************************************************************************************************************************
ÇÑ°ÉÀ½°È±â2:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0
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
    GOTO ÇÑ°ÉÀ½°È±â2_2	

ÇÑ°ÉÀ½°È±â2_2:
    MOVE G6D,110,  76, 147,  93, 100,100
    MOVE G6A,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

ÇÑ°ÉÀ½°È±â2_3:
    ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6A, 90,  56, 145, 115, 112
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6A,108,  76, 147, 93,  98
    MOVE G6D,90, 100, 145,  69, 108
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ÇÑ°ÉÀ½°È±â2_4
    IF A = 11 THEN
        GOTO ÇÑ°ÉÀ½°È±â2_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
ÇÑ°ÉÀ½°È±â2_4:
    SPEED 9
    MOVE G6D,95, 90, 120, 105, 111,100
    MOVE G6A,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    SPEED 6
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN
    '*******************************************************
ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 7
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT

    HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 98
        MOVE G6D,101,  76, 146,  93, 95
        WAIT

        GOTO ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 146,  93, 98
        MOVE G6A,101,  76, 147,  93, 95
        WAIT

        GOTO ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_4
    ENDIF


    '**********************

ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1:
    MOVE G6A,95,  90, 125, 100, 101
    MOVE G6D,104,  77, 146,  93,  99
    WAIT


ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_2:

    MOVE G6A,103,   73, 140, 103,  97
    MOVE G6D, 95,  85, 146,  85, 99
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_2_stop

    ERX 4800,A, ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_4
    IF A <> A_old THEN
ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_2_stop:
        MOVE G6D,95,  90, 124, 95, 101
        MOVE G6A,104,  76, 145,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        'GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        '  SPEED 5
        ' GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_4:
    MOVE G6D,95,  95, 119, 100, 101
    MOVE G6A,104,  77, 147,  93,  99
    WAIT


ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_5:
    MOVE G6D,103,    73, 139, 103,  97
    MOVE G6A, 95,  85, 147,  85, 99
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_5_stop

    ERX 4800,A, ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1
    IF A <> A_old THEN
ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_5_stop:
        MOVE G6A,95,  90, 125, 95, 101
        MOVE G6D,104,  76, 144,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        ' GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        ' SPEED 5
        '  GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO ºü¸¥È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1

    '-----------------------------------------------------------------

¿¬¼ÓÈÄÁø:
    ³Ñ¾îÁøÈ®ÀÎ = 0
    º¸Çà¼Óµµ = 12
    ÁÂ¿ì¼Óµµ = 4
    GOSUB Leg_motor_mode3



    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1

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

        GOTO ¿¬¼ÓÈÄÁø_1	
    ELSE
        º¸Çà¼ø¼­ = 0

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


        GOTO ¿¬¼ÓÈÄÁø_2

    ENDIF


¿¬¼ÓÈÄÁø_1:
    ETX 4800,12 'ÁøÇàÄÚµå¸¦ º¸³¿
    SPEED º¸Çà¼Óµµ

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ¿¬¼ÓÈÄÁø_2
    IF A <> A_old THEN
¿¬¼ÓÈÄÁø_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB ±âº»ÀÚ¼¼2
        GOTO RX_EXIT
    ENDIF
    '**********

¿¬¼ÓÈÄÁø_2:
    ETX 4800,12 'ÁøÇàÄÚµå¸¦ º¸³¿
    SPEED º¸Çà¼Óµµ
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, ¿¬¼ÓÈÄÁø_1
    IF A <> A_old THEN
¿¬¼ÓÈÄÁø_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB ±âº»ÀÚ¼¼2
        GOTO RX_EXIT
    ENDIF  	

    GOTO ¿¬¼ÓÈÄÁø_1
    '**********************************************

    '******************************************
È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_4
    ENDIF


    '**********************

È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_2_stop

    ERX 4800,A, È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_4
    IF A <> A_old THEN
È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_5_stop

    ERX 4800,A, È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1
    IF A <> A_old THEN
È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½_1

    '******************************************

    '******************************************
ÀüÁøÁ¾Á¾°ÉÀ½:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ÀüÁøÁ¾Á¾°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ÀüÁøÁ¾Á¾°ÉÀ½_4
    ENDIF


    '**********************

ÀüÁøÁ¾Á¾°ÉÀ½_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


ÀüÁøÁ¾Á¾°ÉÀ½_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    'IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_2_stop

    ERX 4800,A, ÀüÁøÁ¾Á¾°ÉÀ½_4
    IF A <> A_old THEN
ÀüÁøÁ¾Á¾°ÉÀ½_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

ÀüÁøÁ¾Á¾°ÉÀ½_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


ÀüÁøÁ¾Á¾°ÉÀ½_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    ' IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_5_stop

    ERX 4800,A, ÀüÁøÁ¾Á¾°ÉÀ½_1
    IF A <> A_old THEN
ÀüÁøÁ¾Á¾°ÉÀ½_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

°È±â:


    '*************************************
<<<<<<< HEAD
    
    
=======
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)

    '*********************************

    GOTO ÀüÁøÁ¾Á¾°ÉÀ½_1

    '******************************************
    '******************************************
    '******************************************
ÈÄÁøÁ¾Á¾°ÉÀ½:
    GOSUB All_motor_mode3
    ³Ñ¾îÁøÈ®ÀÎ = 0
    º¸ÇàCOUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,101
        MOVE G6C,101
        WAIT

        GOTO ÈÄÁøÁ¾Á¾°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,101
        MOVE G6C,101
        WAIT

        GOTO ÈÄÁøÁ¾Á¾°ÉÀ½_4
    ENDIF


    '**********************

ÈÄÁøÁ¾Á¾°ÉÀ½_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,116
    MOVE G6C,86
    WAIT



ÈÄÁøÁ¾Á¾°ÉÀ½_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF
    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÈÄÁøÁ¾Á¾°ÉÀ½_3_stop
    ERX 4800,A, ÈÄÁøÁ¾Á¾°ÉÀ½_4
    IF A <> A_old THEN
ÈÄÁøÁ¾Á¾°ÉÀ½_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 101
        MOVE G6B,101
        WAIT

        'SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

ÈÄÁøÁ¾Á¾°ÉÀ½_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,116
    MOVE G6B,86
    WAIT


ÈÄÁøÁ¾Á¾°ÉÀ½_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÈÄÁøÁ¾Á¾°ÉÀ½_6_stop

    ERX 4800,A, ÈÄÁøÁ¾Á¾°ÉÀ½_1
    IF A <> A_old THEN  'GOTO ÈÄÁøÁ¾Á¾°ÉÀ½_¸ØÃã
ÈÄÁøÁ¾Á¾°ÉÀ½_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 101
        MOVE G6C,101
        WAIT

        'SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO ÈÄÁøÁ¾Á¾°ÉÀ½_1




    '******************************************


    '******************************************
    '******************************************

    '******************************************
    '*************************************

    '******************************************
°î¼±ÀüÁøÁ¾Á¾°ÉÀ½:
    ³Ñ¾îÁøÈ®ÀÎ = 0

    °î¼±¹æÇâ = 2
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_4
    ENDIF



    '**********************

°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_1:
    SPEED 8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_3:
    SPEED 8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_4_0

    IF A = 20 THEN
        °î¼±¹æÇâ = 3
    ELSEIF A = 43 THEN
        °î¼±¹æÇâ = 1
    ELSEIF A = 11 THEN
        °î¼±¹æÇâ = 2
    ELSE  'Á¤Áö
        GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_3¸ØÃã
    ENDIF

°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_4_0:

    IF  °î¼±¹æÇâ = 1 THEN'¿ÞÂÊ

    ELSEIF  °î¼±¹æÇâ = 3 THEN'¿À¸¥ÂÊ
        HIGHSPEED SETOFF
        SPEED 8
        MOVE G6D,103,   71, 140, 105,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_1

    ENDIF



    '*********************************

°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_4:
    SPEED 8
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_6:
    SPEED 8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_1_0

    IF A = 20 THEN
        °î¼±¹æÇâ = 3
    ELSEIF A = 43 THEN
        °î¼±¹æÇâ = 1
    ELSEIF A = 11 THEN
        °î¼±¹æÇâ = 2
    ELSE  'Á¤Áö
        GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_6¸ØÃã
    ENDIF

°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_1_0:

    IF  °î¼±¹æÇâ = 1 THEN'¿ÞÂÊ
        HIGHSPEED SETOFF
        SPEED 8
        MOVE G6A,103,   71, 140, 105,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_4
    ELSEIF °î¼±¹æÇâ = 3 THEN'¿À¸¥ÂÊ


    ENDIF



    GOTO °î¼±ÀüÁøÁ¾Á¾°ÉÀ½_1
    '******************************************
    '******************************************
    '*********************************
°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_3¸ØÃã:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ¾ÈÁ¤È­ÀÚ¼¼
    SPEED 10
    GOSUB ±âº»ÀÚ¼¼
    GOTO MAIN	
    '******************************************
°î¼±ÀüÁøÁ¾Á¾°ÉÀ½_6¸ØÃã:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ¾ÈÁ¤È­ÀÚ¼¼
    SPEED 10
    GOSUB ±âº»ÀÚ¼¼
    GOTO MAIN	
    '******************************************

    '************************************************
¿À¸¥ÂÊ¿·À¸·Î20: '****
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  78, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************
    '*************

¿ÞÂÊ¿·À¸·Î20: '****
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  78, 145,  93, 100, 100
    GOSUB All_motor_mode3
    GOTO RX_EXIT

    '**********************************************
    '******************************************
¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_loop:
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


    '  ERX 4800, A ,¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_loop
    '    IF A = A_OLD THEN  GOTO ¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_loop
    '¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_stop:
    GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT
    '**********************************************

¿ÞÂÊ¿·À¸·Î70¿¬¼Ó:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_loop:
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

    '   ERX 4800, A ,¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_loop	
    '    IF A = A_OLD THEN  GOTO ¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_loop
    '¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_stop:

    GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT

    '**********************************************
    '************************************************
<<<<<<< HEAD
=======
    '*********************************************

    'Á»´õ °­ÇÏ°Ô ¿·À¸·Î °¡´Â ÇÔ¼ö(¹®¿­¶§ »ç¿ë)
¿À¸¥ÂÊ¿·À¸·Î°È±â:

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    GOSUB All_motor_Reset
    DELAY  10

    SPEED 7
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
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


    SPEED 5

    RETURN


¿ÞÂÊ¿·À¸·Î°È±â:

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    GOSUB All_motor_Reset
    DELAY  10

    SPEED 7
    MOVE G6A, 90,  90, 120, 105, 110, 100
    MOVE G6D,100,  76, 145,  93, 107, 100
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
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


    SPEED 5

    RETURN

¹®¿­±âµ¿ÀÛ:
    SPEED 5

    MOVE G6C,130,  90, 10
    MOVE G6B,100, 190 , 10	
    WAIT

    DELAY 200

    RETURN


¹®¿­±âµ¿ÀÛ2:
    SPEED 5

    MOVE G6B,130,  90, 10
    MOVE G6C,100, 190 , 10	
    WAIT

    DELAY 200

    RETURN
    '*******************************
¹®¿­±â°È±â:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  77, 147,  93, 101
        MOVE G6D,101,  76, 149,  93, 98
        WAIT

        GOTO ¹®¿­±â°È±â_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 149,  93, 101
        MOVE G6A,101,  77, 147,  93, 98
        WAIT

        GOTO ¹®¿­±â°È±â_4
    ENDIF


    '**********************

¹®¿­±â°È±â_1:
    MOVE G6A,95,  91, 125, 100, 104
    MOVE G6D,104,  77, 149,  93,  102
    WAIT


¹®¿­±â°È±â_2:

    MOVE G6A,103,   74, 140, 103,  100
    MOVE G6D, 95,  85, 149,  85, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ¹®¿­±â°È±â_2_stop

    ERX 4800,A, ¹®¿­±â°È±â_4
    IF A <> A_old THEN
¹®¿­±â°È±â_2_stop:
        MOVE G6D,95,  90, 127, 95, 104
        MOVE G6A,104,  77, 145,  91,  102
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        'GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        ' SPEED 5
        '  GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  75, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

¹®¿­±â°È±â_4:
    MOVE G6D,95,  96, 122, 100, 104
    MOVE G6A,104,  78, 147,  93,  102
    WAIT


¹®¿­±â°È±â_5:
    MOVE G6D,103,    74, 142, 103,  100
    MOVE G6A, 95,  86, 147,  85, 102
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ¹®¿­±â°È±â_5_stop

    ERX 4800,A, ¹®¿­±â°È±â_1
    IF A <> A_old THEN
¹®¿­±â°È±â_5_stop:
        MOVE G6A,95,  91, 125, 95, 104
        MOVE G6D,104,  79, 145,  91,  102
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        '   GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        '  SPEED 5
        ' GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  75, 145,  93, 100, 100
        MOVE G6D,100,  77, 145,  93, 100, 100

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO ¹®¿­±â°È±â_1

¹®¿­±â°È±âÈÄÁø:
    GOSUB All_motor_mode3
    ³Ñ¾îÁøÈ®ÀÎ = 0
    º¸ÇàCOUNT = 0
    SPEED 7
    'HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  77, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        WAIT

        GOTO ¹®¿­±â°È±âÈÄÁø_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        WAIT

        GOTO ¹®¿­±â°È±âÈÄÁø_4
    ENDIF


    '**********************

¹®¿­±â°È±âÈÄÁø_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    WAIT



¹®¿­±â°È±âÈÄÁø_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF
    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ¹®¿­±â°È±âÈÄÁø_3_stop
    ERX 4800,A, ¹®¿­±â°È±âÈÄÁø_4
    IF A <> A_old THEN
¹®¿­±â°È±âÈÄÁø_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        WAIT

        'SPEED 15
        '        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        '       HIGHSPEED SETOFF
        '      SPEED 5
        '     GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100

        '   DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

¹®¿­±â°È±âÈÄÁø_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    WAIT


¹®¿­±â°È±âÈÄÁø_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ¹®¿­±â°È±âÈÄÁø_6_stop

    ERX 4800,A, ¹®¿­±â°È±âÈÄÁø_1
    IF A <> A_old THEN  'GOTO ¹®¿­±â°È±âÈÄÁø_¸ØÃã
¹®¿­±â°È±âÈÄÁø_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        WAIT

        'SPEED 15
        '        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        '       HIGHSPEED SETOFF
        '      SPEED 5
        '     GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100

        '  DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO ¹®¿­±â°È±âÈÄÁø_1

¹®¿­±â¿ÞÂÊ3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¹®¿­±â¿ÞÂÊ3_LOOP:
    'SPEED 5

    'MOVE G6B,130,  90, 10
    'MOVE G6C,100, 190 , 10	
    'WAIT

    ' DELAY 150
    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  91, 100, 100
        MOVE G6A,100,  79, 145,  91, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  76, 100, 100
        MOVE G6A,100,  68, 145,  106, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  76, 102, 100
        MOVE G6A,104,  71, 145,  103, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 128, 102, 104
        MOVE G6A,105,  76, 144,  93,  100
        WAIT



    ELSE
        º¸Çà¼ø¼­ = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  91, 100, 100
        MOVE G6A,100,  79, 145,  91, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  76, 100, 100
        MOVE G6A,100,  65, 145,  106, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  78, 100, 100
        MOVE G6A,90,  58, 145,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 128, 98, 104
        MOVE G6D,105,  77, 144,  93,  100
        WAIT


    ENDIF

    SPEED 12
    ' GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  91, 100, 100
    MOVE G6D,100,  76, 145,  91, 100, 100


    GOTO RX_EXIT

¹®¿­±â¿À¸¥ÂÊ3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¹®¿­±â¿À¸¥ÂÊ3_LOOP:
    '   MOVE G6C,130,  90, 10
    '  MOVE G6B,100, 190 , 10	
    ' WAIT
    'DELAY 150
    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  91, 100, 100
        MOVE G6D,98,  79, 146,  91, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  76, 100, 100
        MOVE G6D,98,  68, 146,  106, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  76, 102, 100
        MOVE G6D,102  71, 146,  103, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 128, 102, 104
        MOVE G6D,103,  76, 145,  93,  100
        WAIT



    ELSE
        º¸Çà¼ø¼­ = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  91, 100, 100
        MOVE G6D,98,  79, 146,  91, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  76, 100, 100
        MOVE G6D,98,  65, 146,  106, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  78, 100, 100
        MOVE G6D,88,  58, 146,  108, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,88,  85, 129, 98, 104
        MOVE G6A,105,  77, 143,  93,  100
        WAIT

    ENDIF
    SPEED 12
    '  GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  91, 100, 100
    MOVE G6D,100,  76, 145,  91, 100, 100

    GOTO RX_EXIT

¹®¿­±â¿ÞÂÊ3_LOOP_°íÁ¤:
    SPEED 5

    MOVE G6C,130,  90, 10
    MOVE G6B,100, 190 , 10	
    WAIT

    DELAY 150
    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        º¸Çà¼ø¼­ = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    ' GOSUB ±âº»ÀÚ¼¼2


    GOTO RX_EXIT

¹®¿­±â¿À¸¥ÂÊ3_LOOP_°íÁ¤:
    '  SPEED 5

    MOVE G6C,130,  90, 10
    MOVE G6B,100, 190 , 10	
    WAIT

    DELAY 150
    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,98,  79, 146,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,98,  68, 146,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,102  71, 146,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,103,  76, 147,  93,  100
        WAIT



    ELSE
        º¸Çà¼ø¼­ = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,98,  79, 146,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,98,  65, 146,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,88,  58, 146,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,88,  85, 131, 98, 104
        MOVE G6A,105,  77, 145,  93,  100
        WAIT

    ENDIF
    SPEED 12
    '  GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT


>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)

¿ÞÂÊÅÏ3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¿ÞÂÊÅÏ3_LOOP:

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
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
        º¸Çà¼ø¼­ = 0
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
    GOSUB ±âº»ÀÚ¼¼2


    GOTO RX_EXIT

    '**********************************************
¿À¸¥ÂÊÅÏ3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¿À¸¥ÂÊÅÏ3_LOOP:

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
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
        º¸Çà¼ø¼­ = 0
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
    GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
¿ÞÂÊÅÏ10:
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

    GOSUB ±âº»ÀÚ¼¼2
    GOTO RX_EXIT
    '**********************************************
¿À¸¥ÂÊÅÏ10:
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

    GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT
    '**********************************************
    '**********************************************
¿ÞÂÊÅÏ20:
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

    GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT
    '**********************************************
¿À¸¥ÂÊÅÏ20:
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

    GOSUB ±âº»ÀÚ¼¼2

    GOTO RX_EXIT
    '**********************************************
<<<<<<< HEAD
=======
¹®¿­°í¿À¸¥ÂÊÅÏ20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    '  MOVE G6B,90
    ' MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    '  GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT
    '**********************************************	

¹®¿­°í¿ÞÂÊÅÏ20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    'MOVE G6B,110
    'MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT

¹®¿­°í¿ÞÂÊÅÏ45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 10
    MOVE G6A,95, 106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    'MOVE G6B,110
    'MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT
    SPEED 8
    '   MOVE G6A,101,  76, 146,  93, 98, 100
    '  MOVE G6D,101,  76, 146,  93, 98, 100

    '  WAIT

    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT

¹®¿­°í¿À¸¥ÂÊÅÏ45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    '  MOVE G6B,90
    ' MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    ' MOVE G6A,101,  76, 146,  93, 98, 100
    'MOVE G6D,101,  76, 146,  93, 98, 100

    'WAIT

    '  GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT
    '**********************************************
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
¿ÞÂÊÅÏ45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
¿ÞÂÊÅÏ45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB ±âº»ÀÚ¼¼2
    'DELAY 50
    '    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    '    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
    '        ³Ñ¾îÁøÈ®ÀÎ = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,¿ÞÂÊÅÏ45_LOOP
    '    IF A_old = A THEN GOTO ¿ÞÂÊÅÏ45_LOOP
    '
    GOTO RX_EXIT

    '**********************************************
¿À¸¥ÂÊÅÏ45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
¿À¸¥ÂÊÅÏ45_LOOP:

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB ±âº»ÀÚ¼¼2
    ' DELAY 50
    '    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    '    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
    '        ³Ñ¾îÁøÈ®ÀÎ = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,¿À¸¥ÂÊÅÏ45_LOOP
    '    IF A_old = A THEN GOTO ¿À¸¥ÂÊÅÏ45_LOOP
    '
    GOTO RX_EXIT
    '**********************************************
¿ÞÂÊÅÏ60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
¿ÞÂÊÅÏ60_LOOP:

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB ±âº»ÀÚ¼¼2
    '  DELAY 50
    '    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    '    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
    '        ³Ñ¾îÁøÈ®ÀÎ = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,¿ÞÂÊÅÏ60_LOOP
    '    IF A_old = A THEN GOTO ¿ÞÂÊÅÏ60_LOOP

    GOTO RX_EXIT

    '**********************************************
¿À¸¥ÂÊÅÏ60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
¿À¸¥ÂÊÅÏ60_LOOP:

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB ±âº»ÀÚ¼¼2
    ' DELAY 50
    '    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    '    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
    '        ³Ñ¾îÁøÈ®ÀÎ = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,¿À¸¥ÂÊÅÏ60_LOOP
    '    IF A_old = A THEN GOTO ¿À¸¥ÂÊÅÏ60_LOOP

    GOTO RX_EXIT
    '****************************************
    '************************************************
    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
µÚ·ÎÀÏ¾î³ª±â:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ÀÚÀÌ·ÎOFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB ±âº»ÀÚ¼¼

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
    GOSUB ±âº»ÀÚ¼¼

    ³Ñ¾îÁøÈ®ÀÎ = 1

    DELAY 200
    GOSUB ÀÚÀÌ·ÎON

    RETURN


    '**********************************************
¾ÕÀ¸·ÎÀÏ¾î³ª±â:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ÀÚÀÌ·ÎOFF

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
    GOSUB ±âº»ÀÚ¼¼
    ³Ñ¾îÁøÈ®ÀÎ = 1

    '******************************
    DELAY 200
    GOSUB ÀÚÀÌ·ÎON
    RETURN

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
    '**********************************************

¸Ó¸®¿ÞÂÊ30µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,70
    GOTO MAIN

¸Ó¸®¿ÞÂÊ45µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,55
    GOTO MAIN

¸Ó¸®¿ÞÂÊ60µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,40
    GOTO MAIN

¸Ó¸®¿ÞÂÊ90µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,10
    GOTO MAIN

¸Ó¸®¿À¸¥ÂÊ30µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,130
    GOTO MAIN

¸Ó¸®¿À¸¥ÂÊ45µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,145
    GOTO MAIN	

¸Ó¸®¿À¸¥ÂÊ60µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,160
    GOTO MAIN

¸Ó¸®¿À¸¥ÂÊ90µµ:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,190
    GOTO MAIN

¸Ó¸®ÁÂ¿ìÁß¾Ó:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
    SERVO 11,100
    GOTO MAIN

¸Ó¸®»óÇÏÁ¤¸é:
    SPEED ¸Ó¸®ÀÌµ¿¼Óµµ
<<<<<<< HEAD
    SERVO 11,100	' ÀÌ°Å ¸ÓÀÓ? ¿Ö »óÇÏÀÎµ¥ 11ÀÌ¾ß
=======
    SERVO 11,100	
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    SPEED 5
    GOSUB ±âº»ÀÚ¼¼
    GOTO MAIN

    '******************************************

¾ÕµÚ±â¿ï±âÃøÁ¤:
    FOR i = 0 TO COUNT_MAX
        A = AD(¾ÕµÚ±â¿ï±âADÆ÷Æ®)	'±â¿ï±â ¾ÕµÚ
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ±â¿ï±âÈ®ÀÎ½Ã°£
    NEXT i

    IF A < MIN THEN
        GOSUB ±â¿ï±â¾Õ
    ELSEIF A > MAX THEN
        GOSUB ±â¿ï±âµÚ
    ENDIF

    RETURN
    '**************************************************
±â¿ï±â¾Õ:
    A = AD(¾ÕµÚ±â¿ï±âADÆ÷Æ®)
    'IF A < MIN THEN GOSUB ¾ÕÀ¸·ÎÀÏ¾î³ª±â
    IF A < MIN THEN
        ETX  4800,16
        GOSUB µÚ·ÎÀÏ¾î³ª±â

    ENDIF
    RETURN

±â¿ï±âµÚ:
    A = AD(¾ÕµÚ±â¿ï±âADÆ÷Æ®)
    'IF A > MAX THEN GOSUB µÚ·ÎÀÏ¾î³ª±â
    IF A > MAX THEN
        ETX  4800,15
        GOSUB ¾ÕÀ¸·ÎÀÏ¾î³ª±â
    ENDIF
    RETURN
    '**************************************************
ÁÂ¿ì±â¿ï±âÃøÁ¤:
    FOR i = 0 TO COUNT_MAX
        B = AD(ÁÂ¿ì±â¿ï±âADÆ÷Æ®)	'±â¿ï±â ÁÂ¿ì
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ±â¿ï±âÈ®ÀÎ½Ã°£
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB ±âº»ÀÚ¼¼	
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
Number_Play: '  BUTTON_NO = ¼ýÀÚ´ëÀÔ


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
Àû¿Ü¼±°Å¸®¼¾¼­È®ÀÎ:

    Àû¿Ü¼±°Å¸®°ª = AD(Àû¿Ü¼±ADÆ÷Æ®)

    IF Àû¿Ü¼±°Å¸®°ª > 50 THEN '50 = Àû¿Ü¼±°Å¸®°ª = 25cm
        'MUSIC "C"
        DELAY 200
    ENDIF




    RETURN

    '******************************************


    '**********************************************
Áý°í¿ÞÂÊÅÏ10:

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
Áý°í¿À¸¥ÂÊÅÏ10:

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
Áý°í¿ÞÂÊÅÏ20:

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
Áý°í¿À¸¥ÂÊÅÏ20:

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
Áý°í¿ÞÂÊÅÏ45:

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
Áý°í¿À¸¥ÂÊÅÏ45:

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
Áý°í¿ÞÂÊÅÏ60:

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
Áý°í¿À¸¥ÂÊÅÏ60:

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

Áý°í¿À¸¥ÂÊÅÏ3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

Áý°í¿À¸¥ÂÊÅÏ3_LOOP:
    MOVE G6B, 143, 10, 60,	  ,	  ,
    MOVE G6C, 143, 10, 60,	  ,   ,
    WAIT
    DELAY 3
    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
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
        º¸Çà¼ø¼­ = 0
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOTO RX_EXIT
    '*************************************************

Áý°í¿ÞÂÊÅÏ3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

Áý°í¿ÞÂÊÅÏ3_LOOP:
    MOVE G6B, 143, 10, 60,	  ,	  ,
    MOVE G6C, 143, 10, 60,	  ,   ,
    WAIT
    DELAY 3

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
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
        º¸Çà¼ø¼­ = 0
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
    '    GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOTO RX_EXIT


    '************************************************
    '************************************************

¾ÈÀü±¸¿ª:
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 4 !"
<<<<<<< HEAD
    GOSUB SOUND_PLAY_CHK
=======
    'GOSUB SOUND_PLAY_CHK
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    RETURN

È®Áø±¸¿ª:
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 5 !"
<<<<<<< HEAD
    GOSUB SOUND_PLAY_CHK
=======
    'GOSUB SOUND_PLAY_CHK
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    RETURN

µ¿ÂÊ:
    SPEED 10
    MOVE G6C, 190, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 0 !"
<<<<<<< HEAD
    GOSUB SOUND_PLAY_CHK
=======
    'GOSUB SOUND_PLAY_CHK
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    DELAY 500
    PRINT "SOUND 0 !"
    DELAY 10
    GOSUB ±âº»ÀÚ¼¼2
    RETURN

¼­ÂÊ:
    SPEED 10
    MOVE G6B, 190, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 1 !"
<<<<<<< HEAD
    GOSUB SOUND_PLAY_CHK
=======
    'GOSUB SOUND_PLAY_CHK
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    DELAY 500
    PRINT "SOUND 1 !"
    DELAY 10
    GOSUB ±âº»ÀÚ¼¼2	
    RETURN
³²ÂÊ:
    SPEED 10
    MOVE G6B, 30, 30, 80
    MOVE G6C, 30, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 2 !"
<<<<<<< HEAD
    GOSUB SOUND_PLAY_CHK
=======
    'GOSUB SOUND_PLAY_CHK
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    DELAY 500
    PRINT "SOUND 2 !"
    DELAY 10
    GOSUB ±âº»ÀÚ¼¼2
    RETURN
ºÏÂÊ:
    SPEED 10
    MOVE G6B, 190, 30, 80
    MOVE G6C, 190, 30, 80
    WAIT
    PRINT "OPEN 20GongMo.mrs !"
    PRINT "SOUND 3 !"
    DELAY 500
    PRINT "SOUND 3 !"
    DELAY 10
<<<<<<< HEAD
    GOSUB SOUND_PLAY_CHK
=======
    'GOSUB SOUND_PLAY_CHK
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    GOSUB ±âº»ÀÚ¼¼2
    RETURN
    '******************************************

AÁö¿ª:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 0 !"
    RETURN
BÁö¿ª:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 1 !"
    RETURN
CÁö¿ª:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 2 !"
    RETURN
DÁö¿ª:
    PRINT "OPEN M_ABCD.mrs !"
    PRINT "SOUND 3 !"
    RETURN

<<<<<<< HEAD
Àü¹æÇÏÇâ110µµ:
    SPEED 3
    SERVO 16, 110

    RETURN
    '******************************************
Àü¹æÇÏÇâ105µµ:
    SPEED 3
    SERVO 16, 105

    RETURN
    '******************************************
=======
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
Àü¹æÇÏÇâ100µµ:
    SPEED 3
    SERVO 16, 100

    RETURN
    '******************************************
Àü¹æÇÏÇâ97µµ:
    SPEED 3
    SERVO 16, 97

    RETURN
    '******************************************
Àü¹æÇÏÇâ95µµ:
    SPEED 3
    SERVO 16, 95

    RETURN
    '******************************************
<<<<<<< HEAD
=======

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
Àü¹æÇÏÇâ90µµ:

    SPEED 3
    SERVO 16, 92

    RETURN
    '******************************************
Àü¹æÇÏÇâ85µµ:

    SPEED 3
    SERVO 16, 85

    RETURN
    '******************************************
<<<<<<< HEAD
=======

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
Àü¹æÇÏÇâ80µµ:

    SPEED 3
    SERVO 16, 80

    RETURN
    '******************************************
Àü¹æÇÏÇâ75µµ:
    SPEED 3
    SERVO 16, 76

    RETURN
    '******************************************
Àü¹æÇÏÇâ70µµ:
    SPEED 3
    SERVO 16, 73

    RETURN
    '******************************************
<<<<<<< HEAD
Àü¹æÇÏÇâ65µµ:
    SPEED 3
    SERVO 16, 69

    RETURN
    '******************************************
=======
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
Àü¹æÇÏÇâ60µµ:

    SPEED 3
    SERVO 16, 65

    RETURN

    '******************************************
<<<<<<< HEAD
Àü¹æÇÏÇâ55µµ:

    SPEED 3
    SERVO 16, 59
=======
Àü¹æÇÏÇâ54µµ:

    SPEED 3
    SERVO 16, 58
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)

    RETURN

    '******************************************
<<<<<<< HEAD
Àü¹æÇÏÇâ50µµ:
=======

Àü¹æÇÏÇâ50µµ:

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    SPEED 3
    SERVO 16, 54

    RETURN
<<<<<<< HEAD
    '******************************************

Àü¹æÇÏÇâ45µµ:
    SPEED 3
    SERVO 16, 50
    
    RETURN
    '******************************************
Àü¹æÇÏÇâ40µµ:
    SPEED 3
    SERVO 16, 45

    RETURN
    '******************************************
Àü¹æÇÏÇâ35µµ:
=======

    '******************************************

Àü¹æÇÏÇâ45µµ:

    SPEED 3
    SERVO 16, 50
    RETURN

    '******************************************
Àü¹æÇÏÇâ35µµ:

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    SPEED 3
    SERVO 16, 40
    RETURN

    '******************************************
<<<<<<< HEAD
=======

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
Àü¹æÇÏÇâ30µµ:

    SPEED 3
    SERVO 16, 36

    RETURN
<<<<<<< HEAD
    '******************************************
Àü¹æÇÏÇâ25µµ:
    SPEED 3
    SERVO 16, 30

    RETURN
    '******************************************
Àü¹æÇÏÇâ20µµ:
    SPEED 3
    SERVO 16, 26

    RETURN
=======

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    '******************************************
Àü¹æÇÏÇâ18µµ:

    SPEED 3
    SERVO 16, 22
<<<<<<< HEAD
    
    RETURN
    '******************************************
=======
    '  ETX 4800,40
    RETURN

    '******************************************

>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
Àü¹æÇÏÇâ10µµ:

    SPEED 3
    SERVO 16, 10
<<<<<<< HEAD

    RETURN
    '******************************************
=======
    '   ETX 4800,41

    RETURN
    '******************************************

Àü¹æÇÏÇâ110µµ:

    SPEED 3
    SERVO 16, 110
    '   ETX 4800,41

    RETURN
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)

¾çÆÈ¹ú¸®±â:
    'MOVE G6A, 101,  83, 128,  96,  99, 100
    'MOVE G6D, 100,  79, 128, 100,  99, 100
    MOVE G6B, 107, 101, 100, 100, 100, 101
    MOVE G6C, 107, 101, 100, 100, 100, 100
    WAIT


    RETURN

Àâ±â±âº»ÀÚ¼¼:
    MOVE G6B, 90, 80, 80, 90, 100, 101
    MOVE G6C, 90, 80, 80, 90, 100, 100
    WAIT

    RETURN


¾çÆÈ¾ÕÀ¸·Î:
    SPEED 4
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT

    'DELAY 10
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN

¾çÆÈ¾ÕÀ¸·Î¿ÞÂÊ°È±â:
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100


    GOSUB All_motor_mode3
    GOTO RX_EXIT


    '******************************************	
¾çÆÈ¾ÕÀ¸·Î¿À¸¥ÂÊ°È±â:
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3
    GOTO RX_EXIT




¹°°ÇÁý±â:
    GOSUB All_motor_mode3
    GOSUB ÀÚÀÌ·ÎOFF
    SPEED 8  'before 2
    MOVE G6A, 100, 150, 30,   150, 100,	
    MOVE G6D, 100, 150, 30,   150, 100,
    MOVE G6B, 140, 30, 80,	  ,	  ,
    MOVE G6C, 140, 30, 80,	  ,   ,
    WAIT

    DELAY 50
    GOTO ¹°°ÇÁý±â_2

¹°°ÇÁý±â_2:
    ETX 4800, 46
    SPEED 4  'before 4
    'DELAY 20
    MOVE G6A, 100, 150, 30,   150, 100,	
    MOVE G6D, 100, 150, 30,   150, 100,
    MOVE G6B, 150, 10, 60,	  ,	  ,
    MOVE G6C, 150, 10, 60,	  ,   ,
    WAIT

    DELAY 20
    GOTO ¹°°ÇÁý±â_3
¹°°ÇÁý±â_3:
    ETX 4800, 46
    SPEED 8   'before 4
    MOVE G6A,100, 76,  145,    93,  100, 100
    MOVE G6D,100, 76,  145,    93,  100, 100
    MOVE G6B, 150, 10, 60,	  ,	  ,
    MOVE G6C, 150, 10, 60,	  ,   ,
    WAIT

    'DELAY 20
    GOTO ¹°°ÇÁý±â_4
¹°°ÇÁý±â_4:
    ETX 4800, 46
    SPEED 8  'before 4
    MOVE G6A,100, 76,  145,    93,  100, 100
    MOVE G6D,100, 76,  145,    93,  100, 100
    MOVE G6B, 160
    MOVE G6C, 160
    WAIT

    RETURN
    '******************************************
Áý°í¿ÞÂÊ¿·À¸·Î:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 175, 10, 60,	  ,	  ,
    MOVE G6C, 175, 10, 60,	  ,   ,
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100


    GOSUB All_motor_mode3
    GOTO RX_EXIT


    '******************************************	
Áý°í¿À¸¥ÂÊ¿·À¸·Î:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    MOVE G6B, 175, 10, 60,	  ,	  ,
    MOVE G6C, 175, 10, 60,	  ,   ,
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3
    GOTO RX_EXIT

Áý°í¿À¸¥ÂÊ¿·À¸·Î2:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

Áý°í¿À¸¥ÂÊ¿·À¸·Î2_LOOP:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    MOVE G6B, 175, 10, 60,	  ,	  ,
    MOVE G6C, 175, 10, 60,	  ,   ,
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


    '  ERX 4800, A ,¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_loop
    '    IF A = A_OLD THEN  GOTO ¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_loop
    '¿À¸¥ÂÊ¿·À¸·Î70¿¬¼Ó_stop:
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT
    '**********************************************

Áý°í¿ÞÂÊ¿·À¸·Î2:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
Áý°í¿ÞÂÊ¿·À¸·Î2_LOOP:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    MOVE G6B, 175, 10, 60,	  ,	  ,
    MOVE G6C, 175, 10, 60,	  ,   ,
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

    '   ERX 4800, A ,¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_loop	
    '    IF A = A_OLD THEN  GOTO ¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_loop
    '¿ÞÂÊ¿·À¸·Î70¿¬¼Ó_stop:

    'GOSUB ±âº»ÀÚ¼¼
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOTO RX_EXIT

    '******************************************

    '******************************************
¿ìÀ¯±ïÀâ±â¿ÞÂÊ¿·À¸·Î:
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100


    GOSUB All_motor_mode3
    GOTO RX_EXIT

¿ìÀ¯±ïÀâ±â¿À¸¥ÂÊ¿·À¸·Î:
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100

    GOSUB All_motor_mode3
    GOTO RX_EXIT


¹°°Ç³õ±â:
    GOSUB All_motor_mode3
    GOSUB ÀÚÀÌ·ÎOFF
    MOVE G6B, 145, , ,
    MOVE G6C, 145, , ,
    WAIT

    MOVE G6B, 140, 10, 60,	  ,	  ,
    MOVE G6C, 140, 10, 60,	  ,   ,
    WAIT

    GOTO ¹°°Ç³õ±â_2	
¹°°Ç³õ±â_2:
    ETX 4800, 47
    MOVE G6A, 100, 150, 30,   150, 100,	
    MOVE G6D, 100, 150, 30,   150, 100,
    MOVE G6B, 150, , ,
    MOVE G6C, 150, , ,
    WAIT

    GOTO ¹°°Ç³õ±â_3
¹°°Ç³õ±â_3:
    ETX 4800, 47
    MOVE G6B, , 30, 90
    MOVE G6C, , 30, 90
    WAIT

    GOTO ¹°°Ç³õ±â_4
¹°°Ç³õ±â_4:
    ETX 4800, 47
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOSUB ±âº»ÀÚ¼¼
    RETURN

Áý°íÀüÁøÁ¾Á¾°ÉÀ½:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 7
    'HIGHSPEED SETON
    MOVE G6B, 160, 10, 50
    MOVE G6C, 160, 10, 50


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        'MOVE G6B,100
        'MOVE G6C,100
        WAIT

        GOTO Áý°íÀüÁøÁ¾Á¾°ÉÀ½_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        'MOVE G6B,100
        'MOVE G6C,100
        WAIT

        GOTO Áý°íÀüÁøÁ¾Á¾°ÉÀ½_4
    ENDIF


    '**********************

Áý°íÀüÁøÁ¾Á¾°ÉÀ½_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    'MOVE G6B, 85
    'MOVE G6C,115
    WAIT


Áý°íÀüÁøÁ¾Á¾°ÉÀ½_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    'IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_2_stop

    ERX 4800,A, Áý°íÀüÁøÁ¾Á¾°ÉÀ½_4
    IF A <> A_old THEN
Áý°íÀüÁøÁ¾Á¾°ÉÀ½_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        'MOVE G6C, 100
        'MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

Áý°íÀüÁøÁ¾Á¾°ÉÀ½_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    'MOVE G6C, 85
    'MOVE G6B,115
    WAIT


Áý°íÀüÁøÁ¾Á¾°ÉÀ½_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    ' IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_5_stop

    ERX 4800,A, Áý°íÀüÁøÁ¾Á¾°ÉÀ½_1
    IF A <> A_old THEN
Áý°íÀüÁøÁ¾Á¾°ÉÀ½_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        'MOVE G6B, 100
        'MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

¹°°ÇÁý°íÀüÁø:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    'GOSUB Àü¹æÇÏÇâ18µµ
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
    GOTO ¹°°ÇÁý°íÀüÁø_2	

¹°°ÇÁý°íÀüÁø_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 102, 107,100
    WAIT

¹°°ÇÁý°íÀüÁø_3:
    'ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  90,  96
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 147, 90,  98
    MOVE G6A,90, 100, 142,  69, 108
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ¹°°ÇÁý°íÀüÁø_4
    IF A = 11 THEN
        GOTO ¹°°ÇÁý°íÀüÁø_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
¹°°ÇÁý°íÀüÁø_4:
    SPEED 9
    MOVE G6A,95, 90, 120, 102, 111,100
    MOVE G6D,108,  76, 146,  93,  96,100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    RETURN

Áý°íÀüÁø:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    'GOSUB Àü¹æÇÏÇâ18µµ
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
    GOTO Áý°íÀüÁø_2	

Áý°íÀüÁø_2:
    MOVE G6A,110,  76, 145,  93, 100,100
    MOVE G6D,96, 90, 118, 101, 106,99
    WAIT

Áý°íÀüÁø_3:
    'ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 143, 114, 109
    MOVE G6A,108,  76, 145,  89,  95
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 145, 89,  97
    MOVE G6A,90, 100, 140,  68, 107
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, Áý°íÀüÁø_4
    IF A = 11 THEN
        GOTO Áý°íÀüÁø_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
Áý°íÀüÁø_4:
    SPEED 13
    MOVE G6A,95, 90, 118, 101, 110,99
    MOVE G6D,108,  76, 144,  92,  95,99
    WAIT

    SPEED 11
    MOVE G6A,100,  76, 143,  92, 99, 100
    MOVE G6D,100,  76, 143,  92, 99, 100
    WAIT

<<<<<<< HEAD
    GOTO RX_EXIT
    '*******************
=======
    RETURN
    '*******************
¹®¿­°íÁý°íÀüÁø:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    'GOSUB Àü¹æÇÏÇâ18µµ
    'DELAY 20
    SPEED 6
    GOSUB All_motor_mode3
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT

    DELAY 20
    'HIGHSPEED SETON

    SPEED 10
    MOVE G6D,  90,  74, 144,  94, 109
    MOVE G6A, 108,  76, 146,  93, 96
    WAIT

    SPEED 12
    MOVE G6D,90, 90, 120, 101, 109,99
    MOVE G6A,108,  76, 147,  92,  96,100
    WAIT

    'HIGHSPEED SETOFF
    GOTO ¹®¿­°íÁý°íÀüÁø_2	

¹®¿­°íÁý°íÀüÁø_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

¹®¿­°íÁý°íÀüÁø_3:
    'ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ¹®¿­°íÁý°íÀüÁø_4
    IF A = 11 THEN
        GOTO ¹®¿­°íÁý°íÀüÁø_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
¹®¿­°íÁý°íÀüÁø_4:
    SPEED 13
    MOVE G6A,95, 90, 120, 101, 110,99
    MOVE G6D,108,  76, 146,  92,  95,99
    WAIT

    SPEED 11
    MOVE G6A,100,  76, 145,  92, 99, 100
    MOVE G6D,100,  76, 145,  92, 99, 100
    WAIT

    RETURN
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
È½¼ö_Áý°íÈÄÁø:
    GOSUB All_motor_mode3
    ³Ñ¾îÁøÈ®ÀÎ = 0
    º¸ÇàCOUNT = 0
    SPEED 7
    'HIGHSPEED SETON


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        GOTO È½¼ö_Áý°íÈÄÁø_1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        GOTO È½¼ö_Áý°íÈÄÁø_4
    ENDIF

<<<<<<< HEAD
    '*******************************************

=======

    '**********************
¹®¿­°íÀüÁø´Þ¸®±â50:
    ³Ñ¾îÁøÈ®ÀÎ = 0
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    DELAY 50
    SPEED 6
    HIGHSPEED SETON

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 146,  93, 98
        WAIT

        MOVE G6A,95,  80, 120, 120, 104
        MOVE G6D,104,  77, 147,  91,  102
        MOVE G6B, 185, 10, 80
        MOVE G6C, 190, 10, 80
        WAIT

        GOTO ¹®¿­°íÀüÁø´Þ¸®±â50_2
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  80, 121, 120, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6B, 185, 10, 80
        MOVE G6C, 190, 10, 80
        WAIT

        GOTO ¹®¿­°íÀüÁø´Þ¸®±â50_5
    ENDIF
    '**********************

¹®¿­°íÀüÁø´Þ¸®±â50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  77, 148,  93,  102
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT

¹®¿­°íÀüÁø´Þ¸®±â50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  78, 148,  90,  100
    WAIT

¹®¿­°íÀüÁø´Þ¸®±â50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 161,  68, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ¹®¿­°íÀüÁø´Þ¸®±â50_3_stop

    ERX 4800,A, ¹®¿­°íÀüÁø´Þ¸®±â50_4
    IF A <> A_old THEN
¹®¿­°íÀüÁø´Þ¸®±â50_3_stop:

        MOVE G6D,90,  93, 116, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6B, 185, 10, 80
        MOVE G6C, 190, 10, 80
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        ' GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 13
        ' GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  76, 145,  91, 100, 100
        MOVE G6D,100,  76, 145,  91, 100, 100

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    '*********************************

¹®¿­°íÀüÁø´Þ¸®±â50_4:
    MOVE G6D,95,  95, 101, 120, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6B, 185, 10, 80
    MOVE G6C, 190, 10, 80
    WAIT
¹®¿­°íÀüÁø´Þ¸®±â50_5:
    MOVE G6D,95,  75, 123, 120, 104
    MOVE G6A,104,  78, 147,  90,  100
    WAIT

¹®¿­°íÀüÁø´Þ¸®±â50_6:
    MOVE G6D,103,  69, 146, 103,  100
    MOVE G6A, 95, 87, 160,  68, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF
    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ¹®¿­°íÀüÁø´Þ¸®±â50_6_stop
    ERX 4800,A, ¹®¿­°íÀüÁø´Þ¸®±â50_1
    IF A <> A_old THEN
¹®¿­°íÀüÁø´Þ¸®±â50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 146,  91,  102
        MOVE G6B, 185, 10, 80
        MOVE G6C, 190, 10, 80
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        ' GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 13
        ' GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  76, 145,  91, 100, 100
        MOVE G6D,100,  76, 145,  91, 100, 100
        DELAY 150
        GOTO RX_EXIT
    ENDIF
    GOTO ¹®¿­°íÀüÁø´Þ¸®±â50_1





    '*******************************************

Áý°íÀüÁø´Þ¸®±â50:
    ³Ñ¾îÁøÈ®ÀÎ = 0
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    DELAY 50
    SPEED 6
    HIGHSPEED SETON

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 146,  93, 98
        WAIT

        MOVE G6A,95,  80, 120, 120, 104
        MOVE G6D,104,  77, 147,  91,  102
        MOVE G6B,185,  10,  60
        MOVE G6C,185,  10,  60
        WAIT

        GOTO Áý°íÀüÁø´Þ¸®±â50_2
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  80, 121, 120, 104
        MOVE G6A,104,  77, 146,  91,  102
        MOVE G6B,185,  10,  60
        MOVE G6C,185,  10,  60
        WAIT

        GOTO Áý°íÀüÁø´Þ¸®±â50_5
    ENDIF
    '**********************

Áý°íÀüÁø´Þ¸®±â50_1:
    MOVE G6A,95,  95, 100, 120, 104
    MOVE G6D,104,  77, 148,  93,  102
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT

Áý°íÀüÁø´Þ¸®±â50_2:
    MOVE G6A,95,  75, 122, 120, 104
    MOVE G6D,104,  78, 148,  90,  100
    WAIT

Áý°íÀüÁø´Þ¸®±â50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 161,  68, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO Áý°íÀüÁø´Þ¸®±â50_3_stop

    ERX 4800,A, ¹®¿­°íÀüÁø´Þ¸®±â50_4
    IF A <> A_old THEN
Áý°íÀüÁø´Þ¸®±â50_3_stop:

        MOVE G6D,90,  93, 116, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6B,185,  10,  60
        MOVE G6C,185,  10,  60
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        ' GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        ' GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  76, 145,  91, 100, 100
        MOVE G6D,100,  76, 145,  91, 100, 100

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    '*********************************

Áý°íÀüÁø´Þ¸®±â50_4:
    MOVE G6D,95,  95, 101, 120, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT
Áý°íÀüÁø´Þ¸®±â50_5:
    MOVE G6D,95,  75, 123, 120, 104
    MOVE G6A,104,  78, 147,  90,  100
    WAIT

Áý°íÀüÁø´Þ¸®±â50_6:
    MOVE G6D,103,  69, 146, 103,  100
    MOVE G6A, 95, 87, 160,  68, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF
    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO Áý°íÀüÁø´Þ¸®±â50_6_stop
    ERX 4800,A, Áý°íÀüÁø´Þ¸®±â50_1
    IF A <> A_old THEN
Áý°íÀüÁø´Þ¸®±â50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 146,  91,  102
        MOVE G6B,185,  10,  60
        MOVE G6C,185,  10,  60
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        ' GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        ' GOSUB ±âº»ÀÚ¼¼2
        MOVE G6A,100,  76, 145,  91, 100, 100
        MOVE G6D,100,  76, 145,  91, 100, 100
        DELAY 150
        GOTO RX_EXIT
    ENDIF
    GOTO Áý°íÀüÁø´Þ¸®±â50_1


>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
È½¼ö_Áý°íÈÄÁø_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT



È½¼ö_Áý°íÈÄÁø_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF
    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO È½¼ö_Áý°íÈÄÁø_3_stop
    ERX 4800,A, È½¼ö_Áý°íÈÄÁø_4
    IF A <> A_old THEN
È½¼ö_Áý°íÈÄÁø_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        'SPEED 15
        '        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        '       HIGHSPEED SETOFF
        '      SPEED 5
        '     GOSUB ±âº»ÀÚ¼¼2

        '   DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

È½¼ö_Áý°íÈÄÁø_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT


È½¼ö_Áý°íÈÄÁø_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO È½¼ö_Áý°íÈÄÁø_6_stop

    ERX 4800,A, È½¼ö_Áý°íÈÄÁø_1
    IF A <> A_old THEN  'GOTO È½¼ö_Áý°íÈÄÁø_¸ØÃã
È½¼ö_Áý°íÈÄÁø_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 190, 10, 50
        MOVE G6C, 190, 10, 50
        WAIT

        'SPEED 15
        '        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        '       HIGHSPEED SETOFF
        '      SPEED 5
        '     GOSUB ±âº»ÀÚ¼¼2

        '  DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO È½¼ö_Áý°íÈÄÁø_1


¿ìÀ¯±ï³õ±â_1:
    SPEED 4
    MOVE G6B, 190, 20, 60
    MOVE G6C, 190, 20, 60
    WAIT

    'DELAY 10
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN

¿ìÀ¯±ï³õ±â_2:
    SPEED 4
    MOVE G6B, 150, 20, 60
    MOVE G6C, 150, 20, 60
    WAIT

    'DELAY 10
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN

¿ìÀ¯±ïÀâ±â_1:
    SPEED 4
    MOVE G6B, 190, 10, 50
    MOVE G6C, 190, 10, 50
    WAIT

    'DELAY 10
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN
    'GOTO RX_EXIT

¿ìÀ¯±ïÀâ±â_2:
    SPEED 4
    MOVE G6B, 150, 10, 50
    MOVE G6C, 150, 10, 50
    WAIT

    'DELAY 10
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN
    ' GOTO RX_EXIT

¿ìÀ¯±ïÀâ±â_3:
    SPEED 4
    MOVE G6B, 130, 10, 50
    MOVE G6C, 130, 10, 50
    WAIT

    'DELAY 10
    'GOSUB ±âº»ÀÚ¼¼2
    RETURN
    'GOTO RX_EXIT
    '*****************************************************
¿ìÀ¯±ïÀâ±â¿À¸¥ÂÊµ¹±â1:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¿ìÀ¯±ïÀâ±â¿À¸¥ÂÊµ¹±â1_LOOP:
    '  MOVE G6B, 190, 10, 50
    ' MOVE G6C, 190, 10, 50  ,   ,
    WAIT
    DELAY 3
    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
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
        º¸Çà¼ø¼­ = 0
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
    'GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOTO RX_EXIT
    '*************************************************

¿ìÀ¯±ïÀâ±â¿ÞÂÊµ¹±â1:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

¿ìÀ¯±ïÀâ±â¿ÞÂÊµ¹±â1_LOOP:
    '   MOVE G6B, 190, 10, 50
    '  MOVE G6C, 190, 10, 50
    WAIT
    DELAY 3

    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
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
        º¸Çà¼ø¼­ = 0
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
    '    GOSUB ±âº»ÀÚ¼¼2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOTO RX_EXIT


¿ìÀ¯±ïÀâ±â°È±â_1:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    'GOSUB Àü¹æÇÏÇâ18µµ
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
    GOTO ¿ìÀ¯±ïÀâ±â°È±â_1_2	

¿ìÀ¯±ïÀâ±â°È±â_1_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

¿ìÀ¯±ïÀâ±â°È±â_1_3:
    'ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ¿ìÀ¯±ïÀâ±â°È±â_1_4
    IF A = 11 THEN
        GOTO ¿ìÀ¯±ïÀâ±â°È±â_1_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
¿ìÀ¯±ïÀâ±â°È±â_1_4:
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
¿ìÀ¯±ïÀâ±â°È±â_2:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    'GOSUB Àü¹æÇÏÇâ18µµ
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
    GOTO ¿ìÀ¯±ïÀâ±â°È±â_2_2	

¿ìÀ¯±ïÀâ±â°È±â_2_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

¿ìÀ¯±ïÀâ±â°È±â_2_3:
    'ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ¿ìÀ¯±ïÀâ±â°È±â_2_4
    IF A = 11 THEN
        GOTO ¿ìÀ¯±ïÀâ±â°È±â_2_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
¿ìÀ¯±ïÀâ±â°È±â_2_4:
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
¿ìÀ¯±ïÀâ±â°È±â_3:
    º¸Çà¼Óµµ = 8
    ÁÂ¿ì¼Óµµ = 4
    ³Ñ¾îÁøÈ®ÀÎ = 0

    'GOSUB Àü¹æÇÏÇâ18µµ
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
    GOTO ¿ìÀ¯±ïÀâ±â°È±â_3_2	

¿ìÀ¯±ïÀâ±â°È±â_3_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 101, 106,99
    WAIT

¿ìÀ¯±ïÀâ±â°È±â_3_3:
    'ETX 4800,13 'ÁøÇàÄÚµå¸¦ º¸³¿

    SPEED º¸Çà¼Óµµ

    MOVE G6D, 90,  56, 145, 114, 109
    MOVE G6A,108,  76, 147,  89,  95
    WAIT

    SPEED ÁÂ¿ì¼Óµµ
    MOVE G6D,108,  76, 147, 89,  97
    MOVE G6A,90, 100, 142,  68, 107
    WAIT

    SPEED º¸Çà¼Óµµ

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, ¿ìÀ¯±ïÀâ±â°È±â_3_4
    IF A = 11 THEN
        GOTO ¿ìÀ¯±ïÀâ±â°È±â_3_4
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
        ' 		GOSUB ±âº»ÀÚ¼¼2

        ' 		GOTO RX_EXIT
    ENDIF
¿ìÀ¯±ïÀâ±â°È±â_3_4:
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
°è´Ü¿Þ¹ß¿À¸£±â1cm:
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

°è´Ü¿À¸¥¹ß¿À¸£±â1cm:
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
<<<<<<< HEAD
<<<<<<< HEAD

    '******************************************
°è´Ü¿À¸¥¹ß³»¸®±â1cm:
    
    GOSUB All_motor_mode3

    '¿À¸¥¹ß ¿ÏÀü Áý¾î³Ö±â ''''
    SPEED 5
    MOVE G6A, 100, 110,  112, 92,  101, 100
    MOVE G6D,  100,  112, 112, 92, 101, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß¸ñ ¿ÞÂÊÀ¸·Î
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  85,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '¿À¸¥¹ß °ÅÀÇ¹ß¸ñ±îÁö   Áý¾î³Ö±â
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '¿À¸¥¹ß °ÅÀÇ  Áý¾î³Ö±â
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  105, 63, 119, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß Áý¾î³Ö±â
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  15, 139, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹«¸­¼öÁ÷ ÃÖÁ¾µé±â
    SPEED 2
    MOVE G6A, 112, 110,  112, 77,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹«¸­ ¸¹ÀÌµé±â
    SPEED 1
    MOVE G6A, 112, 125,  102, 65,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT	

    '¿Þ¹«¸­ µé±â
    SPEED 5
    MOVE G6A, 108, 140,  92, 82,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '½ÃÇè ¿À¸¥¹ß·Î ÁöÅÊÇÏ°í ³»·Á°¡´Â µ¿ÀÛ
    SPEED 5
    MOVE G6A, 105, 140,  92, 102,  81, 100
    MOVE G6D,  95,  15, 169, 149, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß , ¿À¸¥¹ß ¼¼¿ì±â
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  81, 100
    MOVE G6D,  95,  35, 149, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß °ÅÀÇ ¼öÁ÷À¸·Î ¼¼¿ì±â ';';'
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  96, 100
    MOVE G6D,  100,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¹ß¸ñ ¿ÞÂÊÀ¸·Î ±â¿ïÀÌ±â
    SPEED 5
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  105,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¹«¸­°ú »óÃ¼ ¼÷ÀÌ±â
    SPEED 3
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  110,  45, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¹«¸­ ¾à°£ ¿Ã¸®±â
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  110,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¹«¸­ ¾à°£ ¿Ã¸®±â (¿À¸¥¹ß ¹ß¸ñ Áß½É Àâ±â)
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¾ÕÀ¸·Î °®°í¿À±â
    SPEED 3
    MOVE G6A, 97, 105,  103, 132,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¾ÕÀ¸·Î °®°í¿À±â 2
    SPEED 3
    MOVE G6A, 97, 110,  97, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ¾ÕÀ¸·Î °®°í¿À±â 3
    SPEED 3
    MOVE G6A, 97, 110,  107, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ³»¸®±â1
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ³»¸®±â2
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  107,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß ³»¸®±â3
    SPEED 3
    MOVE G6A, 97, 55,  149, 136,  96, 100
    MOVE G6D,  107,  55, 149, 139, 104, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB ±âº»ÀÚ¼¼''°Ë¼ö ´ë»ó

    ETX 4800, 254

    RETURN
    '******************************************
°è´Ü¿Þ¹ß³»¸®±â1cm:
    
	GOSUB All_motor_mode3

    '¿Þ¹ß ¿ÏÀü Áý¾î³Ö±â ''''
    SPEED 5
    MOVE G6D, 100, 110,  112, 92,  101, 100
    MOVE G6A,  100,  112, 112, 92, 101, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß¸ñ ¿ÞÂÊÀ¸·Î
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  85,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    '¿Þ¹ß °ÅÀÇ¹ß¸ñ±îÁö   Áý¾î³Ö±â
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    '¿Þ¹ß °ÅÀÇ  Áý¾î³Ö±â
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  105, 63, 119, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß Áý¾î³Ö±â
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  15, 139, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹«¸­¼öÁ÷ ÃÖÁ¾µé±â
    SPEED 2
    MOVE G6D, 112, 110,  112, 77,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹«¸­ ¸¹ÀÌµé±â
    SPEED 1
    MOVE G6D, 112, 125,  102, 65,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT	

    '¿À¸¥¹«¸­ µé±â
    SPEED 5
    MOVE G6D, 108, 140,  92, 82,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '½ÃÇè ¿Þ¹ß·Î ÁöÅÊÇÏ°í ³»·Á°¡´Â µ¿ÀÛ
    SPEED 5
    MOVE G6D, 105, 140,  92, 102,  81, 100
    MOVE G6A,  95,  15, 169, 149, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿À¸¥¹ß , ¿Þ¹ß ¼¼¿ì±â
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  81, 100
    MOVE G6A,  95,  35, 149, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß °ÅÀÇ ¼öÁ÷À¸·Î ¼¼¿ì±â ';';'
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  96, 100
    MOVE G6A,  100,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¹ß¸ñ ¿ÞÂÊÀ¸·Î ±â¿ïÀÌ±â
    SPEED 5
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  105,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¹«¸­°ú »óÃ¼ ¼÷ÀÌ±â
    SPEED 3
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  110,  45, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¹«¸­ ¾à°£ ¿Ã¸®±â
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  110,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¹«¸­ ¾à°£ ¿Ã¸®±â (¿Þ¹ß ¹ß¸ñ Áß½É Àâ±â)
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¾ÕÀ¸·Î °®°í¿À±â
    SPEED 3
    MOVE G6D, 97, 105,  103, 132,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¾ÕÀ¸·Î °®°í¿À±â 2
    SPEED 3
    MOVE G6D, 97, 110,  97, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ¾ÕÀ¸·Î °®°í¿À±â 3
    SPEED 3
    MOVE G6D, 97, 110,  107, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ³»¸®±â1
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ³»¸®±â2
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  107,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '¿Þ¹ß ³»¸®±â3
    SPEED 3
    MOVE G6D, 97, 55,  149, 136,  96, 100
    MOVE G6A,  107,  55, 149, 139, 104, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB ±âº»ÀÚ¼¼''°Ë¼ö ´ë»ó

    ETX 4800, 254

    RETURN

    '******************************************

»þ»è»þ»è:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 13
    'HIGHSPEED·Î ¾È ÇÏ¸é µÚ·Î °¨... ¹ÌÄ£³ðÀÎ µí
    'HIGHSPEED SETON
    '..... ÀÌ°Å ÇÏ¸é ´ÙÀ½ ¸ð¼Çµé±îÁö ´Ù °³»¡¶óÁö´Âµ¥ º¹±Í¸¦ ¾î¶»°Ô ÇÏ´ÂÁö ¸ð¸£°ÚÀ½


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »þ»è»þ»è1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »þ»è»þ»è4
    ENDIF


    '**********************

»þ»è»þ»è1: '¿Þ¹ß
    'HIGHSPEED SETON
    MOVE G6D,104,  77, 147, 93, 100
    MOVE G6A,95,  95, 143,  94,  102
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT
»þ»è»þ»è2:

    MOVE G6A,99,    75, 146, 97,  98
    MOVE G6D, 95,  77, 147,  90, 100
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    'IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_2_stop

    ERX 4800,A, »þ»è»þ»è4
    IF A <> A_old THEN
»þ»è»þ»è_2_stop:
        MOVE G6D,95,  87, 143, 97, 102
        MOVE G6A,104,  76, 145,  92,  100
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

»þ»è»þ»è4: '¿À¸¥¹ß
    MOVE G6A,104,  77, 147, 93, 100
    MOVE G6D,95,  95, 143,  94,  102
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

»þ»è»þ»è5:
    MOVE G6D,99,    75, 146, 97,  98
    MOVE G6A, 95,  77, 147,  93, 100
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    ' IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_5_stop

    ERX 4800,A, »þ»è»þ»è1
    IF A <> A_old THEN
»þ»è»þ»è5_stop:
        MOVE G6A,95,  87, 143, 97, 102
        MOVE G6D,104,  76, 145,  92,  100
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
		GOTO »þ»è»þ»è1
    '******************************************

È½¼ö_»þ»è»þ»è:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 13
    'HIGHSPEED·Î ¾È ÇÏ¸é µÚ·Î °¨... ¹ÌÄ£³ðÀÎ µí
    'HIGHSPEED SETON
    '..... ÀÌ°Å ÇÏ¸é ´ÙÀ½ ¸ð¼Çµé±îÁö ´Ù °³»¡¶óÁö´Âµ¥ º¹±Í¸¦ ¾î¶»°Ô ÇÏ´ÂÁö ¸ð¸£°ÚÀ½


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »þ»è»þ»è1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »þ»è»þ»è4
    ENDIF


    '**********************

È½¼ö_»þ»è»þ»è1: '¿Þ¹ß
    'HIGHSPEED SETON
    MOVE G6D,104,  77, 147, 93, 100
    MOVE G6A,95,  95, 143,  94,  102
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT
È½¼ö_»þ»è»þ»è2:

    MOVE G6A,99,    75, 146, 97,  98
    MOVE G6D, 95,  77, 147,  90, 100
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO È½¼ö_»þ»è»þ»è_2_stop

    ERX 4800,A, È½¼ö_»þ»è»þ»è4
    IF A <> A_old THEN
È½¼ö_»þ»è»þ»è_2_stop:
        MOVE G6D,104,  77, 147, 93, 100
        MOVE G6A,95,  95, 143,  94,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

È½¼ö_»þ»è»þ»è4: '¿À¸¥¹ß
    MOVE G6A,104,  77, 147, 93, 100
    MOVE G6D,95,  95, 143,  94,  102
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

È½¼ö_»þ»è»þ»è5:
    MOVE G6D,99,    75, 146, 97,  98
    MOVE G6A, 95,  77, 147,  93, 100
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO È½¼ö_»þ»è»þ»è5_stop

    ERX 4800,A, È½¼ö_»þ»è»þ»è1
    IF A <> A_old THEN
È½¼ö_»þ»è»þ»è5_stop:
        MOVE G6A,104,  77, 147, 93, 100
        MOVE G6D,95,  95, 143,  94,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
		GOTO »þ»è»þ»è1


=======
    
    '******************************************    
=======

    '******************************************
>>>>>>> 5f3e757 (Chore: ìƒ¤ì‚­ìƒ¤ì‚­ ëª¨ì…˜ ìˆ˜ì •)

°è´Ü¿À¸¥¹ß³»¸®±â1cm:
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
°è´Ü¿Þ¹ß³»¸®±â1cm:
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


    '******************************************

»þ»è»þ»è:
    GOSUB All_motor_mode3
    º¸ÇàCOUNT = 0
    SPEED 7
    'HIGHSPEED SETON..... ÀÌ°Å ÇÏ¸é ´ÙÀ½ ¸ð¼Çµé±îÁö ´Ù °³»¡¶óÁö´Âµ¥ º¹±Í¸¦ ¾î¶»°Ô ÇÏ´ÂÁö ¸ð¸£°ÚÀ½


    IF º¸Çà¼ø¼­ = 0 THEN
        º¸Çà¼ø¼­ = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »þ»è»þ»è1
    ELSE
        º¸Çà¼ø¼­ = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO »þ»è»þ»è2
    ENDIF


    '**********************

»þ»è»þ»è1: '¿Þ¹ß
    'HIGHSPEED SETON
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6B, 100
    MOVE G6C, 100
    WAIT
»þ»è»þ»è2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0

        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    'IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_2_stop

    ERX 4800,A, »þ»è»þ»è4
    IF A <> A_old THEN
»þ»è»þ»è2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

»þ»è»þ»è4: '¿À¸¥¹ß
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6C, 100
    MOVE G6B, 100
    WAIT

»þ»è»þ»è5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    IF ³Ñ¾îÁøÈ®ÀÎ = 1 THEN
        ³Ñ¾îÁøÈ®ÀÎ = 0
        GOTO RX_EXIT
    ENDIF

    ' º¸ÇàCOUNT = º¸ÇàCOUNT + 1
    ' IF º¸ÇàCOUNT > º¸ÇàÈ½¼ö THEN  GOTO ÀüÁøÁ¾Á¾°ÉÀ½_5_stop

    ERX 4800,A, »þ»è»þ»è1
    IF A <> A_old THEN
»þ»è»þ»è5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ¾ÈÁ¤È­ÀÚ¼¼
        SPEED 5
        GOSUB ±âº»ÀÚ¼¼2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '******************************************
<<<<<<< HEAD
    
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
=======

>>>>>>> 5f3e757 (Chore: ìƒ¤ì‚­ìƒ¤ì‚­ ëª¨ì…˜ ìˆ˜ì •)
    '******************************************


MAIN: '¶óº§¼³Á¤

    ETX 4800, 200 ' µ¿ÀÛ ¸ØÃã È®ÀÎ ¼Û½Å °ª

MAIN_2:

    GOSUB ¾ÕµÚ±â¿ï±âÃøÁ¤
    GOSUB ÁÂ¿ì±â¿ï±âÃøÁ¤
    GOSUB Àû¿Ü¼±°Å¸®¼¾¼­È®ÀÎ


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** ÀÔ·ÂµÈ A°ªÀÌ 0 ÀÌ¸é MAIN ¶óº§·Î °¡°í
    '**** 1ÀÌ¸é 	 ¶óº§, 2ÀÌ¸é key2·Î... °¡´Â¹®
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
        GOSUB ±âº»ÀÚ¼¼

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN ¶óº§·Î °¡±â
    '*******************************************

KEY1:
    ETX  4800,1

    ' º¸ÇàÈ½¼ö = 2
    GOSUB ¿ÞÂÊÅÏ10
    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

<<<<<<< HEAD
    º¸ÇàÈ½¼ö = 1
=======
    º¸ÇàÈ½¼ö = 6
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    GOTO È½¼ö_ÀüÁøÁ¾Á¾°ÉÀ½

    GOTO RX_EXIT
    '***************

KEY3:
    ETX 4800, 3
    ' GOTO ¿ÞÂÊ¿·À¸·Î20
    GOSUB ¿À¸¥ÂÊÅÏ10
    GOTO RX_EXIT
KEY4:
    ETX 4800, 4
    GOSUB ¿ÞÂÊ¿·À¸·Î20
<<<<<<< HEAD
=======
    '  GOTO ¹®¿­±â¿ÞÂÊ3
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    'J = AD(Àû¿Ü¼±ADÆ÷Æ®)	'Àû¿Ü¼±°Å¸®°ª ÀÐ±â
    'ETX 4800, J
    'BUTTON_NO = J
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    'GOSUB GOSUB_RX_EXIT
    GOSUB ¸Ó¸®ÁÂ¿ìÁß¾Ó

    GOTO RX_EXIT
    '***************
KEY6:
    ETX 4800, 6
    GOSUB ¿À¸¥ÂÊ¿·À¸·Î20
    GOTO RX_EXIT
KEY7:
    ETX 4800, 7
    GOSUB ¿ÞÂÊÅÏ45
    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB ¿¬¼ÓÈÄÁø
    GOTO RX_EXIT
    '***************
KEY9:
    ETX 4800, 9
    GOSUB ¿À¸¥ÂÊÅÏ45
    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX 4800, 10
    GOSUB ±âº»ÀÚ¼¼
    GOTO RX_EXIT
    '***************
KEY11: ' ¡ã
    ETX  4800,11

    GOTO Áý°íÀüÁø
    GOTO RX_EXIT

    '***************
KEY12: ' ¡å
    ETX  4800,12

    GOSUB ¹°°Ç³õ±â
    GOTO RX_EXIT
    '***************
KEY13: '¢º
    ETX  4800,13
    'GOSUB Àü¹æÇÏÇâ90µµ
    GOSUB ¿ìÀ¯±ïÀâ±â¿À¸¥ÂÊµ¹±â1

    GOTO RX_EXIT
    '**************
KEY14: ' ¢¸
    ETX  4800,14
    GOSUB ¿ìÀ¯±ïÀâ±â¿ÞÂÊµ¹±â1
    GOTO RX_EXIT


    GOTO RX_EXIT
    '***************
KEY15: 'A
    ETX 4800, 15
    GOSUB ¸Ó¸®¿ÞÂÊ30µµ
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
    GOSUB ¾ÉÀºÀÚ¼¼	
    GOSUB Á¾·áÀ½

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ¸ðÅÍONOFF = 1  THEN
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


    IF  A = 16 THEN 	'´Ù½Ã ÆÄ¿ö¹öÆ°À» ´­·¯¾ß¸¸ º¹±Í
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB ±âº»ÀÚ¼¼2
        GOSUB ÀÚÀÌ·ÎON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX 4800, 17
    GOSUB ¸Ó¸®¿ÞÂÊ60µµ
    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX 4800, 18
    GOSUB ¿ìÀ¯±ïÀâ±â¿ÞÂÊ¿·À¸·Î
    GOTO RX_EXIT
    '***************
KEY19: 'P2
    ETX 4800, 19
    GOSUB  °è´Ü¿À¸¥¹ß³»¸®±â1cm
    GOTO RX_EXIT
    '***************
KEY20: 'B
    ETX 4800, 20
    GOSUB ¸Ó¸®¿À¸¥ÂÊ30µµ
    GOTO RX_EXIT
    '***************
KEY21: ' ¡â
    ETX  4800,21
    GOSUB Àü¹æÇÏÇâ70µµ

    GOTO RX_EXIT
    '***************
KEY22: ' *
    ETX 4800, 22
    '  GOTO ¿À¸¥ÂÊÅÏ3
    'GOTO ¿À¸¥ÂÊÅÏ20
    ' GOTO Áý°í¿À¸¥ÂÊÅÏ45
    GOTO °è´Ü¿Þ¹ß¿À¸£±â1cm
    GOTO RX_EXIT
    '***************
KEY23: 'G
    ETX 4800, 23
    GOSUB ¿ìÀ¯±ïÀâ±â¿À¸¥ÂÊ¿·À¸·Î
    GOTO RX_EXIT
    '***************
KEY24: '#
    ETX 4800, 24
    GOSUB °è´Ü¿À¸¥¹ß¿À¸£±â1cm
    GOTO RX_EXIT
    '***************
KEY25: 'P1
    ETX 4800, 25
    ' GOTO Áý°í¿ÞÂÊÅÏ45
    ' GOTO ¿ÞÂÊÅÏ3
    'GOTO ¿ÞÂÊÅÏ20
    GOSUB °è´Ü¿Þ¹ß³»¸®±â1cm
    GOTO RX_EXIT
    '***************
KEY26: ' ¡á
    ETX  4800,26

<<<<<<< HEAD
    'SPEED 5
    º¸ÇàÈ½¼ö = 1
    GOSUB È½¼ö_»þ»è»þ»è
    'GOSUB ¹°°ÇÁý±â
=======
    SPEED 5
<<<<<<< HEAD
    GOSUB ¹°°ÇÁý±â
>>>>>>> 601e172 (Add: Motion file ì¶”ê°€)
=======
    GOSUB »þ»è»þ»è
    'GOSUB ¹°°ÇÁý±â
>>>>>>> 5f3e757 (Chore: ìƒ¤ì‚­ìƒ¤ì‚­ ëª¨ì…˜ ìˆ˜ì •)
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX 4800, 27
    GOTO ¸Ó¸®¿À¸¥ÂÊ60µµ
    GOTO RX_EXIT
    '***************
KEY28: ' ¢·
    ETX 4800, 28
    GOSUB Àü¹æÇÏÇâ45µµ
    GOTO RX_EXIT
    '***************
KEY29: ' ¡à
    ETX 4800, 29
    GOSUB Àü¹æÇÏÇâ110µµ
    GOTO RX_EXIT
    '***************
KEY30: ' ¢¹
    ETX 4800, 30
    GOSUB Àü¹æÇÏÇâ30µµ
    GOTO RX_EXIT
    '***************
KEY31: ' ¡ä
    ETX 4800, 31
    GOSUB Àü¹æÇÏÇâ10µµ
    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX 4800, 32
    GOSUB ¾çÆÈ¹ú¸®±â
    GOTO RX_EXIT
    '***************
