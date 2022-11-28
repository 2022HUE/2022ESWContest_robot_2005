# -*- coding: utf-8 -*-
# Debuging
from enum import Enum, auto


class LineColor(Enum):
    YELLOW = auto()


class Arrow(Enum):
    LEFT = auto()
    RIGHT = auto()


class Setting:
    def __init__(self):
        pass


'''SETTING CONSTANT'''
setting = Setting()
########### LINE DETECTION ###########
setting.YELLOW_DATA = [[20, 100, 100], [35, 255, 255]]

########### ENTRANCE PROCESSING ###########
setting.ARROW_BLUR = 7
setting.ARROW_BRIGHT = 0.0
setting.DIR_BLUR = 7
setting.DIR_KERNEL = 1

########### DANGER DETECTION ###########

# 장애물 파란색 색상 마스크 lower, upper의 [h, s, v] 값
setting.DANGER_MILKBOX_BLUE = [[82, 87, 30], [130, 255, 120]]
# 장애물 빨간색 색상 마스크 lower, upper의 [h, s, v] 값
# 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
setting.DANGER_MILKBOX_RED = [[167, 77, 30], [180, 255, 189]]

# 알파벳 파란색 색상 마스크 lower, upper의 [h, s, v] 값
setting.ALPHABET_BLUE = [[82, 87, 30], [130, 255, 120]]
# 알파벳 빨간색 색상 마스크 lower, upper의 [h, s, v] 값
setting.ALPHABET_RED = [[167, 77, 30], [180, 255, 189]]

# 위험 지역 인식 검은 색상 마스크 lower, upper [h, s, v] 값
setting.DANGER_BLACK = [[0, 0, 0], [180, 255, 80]]

# 위험/계단 지역 판단하는 비율의 기준 (밝기 올라가면 rate threshold 값을 올려줘야하고, 어두우면 내려줘야함)
setting.DANGER_STAIR_RATE = 20
# 위험 지역 벗어났음을 판단하는 비율의 기준
setting.OUT_DANGER_RATE = 20
# 위험 지역 인식 용도 s(채도) 기준값
setting.DANGER_ROOM_S = 170
# 위험 지역 인식 용도 v(명도) 기준값
setting.DANGER_ROOM_V = 80
# 장애물 인식 용도 s(채도) 기준값
setting.DANGER_MILKBOX_S = 80
# 장애물 인식 용도 v(명도) 기준값
setting.DANGER_MILKBOX_V = 150
setting.DANGER_H_BLUE = [[82, 87, 30], [130, 255, 120]]
# 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
setting.DANGER_H_RED = [[167, 77, 30], [180, 255, 189]]
# 장애물 들고 있음을 판단하는 비율의 기준
# 시야에서 없을 경우 HOLDING_RATE 값 0
# 시야에 있고 들고 있을 경우 파랑은 최소 15 이상, 빨강은 10 이상
setting.HOLDING_RATE = 2

# 로봇 시야에서 장애물의 위치 (9개 구역으로 나누기)
setting.MILKBOX_POS = [((0, 209), (0, 159)), ((210, 429), (0, 159)), ((430, 639), (0, 159)),
                       ((0, 209), (160, 319)), ((210, 429),
                                                (160, 319)), ((430, 639), (160, 319)),
                       ((0, 209), (320, 479)), ((210, 429), (320, 479)), ((430, 639), (320, 479))]

# morphology kernel 값
setting.MORPH_kernel = 3

########### STAIR DETECTION ###########
setting.ROOM_S = 180
setting.ROOM_V = 0

setting.STAIR_S = 50  # 계단 내려갈 때 채도 체크
setting.LINE_HIGH = 300  # 계단 올라갈 때 허프라인 위치
setting.STAIR_BLUE = [[102, 30, 30], [130, 255, 255]]  # 계단 맨 위의 파란색 hsv
setting.STAIR_UP = 290  # 계단 올라갈 때 채도값 설정
setting.ALPHABET_ROTATION = 50  # 알파벳 방향으로 회전할 때 알파벳 부분의 채도가 이거 이하여야 함.
setting.STAIR_ROTATION = 370  # 계단 지역으로 회전할 때 채도

setting.STAIR_ALPHABET_SIZE = 39000
setting.STAIR_LEVEL: int=1

setting.ONE_F = 90  # 계단 1층 채도
setting.TWO_F = 100  # 계단 2층 채도
setting.THREE_F = 400  # 계단 3층 채도

# setting.ARROW = 'RIGHT' #임시로 선언 (채연) -> 지워야함 (사용중인지 체크 필요)

########### CURRENT ACT ###########
cur = Setting()
cur.MAP_DIRECTION = ""  # (entr) E, W, S, N
cur.MAP_ARROW = ""  # (entr) LEFT, RIGHT
cur.AREA = ""
cur.ALPHABET_COLOR = None  # (danger) RED, BLUE
cur.ALPHABET_NAME = None  # (danger) A, B, C, D
cur.BLACK_ROOM_LIST = []  # (exit) 지나온 위험지역 방 이름 리스트
cur.FIRST_MILKBOX_POS = None  # (danger) 0 ~ 8
