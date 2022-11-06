import cv2 as cv
import numpy as np

global DANGER_MILKBOX_BLUE, DANGER_MILKBOX_RED, DANGER_BLACK, ALPHABET_RED, ALPHABET_BLUE, DANGER_RATE, DANGER_ROOM_S, DANGER_ROOM_V, MORPH_kernel, GAUSSIAN_kernel

# blue 를 찾는 범위 값으로 HSV 이미지 위에 씌울 마스크 생성
# opencv 에서 hue 값: 0 ~ 180, blue : 120, red : 0 (음수로 내려가면 알아서 변환함)
# 실제 경기장에서는 어두운 파란색이라 120보다 낮은 100 ~ 115 정도 값인 듯
DANGER_MILKBOX_BLUE = [[82, 87, 30], [130, 255, 120]]
DANGER_MILKBOX_RED = [[167, 77, 30], [180, 255, 189]]  # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
DANGER_BLACK = [[0, 0, 0], [180, 255, 80]]

# 장애물 인식 용도 s(채도) 기준값
DANGER_MILKBOX_S = 80
# 장애물 인식 용도 v(명도) 기준값
DANGER_MILKBOX_V = 150

# 알파벳 hsv 값, 일단 장애물이랑 같게 설정해둠 바꿔야함
ALPHABET_RED = [[167, 77, 30], [180, 255, 189]]
ALPHABET_BLUE = [[82, 87, 30], [130, 255, 120]]

# morphology kernel 값
MORPH_kernel = 3

# 위험/계단 지역 판단하는 비율의 기준
DANGER_RATE = 10
# 위험 지역 인식 용도 s(채도) 기준값
DANGER_ROOM_S = 170
# 위험 지역 인식 용도 v(명도) 기준값
DANGER_ROOM_V = 80

# 장애물 들고 있음을 판단하는 비율의 기준
# 시야에서 없을 경우 HOLDING_RATE 값 0
# 시야에 있고 들고 있을 경우 파랑은 6 이상, 빨강은 10 이상
HOLDING_RATE = 5

# ---------------------------

# 로봇 시야에서 장애물의 위치 (9개 구역으로 나누기)
MILKBOX_POS = [((0, 209), (0, 159)), ((210, 429), (0, 159)), ((430, 639), (0, 159)),
               ((0, 209), (160, 319)), ((210, 429), (160, 319)), ((430, 639), (160, 319)),
               ((0, 209), (320, 479)), ((210, 429), (320, 479)), ((430, 639), (320, 479))]


