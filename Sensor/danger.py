import cv2 as cv
import numpy as np

from Sensor.Setting import setting

# # blue 를 찾는 범위 값으로 HSV 이미지 위에 씌울 마스크 생성
# # opencv 에서 hue 값: 0 ~ 180, blue : 120, red : 0 (음수로 내려가면 알아서 변환함)
# # 실제 경기장에서는 어두운 파란색이라 120보다 낮은 100 ~ 115 정도 값인 듯
# DANGER_MILKBOX_BLUE = [[82, 87, 30], [130, 255, 120]]
# DANGER_MILKBOX_RED = [[167, 77, 30], [180, 255, 189]]  # 실제로 hue값 가져왔을 때 167 까지 내려갔음 167 ~ 5
# DANGER_BLACK = [[0, 0, 0], [180, 255, 80]]
#
# # 안쓰는 변수
# # 장애물 인식 용도 s(채도) 기준값
# DANGER_MILKBOX_S = 80
# # 장애물 인식 용도 v(명도) 기준값
# DANGER_MILKBOX_V = 150
#
# # 알파벳 hsv 값, 일단 장애물이랑 같게 설정해둠 바꿔야함
# ALPHABET_RED = [[167, 77, 30], [180, 255, 189]]
# ALPHABET_BLUE = [[82, 87, 30], [130, 255, 120]]
#
# # 위험/계단 지역 판단하는 비율의 기준
# DANGER_STAIR_RATE = 10
# # 위험 지역 인식 용도 s(채도) 기준값
# DANGER_ROOM_S = 170
# # 위험 지역 인식 용도 v(명도) 기준값
# DANGER_ROOM_V = 80
#
# # 장애물 들고 있음을 판단하는 비율의 기준
# # 시야에서 없을 경우 HOLDING_RATE 값 0
# # 시야에 있고 들고 있을 경우 파랑은 최소 15 이상, 빨강은 10 이상
# HOLDING_RATE = 5
#
# # 장애물을 집을 만한 거리에 있다고 판단하는 기준
#
#
# # ---------------------------
#
# # 로봇 시야에서 장애물의 위치 (9개 구역으로 나누기)
# MILKBOX_POS = [((0, 209), (0, 159)), ((210, 429), (0, 159)), ((430, 639), (0, 159)),
#                ((0, 209), (160, 319)), ((210, 429), (160, 319)), ((430, 639), (160, 319)),
#                ((0, 209), (320, 479)), ((210, 429), (320, 479)), ((430, 639), (320, 479))]


