# -*- coding: utf-8 -*-
from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import Setting
from Sensor.DataPath import DataPath

print('code: Robo.py - ## Debug')


class Robo:
<<<<<<< HEAD
    arrow: str = "LEFT"
    dis_arrow: str = "RIGHT"
=======
    arrow: str = ""
    dis_arrow: str = ""
>>>>>>> b990fdb (Fix: 모션 파라미터 수정)
    black_room_list: list = []
    alphabet_color: str
    box_pos: int=0
    _image_processor = ImageProccessor(video="")  # Image Processor

    def __init__(self, vpath=''):
        # self._image_processor = ImageProccessor(video=vpath) # Image Processor
        self._motion = Motion()  # Motion
