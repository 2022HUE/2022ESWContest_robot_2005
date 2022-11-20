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
    # _image_processor 이거 없어도 되는 거 맞쥬?
    _image_processor = ImageProccessor(video="") # Image Processor

    def __init__(self, vpath='Sensor/src/danger/1110_22:29.h264'):
        self._image_processor = ImageProccessor(video=vpath) # Image Processor
        # self._motion = Motion() # Motion
