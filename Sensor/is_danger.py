import cv2 as cv
import numpy as np

global DANGER_CONST, ROOM_S, ROOM_V
DANGER_CONST = 10
ROOM_S = 170
ROOM_V = 80

def mophorlogy(mask):
    kernel = np.ones((3, 3), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask

def get_s_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, ROOM_S, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    s_bin = mophorlogy(s_bin)

    return s_bin

def get_v_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_v, v_bin = cv.threshold(v, ROOM_V, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    v_bin = mophorlogy(v_bin)

    return v_bin

def is_danger(src):
    mask_AND = cv.bitwise_and(get_s_mask(src), get_v_mask(src))
    cv.imshow('mask_AND', mask_AND)
    # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
    rate = np.count_nonzero(mask_AND) / (640 * 480)
    rate = int(rate * 1000)
    print(rate)
    return "DANGER" if rate <= DANGER_CONST else "STAIR"

# cap = cv.VideoCapture("videos/danger/1002_19:36.h264")
# cap = cv.VideoCapture("videos/stair/0925_18:19.h264")

# while cap.isOpened():
#     _, src = cap.read()
#
#     if not _:
#         print("ret is false")
#         break
#     img_hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
#     # s_bin = get_s_mask(img_hsv)
#     # h, s, v = cv.split(img_hsv)
#     #
#     #
#     # cv.imshow('s_bin', s_bin)
#     # # cv.imshow('img_s', img_s)
#     cv.imshow('src', src)
#
#     # h, s, v = cv.split(img_hsv)
#     # ret_v, v_bin = cv.threshold(v, 80, 255, cv.THRESH_BINARY)
#     #
#     # cv.imshow('v_bin', v_bin)
#     #
#     # mask_AND = cv.bitwise_and(s_bin, v_bin)
#     # cv.imshow('mask_AND', mask_AND)
#     #
#     # # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
#     # rate = np.count_nonzero(mask_AND) / (640 * 480)
#     # rate = int(rate * 1000)
#     # img_s = cv.bitwise_and(src, src, mask=s_bin)
#     # print(rate)
#     print(is_danger(src))
#
#     if cv.waitKey(10) & 0xFF == ord('q'):
#         break
#
# cap.release()

'''
-----------debug-----------------

src = cv.imread('danger_room.png')

cv.imshow('src', src)
print(is_danger(src))
cv.waitKey(0)
'''