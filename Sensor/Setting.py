# Debuging
import os
from enum import Enum, auto

print(os.path.abspath('.'))

class LineColor(Enum):
    YELLOW = auto()

class Arrow(Enum):
    LEFT = auto()
    RIGHT = auto() 

class Setting:
    def __init__(self) -> None:
        pass

'''SETTING CONSTANT'''
setting = Setting()
########### LINE DETECTION ###########
setting.YELLOW_DATA = [[20, 100, 100], [35, 255, 255]]

########### ENTRANCE PROCESSING ###########
setting.ARROW_BLUR = 7
setting.ARROW_BRIGHT = 1.0
setting.DIR_BLUR = 7
setting.DIR_KERNEL = 1


########### CURRENT ACT ###########
cur = Setting()
# cur.MAP_DIRECTION = "E" # (entr) E, W, S, N
cur.MAP_DIRECTION = None # (entr) E, W, S, N
cur.MAP_ARROW = "" # (entr) LEFT, RIGHT

setting.DANGER_H_BLUE = [[82, 87, 30], [130, 255, 120]]
setting.DANGER_H_RED = [[167, 77, 30], [180, 255, 189]] # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5

