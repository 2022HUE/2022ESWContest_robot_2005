# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import Setting
from Sensor.DataPath import DataPath


class Robo:
    arrow: str = "LEFT"
    dis_arrow: str = "RIGHT"
    black_room_list = []
    alphabet_color: str
    stair_level: int = 1
    # _image_processor = ImageProccessor(video="") # Image Processor

    def __init__(self, vpath='Sensor/src/stair/1106_20:13.h264'):
        self._image_processor = ImageProccessor(video=vpath) # Image Processor
        # self._motion = Motion() # Motion
