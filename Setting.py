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
