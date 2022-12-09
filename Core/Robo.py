# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import Setting
from Sensor.DataPath import DataPath

print('code: Robo.py - ## Debug')

 
class Robo:
    arrow: str = "LEFT"
    dis_arrow: str = "RIGHT"
    black_room_list = list = []
    alphabet_color: str
    box_pos: int = 5
    feet_down = 'LEFT_DOWN'
    _image_processor = ImageProccessor(video="")  # Image Processor
    _motion = Motion()  # Motion

    def __init__(self, vpath=''):
        # self._image_processor = ImageProccessor(video=vpath) # Image Processor
        pass
