from enum import Enum, auto

class LineColor(Enum):
    YELLOW = auto()

class Setting:
    def __init__(self) -> None:
        pass

'''SETTING CONSTANT'''
setting = Setting()
########### LINE DETECTION ###########
setting.YELLOW_DATA = [[20, 100, 100], [35, 255, 255]]

########### DANGER DETECTION ###########

# 장애물 파란색 색상 마스크 lower, upper의 [h, s, v] 값
setting.DANGER_MILKBOX_BLUE = [[82, 87, 30], [130, 255, 120]]
# 장애물 빨간색 색상 마스크 lower, upper의 [h, s, v] 값
setting.DANGER_MILKBOX_RED = [[167, 77, 30], [180, 255, 189]] # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5

# 알파벳 파란색 색상 마스크 lower, upper의 [h, s, v] 값
setting.ALPHABET_BLUE = [[82, 87, 30], [130, 255, 120]]
# 알파벳 빨간색 색상 마스크 lower, upper의 [h, s, v] 값
setting.ALPHABET_RED = [[167, 77, 30], [180, 255, 189]]

# 위험 지역 인식 검은 색상 마스크 lower, upper [h, s, v] 값
setting.DANGER_BLACK = [[0, 0, 0], [180, 255, 80]]

# 위험/계단 지역 판단하는 비율의 기준
setting.DANGER_STAIR_RATE = 10
# 위험 지역 벗어났음을 판단하는 비율의 기준
setting.OUT_DANGER_RATE = 30
# 위험 지역 인식 용도 s(채도) 기준값
setting.DANGER_ROOM_S = 170
# 위험 지역 인식 용도 v(명도) 기준값
setting.DANGER_ROOM_V = 80
# 장애물 인식 용도 s(채도) 기준값
setting.DANGER_MILKBOX_S = 80
# 장애물 인식 용도 v(명도) 기준값
setting.DANGER_MILKBOX_V = 150

# 장애물 들고 있음을 판단하는 비율의 기준
# 시야에서 없을 경우 HOLDING_RATE 값 0
# 시야에 있고 들고 있을 경우 파랑은 최소 15 이상, 빨강은 10 이상
setting.HOLDING_RATE = 5

# 로봇 시야에서 장애물의 위치 (9개 구역으로 나누기)
setting.MILKBOX_POS = [((0, 209), (0, 159)), ((210, 429), (0, 159)), ((430, 639), (0, 159)),
               ((0, 209), (160, 319)), ((210, 429), (160, 319)), ((430, 639), (160, 319)),
               ((0, 209), (320, 479)), ((210, 429), (320, 479)), ((430, 639), (320, 479))]

# morphology kernel 값
setting.MORPH_kernel = 3
########### ENTRANCE PROCESSING ###########
setting.ARROW_BLUR = 7
setting.ARROW_BRIGHT = 1.0
