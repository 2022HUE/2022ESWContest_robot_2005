from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import LineColor, Arrow, Setting

class Robo:
    arrow: Arrow = Arrow.LEFT
    dis_arrow: str = 'RIGHT'
    black_room_list = []
    alphabet_color: str = "RED"

    def __init__(self, vpath=''):
        self._image_processor = ImageProccessor(video=vpath) # Image Processor
        self._motion = Motion() # Motion
