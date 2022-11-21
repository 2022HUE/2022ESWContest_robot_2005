# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import Setting

print('code: Robo.py - ## Debug')

class Robo:
    arrow: str = "LEFT"
    dis_arrow: str = "RIGHT"
    black_room_list = list = []
    alphabet_color: str
    _image_processor = ImageProccessor(video="") # Image Processor

    def __init__(self, vpath=''):
        #self._image_processor = ImageProccessor(video=vpath) # Image Processor
        self._motion = Motion() # Motion
