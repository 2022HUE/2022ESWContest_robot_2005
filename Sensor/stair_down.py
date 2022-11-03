import cv2 as cv
import numpy as np

global DANGER_CONST, ROOM_S, ROOM_V
global ALPHABET_GO,ARROW
DANGER_CONST = 10
ROOM_S = 180
ROOM_V = 0
ALPHABET_GO= False
ARROW = ''
def mophorlogy(mask):
    kernel = np.ones((3, 3), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask

def get_s_mask(src):
    hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, 80, 255, cv.THRESH_BINARY)
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

def stair_down(img_mask,x=140,y=0):
    saturation = int((np.count_nonzero(img_mask[y:y+480,x:x+500]) / (640 * 480))*1000 )
    cv.imshow('saturation',img_mask[y:y+480,x:x+640])

    if saturation>=400:
        print("3층 입니다.%d"%saturation)
        return 'down' #내려가기
    elif saturation>=100:
        print("2층입니다.%d"%saturation)
        return 'down'  # 내려가기
    elif saturation<=70:
        print("모두 내려왔습니다.%d"%saturation)
        return 'go' #전진

# cap = cv.VideoCapture('src/stair/0925_19:27.h264')  # 제일 쓸만함
# cap = cv.VideoCapture("src/stair/1027_23:21.h264") # 알파벳 채도로 위치 구분 영상으로 쓰기.
# cap = cv.VideoCapture("src/stair/1027_23:22.h264") #알파벳 사이즈 및 중앙 측정 영상으로 쓰기

# cap = cv.VideoCapture("src/stair/1027_23:26.h264") #계단 내려가기
cap = cv.VideoCapture("src/stair/1006_18:40.h264") #계단 내려가기

while(True):
    ret, img_color = cap.read()
    if ret==False: break
    img_hsv = cv.cvtColor(img_color, cv.COLOR_BGR2HSV)
    img_gray = cv.cvtColor(img_color,cv.COLOR_BGR2GRAY)

    stair_saturation_check_mask = saturation_measurement(img_color)

    img_canny = cv.Canny(img_color,50,150)

    # left_rignt(stair_saturation_check_mask,ARROW='left') # 알파벳 오른쪽 왼쪽 확인하는 함수., ARROW에 화살표 방향 넣어야 함.
    stair_down(stair_saturation_check_mask)

    cv.imshow('result',img_color)

    if cv.waitKey(2) & 0xFF == 27:
        break

cv.destroyAllWindows()

# 올라갔을 때 계단 색 확인 하는 함수 --> 허프라인으로 시도해보기
# 수평 확인하는 함수