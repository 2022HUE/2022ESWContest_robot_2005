import os
from enum import Enum, auto

print(os.path.abspath('.'))

class LineColor(Enum):
    YELLOW = auto()

class Setting:
    def __init__(self) -> None:
        pass

'''SETTING CONSTANT'''
setting = Setting()
########### LINE DETECTION ###########
setting.YELLOW_DATA = [[20, 100, 100], [35, 255, 255]]
setting.ROOM_S = 180 #--> 계단 내려갈 땐 50이면 좋겠어 원래는 180이야.
setting.STAIR_S = 50
setting.ROOM_V = 0
setting.ARROW = 'LEFT' #임시로 선언 (채연)

setting.ARROW_BLUR = 7
setting.ARROW_BRIGHT = 1.0
setting.DIR_BLUR = 7
setting.DIR_KERNEL = 1
