# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import LineColor, Arrow, Setting

class Robo:
    arrow: Arrow = Arrow.LEFT
    disarrow: str = 'RIGHT'
    def __init__(self, vpath=''): #Sensor/src/stair/1114_21:26.h264
        self._image_processor = ImageProccessor(video="") # Image Processor
        self._motion = Motion() # Motion
