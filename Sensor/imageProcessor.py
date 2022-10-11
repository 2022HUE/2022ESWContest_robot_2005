import cv2 as cv
import numpy as np
import os
import time
import platform
from imutils.video import WebcamVideoStream
from imutils.video import FileVideoStream
from imutils.video import FPS

if __name__ == "__main__":
    from line import Line
    from Setting import setting, LineColor
<<<<<<< HEAD
    from danger import Danger
=======
>>>>>>> 3153e74 (Feat: Image Processing to Yellowline)

else:
    from Sensor.line import Line
    from Sensor.Setting import setting, LineColor
<<<<<<< HEAD
    from danger import Danger

=======
>>>>>>> 3153e74 (Feat: Image Processing to Yellowline)
print(setting.YELLOW_DATA[0], setting.YELLOW_DATA[1])


class ImageProccessor:
    def __init__(self, video: str = ""):
        if video and os.path.exists(video):
            self._cam = FileVideoStream(path=video).start()
        else:
            if platform.system() == "Linux":
                self._cam = WebcamVideoStream(src=-1).start()
            else:
                self._cam = WebcamVideoStream(src=0).start()

        self.fps = FPS()  # FPS
        print(self.fps)  # debuging: fps

        shape = (self.height, self.width, _) = self.get_img().shape
        print(shape)  # debuging: image shape => height, width
        time.sleep(2)

    ########### 이미지 불러오기 ###########
    def get_img(self, show=False):
        img = self._cam.read()
        # 이미지를 받아오지 못하면 종료
        if img is None:
            exit()
        # 이미지를 받아오면 화면에 띄움
        if show:
            cv.imshow("imageProcessor-get_img", img)
            cv.waitKey(1)
        return img

    #######################################

    ########### 기본 공용 함수 ###########
    def blur(self, img):
        return cv.GaussianBlur(img, (7, 7), 1)

    def light(self, img, val):  # 밝기
        arr = np.full(img.shape, (val, val, val), np.uint8)
        return cv.add(img, arr)

    def bright(self, img, alpha):  # 명도
        return np.clip((1 + alpha) * img - 128 * alpha, 0, 255).astype(np.uint8)

    def correction(self, img):
        img = self.blur(img)
        img = self.light(img, 0)
        img = self.bright(img, 0)
        return img

    def RGB2GRAY(self, img):
        return cv.cvtColor(img, cv.COLOR_RGB2GRAY)

    def HSV2BGR(self, hsv):  # hsv 포맷 이미지를 파라미터로 받음
        return cv.cvtColor(hsv, cv.COLOR_HSV2BGR)

    def hsv_mask(self, img):
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)

        _, th_s = cv.threshold(s, 120, 255, cv.THRESH_BINARY)
        _, th_v = cv.threshold(v, 100, 255, cv.THRESH_BINARY_INV)

        th_mask = cv.bitwise_or(th_s, th_v)
        hsv = cv.bitwise_and(hsv, hsv, mask=th_mask)
        return hsv

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

    def get_color_mask(self, hsv, const):
        lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
        mask = cv.inRange(hsv, lower_hue, upper_hue)
        return mask

    #######################################

    ########### LINE DETECTION ###########
    def line_detection(self, show):
        img = self.get_img()
        origin = img.copy()
<<<<<<< HEAD
=======

>>>>>>> 3153e74 (Feat: Image Processing to Yellowline)

        # height, width = img.shape[:2]

        img = self.correction(img)
        hsv = self.hsv_mask(img)

        line_mask = Line.yellow_mask(self, hsv, setting.YELLOW_DATA)
        line_mask = self.HSV2BGR(line_mask)
        line_gray = self.RGB2GRAY(line_mask)
<<<<<<< HEAD

        roi_img = Line.ROI(self, line_gray, self.height, self.width)
        # get Line
        line_arr = Line.hough_lines(self, roi_img, 1, 1 * np.pi / 180, 30, 10, 20)  # 허프 변환
=======
        
        roi_img = Line.ROI(self, line_gray, self.height, self.width)
        # get Line
        line_arr = Line.hough_lines(self, roi_img, 1, 1 * np.pi/180, 30, 10, 20) # 허프 변환
>>>>>>> 3153e74 (Feat: Image Processing to Yellowline)
        line_arr = np.squeeze(line_arr)
        if line_arr != 'None':
            Line.draw_lines(self, origin, line_arr, [0, 0, 255], 2)

            # tmp_zero = np.zeros((origin.shape[0], origin.shape[1], 3), dtype=np.uint8)
            left_line_arr, right_line_arr = Line.slope_filter(self, line_arr)
<<<<<<< HEAD
            left_line, right_line = Line.find_fitline(self, origin, left_line_arr), Line.find_fitline(self, origin,
                                                                                                      right_line_arr)

=======
            left_line, right_line = Line.find_fitline(self, origin, left_line_arr), Line.find_fitline(self, origin, right_line_arr)
            
>>>>>>> 3153e74 (Feat: Image Processing to Yellowline)
            # draw
            if left_line != 'failed_to_find_line' and Line.slope_cal(self, left_line):
                if Line.slope_cal(self, left_line) < 10:
                    # print('수평선!입니다!')
                    Line.draw_fitline(self, origin, left_line, [0, 255, 0])
                elif 85 < Line.slope_cal(self, left_line) < 95:
                    # print('수직선!입니다!')
                    Line.draw_fitline(self, origin, left_line, [0, 255, 255])
            if right_line != 'failed_to_find_line' and Line.slope_cal(self, right_line):
                if Line.slope_cal(self, right_line) < 10:
                    # print('수평선!입니다!')
                    Line.draw_fitline(self, origin, right_line, [0, 255, 0])
                elif 85 < Line.slope_cal(self, right_line) < 95:
                    # print('수직선!입니다!')
                    Line.draw_fitline(self, origin, right_line, [0, 255, 255])
            if show:
                cv.imshow("imageProcessor-get_img", origin)
                cv.waitKey(1) & 0xFF == ord('q')
<<<<<<< HEAD

    ########################################

    ########### DANGER DETECTION ###########
    def danger_detection(self, show):
        img = self.get_img()
        origin = img.copy()

        img = self.correction(img)
        hsv = self.hsv_mask(img)

    # 방 이름이 적힌 글자(A, B, C, D)의 색상 판단
    def get_alphabet_color(self):
        img = self.get_img()
        return Danger.get_alphabet_color(img)

    # 계단 지역인지(False) 위험 지역인지(True) detection
    def is_danger(self):
        img = self.get_img()
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        return Danger.is_danger(hsv)

    # 장애물 들고 위험 지역에서 벗어났는지 확인 (show : imshow() 해줄 건지에 대한 여부)
    def is_out_of_black(self, show=False):
        img = self.get_img()
        return Danger.is_out_of_black(img, show)

    # 장애물을 떨어트리지 않고 여전히 들고 있는 지에 대한 체크
    def is_holding_milkbox(self, color):
        img = self.get_img()
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        return Danger.is_holding_milkbox(hsv, color)

    # 장애물 위치 파악을 위한 함수
    def get_milkbox_pos(self, color):
        img = self.get_img()
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        return Danger.get_milkbox_pos(hsv)

    ########################################
=======
>>>>>>> 3153e74 (Feat: Image Processing to Yellowline)


if __name__ == "__main__":
    img_processor = ImageProccessor(video="src/danger/1027_23:35.mp4")

    while True:
        img_processor.line_detection(show=True)
