# -*- coding: utf-8 -*-
class DataPath:
    ### Debug Path List ###
    # entrance
    e01 = "src/entrance/entr03-1.mp4"
    e02 = "src/entrance/1027_23:14.h264"
    # line
    l01 = "src/line/1003_line2.mp4"
    l02 = "src/entrance/1027_23:19.h264"
    l03 = "src/line/1106_22:30.h264" # S
    l04 = "src/line/1106_22:33.h264" # W+arrow
    l04_ = "src/line/1106_22:34.h264" # W+arrow
    l05 = "src/line/1106_22:37.h264" # rotate entrance (조명 이상)
    l06 = "src/line/1106_22:38.h264" # rotate entrance
    l07 = "src/line/1106_22:39.h264" # goto_nextroom -> right
    l08 = "src/line/1106_22:46.h264" # goto_nextroom -> left
    l09 = "src/line/1106_22:41.h264" # goto_exit
    l10 = "src/line/1106_22:42.h264" # goto_exit
    l11 = "src/line/1106_22:43.h264" # goto_exit + object
    l12 = "src/line/1106_22:44.h264" # goto_exit + object
    l13 = "src/line/1106_22:45.h264" # exit - right
    l14 = "src/line/1106_22:47.h264" # exit - left
    # 1114 #
    l15 = "src/line/1114_21:51.h264" # entrance
    l16 = "src/line/1114_21:53.h264" # entrance
    l19 = "src/line/1114_21:56.h264" # E+arrow -> ISSUE!
    l20 = "src/line/1114_21:57.h264" # goto
    l21 = "src/line/1114_21:58.h264" # is_danger -> stair
    l22 = "src/line/1114_22:01.h264" # entrance
    l23 = "src/line/1114_22:02.h264" # S+arrow
    l24 = "src/line/1114_22:03.h264" # goto
    l25 = "src/line/1114_22:05.h264" # exit - right
    l26 = "src/line/1114_22:10.h264" # exit - object


    # danger
    danger01 = "src/danger/1027_23:41.h264" # A
    danger02 = "src/danger/1031_20:56.h264" # C
    danger03 = "src/danger/1027_23:32.h264" # D
    danger04 = "src/danger/1031_20:49.h264" # B
    danger05 = "src/danger/1110_22:29.h264" # 위험지역 확인과 알파벳 확인
    de1 = "src/danger/1127_de1.h264"
    de2 = "src/danger/1127_de2.h264"

    stair01 = "src/stair/1114_22:24.h264" # 방 입구 도착해서 위험지역, 계단지역 구분
    stair02 = "src/stair/1114_21:18.h264" # 알파벳 센터 체크 & 전진
    stair03 = "src/stair/1027_23:22.h264" # 알파벳 도착부터 전진까지
    stair04 = "src/stair/1106_20:13.h264" # 알파벳에서 계단지역쪽으로 회전
    stair05 = "src/stair/1114_21:20.h264" # 계단 오르기 시작
    stair06 = "src/stair/1114_21:26.h264" # 계단 내려가기

    se1="src/stair/se1.h264"
    se2="src/stair/se2.h264"
    se3="src/stair/se4.h264"
    se4="src/stair/se6.h264"
    se5="src/stair/se8.h264"
    
    test = "src/stair/1114_22:26.h264"

    stair07 = "src/stair/1124_18:28.h264"
    stair08 = "src/stair/1124_18:34.h264"
    stair09 = "src/stair/1124_18:36.h264"
    stair10 = "src/stair/1124_18:37.h264"
    stair11 = "src/stair/1124_18:38.h264"


    # debug in image processor
    d_alpha = 'src/alphabet_data/'
    d_dirfont = 'src/entrance/direction_data/font_img'
    d_dirimg = 'src/entrance/direction_data/'

    d_dangerfont = 'src/alphabet_data/font'

    


    # robot path
    r_alpha = 'Sensor/src/alphabet_data/' # robot path
    r_dirfont = 'Sensor/src/entrance/direction_data/font_img' # robot path
    r_dirimg = 'Sensor/src/entrance/direction_data/' # robot path
    r_dangerfont = 'Sensor/src/alphabet_data/font' # robot path

    