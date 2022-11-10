import cv2 as cv
import numpy as np
from Sensor.Setting import setting


def stair_top(hsv, const):
    lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
    y = 200; x = 0; h = 200; w = 640
    mask = cv.inRange(hsv[y:y+h,x:x+w], lower_hue, upper_hue)
    cv.imshow('mask',mask)
    top = int((np.count_nonzero(mask) / (640 * 480)) * 1000)
cap = cv.VideoCapture('src/stair/1106_21:08.h264')

while(True):
    ret, img = cap.read()
    if ret==False: break

    hsv = cv.cvtColor(img,cv.COLOR_BGR2HSV)
    stair_top(hsv,setting.STAIR_BLUE)
    # blur = cv.GaussianBlur(img_gray, (9, 9), 0)
    # add = cv.add(blur, 0)
    # alpha = 0.0
    # dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)
    #
    # ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
    # dst = cv.bitwise_or(dst, dst, mask=th)
    #
    # kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    # dst = cv.dilate(dst, kernel, iterations=1)
    # cv.imshow('dst',dst)
    cv.imshow('img', img)  # 결과 이미지 출력

    if cv.waitKey(5) & 0xFF == 27:
        break

cv.destroyAllWindows()