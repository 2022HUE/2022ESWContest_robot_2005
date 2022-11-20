import cv2 as cv
import numpy as np

from Setting import setting


class Danger:

    def __init__(self):
        pass

    @classmethod
    def mophorlogy(self, mask):
        kernel = np.ones((setting.MORPH_kernel, setting.MORPH_kernel), np.uint8)
        mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
        mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
        return mask

    @classmethod
    def get_s_mask(self, hsv, s_value):
        h, s, v = cv.split(hsv)
        ret_s, s_bin = cv.threshold(s, s_value, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        s_bin = self.mophorlogy(s_bin)
        return s_bin

    @classmethod
    def get_v_mask(self, hsv, v_value):
        h, s, v = cv.split(hsv)
        ret_v, v_bin = cv.threshold(v, v_value, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        v_bin = self.mophorlogy(v_bin)
        return v_bin

    # 장애물을 떨어트리지 않고 여전히 들고 있는 지에 대한 체크
    @classmethod
    def is_holding_milkbox(self, src, color, show=False):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        holding_hsv = self.get_holding_milkbox_roi(hsv)
        mask = self.get_milkbox_mask(holding_hsv, color)
        rate = np.count_nonzero(mask) / (180 * 640)
        rate *= 100
        print(rate)

        if show:
            text = "hold" if rate >= setting.HOLDING_RATE else "miss"
            color = (0, 255, 0) if rate >= setting.HOLDING_RATE else (0, 0, 255)
            # 장애물이 위치한 구역 ROI 사각형으로 show
            src = cv.putText(src, "{}".format(text), (0, 210), cv.FONT_HERSHEY_SIMPLEX, 1, color, 2)
            cv.imshow("holding_milkbox_roi", cv.rectangle(src, (0, 0), (639, 179), color, 3))  # hsv 말고 src 여야함
        return True if rate >= setting.HOLDING_RATE else False

    # 잡고 있는 장애물의 크롭 화면 가져오기 (장애물 집었을 때, 최대 y좌표 180)
    # -> 그냥 이 부분 제외하고는 검은색으로 채울 까
    @classmethod
    def get_holding_milkbox_roi(self, hsv):
        hsv_crop = hsv.copy()[0:179, 0:639]
        # cv.imshow('holding_milkbox_img', hsv_crop)
        return hsv_crop

    # 장애물에 충분히 근접했는지 (즉, 이제 장애물 집어도 되는지) 확인
    @classmethod
    def can_hold_milkbox(self, hsv):
        return True

    # 장애물 위치 파악을 위한 함수
    @classmethod
    def get_milkbox_pos(self, src, color, show=False):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        max_idx = 0
        max_rate = 0
        count = 0
        milkbox_pos = setting.MILKBOX_POS
        # 9개의 구역 중 하나의 구역 리턴 (index로 리턴)
        for idx, pos in enumerate(milkbox_pos):
            mask = self.get_milkbox_mask(hsv[pos[1][0]:pos[1][1], pos[0][0]:pos[0][1]], color)
            rate = np.count_nonzero(mask) / ((pos[1][1] - pos[1][0]) * (pos[0][1] - pos[0][0]))
            rate *= 100
            # print("{}번째 그냥 rate 값: {}".format(idx, rate))
            if rate > max_rate:
                max_idx = idx
                max_rate = rate
        # print("----------------------------")
        # print("max_rate 값: ", max_rate)
        # if max_idx == 7:
        #     print("지금 장애물 집자!")

        if show:
            # 장애물이 위치한 구역 crop
            milkbox_crop = src.copy()[milkbox_pos[max_idx][1][0]:milkbox_pos[max_idx][1][1],
                           milkbox_pos[max_idx][0][0]:milkbox_pos[max_idx][0][1]]
            milkbox_crop = cv.putText(milkbox_crop, "milkbox pos : {}".format(max_idx), (0, 20), cv.FONT_HERSHEY_PLAIN,
                                      1, (0, 0, 255), 1)
            cv.imshow('holding milkbox crop', milkbox_crop)
            # x축 구분선 두 개
            src = cv.line(src, (0, 159), (639, 159), (0, 0, 255), 2)
            src = cv.line(src, (0, 319), (639, 319), (0, 0, 255), 2)
            # y축 구분선 두 개
            src = cv.line(src, (209, 0), (209, 479), (0, 0, 255), 2)
            src = cv.line(src, (429, 0), (429, 479), (0, 0, 255), 2)
            cv.imshow('milkbox_position', src)
        return max_idx

    @classmethod
    def get_black_mask(self, hsv):
        return self.get_color_mask(hsv, setting.DANGER_BLACK)

    @classmethod
    def get_color_mask(self, hsv, const):
        lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
        mask = cv.inRange(hsv, lower_hue, upper_hue)
        return mask

    @classmethod
    def get_alphabet_red_mask(self, hsv):
        return self.get_color_mask(hsv, setting.ALPHABET_RED)

    @classmethod
    def get_alphabet_blue_mask(self, hsv):
        return self.get_color_mask(hsv, setting.ALPHABET_BLUE)

    # 떨어트렸을 때 장애물이 위험지역 내부에 있는 지에 대한 확인

    # 장애물 들고 위험지역에서 벗어났는지 확인 (visualization : imshow() 해줄 건지에 대한 여부)
    @classmethod
    def is_out_of_black(self, src, show=False):
        begin = (bx, by) = (160, 200)
        end = (ex, ey) = (480, 420)
        mask = self.get_black_mask(src[by:ey, bx:ex])

        rate = np.count_nonzero(mask) / ((ex - bx) * (ey - by))
        rate *= 100

        if show:
            text = "OUT of Danger" if rate <= setting.OUT_DANGER_RATE else "IN Danger"
            color = (0, 255, 0) if rate <= setting.OUT_DANGER_RATE else (0, 0, 255)
            src = cv.putText(src, "{}".format(text), (160, 180), cv.FONT_HERSHEY_SIMPLEX, 1, color, 2)
            cv.imshow("roi", cv.rectangle(src, begin, end, color, 3))  # hsv 말고 src 여야함
            cv.imshow("mask", mask)
        print(rate)

        return rate <= setting.OUT_DANGER_RATE

    # 파라미터는 src로 받고, hsv로 리턴함
    @classmethod
    def get_alphabet_roi(self, src, option="HSV"):  # [option] GRAY, HSV
        img_copy = src.copy()
        gray = cv.cvtColor(src, cv.COLOR_BGR2GRAY)
        blur = cv.GaussianBlur(gray, (7, 7), 0)
        val = 0
        add = cv.add(blur, val)
        alpha = 0.0  # 1.0으로 변경

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
            if option == "GRAY":
                return text_gray

        else:
            text = src.copy()
            text_gray = cv.cvtColor(text, cv.COLOR_BGR2GRAY)
            return "Failed"  # ROI 인식 실패
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

    @classmethod
    def get_alphabet_color(self, hsv):
        red_mask = self.get_alphabet_red_mask(hsv)
        blue_mask = self.get_alphabet_blue_mask(hsv)
        color = "RED" if np.count_nonzero(red_mask) > np.count_nonzero(blue_mask) else "BLUE"
        return color

    @classmethod
    def get_milkbox_mask(self, hsv, color):
        lower_hue, upper_hue = np.array(setting.DANGER_MILKBOX_BLUE[0]), np.array(setting.DANGER_MILKBOX_BLUE[1])
        if color == "RED":
            lower_hue, upper_hue = np.array(setting.DANGER_MILKBOX_RED[0]), np.array(setting.DANGER_MILKBOX_RED[1])
        h_mask = cv.inRange(hsv, lower_hue, upper_hue)
        # print(color)
        return h_mask  # mask 리턴

    # 계단 지역인지(False) 위험 지역인지(True) detection
    @classmethod
    def is_danger(self, src, show=False):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        mask_AND = cv.bitwise_and(self.get_s_mask(hsv, setting.DANGER_ROOM_S),
                                  self.get_v_mask(hsv, setting.DANGER_ROOM_V))
        mask_AND = self.mophorlogy(mask_AND)
        cv.imshow('mask_AND', mask_AND)
        # 계단일 때 채색 비율: 80~200, 위험지역일 때 비율: 0~10
        rate = np.count_nonzero(mask_AND) / (640 * 480)
        rate = int(rate * 1000)
        print(rate)

        if show:
            text = "DANGER" if rate <= setting.DANGER_STAIR_RATE else "STAIR"
            # 장애물이 위치한 구역 ROI 사각형으로 show
            src = cv.putText(src, "{}".format(text), (10, 30), cv.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 0), 2)
            cv.imshow("Check is Danger or Stair", src)

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
    # cap = cv.VideoCapture("src/danger/1031_20:57.h264")
    cap = cv.VideoCapture("src/danger/1110_22:29.h264")

    # 장애물 어디있는지 바라볼 때의 시야
    # cap = cv.VideoCapture("src/danger/1031_20:53.h264")
    # cap = cv.VideoCapture("src/danger/1106_21:31.h264")

    while cap.isOpened():
        _, img = cap.read()

        if not _:
            print("ret is false")
            break
        blur = cv.GaussianBlur(img, (5, 5), 0)
        cv.imshow('src', img)

        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        # print("위험 지역 탈출") if danger.is_out_of_black(src, True) else print("아직 위험 지역")
        # pos_idx = danger.get_milkbox_pos(img, "BLUE", True)
        # alpha_hsv = danger.get_alphabet_roi(img)
        # if alpha_hsv == "Failed":
        #     print("Failed")
        # else:
        #     print(danger.get_alphabet_color(alpha_hsv))

        milk_mask = danger.get_milkbox_mask(hsv, "RED")
        cv.imshow('milk_mask', milk_mask)

        if cv.waitKey(5) & 0xFF == ord('q'):
            break

# cap.release()