'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

'-*- coding: utf-8 -*-'

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER

DIM ����� AS BYTE

DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms

CONST ���ܼ�AD��Ʈ  = 4


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************



PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
'MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON



PRINT "VOLUME 200 !"
'PRINT "SOUND 12 !" '�ȳ��ϼ���

GOSUB All_motor_mode3





GOTO MAIN	'�ø��� ���� ��ƾ���� ����

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
������:
    TEMPO 220
    'MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    'MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '��ġ���ǵ��
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

�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90

    WAIT
    mode = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
�⺻�ڼ�:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
�⺻�ڼ�2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN
    '******************************************	
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
�����ڼ�:
    GOSUB ���̷�OFF
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
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '******************ZERO G6A,100, 101, 102, 106, 100, 100
    ZERO G6B,102, 101, 100, 100, 100, 100
    ZERO G6C, 97, 100,  96, 100, 100, 100
    ZERO G6D,100, 103, 103, 104, 103, 100
    '*****************************
���̷�ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
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

�Ӹ��¿��߾�:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100
    GOTO MAIN
    '*****************************************


���ε������:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ���ε������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ���ε������_4
    ENDIF


    '**********************

���ε������_1: '�޹�
    'HIGHSPEED SETON
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,106,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


���ε������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ���ε������_4
    IF A <> A_old THEN
���ε������_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF

    '*********************************

���ε������_4: '������
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,102,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


���ε������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ERX 4800,A, ���ε������_1
    IF A <> A_old THEN
���ε������_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        'HIGHSPEED SETOFF
        GOTO RX_EXIT
    ENDIF
    '*************************************

    GOTO ���ε������_1

    '******************************************
�����޸���50:
    �Ѿ���Ȯ�� = 0
    GOSUB All_motor_mode3
    ����COUNT = 0
    DELAY 50
    SPEED 6
    HIGHSPEED SETON



    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 146,  93, 98
        WAIT

        MOVE G6A,95,  82, 120, 120, 104
        MOVE G6D,104,  79, 147,  91,  102
        MOVE G6B, 80
        MOVE G6C,120
        WAIT


        GOTO �����޸���50_2
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 146,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        WAIT

        MOVE G6D,95,  82, 121, 120, 104
        MOVE G6A,104,  79, 146,  91,  102
        MOVE G6C, 80
        MOVE G6B,120
        WAIT


        GOTO �����޸���50_5
    ENDIF


    '**********************

�����޸���50_1:
    MOVE G6A,95,  97, 100, 120, 104
    MOVE G6D,104,  79, 148,  93,  102
    MOVE G6B, 80
    MOVE G6C,120
    WAIT


�����޸���50_2:
    MOVE G6A,95,  77, 122, 120, 104
    MOVE G6D,104,  80, 148,  90,  100
    WAIT

�����޸���50_3:
    MOVE G6A,103,  69, 145, 103,  100
    MOVE G6D, 95, 87, 161,  68, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_3_stop

    ERX 4800,A, �����޸���50_4
    IF A <> A_old THEN
�����޸���50_3_stop:

        MOVE G6D,90,  93, 116, 100, 104
        MOVE G6A,104,  74, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    '*********************************

�����޸���50_4:
    MOVE G6D,95,  97, 101, 120, 104
    MOVE G6A,104,  79, 147,  93,  102
    MOVE G6C, 80
    MOVE G6B,120
    WAIT


�����޸���50_5:
    MOVE G6D,95,  77, 123, 120, 104
    MOVE G6A,104,  80, 147,  90,  100
    WAIT


�����޸���50_6:
    MOVE G6D,103,  71, 146, 103,  100
    MOVE G6A, 95, 89, 160,  68, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF
    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO �����޸���50_6_stop
    ERX 4800,A, �����޸���50_1
    IF A <> A_old THEN
�����޸���50_6_stop:

        MOVE G6A,90,  93, 115, 100, 104
        MOVE G6D,104,  74, 146,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        DELAY 150
        GOTO RX_EXIT
    ENDIF
    GOTO �����޸���50_1


