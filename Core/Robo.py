# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import Setting

class Robo:
    arrow: str = "LEFT"
    dis_arrow: str = "RIGHT"
    black_room_list = []
    alphabet_color: str

    def __init__(self, vpath='Sensor/src/danger/1110_22:29.h264'):
        self._image_processor = ImageProccessor(video=vpath) # Image Processor
        # self._motion = Motion() # Motion
