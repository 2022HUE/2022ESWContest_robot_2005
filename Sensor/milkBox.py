import cv2
import numpy as np

cap = cv2.VideoCapture("videos/danger/09-25_19:32.h264")

def danger_roi(src):
    return True

while cap.isOpened():
    _, frame = cap.read()

    if not _:
        print("ret is false")
        break
    frame = cv2.GaussianBlur(frame, (0,0), 1)
    cv2.imshow('frame', frame)

    # HSV로 색 추출
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    h, s, v = cv2.split(hsv)

    # blue 를 찾는 범위 값으로 HSV 이미지 위에 씌울 마스크 생성
    # opencv 에서 hue 값: 0 ~ 180, blue : 120
    hue_blue = 120
    # saturation, value 적당한 값 : 30 이라고 함 -> 일단 150, 0 으로 둠
    lower_blue = np.array([hue_blue - 10, 30, 30])
    upper_blue = np.array([hue_blue + 10, 255, 255])
    blue_mask = cv2.inRange(hsv, lower_blue, upper_blue)
    cv2.imshow('blue_mask', blue_mask)

    # blue 마스크를 씌워서 imshow 하기
    img_blue = cv2.bitwise_and(frame, frame, mask=blue_mask)

    # ret_s, s_bin = cv2.threshold(s, 80, 255, cv2.THRESH_BINARY_INV)
    # ret_v, v_bin = cv2.threshold(s, 100, 255, cv2.THRESH_BINARY)
    # cv2.imshow('s_bin', s_bin)
    # cv2.imshow('v_bin', v_bin)
    cv2.imshow('img_masked_blue', img_blue)
    if cv2.waitKey(2) & 0xFF == ord('q'):
        break

# 안전 지역인지(False) 위험 지역인지(True) detection
def isDanger(cap):
    return True

# 위험 지역인지 계단 지역인지의 detection
def stair_danger(cap):
    return True

cap.release()
cv2.destroyWindow()