class Danger:

    def __init__(self):
        pass

    def mophorlogy(self, mask):
        kernel = np.ones((setting.MORPH_kernel, setting.MORPH_kernel), np.uint8)
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

    # 장애물을 떨어트리지 않고 여전히 들고 있는 지에 대한 체크
    def is_holding_milkbox(self, hsv, color):
        holding_hsv = self.get_holding_milkbox_roi(hsv)
        mask = self.get_milkbox_mask(holding_hsv, color)
        rate = np.count_nonzero(mask) / (180 * 640)
        rate *= 100
        print(rate)
        return True if rate >= setting.HOLDING_RATE else False

    # 잡고 있는 장애물의 크롭 화면 가져오기 (장애물 집었을 때, 최대 y좌표 180)
    # -> 그냥 이 부분 제외하고는 검은색으로 채울 까
    def get_holding_milkbox_roi(self, hsv):
        hsv_crop = hsv.copy()[0:179, 0:639]
        # cv.imshow('holding_milkbox_img', hsv_crop)
        return hsv_crop

    # 장애물에 충분히 근접했는지 (즉, 이제 장애물 집어도 되는지) 확인
    def can_hold_milkbox(self, hsv):
        return True

    # 장애물 위치 파악을 위한 함수
    def get_milkbox_pos(self, img, color, show=False):
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        max_idx = 0
        max_rate = 0
        count = 0
        milkbox_pos = setting.MILKBOX_POS
        # 9개의 구역 중 하나의 구역 리턴 (index로 리턴)
        for idx, pos in enumerate(milkbox_pos):
            mask = self.get_milkbox_mask(hsv[pos[1][0]:pos[1][1], pos[0][0]:pos[0][1]], color)
            cv.imshow('crop mask', mask)
            rate = np.count_nonzero(mask) / ((pos[1][1]-pos[1][0]) * (pos[0][1]-pos[0][0]))
            rate*=100
            print(f"{idx}번째 그냥 rate 값: {rate}")
            if rate > max_rate:
                max_idx = idx
                max_rate = rate
        print("----------------------------")
        print("max_rate 값: ", max_rate)
        if max_idx == 7:
            print("지금 장애물 집자!")

        if show:
            # x축 구분선 두 개
            img = cv.line(img, (0, 159), (639, 159), (0,0,255), 2)
            img = cv.line(img, (0, 319), (639, 319), (0,0,255), 2)
            # y축 구분선 두 개
            img = cv.line(img, (209, 0), (209, 479), (0,0,255), 2)
            img = cv.line(img, (429, 0), (429, 479), (0,0,255), 2)
            cv.imshow('milkbox_position', img)
        return max_idx, count

    def get_black_mask(self, hsv):
        return self.get_color_mask(hsv, setting.DANGER_BLACK)

    def get_color_mask(self, hsv, const):
        lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
        mask = cv.inRange(hsv, lower_hue, upper_hue)
        return mask

    def get_alphabet_red_mask(self, hsv):
        return self.get_color_mask(hsv, setting.ALPHABET_RED)

    def get_alphabet_blue_mask(self, hsv):
        return self.get_color_mask(hsv, setting.ALPHABET_BLUE)

    # 떨어트렸을 때 장애물이 위험지역 내부에 있는 지에 대한 확인


    # 장애물 들고 위험지역에서 벗어났는지 확인 (visualization : imshow() 해줄 건지에 대한 여부)
    def is_out_of_black(self, src, visualization=False):
        begin = (bx, by) = (160, 200)
        end = (ex, ey) = (480, 420)
        mask = self.get_black_mask(src[by:ey, bx:ex])

        rate = np.count_nonzero(mask) / ((ex - bx) * (ey - by))
        rate *= 100

        if visualization:
            cv.imshow("roi", cv.rectangle(src, begin, end, (0, 0, 255), 3))  # hsv 말고 src 여야함
            cv.imshow("mask", mask)
            cv.waitKey(1)
        print(rate)

        return rate <= setting.OUT_DANGER_RATE

    # 파라미터는 src로 받고, hsv로 리턴함
    def get_alphabet_roi(self, src):
        img_copy = src.copy()
        gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY)
        blur = cv.GaussianBlur(gray, (7, 7), 0)
        val = 0
        add = cv.add(blur, val)
        alpha = 0.0 # 1.0으로 변경

        dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)
        ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
        dst = cv.bitwise_and(dst, dst, mask=th)
        cv.imshow('dst', dst)
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
        lower_hue, upper_hue = np.array(setting.DANGER_MILKBOX_BLUE[0]), np.array(setting.DANGER_MILKBOX_BLUE[1])
        if color == "RED":
            lower_hue, upper_hue = np.array(setting.DANGER_MILKBOX_RED[0]), np.array(setting.DANGER_MILKBOX_RED[1])
        h_mask = cv.inRange(hsv, lower_hue, upper_hue)
        # print(color)
        return h_mask  # mask 리턴

    # 계단 지역인지(False) 위험 지역인지(True) detection
    def is_danger(self, hsv):
        mask_AND = cv.bitwise_and(self.get_s_mask(hsv, setting.DANGER_ROOM_S), self.get_v_mask(hsv, setting.DANGER_ROOM_V))
        mask_AND = self.mophorlogy(mask_AND)
        cv.imshow('mask_AND', mask_AND)
        # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
        rate = np.count_nonzero(mask_AND) / (640 * 480)
        rate = int(rate * 1000)
        print(rate)
        return "DANGER" if rate <= setting.DANGER_STAIR_RATE else "STAIR"


if __name__ == "__main__":
    danger = Danger()

    # 알파벳 글자 인식 부분 촬영
    # 파랑
    # 1031 20:56 촬영본은 제대로 안됨
    # cap = cv.VideoCapture("src/danger/1031_20:56.h264")
    # cap = cv.VideoCapture("src/danger/1106_20:02.h264")
    # 1106 20:06, 07 완전 모범 결과 출력
    # cap = cv.VideoCapture("src/danger/1106_20:06.h264")
    # cap = cv.VideoCapture("src/danger/1106_20:07.h264")


    # 빨강
    # cap = cv.VideoCapture("src/danger/1031_20:35.h264")
    # cap = cv.VideoCapture("src/danger/1031_20:49.h264")
    # cap = cv.VideoCapture("src/danger/1027_23:32.h264")

    # 장애물 집고 나올 때의 영상
    # cap = cv.VideoCapture("src/danger/1031_20:47.h264")
    cap = cv.VideoCapture("src/danger/1031_20:57.h264")

    # 장애물 어디있는지 바라볼 때의 시야
    # cap = cv.VideoCapture("src/danger/1031_20:53.h264")
    # cap = cv.VideoCapture("src/danger/1106_21:31.h264")

    while cap.isOpened():
        _, src = cap.read()

        if not _:
            print("ret is false")
            break
        blur = cv.GaussianBlur(src, (5, 5), 0)
        cv.imshow('src', src)

        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        # print("위험 지역 탈출") if danger.is_out_of_black(src, True) else print("아직 위험 지역")
        pos_idx, count = danger.get_milkbox_pos(src, "BLUE", True)

        if cv.waitKey(5) & 0xFF == ord('q'):
            break

cap.release()