��������:
    ����COUNT = 0
    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO ��������_1	
    ELSE
        ������� = 0

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


        GOTO ��������_2	

    ENDIF


    '*******************************



��������_1:

    ETX 4800,11 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 149,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 147,  69, 110
    WAIT


    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_2
    IF A = 11 THEN
        GOTO ��������_2
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF
    '**********

��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 122, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

��������_3:
    ETX 4800,11 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 147, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 149, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_4
    IF A = 11 THEN
        GOTO ��������_4
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF

��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 148,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO ��������_1
    '*******************************
    '*******************************


    '************************************************
�Ѱ����ȱ�:
    ����ӵ� = 12
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0
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
    GOTO �Ѱ����ȱ�_2	

�Ѱ����ȱ�_2:
    MOVE G6A,110,  76, 147,  93, 100,100
    MOVE G6D,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

�Ѱ����ȱ�_3:
    ETX 4800,13 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6D, 90,  56, 145, 115, 112
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,108,  76, 147, 93,  98
    MOVE G6A,90, 100, 145,  69, 108
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, �Ѱ����ȱ�_4
    IF A = 11 THEN
        GOTO �Ѱ����ȱ�_4
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
        ' 		GOSUB �⺻�ڼ�2

        ' 		GOTO RX_EXIT
    ENDIF
�Ѱ����ȱ�_4:
    SPEED 13
    MOVE G6A,95, 90, 120, 105, 111,100
    MOVE G6D,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    ' SPEED 10
    '  GOSUB �⺻�ڼ�2
    ' GOTO �Ѱ����ȱ�

    SPEED 10
    GOSUB �⺻�ڼ�2
    RETURN

    '*******************************************************************************************************************************
�Ѱ����ȱ�2:
    ����ӵ� = 8
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0
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
    GOTO �Ѱ����ȱ�2_2	

�Ѱ����ȱ�2_2:
    MOVE G6D,110,  76, 147,  93, 100,100
    MOVE G6A,96, 90, 120, 102, 107,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

�Ѱ����ȱ�2_3:
    ETX 4800,13 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6A, 90,  56, 145, 115, 112
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6A,108,  76, 147, 93,  98
    MOVE G6D,90, 100, 145,  69, 108
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    ERX 4800,A, �Ѱ����ȱ�2_4
    IF A = 11 THEN
        GOTO �Ѱ����ȱ�2_4
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
        ' 		GOSUB �⺻�ڼ�2

        ' 		GOTO RX_EXIT
    ENDIF
�Ѱ����ȱ�2_4:
    SPEED 9
    MOVE G6D,95, 90, 120, 105, 111,100
    MOVE G6A,108,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    SPEED 6
    'GOSUB �⺻�ڼ�2
    RETURN
    '*******************************************************
����Ƚ��_������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    MOVE G6B,185,  10,  60
    MOVE G6C,185,  10,  60
    WAIT

    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 98
        MOVE G6D,101,  76, 146,  93, 95
        WAIT

        GOTO ����Ƚ��_������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 146,  93, 98
        MOVE G6A,101,  76, 147,  93, 95
        WAIT

        GOTO ����Ƚ��_������������_4
    ENDIF


    '**********************

����Ƚ��_������������_1:
    MOVE G6A,95,  90, 125, 100, 101
    MOVE G6D,104,  77, 146,  93,  99
    WAIT


����Ƚ��_������������_2:

    MOVE G6A,103,   73, 140, 103,  97
    MOVE G6D, 95,  85, 146,  85, 99
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ����Ƚ��_������������_2_stop

    ERX 4800,A, ����Ƚ��_������������_4
    IF A <> A_old THEN
����Ƚ��_������������_2_stop:
        MOVE G6D,95,  90, 124, 95, 101
        MOVE G6A,104,  76, 145,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        'GOSUB ����ȭ�ڼ�
        '  SPEED 5
        ' GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

����Ƚ��_������������_4:
    MOVE G6D,95,  95, 119, 100, 101
    MOVE G6A,104,  77, 147,  93,  99
    WAIT


