import cv2 as cv
import numpy as np

global DANGER_CONST, ROOM_S, ROOM_V
global ALPHABET_GO
DANGER_CONST = 10
ROOM_S = 180
ROOM_V = 0
ALPHABET_GO= False
def mophorlogy(mask):
    kernel = np.ones((3, 3), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask

def get_s_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, ROOM_S, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    s_bin = mophorlogy(s_bin)

    return s_bin

def get_v_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_v, v_bin = cv.threshold(v, ROOM_V, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    v_bin = mophorlogy(v_bin)
    return v_bin

def saturation_measurement(src):
    mask_AND = cv.bitwise_and(get_s_mask(src), get_v_mask(src))
    mask_AND = mophorlogy(mask_AND)
    return mask_AND

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

#계단 지역 기준 왼쪽 오른쪽 판단하는 함수
def left_rignt(img_mask,ALPHABET_GO,x=0,y=0,w=0,h=0):
    if ALPHABET_GO == False:
        left = int((np.count_nonzero(img_mask[y:y+480,x:x+320]) / (640 * 480))*1000 )
        x =320;
        right = int((np.count_nonzero(img_mask[y:y+480,x:x+320]) / (640 * 480))*1000)
        #
        # rate = np.count_nonzero(mask_AND) / (640 * 480)
        # rate = int(rate * 1000)
        # print(rate)

        #로봇의 각도가 70도
        print("left %d  right %d"%(left,right))
        # if abs(left-right)>10 and abs(left-right)<50:
        if left<=10: #이부분 다시 확인.
            print("회전 완료")
            alphabet_go = True
            # rect(img_mask) # 여기서 알파벳 크기 체크 # 여기서 A를 중앙에 오도록
        elif left>right:
            print("알파벳은 오른쪽에 있습니다.")
        else:
            print("알파벳은 왼쪽에 있습니다.")

    if alphabet_go==True:
        return 'rectgo'
    else:
        return 'notgo'

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


# cap = cv.VideoCapture('src/stair/0925_19:27.h264')  # 제일 쓸만함
cap = cv.VideoCapture("src/stair/1027_23:21.h264") #알파벳 구분 영상으로 쓰기.

while(True):
    ret, img_color = cap.read()
    if ret==False: break
    img_hsv = cv.cvtColor(img_color, cv.COLOR_BGR2HSV)
    img_gray = cv.cvtColor(img_color,cv.COLOR_BGR2GRAY)

    stair_saturation_check_mask = saturation_measurement(img_color)

    img_canny = cv.Canny(img_color,50,150)
    left_rignt(stair_saturation_check_mask,ALPHABET_GO) #알파벳 오른쪽 왼쪽 확인하는 함수.
    # HoughLine()

    h, w = img_color.shape[:2] #(480,640)
    cv.imshow('img_color', img_color)

    # ---------------------------------------------------------------

    blur = cv.GaussianBlur(img_gray, (9,9), 0)
    add = cv.add(blur, 0)
    alpha = 0.0
    dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)

    ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)

    edges = cv.Canny(th, 100, 200, apertureSize=3)


    contours1, hierarchy1 = cv.findContours(dst, cv.RETR_LIST, cv.CHAIN_APPROX_TC89_L1)

    x,y,w,h = 0,0,600,400
    rect(th[y:y+h, x:x+w], contours1)
    #----------------------------------------------------------------

    cv.imshow('result',img_color)

    if cv.waitKey(20) & 0xFF == 27:
        break

cv.destroyAllWindows()

# 올라갔을 때 계단 색 확인 하는 함수
# 수평 확인하는 함수
# 시야에서 노란게 보이나 안 보이나
