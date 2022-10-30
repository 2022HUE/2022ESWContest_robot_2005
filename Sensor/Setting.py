from enum import Enum, auto

class LineColor(Enum):
    YELLOW = auto()

class Setting:
    def __init__(self) -> None:
        pass


setting = Setting()

########### LINE DETECTION ###########
setting.YELLOW_DATA = [[20, 100, 100], [35, 255, 255]]
setting.DANGER_H_BLUE = [[82, 87, 30], [130, 255, 120]]
setting.DANGER_H_RED = [[167, 77, 30], [180, 255, 189]] # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5