����Ƚ��_������������_5:
    MOVE G6D,103,    73, 139, 103,  97
    MOVE G6A, 95,  85, 147,  85, 99
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO ����Ƚ��_������������_5_stop

    ERX 4800,A, ����Ƚ��_������������_1
    IF A <> A_old THEN
����Ƚ��_������������_5_stop:
        MOVE G6A,95,  90, 125, 95, 101
        MOVE G6D,104,  76, 144,  91,  99
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        MOVE G6A,98,  76, 145,  93, 101, 97
        MOVE G6D,98,  76, 145,  93, 101, 97
        ' GOSUB ����ȭ�ڼ�
        ' SPEED 5
        '  GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO ����Ƚ��_������������_1

    '-----------------------------------------------------------------

��������:
    �Ѿ���Ȯ�� = 0
    ����ӵ� = 12
    �¿�ӵ� = 4
    GOSUB Leg_motor_mode3



    IF ������� = 0 THEN
        ������� = 1

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

        GOTO ��������_1	
    ELSE
        ������� = 0

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


        GOTO ��������_2

    ENDIF


��������_1:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ��������_2
    IF A <> A_old THEN
��������_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�2
        GOTO RX_EXIT
    ENDIF
    '**********

��������_2:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, ��������_1
    IF A <> A_old THEN
��������_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�2
        GOTO RX_EXIT
    ENDIF  	

    GOTO ��������_1
    '**********************************************

    '******************************************
Ƚ��_������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������_4
    ENDIF


    '**********************

Ƚ��_������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


Ƚ��_������������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_2_stop

    ERX 4800,A, Ƚ��_������������_4
    IF A <> A_old THEN
Ƚ��_������������_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

Ƚ��_������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


Ƚ��_������������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_5_stop

    ERX 4800,A, Ƚ��_������������_1
    IF A <> A_old THEN
Ƚ��_������������_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*************************************

    '*********************************

    GOTO Ƚ��_������������_1

    '******************************************

    '******************************************
������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_4
    ENDIF


    '**********************

������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


������������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_2_stop

    ERX 4800,A, ������������_4
    IF A <> A_old THEN
������������_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


������������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    ' IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_5_stop

    ERX 4800,A, ������������_1
    IF A <> A_old THEN
������������_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

�ȱ�:


    '*************************************

    '*********************************

    GOTO ������������_1

    '************************************************
�����ʿ�����20: '****
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
    'GOSUB �⺻�ڼ�2
    MOVE G6A,100,  78, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************
    '*************

���ʿ�����20: '****
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
    'GOSUB �⺻�ڼ�2
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  78, 145,  93, 100, 100
    GOSUB All_motor_mode3
    GOTO RX_EXIT

    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
�ڷ��Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

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
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN


    '**********************************************
�������Ͼ��:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

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
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************

    '******************************************

�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  4800,16
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  4800,15
        GOSUB �������Ͼ��
    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
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
Number_Play: '  BUTTON_NO = ���ڴ���


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
���ܼ��Ÿ�����Ȯ��:

    ���ܼ��Ÿ��� = AD(���ܼ�AD��Ʈ)

    IF ���ܼ��Ÿ��� > 50 THEN '50 = ���ܼ��Ÿ��� = 25cm
        'MUSIC "C"
        DELAY 200
    ENDIF




    RETURN

    '******************************************

    '******************************************
��ܿ޹߿�����3cm:
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
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT
    '****************************************

��ܿ����߿�����3cm:
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
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT
<<<<<<< HEAD
<<<<<<< HEAD
    '************************************************
=======
'************************************************
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
    '************************************************
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
��ܿ޹߿�����1cm:
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

��ܿ����߿�����1cm:
    GOSUB All_motor_mode3
<<<<<<< HEAD
=======
    GOSUB All_motor_mode3
>>>>>>> f684033 (Add: 계단 파일 추가)

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
��ܿ޹߳�����3cm:
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
    ' �޹� ��¦ ���
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	
	' �޹� ��¦ ���
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======

    ' �޹� ��¦ ���
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  76, 145,  93,  94
    WAIT

    ' ������� �ö󰡱� ������ �Ȱ���

<<<<<<< HEAD
    ' ������� �ö󰡱� ������ �Ȱ���

    GOSUB Leg_motor_mode2

    '�޹� ���� ���
