# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import LineColor, Arrow, Setting

class Robo:
    arrow: Arrow = 'LEFT'
    disarrow: str = 'RIGHT'


    def __init__(self, vpath=''): #Sensor/src/stair/1114_21:26.h264
        stair01 = "src/stair/1114_22:24.h264"  # 방 입구 도착해서 위험지역, 계단지역 구분
        stair02 = "src/stair/1114_21:18.h264"  # 알파벳 센터 체크 & 전진
        stair03 = "src/stair/1027_23:22.h264"  # 알파벳 도착부터 전진까지
        stair04 = "src/stair/1106_20:13.h264"  # 알파벳에서 계단지역쪽으로 회전
        stair05 = "src/stair/1114_21:20.h264"  # 계단 오르기 시작
        stair06 = "src/stair/1114_21:26.h264"  # 계단 내려가기

        self._image_processor = ImageProccessor(video=stair02) # Image Processor
        # self._motion = Motion() # Motion
