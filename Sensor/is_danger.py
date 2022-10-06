import cv2 as cv
import numpy as np

# 가우시안 블러 안씀 !

global DANGER_CONST, ROOM_S, ROOM_V, MORPH_kernel, GAUSSIAN_kernel
DANGER_CONST = 10
# 위험 지역 인식 용도 s(채도) 기준값
ROOM_S = 170
# 위험 지역 인식 용도 v(명도) 기준값
ROOM_V = 80
# morphology kernel 값
MORPH_kernel = 3
# 가우시안 블러 kernel 값
GAUSSIAN_kernel = 1



def mophorlogy(mask):
    kernel = np.ones((MORPH_kernel, MORPH_kernel), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask

def get_s_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, ROOM_S, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    # s_bin = mophorlogy(s_bin)
    cv.imshow('s_bin', s_bin)

    return s_bin

def get_v_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_v, v_bin = cv.threshold(v, ROOM_V, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    # v_bin = mophorlogy(v_bin)
    cv.imshow('v_bin', v_bin)
    return v_bin

def is_danger(src):
    mask_AND = cv.bitwise_and(get_s_mask(src), get_v_mask(src))
    mask_AND = mophorlogy(mask_AND)
    cv.imshow('mask_AND', mask_AND)
    # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
    rate = np.count_nonzero(mask_AND) / (640 * 480)
    rate = int(rate * 1000)
    print(rate)
    return "DANGER" if rate <= DANGER_CONST else "STAIR"

# cap = cv.VideoCapture("videos/danger/1002_19:36.h264")
cap = cv.VideoCapture("videos/stair/0925_18:19.h264")

# while cap.isOpened():
#     _, src = cap.read()
#
#     if not _:
#         print("ret is false")
#         break
#     img_hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
#     blur = cv.GaussianBlur(src, (GAUSSIAN_kernel, GAUSSIAN_kernel), 1)
#     cv.imshow('src', src)
#
#     print(is_danger(blur))
#
#     if cv.waitKey(10) & 0xFF == ord('q'):
#         break
#
# cap.release()


# -----------debug-----------------

src = cv.imread('src/danger/danger_room_0.png')

cv.imshow('src', src)
blur = cv.GaussianBlur(src, (GAUSSIAN_kernel, GAUSSIAN_kernel), 1)
print(is_danger(blur))
cv.waitKey(0)