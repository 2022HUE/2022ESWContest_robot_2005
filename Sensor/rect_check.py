import cv2 as cv
import numpy as np

cap = cv.VideoCapture("src/stair/1027_23:22.h264")  # 알파벳 구분 영상으로 쓰기.

def rect(img, contours1):
    for pos in range(len(contours1)):
        peri = cv.arcLength(contours1[pos], True)
        approx = cv.approxPolyDP(contours1[pos], peri * 0.1, True)
        points = len(approx)
        area_arr = cv.moments(contours1[pos])
        # x = contours1[pos][0][0][0]  # 알파벳 위치의 x값 좌표 --> 알파벳 중앙에 오게할 때 필요
        y = contours1[pos][0][0][1] #가장 위의 y값 좌표

        # center = alphabet_center_check(x+10) #x값이 0인걸 방지
        # if center=='right':
        #     pass # 오른쪽 가기 모션
        # elif center=='left':
        #     pass # 왼쪽으로 가는 모션
        # elif center=='go':
        #     #크기 측정하며 전진.
        alphabet_size_calculation(peri, points, area_arr, approx, y)

def alphabet_center_check(x): #안됨..
    print(x)
    if x < 100:
        print("왼쪽으로 이동해야 알파벳이 중앙에 위치합니다.")
        return 'left'
    elif x >= 400 and x<500:
        print("오른쪽으로 이동해야 알파벳이 중앙에 위치합니다.")
        return 'right'
    elif x >= 100 and x <= 400:
        print("알파벳의 위치는 중앙입니다. 전진하세요")
        return 'go'


#전진 하면서 크기 측정 함수
def alphabet_size_calculation(peri, points, area_arr,approx,y):
    if peri >= 300 and peri <= 1000 and points == 4 and y < 150:
        area = area_arr["m00"]
        cv.drawContours(img_color, [approx], 0, (0, 255, 255), 2)
        if area >= 43000:
            print("정지 후 계단 지역으로 회전하세요.")


while (True):
    ret, img_color = cap.read()
    if ret == False: break
    # img_color = cv.resize(img_color, (640, 360))

    img_copy = img_color.copy()
    gray = cv.cvtColor(img_color, cv.COLOR_BGR2GRAY)
    blur = cv.GaussianBlur(gray, (9,9), 0)
    val = 0
    add = cv.add(blur, val)
    alpha = 0.0
    dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)

    ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
    dst = cv.bitwise_or(dst, dst, mask=th)

    kernel = cv.getStructuringElement(cv.MORPH_RECT, (5,5))
    dst = cv.dilate(dst, kernel, iterations=1)

    edges = cv.Canny(th, 100, 200, apertureSize=3)

    # lines = cv2.HoughLinesP(edges, 1, np.pi / 180, 70, maxLineGap=50)


    contours1, hierarchy1 = cv.findContours(dst, cv.RETR_LIST, cv.CHAIN_APPROX_TC89_L1)
    # contours2, hierarchy2 = cv.findContours(edges, cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)
    # print(contours1)
    x,y,w,h = 0,0,600,400

    rect(th[y:y+h, x:x+w], contours1)
    cv.imshow('rrrrr',img_color)

    if cv.waitKey(10) & 0xFF == 27:
        break

cv.destroyAllWindows()

