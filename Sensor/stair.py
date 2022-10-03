import cv2 as cv
import numpy as np

hsv = 0
lower_blue1 = 175
upper_blue1 = 180
lower_blue2 = 0
upper_blue2 = 6
lower_blue3 = 165
upper_blue3 = 175

def mouse_callback(event, x, y, flags, param):
    global hsv, lower_blue1, upper_blue1, lower_blue2, upper_blue2, lower_blue3, upper_blue3

    # 마우스 왼쪽 버튼 누를시 위치에 있는 픽셀값을 읽어와서 HSV로 변환 (x, y 값으로 저장)
    if event == cv.EVENT_LBUTTONDOWN:
        print(img_color[y, x])
        color = img_color[y, x]

        one_pixel = np.uint8([[color]])
        hsv = cv.cvtColor(one_pixel, cv.COLOR_BGR2HSV)
        hsv = hsv[0][0]
        print(hsv)
        # HSV 색공간에서 마우스 클릭으로 얻은 픽셀값과 유사한 픽셀값의 범위를 정함
        if hsv[0] < 10:
            print("case1")
            lower_blue1 = np.array([hsv[0]-10+180, 30, 30]) # 색상만 조절
            upper_blue1 = np.array([180, 255, 255])
            lower_blue2 = np.array([0, 30, 30])
            upper_blue2 = np.array([hsv[0], 255, 255])
            lower_blue3 = np.array([hsv[0], 30, 30])
            upper_blue3 = np.array([hsv[0]+10, 255, 255])
            #     print(i-10+180, 180, 0, i)
            #     print(i, i+10)

        elif hsv[0] > 170:
            print("case2")
            lower_blue1 = np.array([hsv[0], 30, 30])
            upper_blue1 = np.array([180, 255, 255])
            lower_blue2 = np.array([0, 30, 30])
            upper_blue2 = np.array([hsv[0]+10-180, 255, 255])
            lower_blue3 = np.array([hsv[0]-10, 30, 30])
            upper_blue3 = np.array([hsv[0], 255, 255])
            #     print(i, 180, 0, i+10-180)
            #     print(i-10, i)
        else:
            print("case3")
            lower_blue1 = np.array([hsv[0], 30, 30])
            upper_blue1 = np.array([hsv[0]+10, 255, 255])
            lower_blue2 = np.array([hsv[0]-10, 30, 30])
            upper_blue2 = np.array([hsv[0], 255, 255])
            lower_blue3 = np.array([hsv[0]-10, 30, 30])
            upper_blue3 = np.array([hsv[0], 255, 255])
            #     print(i, i+10)
            #     print(i-10, i)

        print(hsv[0])
        print("@1", lower_blue1, "~", upper_blue1)
        print("@2", lower_blue2, "~", upper_blue2)
        print("@3", lower_blue3, "~", upper_blue3)

cap = cv.VideoCapture('src/stair/0925_19:27.h264')  # 제일 쓸만함
red_cnt = 0
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
            print("오른쪼으로 돌아라")
        center_x = int(centroids[max_index, 0])
        center_y = int(centroids[max_index, 1])
        left = stats[max_index, cv.CC_STAT_LEFT]
        top = stats[max_index, cv.CC_STAT_TOP]
        width = stats[max_index, cv.CC_STAT_WIDTH]
        height = stats[max_index, cv.CC_STAT_HEIGHT]

        cv.rectangle(img_color, (left, top), (left + width, top + height), (0, 0, 255), 5)



    cv.imshow('img_color', img_color)
    cv.imshow('img_result', img_result)

    if cv.waitKey(10) & 0xFF == 27:
        break


    cv.namedWindow('img_color')
    cv.setMouseCallback('img_color', mouse_callback)

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