class Danger:

    def __init__(self):
        pass

    def mophorlogy(self, mask):
        kernel = np.ones((MORPH_kernel, MORPH_kernel), np.uint8)
        mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
        mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
        return mask

    def get_s_mask(self, hsv, s_value):
        h, s, v = cv.split(hsv)
        ret_s, s_bin = cv.threshold(s, s_value, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        s_bin = self.mophorlogy(s_bin)
        return s_bin

    def get_v_mask(self, hsv, v_value):
        h, s, v = cv.split(hsv)
        ret_v, v_bin = cv.threshold(v, v_value, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        v_bin = self.mophorlogy(v_bin)
        return v_bin

    def is_holding_milkbox(self, hsv, color):
        mask = self.get_milkbox_mask(hsv, color)
        rate = np.count_nonzero(mask) / (640 * 480)
        rate *= 100
        # print(rate)
        return True if rate >= HOLDING_RATE else False

    # 잡고 있는 장애물의 크롭 화면 가져오기
    # -> 그냥 이 부분 제외하고는 검은색으로 채울 까
    def get_holding_milkbox_roi(self, hsv):
        hsv_crop = hsv.copy()[0:179, 0:639]
        cv.imshow('holding_milkbox_img', hsv_crop)
        return hsv_crop

    # 장애물 위치 파악을 위한 함수
    def get_milkbox_pos(self, hsv):
        # 9개의 구역 중 하나의 구역 리턴 (index로 리턴)
        idx = 0
        return idx

    def get_black_mask(self, hsv):
        return self.get_color_mask(hsv, DANGER_BLACK)

    def get_color_mask(self, hsv, const):
        lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
        mask = cv.inRange(hsv, lower_hue, upper_hue)
        return mask

    def get_alphabet_red_mask(self, hsv):
        return self.get_color_mask(hsv, ALPHABET_RED)

    def get_alphabet_blue_mask(self, hsv):
        return self.get_color_mask(hsv, ALPHABET_BLUE)

    # 장애물이 위험지역에서 벗어났는지 확인
    def is_out_of_black(self, hsv, visualization=False):
        begin = (bx, by) = (160, 200)
        end = (ex, ey) = (480, 420)

        mask = self.get_black_mask(hsv)

        rate = np.count_nonzero(mask) / ((ex - bx) * (ey - by))
        rate *= 100

        if visualization:
            cv.imshow("roi", cv.rectangle(hsv, begin, end, (0, 0, 255), 3))  # hsv 말고 src 여야함
            cv.imshow("mask", mask)
            cv.waitKey(1)
        print(rate)

        return rate <= 30

    # 방 이름 ROI 찾기
    def get_alphabet_roi(self, src, option): # [Option] gray, hsv
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
            contour_pos.append(pos)

        ##########################################################################
        # text count
        if text_cont:
            x, y, w, h = cv.boundingRect(text_cont[0])
            img_crop = img_copy[y:y + h, x:x + w]
            text_gray = cv.cvtColor(img_crop, cv.COLOR_BGR2GRAY)
            text = img_crop.copy()
            if option == "GRAY":
                return text_gray

        else:
            text = src.copy()
            text_gray = cv.cvtColor(text, cv.COLOR_BGR2GRAY)
            return "Failed" # ROI 인식 실패
        ##########################################################################

        img_crop = img_copy
        for pos in contour_pos:
            # print(pos)
            x, y, w, h = cv.boundingRect(text_cont[pos])
            # print('x, y, w, h:', x, y, w, h)
            img_crop = img_copy[y:y + h, x:x + w]
        cv.imshow('img_crop', img_crop)

        hsv_crop = cv.cvtColor(img_crop, cv.COLOR_BGR2HSV)
        return hsv_crop

    def get_alphabet_color(self, src):
        hsv = self.get_alphabet_roi(src)
        red_mask = self.get_alphabet_red_mask(hsv)
        blue_mask = self.get_alphabet_blue_mask(hsv)
        color = "RED" if np.count_nonzero(red_mask) > np.count_nonzero(blue_mask) else "BLUE"
        return color

    def get_milkbox_mask(self, hsv, color):
        lower_hue, upper_hue = np.array(DANGER_MILKBOX_BLUE[0]), np.array(DANGER_MILKBOX_BLUE[1])
        if color == "RED":
            lower_hue, upper_hue = np.array(DANGER_MILKBOX_RED[0]), np.array(DANGER_MILKBOX_RED[1])
        h_mask = cv.inRange(hsv, lower_hue, upper_hue)
        # print(color)
        return h_mask  # mask 리턴

    # 안전 지역인지(False) 위험 지역인지(True) detection
    def is_danger(self, src):
        mask_AND = cv.bitwise_and(self.get_s_mask(src, DANGER_ROOM_S), self.get_v_mask(src, DANGER_ROOM_V))
        mask_AND = self.mophorlogy(mask_AND)
        cv.imshow('mask_AND', mask_AND)
        # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
        rate = np.count_nonzero(mask_AND) / (640 * 480)
        rate = int(rate * 1000)
        print(rate)
        return "DANGER" if rate <= DANGER_RATE else "STAIR"


if __name__ == "__main__":
    danger = Danger()

    # 알파벳 글자 인식 부분 촬영
    # 파랑
    # 1031 20:56 촬영본은 제대로 안됨
    # cap = cv.VideoCapture("src/danger/1031_20:56.h264")
    # cap = cv.VideoCapture("src/danger/1027_23:41.h264")

    # 빨강
    # cap = cv.VideoCapture("src/danger/1031_20:35.h264")
    # cap = cv.VideoCapture("src/danger/1031_20:49.h264")
    # cap = cv.VideoCapture("src/danger/1027_23:32.h264")

    # 장애물 집고 나올 때의 영상
    # cap = cv.VideoCapture("src/danger/1031_20:47.h264")
    cap = cv.VideoCapture("src/danger/1031_20:57.h264")


    while cap.isOpened():
        _, src = cap.read()

        if not _:
            print("ret is false")
            break
        blur = cv.GaussianBlur(src, (5, 5), 0)
        cv.imshow('src', src)

        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        # black_mask = danger.get_black_mask(hsv)
        # cv.imshow('danger_region_mask', black_mask)

        milk_crop = danger.get_holding_milkbox_roi(hsv)
        print("들고 있는 중~") if danger.is_holding_milkbox(milk_crop, "BLUE") else print("떨굼")

        if cv.waitKey(10) & 0xFF == ord('q'):
            break

# cap.release()
