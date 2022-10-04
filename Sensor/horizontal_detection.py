import cv2 as cv
import numpy as np

hsv = 0

lower_blue1 = np.array([175, 30, 30])
upper_blue1 = np.array([180, 255, 255])
lower_blue2 = np.array([0, 30, 30])
upper_blue2 = np.array([175 + 10 - 180, 255, 255])
lower_blue3 = np.array([175 - 10, 30, 30])
upper_blue3 = np.array([175, 255, 255])

cap = cv.VideoCapture('src/stair/0925_19:27.h264')  # 제일 쓸만함

while(True):
    ret, img_color = cap.read()
    if ret==False: break

    height, width = img_color.shape[:2]
    img_color = cv.resize(img_color, (width, height), interpolation=cv.INTER_AREA)

    img_hsv = cv.cvtColor(img_color, cv.COLOR_BGR2HSV)

    img_mask1 = cv.inRange(img_hsv, lower_blue1, upper_blue1)
    img_mask2 = cv.inRange(img_hsv, lower_blue2, upper_blue2)
    img_mask3 = cv.inRange(img_hsv, lower_blue3, upper_blue3)
    img_mask = img_mask1 | img_mask2 | img_mask3

    img_result = cv.bitwise_and(img_color, img_color, mask=img_mask)

    img_canny = cv.Canny(img_mask,50,150)

    h, w = img_color.shape[:2] #(480,640)

    # 알파벳 검출 여기 넣으면 됨.

    cv.imshow('img_color', img_color)
    cv.imshow('img_result', img_result)

    if cv.waitKey(10) & 0xFF == 27:
        break


    # cv.namedWindow('img_color')
    # cv.setMouseCallback('img_color', mouse_callback)

cv.destroyAllWindows()

# 허프라인 검출
def HoughLine():
    lines = cv.HoughLines(img_canny, 1, np.pi / 45, 80, None, None, None, None)
    if lines is not None:
        for i in range(len(lines)):
            # rho = 거리, scale = 각도
            for rho, theta in lines[i]:
                # scale = img_color.shape[0] + img_color.shape[1]
                scale = 1000
                a = np.cos(theta)
                b = np.sin(theta)
                x0 = a * rho
                y0 = b * rho
                x1 = int(x0 + scale * (-b))
                y1 = int(y0 + scale * (a))
                x2 = int(x0 - scale * (-b))
                y2 = int(y0 - scale * (a))
            cv.line(img_color, (x1, y1), (x2, y2), (0, 0, 255), 2)

def alphabet_detection():

    red_cnt=0

    #라벨링 진행
    nlabels, labels, stats, centroids = cv.connectedComponentsWithStats(img_mask) #흰색과 검은색 분리.

    #가장 큰 영역이 파란색 공이라고 가정할 것이다.
    max = 1000
    max_index = -1

    for i in range(nlabels):
        if i < 1:
            continue
        area = stats[i, cv.CC_STAT_AREA]

        if area > max: # 노이즈 제거
            max_index = i
            red_cnt += 1
        else:
            max_index = -1
            if red_cnt>=30 and red_cnt<=150:
                red_cnt -= 20

    # print(red_cnt)
    if max_index != -1 and red_cnt > 40:
        if area>26000:
            print("오른쪽으로 돌아라")
            # Motion.test_arrow(motion, 'RIGHT')
        center_x = int(centroids[max_index, 0])
        center_y = int(centroids[max_index, 1])
        left = stats[max_index, cv.CC_STAT_LEFT]
        top = stats[max_index, cv.CC_STAT_TOP]
        width = stats[max_index, cv.CC_STAT_WIDTH]
        height = stats[max_index, cv.CC_STAT_HEIGHT]

        cv.rectangle(img_color, (left, top), (left + width, top + height), (0, 0, 255), 5)
