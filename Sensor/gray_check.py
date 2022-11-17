import cv2 as cv
import numpy as np

cap = cv.VideoCapture('src/stair/1027_23:22.h264')  # 제일 쓸만함
gray_cnt = 0

def stair_labeling(img_mask): # 알파벳 마스킹 하는 부분 mask 다시 만들기
    #라벨링 진행
    nlabels, labels, stats, centroids = cv.connectedComponentsWithStats(img_mask) #흰색과 검은색 분리.

    #가장 큰 영역이 파란색 공이라고 가정할 것이다.
    max = 4000
    max_index = -1

    for i in range(nlabels):
        if i < 1:
            continue
        area = stats[i, cv.CC_STAT_AREA]

        if area > max: # 노이즈 제거
            max_index = i
        # else:
        #     max_index = -1
        print(area) #도는 과정에서 중간 값이 9000이 뜨는게 있다. (우려했던 부분)
        cv.imshow('alpha',img_color)

    # print(area)
    if max_index != -1 :
        center_x = int(centroids[max_index, 0])
        center_y = int(centroids[max_index, 1])
        left = stats[max_index, cv.CC_STAT_LEFT]
        top = stats[max_index, cv.CC_STAT_TOP]
        width = stats[max_index, cv.CC_STAT_WIDTH]
        height = stats[max_index, cv.CC_STAT_HEIGHT]

        cv.rectangle(img_color, (left, top), (left + width, top + height), (0, 0, 255), 5)

while(True):
    ret, img_color = cap.read()
    if ret==False: break


    height, width = img_color.shape[:2]
    img_color = cv.resize(img_color, (width, height), interpolation=cv.INTER_AREA)
    cv.imshow('imgcolor',img_color)
    stair_labeling(img_color)
    # img_hsv = cv.cvtColor(img_color,cv.COLOR_BGR2HSV)
    # change = cv.cvtColor(img_color, cv.COLOR_BGR2Luv )
    # cv.imshow('hsv', change)
    # img_result = cv.bitwise_and(img_color, img_color, mask=img_mask)

    # cv.imshow('img_result', img_result)

    if cv.waitKey(10) & 0xFF == 27:
        break


cv.destroyAllWindows()
