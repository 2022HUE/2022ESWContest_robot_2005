from Sensor.imageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import LineColor, Setting

class Robo:
    print('robo py')
    def __init__(self, vpath=''):
        # self._image_processor = ImageProccessor(video=vpath) # Image Processor
        self._motion = Motion() # Motion
        self.map_arrow: str
        
        # misson list
        self.entrance = False
        self.stair = False
        self.danger = False