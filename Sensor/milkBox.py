import cv2 as cv
import numpy as np

global H_BLUE, H_RED

# blue 를 찾는 범위 값으로 HSV 이미지 위에 씌울 마스크 생성
# opencv 에서 hue 값: 0 ~ 180, blue : 120, red : 0 (음수로 내려가면 알아서 변환함)
# 실제 경기장에서는 어두운 파란색이라 120보다 낮은 100 ~ 115 정도 값인 듯
# BOX
H_BLUE = [[82, 87, 30], [130, 255, 120]]
H_RED = [[167, 77, 30], [180, 255, 189]]  # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
DANGER_BLACK = [[0, 0, 0], [180, 255, 80]]
# 알파벳 hsv 값, 일단 장애물이랑 같게 설정해둠 바꿔야함
ALPHABET_RED = [[167, 77, 30], [180, 255, 189]]
ALPHABET_BLUE = [[82, 87, 30], [130, 255, 120]]

# morphology kernel 값
MORPH_kernel = 3

cap = cv.VideoCapture("src/danger/0925_19:32.h264")


def mophorlogy(mask):
    kernel = np.ones((MORPH_kernel, MORPH_kernel), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask


def get_s_mask(hsv):
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, 80, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    s_bin = mophorlogy(s_bin)
    return s_bin


def get_v_mask(hsv):
    h, s, v = cv.split(hsv)
    ret_v, v_bin = cv.threshold(v, 150, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    v_bin = mophorlogy(v_bin)
    return v_bin


# 장애물 위치 파악을 위한 함수
def danger_roi(hsv):
    return True


def get_black_mask(hsv):
    lower_hue, upper_hue = np.array(DANGER_BLACK[0]), np.array(DANGER_BLACK[1])
    h_mask = cv.inRange(hsv, lower_hue, upper_hue)
    # h_mask = mophorlogy(h_mask)
    return h_mask  # mask 리턴


def get_color_mask(hsv, const):
    lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
    mask = cv.inRange(hsv, lower_hue, upper_hue)
    return mask


def get_alphabet_red_mask(hsv):
    return get_color_mask(hsv, ALPHABET_RED)


def get_alphabet_blue_mask(hsv):
    return get_color_mask(hsv, ALPHABET_BLUE)


def is_out_of_black(hsv, visualization=False):
    begin = (bx, by) = (160, 200)
    end = (ex, ey) = (480, 420)

    mask = get_black_mask(hsv)

    rate = np.count_nonzero(mask) / ((ex - bx) * (ey - by))
    rate *= 100

    if visualization:
        cv.imshow("roi", cv.rectangle(hsv, begin, end, (0, 0, 255), 3))  # hsv 말고 src 여야함
        cv.imshow("mask", mask)
        cv.waitKey(1)
    print(rate)

    return rate <= 30


def get_alphabet_roi(hsv):
    gray = cv.cvtColor(hsv, cv.COLOR_HSV2BGR)
    gray = cv.cvtColor(gray, cv.COLOR_BGR2GRAY)
    cv.imshow('gray', gray)
    v_mask = get_v_mask(hsv)
    cv.imshow('v', v_mask)


def get_alphabet_color(hsv):
    get_alphabet_roi(hsv)
    red_mask = get_alphabet_red_mask(hsv)
    blue_mask = get_alphabet_blue_mask(hsv)
    color = "RED" if np.count_nonzero(red_mask) > np.count_nonzero(blue_mask) else "BLUE"
    return color


def get_milkbox_mask(hsv, color):
    lower_hue, upper_hue = np.array(H_BLUE[0]), np.array(H_BLUE[1])
    if color == "RED":
        lower_hue, upper_hue = np.array(H_RED[0]), np.array(H_RED[1])
    # saturation, value 적당한 값 : 30 이라고 함 -> 일단 150, 0 으로 둠
    # lower_hue = np.array([hue - 10, 30, 30])
    # upper_hue = np.array([hue + 10, 255, 255])
    h_mask = cv.inRange(hsv, lower_hue, upper_hue)
    print(color)
    # cv.imshow('h_mask', h_mask)
    return h_mask  # mask 리턴


while cap.isOpened():
    _, src = cap.read()

    if not _:
        print("ret is false")
        break
    blur = cv.GaussianBlur(src, (5, 5), 0)
    cv.imshow('src', src)
    cv.imshow('blur', blur)

    # HSV로 색 추출
    hsv = cv.cvtColor(blur, cv.COLOR_BGR2HSV)
    s_bin = get_s_mask(hsv)
    # cv.imshow('s_bin', s_bin)

    # hsv에 채색 mask 씌워서 해당하는 장애물 mask 받아내기
    hsv_s = cv.bitwise_and(hsv, hsv, mask=s_bin)
    # cv.imshow('hsv_s', hsv_s)
    milk_color = get_alphabet_color(hsv)
    milk_mask = get_milkbox_mask(hsv_s, milk_color)
    cv.imshow('milk_mask', milk_mask)

    # milk_mask = get_milkbox_color(hsv)
    # 우유팩 마스크를 씌워서 imshow 하기
    # img_blue = cv.bitwise_and(src, src, mask=milk_mask)

    # ret_s, s_bin = cv2.threshold(s, 80, 255, cv2.THRESH_BINARY_INV)
    # ret_v, v_bin = cv2.threshold(s, 100, 255, cv2.THRESH_BINARY)
    # cv2.imshow('s_bin', s_bin)
    # cv2.imshow('v_bin', v_bin)
    # cv.imshow('img_masked_blue', img_blue)
    if cv.waitKey(2) & 0xFF == ord('q'):
        break


# 안전 지역인지(False) 위험 지역인지(True) detection
def isDanger(cap):
    return True


# 위험 지역인지 계단 지역인지의 detection
def stair_danger(cap):
    return True


cap.release()
