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
# 위험/계단 지역 판단하는 비율의 기준
DANGER_RATE = 10
# 위험 지역 인식 용도 s(채도) 기준값
DANGER_ROOM_S = 170
# 위험 지역 인식 용도 v(명도) 기준값
DANGER_ROOM_V = 80

# morphology kernel 값
MORPH_kernel = 3

cap = cv.VideoCapture("src/danger/1027_23:32.h264")


def mophorlogy(mask):
    kernel = np.ones((MORPH_kernel, MORPH_kernel), np.uint8)
    mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
    mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
    return mask


def get_s_mask(hsv, s_value):
    h, s, v = cv.split(hsv)
    ret_s, s_bin = cv.threshold(s, s_value, 255, cv.THRESH_BINARY)
    # morphology 연산으로 노이즈 제거
    s_bin = mophorlogy(s_bin)
    return s_bin


def get_v_mask(hsv, v_value):
    h, s, v = cv.split(hsv)
    ret_v, v_bin = cv.threshold(v, v_value, 255, cv.THRESH_BINARY)
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


def get_alphabet_roi(src):
    img_copy = src.copy()
    gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY)
    blur = cv.GaussianBlur(gray, (7, 7), 0)
    val = 0
    add = cv.add(blur, val)
    alpha = 0.0

    dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)
    ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
    dst = cv.bitwise_and(dst, dst, mask=th)
    # cv.imshow('dst', dst)
    kernel = cv.getStructuringElement(cv.MORPH_RECT, (1, 1))
    dst = cv.dilate(dst, kernel, iterations=1)

    edges = cv.Canny(th, 100, 200, apertureSize=3)

    contours1, hierarchy1 = cv.findContours(th, cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)

    text_cont = []
    for pos in range(len(contours1)):
        peri = cv.arcLength(contours1[pos], True)
        approx = cv.approxPolyDP(contours1[pos], peri * 0.02, True)
        points = len(approx)
        if peri > 200 and peri < 400:
            text_cont.append(contours1[pos])
            cv.drawContours(src, [approx], 0, (0, 255, 255), 1)

    contour_pos = []
    for pos in range(len(text_cont)):
        area = cv.contourArea(text_cont[pos])
        # if area > 20000:
        contour_pos.append(pos)

    ##########################################################################
    # text count
    if text_cont:
        x, y, w, h = cv.boundingRect(text_cont[0])
        img_crop = img_copy[y:y + h, x:x + h]
        text_gray = cv.cvtColor(img_crop, cv.COLOR_BGR2GRAY)
        text = img_crop.copy()

    else:
        text = src.copy()
        text_gray = cv.cvtColor(text, cv.COLOR_BGR2GRAY)
    ##########################################################################

    img_crop = img_copy
    for pos in contour_pos:
        # print(pos)
        x, y, w, h = cv.boundingRect(text_cont[pos])
        # print('x, y, w, h:', x, y, w, h)
        img_crop = img_copy[y:y + h, x:x + w]
    # cv.imshow('img_crop', img_crop)

    hsv_crop = cv.cvtColor(img_crop, cv.COLOR_BGR2HSV)
    return hsv_crop


def get_alphabet_color(hsv):
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

# 위험 지역인지 계단 지역인지의 detection
def is_danger(src):
    mask_AND = cv.bitwise_and(get_s_mask(src, DANGER_ROOM_S), get_v_mask(src, DANGER_ROOM_V))
    mask_AND = mophorlogy(mask_AND)
    cv.imshow('mask_AND', mask_AND)
    # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
    rate = np.count_nonzero(mask_AND) / (640 * 480)
    rate = int(rate * 1000)
    print(rate)
    return "DANGER" if rate <= DANGER_RATE else "STAIR"

while cap.isOpened():
    _, src = cap.read()

    if not _:
        print("ret is false")
        break
    blur = cv.GaussianBlur(src, (5, 5), 0)
    cv.imshow('src', src)
    cv.imshow('blur', blur)

    alphabet_hsv = get_alphabet_roi(src)
    color = get_alphabet_color(alphabet_hsv)

    # HSV로 색 추출
    hsv = cv.cvtColor(blur, cv.COLOR_BGR2HSV)
    # s_bin = get_s_mask(hsv, DANGER_MILKBOX_S)
    # # cv.imshow('s_bin', s_bin)
    #
    # # hsv에 채색 mask 씌워서 해당하는 장애물 mask 받아내기
    # hsv_s = cv.bitwise_and(hsv, hsv, mask=s_bin)
    # # cv.imshow('hsv_s', hsv_s)
    # milk_color = get_alphabet_color(hsv)
    # milk_mask = get_milkbox_mask(hsv_s, milk_color)
    # cv.imshow('milk_mask', milk_mask)

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

cap.release()