<<<<<<< HEAD
=======
    GOSUB Leg_motor_mode2

<<<<<<< HEAD

>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'�޹� ���� ���
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '�޹� �� �������� ������ + �������� ������ + ��� �ڷ� �ϱ�
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'�޹� �� �������� ������ + �������� ������ + ��� �ڷ� �ϱ�
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '�޹� �� �������� ������ + �������� ������ + ��� �ڷ� �ϱ�
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '�޹��� ��ġ�� + �������� �� ������ + ������ ������ �ϱ�
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'�޹��� ��ġ�� + �������� �� ������ + ������ ������ �ϱ�
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '�޹��� ��ġ�� + �������� �� ������ + ������ ������ �ϱ�
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
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
    '�޹��� ���� �� ��ġ�鼭 ���� ������ + �������� ���� ��� + ���� ������ ������ �ڷ�
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	
	'�޹��� ���� �� ��ġ�鼭 ���� ������ + �������� ���� ��� + ���� ������ ������ �ڷ�
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======

    '�޹��� ���� �� ��ġ�鼭 ���� ������ + �������� ���� ��� + ���� ������ ������ �ڷ�
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD

    '�޹��� Ȯ ��� + ������ �ڷ� �ϸ鼭 ���� + �� �յ� ���� �� ũ��
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======

<<<<<<< HEAD
	'�޹��� Ȯ ��� + ������ �ڷ� �ϸ鼭 ���� + �� �յ� ���� �� ũ��
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '�޹��� Ȯ ��� + ������ �ڷ� �ϸ鼭 ���� + �� �յ� ���� �� ũ��
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '�޴ٸ� ������ �α� + �����ٸ� �����鼭 ������ ��������
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'�޴ٸ� ������ �α� + �����ٸ� �����鼭 ������ ��������
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '�޴ٸ� ������ �α� + �����ٸ� �����鼭 ������ ��������
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '�޹� �����ϱ� + �������� ��鼭 ������ ���������
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'�޹� �����ϱ� + �������� ��鼭 ������ ���������
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '�޹� �����ϱ� + �������� ��鼭 ������ ���������
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '������ ���� ������
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'������ ���� ������
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '������ ���� ������
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
    '�⺻�ڼ�
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
	'�⺻�ڼ�
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
=======
    '�⺻�ڼ�
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT
    '************************************************
��ܿ����߳�����3cm:
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
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT

    '******************************************
