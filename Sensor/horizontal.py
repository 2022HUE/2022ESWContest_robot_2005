import cv2 as cv
import numpy as np
cap = cv.VideoCapture('src/stair/0925_19:27.h264')  # 제일 쓸만함

while(True):
    ret, img_color = cap.read()
    if ret==False: break

    height, width = img_color.shape[:2]
    img_color = cv.resize(img_color, (width, height), interpolation=cv.INTER_AREA)
    cv.imshow('img_color', img_color)

    if cv.waitKey(10) & 0xFF == 27:
        break
cv.destroyAllWindows()