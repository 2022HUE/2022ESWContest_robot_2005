# -*- coding: utf-8 -*-
# from enum import Enum, auto

class Setting:
    def __init__(self):
        pass


'''SETTING CONSTANT'''
setting = Setting()
########### LINE DETECTION ###########
# setting.YELLOW_DATA = [[20, 100, 100], [35, 255, 255]]
# setting.YELLOW_DATA = [[9, 30, 30], [20, 255, 255]] # 1206
setting.YELLOW_DATA = [[15, 150, 100], [40, 255, 255]]  # 1207
setting.YELLOW_DANGER_DATA = [[11, 70, 100], [30, 150, 255]]  # 1208
setting.VSLOPE1 = 85
setting.VSLOPE2 = 105

########### ENTRANCE PROCESSING ###########
setting.ARROW_BLUR = 7
setting.ARROW_BRIGHT = 0.0
setting.DIR_BLUR = 7
setting.DIR_KERNEL = 1

########### DANGER DETECTION ###########

# 장애물 파란색 색상 마스크 lower, upper의 [h, s, v] 값
setting.DANGER_MILKBOX_BLUE1 = [[82, 87, 30], [130, 255, 120]]
setting.DANGER_MILKBOX_BLUE2 = [[97, 30, 30], [107, 255, 190]]
setting.DANGER_MILKBOX_BLUE3 = [[82, 87, 30], [110, 255, 190]]
# setting.DANGER_MILKBOX_BLUE = [[92, 87, 30], [117, 255, 190]] # 경기장용
setting.DANGER_MILKBOX_BLUE = [[102, 30, 30], [123, 255, 210]]  # 테스트용

# 장애물 빨간색 색상 마스크 lower, upper의 [h, s, v] 값
# 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
setting.DANGER_MILKBOX_RED1 = [[167, 77, 30], [180, 255, 189]]
setting.DANGER_MILKBOX_RED2 = [[164, 77, 30], [180, 255, 179]]
setting.DANGER_MILKBOX_RED3 = [[164, 77, 30], [180, 255, 189]]
# setting.DANGER_MILKBOX_RED = [[164, 77, 30], [190, 255, 210]] # 경기장용
setting.DANGER_MILKBOX_RED = [[164, 77, 30], [190, 255, 210]]  # 테스트용

# 알파벳 파란색 색상 마스크 lower, upper의 [h, s, v] 값
setting.ALPHABET_BLUE = [[82, 87, 30], [130, 255, 120]]
# 알파벳 빨간색 색상 마스크 lower, upper의 [h, s, v] 값
setting.ALPHABET_RED = [[167, 77, 30], [180, 255, 189]]

# 위험 지역 인식 검은 색상 마스크 lower, upper [h, s, v] 값
setting.DANGER_BLACK2 = [[0, 0, 0], [180, 255, 80]]
setting.DANGER_BLACK = [[0, 0, 0], [110, 45, 70]]

# 위험/계단 지역 판단하는 비율의 기준 (밝기 올라가면 rate threshold 값을 올려줘야하고, 어두우면 내려줘야함)
setting.DANGER_STAIR_RATE = 30
# 위험 지역 벗어났음을 판단하는 비율의 기준
setting.OUT_DANGER_RATE = 10
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
setting.STAIR_GREEN = [[64, 30, 30], [84, 255, 200]]


setting.STAIR_UP = 290  # 계단 올라갈 때 채도값 설정
setting.STAIR_DOWN = 150  # 계단 내려갈 때 전진 채도값 설정

setting.ALPHABET_ROTATION = 40  # 알파벳 방향으로 회전할 때 알파벳 부분의 채도가 이거 이하여야 함.
setting.STAIR_ROTATION = 370  # 계단 지역으로 회전할 때 채도

setting.STAIR_ALPHABET_SIZE = 40000
setting.STAIR_LEVEL = 1  # 채연아 미안  merge하면서 지워졌다^^,,,,,

setting.ONE_F = 150  # 계단 1층 채도
setting.TWO_F = 250  # 계단 2층 채도
setting.THREE_F = 400  # 계단 3층 채도

# setting.top_forward = 95  # 꼭대기에서 전진 판단하는 채도
setting.top_forward = 190  # 꼭대기에서 전진 판단하는 채도
setting.top_move = 50  # 반대쪽 계단으로 떨어지지 않기 위해 안쪽으로 이동할 때 채도 값
setting.top_saturation = 630  # 현장=580

setting.STAIR_START_UP = 310
########### MOTION ###########
setting.SICK = 0

########### CURRENT ACT ###########
cur = Setting()
cur.MAP_DIRECTION = "E"  # (entr) E, W, S, N
cur.MAP_ARROW = "LEFT"  # (entr) LEFT, RIGHT
cur.AREA = ""
cur.ALPHABET_COLOR = "BLUE"  # (danger) RED, BLUE
cur.ALPHABET_NAME = None  # (danger) A, B, C, D
cur.BLACK_ROOM_LIST = ["B"]  # (exit) 지나온 위험지역 방 이름 리스트
cur.FIRST_MILKBOX_POS = None  # (danger) 0 ~ 8
  