��ܿ����߳�����1cm:

    GOSUB All_motor_mode3

    '������ ���� ����ֱ� ''''
    SPEED 5
    MOVE G6A, 100, 110,  112, 92,  101, 100
    MOVE G6D,  100,  112, 112, 92, 101, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹߸� ��������
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  85,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '������ ���ǹ߸����   ����ֱ�
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  110, 112, 92, 108, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT 	

    '������ ����  ����ֱ�
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  105, 63, 119, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ����ֱ�
    SPEED 5
    MOVE G6A, 112, 110,  112, 92,  101, 100
    MOVE G6D,  95,  15, 139, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹������� �������
    SPEED 2
    MOVE G6A, 112, 110,  112, 77,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹��� ���̵��
    SPEED 1
    MOVE G6A, 112, 125,  102, 65,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT	

    '�޹��� ���
    SPEED 5
    MOVE G6A, 108, 140,  92, 82,  91, 100
    MOVE G6D,  95,  15, 169, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '���� �����߷� �����ϰ� �������� ����
    SPEED 5
    MOVE G6A, 105, 140,  92, 102,  81, 100
    MOVE G6D,  95,  15, 169, 149, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� , ������ �����
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  81, 100
    MOVE G6D,  95,  35, 149, 139, 116, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ���� �������� ����� ';';'
    SPEED 5
    MOVE G6A, 105, 120,  112, 102,  96, 100
    MOVE G6D,  100,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ �߸� �������� ����̱�
    SPEED 5
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  105,  35, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ ��ü ���̱�
    SPEED 3
    MOVE G6A, 97, 120,  112, 102,  96, 100
    MOVE G6D,  110,  45, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ���� �ణ �ø���
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  110,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ���� �ణ �ø��� (������ �߸� �߽� ���)
    SPEED 5
    MOVE G6A, 97, 120,  102, 107,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ �������
    SPEED 3
    MOVE G6A, 97, 105,  103, 132,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ ������� 2
    SPEED 3
    MOVE G6A, 97, 110,  97, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������ ������� 3
    SPEED 3
    MOVE G6A, 97, 110,  107, 160,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������1
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  112,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������2
    SPEED 3
    MOVE G6A, 90, 65,  149, 149,  96, 100
    MOVE G6D,  107,  55, 149, 139, 106, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT

    '������ ������3
    SPEED 3
    MOVE G6A, 97, 55,  149, 136,  96, 100
    MOVE G6D,  107,  55, 149, 139, 104, 100
    MOVE G6B, 101,  36,  85, 100, 100, 101
    MOVE G6C,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB �⺻�ڼ�''�˼� ���

    ETX 4800, 254

    RETURN
<<<<<<< HEAD
<<<<<<< HEAD
    '****************************************
��ܿ޹߳�����1cm:    

	GOSUB All_motor_mode3

    '�޹� ���� ����ֱ� ''''
    SPEED 5
    MOVE G6D, 100, 110,  112, 92,  101, 100
    MOVE G6A,  100,  112, 112, 92, 101, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�����߸� ��������
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  85,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    '�޹� ���ǹ߸����   ����ֱ�
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  110, 112, 92, 108, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT 	

    '�޹� ����  ����ֱ�
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  105, 63, 119, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ����ֱ�
    SPEED 5
    MOVE G6D, 112, 110,  112, 92,  101, 100
    MOVE G6A,  95,  15, 139, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '������������ �������
    SPEED 2
    MOVE G6D, 112, 110,  112, 77,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�������� ���̵��
    SPEED 1
    MOVE G6D, 112, 125,  102, 65,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT	

    '�������� ���
    SPEED 5
    MOVE G6D, 108, 140,  92, 82,  91, 100
    MOVE G6A,  95,  15, 169, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '���� �޹߷� �����ϰ� �������� ����
    SPEED 5
    MOVE G6D, 105, 140,  92, 102,  81, 100
    MOVE G6A,  95,  15, 169, 149, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '������ , �޹� �����
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  81, 100
    MOVE G6A,  95,  35, 149, 139, 116, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ���� �������� ����� ';';'
    SPEED 5
    MOVE G6D, 105, 120,  112, 102,  96, 100
    MOVE G6A,  100,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� �߸� �������� ����̱�
    SPEED 5
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  105,  35, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������ ��ü ���̱�
    SPEED 3
    MOVE G6D, 97, 120,  112, 102,  96, 100
    MOVE G6A,  110,  45, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ���� �ణ �ø���
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  110,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ���� �ణ �ø��� (�޹� �߸� �߽� ���)
    SPEED 5
    MOVE G6D, 97, 120,  102, 107,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������ �������
    SPEED 3
    MOVE G6D, 97, 105,  103, 132,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������ ������� 2
    SPEED 3
    MOVE G6D, 97, 110,  97, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������ ������� 3
    SPEED 3
    MOVE G6D, 97, 110,  107, 160,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������1
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  112,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������2
    SPEED 3
    MOVE G6D, 90, 65,  149, 149,  96, 100
    MOVE G6A,  107,  55, 149, 139, 106, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT

    '�޹� ������3
    SPEED 3
    MOVE G6D, 97, 55,  149, 136,  96, 100
    MOVE G6A,  107,  55, 149, 139, 104, 100
    MOVE G6C, 101,  36,  85, 100, 100, 101
    MOVE G6B,  99,  32,  92, 100,  95, 100
    WAIT


    SPEED 4
    GOSUB �⺻�ڼ�''�˼� ���

    ETX 4800, 254

    RETURN

	'****************************************

stair_right_down:

=======
   	'****************************************
=======
    '****************************************
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)

stair_right_down:
    GOSUB All_motor_mode3
