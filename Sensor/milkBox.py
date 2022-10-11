import cv2 as cv
import numpy as np

global H_BLUE, H_RED

# blue 를 찾는 범위 값으로 HSV 이미지 위에 씌울 마스크 생성
# opencv 에서 hue 값: 0 ~ 180, blue : 120, red : 0 (음수로 내려가면 알아서 변환함)
# 실제 경기장에서는 어두운 파란색이라 120보다 낮은 100 ~ 115 정도 값인 듯
# BOX
H_BLUE = [[82, 87, 30], [170, 255, 120]]
H_RED = [[167, 77, 30], [180, 255, 189]] # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
# morphology kernel 값
MORPH_kernel = 3

cap = cv.VideoCapture("src/danger/1002_19:05.h264")

def mophorlogy(mask):
    kernel = np.ones((MORPH_kernel, MORPH_kernel), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask

def get_s_mask(hsv):
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, 80, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    s_bin = mophorlogy(s_bin)
    return s_bin

def get_v_mask(hsv):
    h, s, v = cv.split(hsv)
    ret_v, v_bin = cv.threshold(v, 150, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    v_bin = mophorlogy(v_bin)
    return v_bin

def danger_roi(hsv):
    return True

def get_milkbox_color(hsv):
    return True

def get_milkbox_mask(hsv, color):
    lower_hue, upper_hue = np.array(H_BLUE[0]), np.array(H_BLUE[1])
    if color == "RED":
        lower_hue, upper_hue = H_RED[0], H_RED[1]
    # saturation, value 적당한 값 : 30 이라고 함 -> 일단 150, 0 으로 둠
    # lower_hue = np.array([hue - 10, 30, 30])
    # upper_hue = np.array([hue + 10, 255, 255])
    h_mask = cv.inRange(hsv, lower_hue, upper_hue)
    cv.imshow('milk_mask', h_mask)
    return h_mask # mask 리턴

while cap.isOpened():
    _, src = cap.read()

    if not _:
        print("ret is false")
        break
    blur = cv.GaussianBlur(src, (0,0), 1)
    cv.imshow('src', src)

    # HSV로 색 추출
    hsv = cv.cvtColor(blur, cv.COLOR_BGR2HSV)
    s_bin = get_s_mask(hsv)
    cv.imshow('s_bin', s_bin)

    # milk_mask = get_milkbox_color(hsv)
    # 우유팩 마스크를 씌워서 imshow 하기
    # img_blue = cv.bitwise_and(src, src, mask=milk_mask)

    # ret_s, s_bin = cv2.threshold(s, 80, 255, cv2.THRESH_BINARY_INV)
    # ret_v, v_bin = cv2.threshold(s, 100, 255, cv2.THRESH_BINARY)
    # cv2.imshow('s_bin', s_bin)
    # cv2.imshow('v_bin', v_bin)
    # cv.imshow('img_masked_blue', img_blue)
    if cv.waitKey(2) & 0xFF == ord('q'):
        break

# 안전 지역인지(False) 위험 지역인지(True) detection
def isDanger(cap):
    return True

# 위험 지역인지 계단 지역인지의 detection
def stair_danger(cap):
    return True

cap.release()