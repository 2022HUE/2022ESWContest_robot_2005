import cv2 as cv
import numpy as np

def block(img,contours1):
    for pos in range(len(contours1)):
        peri = cv.arcLength(contours1[pos], True)
        approx = cv.approxPolyDP(contours1[pos], peri * 0.1, True)
        points = len(approx)
        area_arr = cv.moments(contours1[pos])
        # x = contours1[pos][0][0][0]  # 알파벳 위치의 x값 좌표 --> 알파벳 중앙에 오게할 때 필요
        rect_y = contours1[pos][0][0][1]  # 가장 위의 y값 좌표
        rect_x = contours1[pos][0][0][0]  # 가장 위의 y값 좌표
        #
        if points>=3 and peri>=280 and peri <=1000:
            print(peri)
            cv.drawContours(img, [approx], 0, (0, 255, 255), 2)
            cv.imshow('img',img)

cap = cv.VideoCapture('src/stair/1107_20:56.h264')

while(True):
    ret, img = cap.read()
    if ret==False: break
    img_gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

    blur = cv.GaussianBlur(img_gray, (9, 9), 0)
    add = cv.add(blur, 0)
    alpha = 0.0
    dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)

    ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
    dst = cv.bitwise_or(dst, dst, mask=th)

    kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
    dst = cv.dilate(dst, kernel, iterations=1)
    cv.imshow('dst',dst)
    contours1, hierarchy1 = cv.findContours(dst, cv.RETR_LIST, cv.CHAIN_APPROX_TC89_L1)
    img = np.clip((1 + 1.0) * img - 128 * 1.0, 0, 255).astype(np.uint8)
    block(img,contours1)
    cv.imshow('img', img)  # 결과 이미지 출력

    if cv.waitKey(10) & 0xFF == 27:
        break

cv.destroyAllWindows()