>>>>>>> f684033 (Add: 계단 파일 추가)
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
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
    MOVE G6D,108,  76, 145,  93,  94
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,113,  76, 145,  93,  94
    WAIT
<<<<<<< HEAD
<<<<<<< HEAD

    '������� �ö󰡱� ������ �Ȱ���

    GOSUB Leg_motor_mode2

    '�޹� ���� ���
    '�� �ǵ帲
    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    '�޹� �� �������� ������ + �������� ������ + ��� �ڷ� �ϱ�
    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    '�޹��� ��ġ�� + �������� �� ������ + ������ ������ �ϱ�
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 15, 135, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,30
    MOVE G6C,150,70
    WAIT

    '****************************

    '�޹��� ���� �� ��ġ�鼭 ���� ������ + �������� ���� ��� + ���� ������ ������ �ڷ�
    SPEED 8
    MOVE G6A,104, 25, 135, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,150,30
    MOVE G6C,120,70
    WAIT

    '�޹��� Ȯ ��� + ������ �ڷ� �ϸ鼭 ���� + �� �յ� ���� �� ũ��
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,30
    MOVE G6C,120,70
    WAIT

    '�޴ٸ� ������ �α� + �����ٸ� �����鼭 ������ ��������
    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    '�޹� �����ϱ� + �������� ��鼭 ������ ��������
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  70, 90,  150,114
    WAIT

    '������ ���� ������
    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,150,30
    MOVE G6C,120,70
    WAIT

    '�⺻�ڼ�
    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
=======
    SPEED 8
    MOVE G6A, 90, 100, 110, 100, 114
    MOVE G6D,114,  78, 146,  93,  94
=======
	
	'������� �ö󰡱� ������ �Ȱ���
	
=======

    '������� �ö󰡱� ������ �Ȱ���

>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    GOSUB Leg_motor_mode2

    '�޹� ���� ���
    '�� �ǵ帲
    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
    WAIT

    GOSUB Leg_motor_mode2

    '�޹� �� �������� ������ + �������� ������ + ��� �ڷ� �ϱ��
    SPEED 7
    MOVE G6A,  95, 10, 170, 148, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    '�޹��� ��ġ�� + �������� �� ������ + ������ ������ �ϱ�
    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 10, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    '�޹��� ���� �� ��ġ�鼭 ���� ������ + �������� ���� ��� + ���� ������ ������ �ڷ�
    SPEED 8
    MOVE G6A,100, 15, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    '�޹��� Ȯ ��� + ������ �ڷ� �ϸ鼭 ���� + �� �յ� ���� �� ũ��
    SPEED 10
<<<<<<< HEAD
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
>>>>>>> f684033 (Add: 계단 파일 추가)
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

<<<<<<< HEAD
    SPEED 4
    GOSUB �⺻�ڼ�
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

    '�޴ٸ� ������ �α� + �����ٸ� �����鼭 ������ ��������
    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
>>>>>>> 9df3388 (Comment: 계단왼발내리기3cm, stair_left_down 주석 추가)
    WAIT

    '�޹� �����ϱ� + �������� ��鼭 ������ ��������
    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    '������ ���� ������
    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    '�⺻�ڼ�
    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT
>>>>>>> f684033 (Add: 계단 파일 추가)

    SPEED 4
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT

    '******************************************


MAIN: '�󺧼���

    ETX 4800, 200 ' ���� ���� Ȯ�� �۽� ��

MAIN_2:

    GOSUB �յڱ�������
    GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� 	 ��, 2�̸� key2��... ���¹�
<<<<<<< HEAD
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32
=======
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY16,KEY19,KEY22,KEY25

>>>>>>> f684033 (Add: 계단 파일 추가)

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
        GOSUB �⺻�ڼ�

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************

KEY1:
    ETX  4800,1

    ' ����Ƚ�� = 2
    GOSUB ��ܿ޹߿�����1cm
    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2

    ����Ƚ�� = 6
    GOTO Ƚ��_������������

    GOTO RX_EXIT
    '***************

KEY3:
    ETX 4800, 3
    ' GOTO ���ʿ�����20
    GOSUB ��ܿ����߿�����1cm
    GOTO RX_EXIT
