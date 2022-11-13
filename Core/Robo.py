from Sensor.ImageProcessor import ImageProccessor
from Motion.Motion import Motion
from Setting import LineColor, Arrow, Setting

class Robo:
    def __init__(self, vpath=''):
        self._image_processor = ImageProccessor(video=vpath) # Image Processor
        self._motion = Motion() # Motion
        self.arrow: str="LEFT"
        self.alpha: str="A"