KEY4:
    ETX 4800, 4
    GOSUB ���ʿ�����20
    '  GOTO ���������3
    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    'J = AD(���ܼ�AD��Ʈ)	'���ܼ��Ÿ��� �б�
    'ETX 4800, J
    'BUTTON_NO = J
    'GOSUB Number_Play
    'GOSUB SOUND_PLAY_CHK
    'GOSUB GOSUB_RX_EXIT
    GOSUB �Ӹ��¿��߾�

    GOTO RX_EXIT
    '***************
KEY6:
    ETX 4800, 6
    GOSUB �����ʿ�����20
    GOTO RX_EXIT
KEY7:
    ETX 4800, 7
    GOSUB ��ܿ޹߳�����3cm
    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB ��������
    GOTO RX_EXIT
    '***************
KEY9:
    ETX 4800, 9
    GOSUB ��ܿ����߳�����3cm
    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX 4800, 10
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
<<<<<<< HEAD
KEY11: ' ��
    ETX  4800,11

    GOTO �⺻�ڼ�
    GOTO RX_EXIT

    '***************
KEY12: ' ��
    ETX  4800,12

    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY13: '��
    ETX  4800,13
    'GOSUB ��������90��
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '**************
KEY14: ' ��
    ETX  4800,14
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT


    GOTO RX_EXIT
    '***************
KEY15: 'A
    ETX 4800, 15
    GOSUB �⺻�ڼ�
=======
>>>>>>> f684033 (Add: 계단 파일 추가)
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
    GOSUB �����ڼ�	
    GOSUB ������

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ����ONOFF = 1  THEN
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


    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB �⺻�ڼ�2
        GOSUB ���̷�ON
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
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX 4800, 18
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY19: 'P2
    ETX 4800, 19
    GOSUB stair_right_down
    GOTO RX_EXIT
    '***************
KEY20: 'B
    ETX 4800, 20
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY21: ' ��
    ETX  4800,21
    GOSUB �⺻�ڼ�

=======
KEY19: 'P2
    ETX 4800, 19
    GOSUB  ��ܿ����߳�����1cm
>>>>>>> f684033 (Add: 계단 파일 추가)
    GOTO RX_EXIT
    '***************
KEY22: ' *
    ETX 4800, 22
<<<<<<< HEAD
    'GOSUB �⺻�ڼ�
    GOSUB ��ܿ޹߳�����1cm
    GOTO RX_EXIT
    '***************
KEY23: 'G
    ETX 4800, 23
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY24: '#
    ETX 4800, 24
    GOSUB  ��ܿ����߳�����1cm
    GOTO RX_EXIT
=======
    '  GOTO ��������3
    'GOTO ��������20
    ' GOTO �����������45
    GOTO stair_left_down
    GOTO RX_EXIT
    '***************
<<<<<<< HEAD
'KEY24: '#
 '   ETX 4800, 24
 '   GOSUB ��ܿ޹߳�����1cm
 '   GOTO RX_EXIT
>>>>>>> f684033 (Add: 계단 파일 추가)
=======
    'KEY24: '#
    '   ETX 4800, 24
    '   GOSUB ��ܿ޹߳�����1cm
    '   GOTO RX_EXIT
>>>>>>> 1af3458 (Chore: stair_left_down 값 수정)
    '***************
KEY25: 'P1
    ETX 4800, 25
    ' GOTO ���������45
    ' GOTO ������3
    'GOTO ������20
<<<<<<< HEAD
    GOSUB stair_left_down
    GOTO RX_EXIT
    '***************
KEY26: ' ��
    ETX  4800,26

    'SPEED 5
    'GOSUB �������
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX 4800, 27
    GOTO �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY28: ' ��
    ETX 4800, 28
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY29: ' ��
    ETX 4800, 29
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY30: ' ��
    ETX 4800, 30
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY31: ' ��
    ETX 4800, 31
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX 4800, 32
    GOSUB �⺻�ڼ�
=======
    GOSUB stair_right_down
>>>>>>> f684033 (Add: 계단 파일 추가)
    GOTO RX_EXIT
    '***************
