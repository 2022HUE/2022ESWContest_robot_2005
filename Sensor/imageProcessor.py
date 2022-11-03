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
    from Stair import Stair #파일명 / class이름
    from Setting import setting, LineColor

else:
    from Sensor.line import Line
    from Sensor.Stair import Stair
    from Sensor.Setting import setting, LineColor
print(setting.YELLOW_DATA[0], setting.YELLOW_DATA[1])


class ImageProccessor:
    def __init__(self, video : str = ""):
        if video and os.path.exists(video):
            self._cam = FileVideoStream(path=video).start()
        else:
            if platform.system() == "Linux":
                self._cam = WebcamVideoStream(src=-1).start()
            else:
                self._cam = WebcamVideoStream(src=0).start()


        self.fps = FPS() # FPS
        print(self.fps) # debuging: fps

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
    def light(self, img, val): # 밝기
        arr = np.full(img.shape, (val, val, val), np.uint8)
        return cv.add(img, arr)
    def bright(self, img, alpha): # 명도
        return np.clip((1+alpha)*img - 128*alpha, 0, 255).astype(np.uint8)
    def correction(self, img):
        img = self.blur(img)
        img = self.light(img, 0)
        img = self.bright(img, 0)
        return img

    def RGB2GRAY(self, img):
        return cv.cvtColor(img, cv.COLOR_RGB2GRAY)
    def HSV2BGR(self, hsv): # hsv 포맷 이미지를 파라미터로 받음
        return cv.cvtColor(hsv, cv.COLOR_HSV2BGR)
    def hsv_mask(self, img):
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)

        _, th_s = cv.threshold(s, 120, 255, cv.THRESH_BINARY)
        _, th_v = cv.threshold(v, 100, 255, cv.THRESH_BINARY_INV)

        th_mask = cv.bitwise_or(th_s, th_v)
        hsv = cv.bitwise_and(hsv, hsv, mask = th_mask)
        return hsv
    #######################################

    
    ########### LINE DETECTION ###########
    def line_detection(self, show):
        img = self.get_img()
        origin = img.copy()

        # height, width = img.shape[:2]
        
        img = self.correction(img)
        hsv = self.hsv_mask(img)

        line_mask = Line.yellow_mask(self, hsv, setting.YELLOW_DATA)
        line_mask = self.HSV2BGR(line_mask)
        line_gray = self.RGB2GRAY(line_mask)
        
        roi_img = Line.ROI(self, line_gray, self.height, self.width)
        # get Line
        line_arr = Line.hough_lines(self, roi_img, 1, 1 * np.pi/180, 30, 10, 20) # 허프 변환
        line_arr = np.squeeze(line_arr)
        if line_arr != 'None':
            Line.draw_lines(self, origin, line_arr, [0, 0, 255], 2)

            # tmp_zero = np.zeros((origin.shape[0], origin.shape[1], 3), dtype=np.uint8)
            left_line_arr, right_line_arr = Line.slope_filter(self, line_arr)
            left_line, right_line = Line.find_fitline(self, origin, left_line_arr), Line.find_fitline(self, origin, right_line_arr)
            
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

    # img_processor.rect(self, img, th[y:y + h, x:x + w], contours1, show=True)
    def rect(self,show):
        img = img_processor.get_img()
        img_gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)

        blur = cv.GaussianBlur(img_gray, (9, 9), 0)
        add = cv.add(blur, 0)
        alpha = 0.0
        dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)

        ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
        dst = cv.bitwise_or(dst, dst, mask=th)

        kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
        dst = cv.dilate(dst, kernel, iterations=1)

        contours1, hierarchy1 = cv.findContours(dst, cv.RETR_LIST, cv.CHAIN_APPROX_TC89_L1)

        return Stair.in_rect(self, img, contours1)

    def alphabet_size_calc(self,area, rect_x):
        img = img_processor.get_img()
        return Stair.in_alphabet_size_calc(self, area, rect_x)

    def alphabet_center_check(self,x):
        return Stair.in_alphabet_center_check(self,x)
    def mophorlogy(self,mask):
        kernel = np.ones((3, 3), np.uint8)
        mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
        mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
        return mask

    def get_s_mask(self,src):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)
        ret_s, s_bin = cv.threshold(s, setting.STAIR_S, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        s_bin = self.mophorlogy(s_bin)
        return s_bin

    def get_v_mask(self,src):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)
        ret_v, v_bin = cv.threshold(v, setting.ROOM_V, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        v_bin = self.mophorlogy(v_bin)
        return v_bin

    # def saturation_measurement(self):
    #     img= img_processor.get_img()
    #     stair_saturation_check_mask = Stair.in_saturation_measurement(self,img)
    #     return stair_saturation_check_mask

        # 계단 지역 기준 왼쪽 오른쪽 판단하는 함수 #화살표 방향대로 돌아야 함.

    def stair_start_rotation(self,a,b):
        return Stair.in_stair_start_rotation(self,a,b,setting.ARROW)
    def left_rignt(self):
        img = img_processor.get_img()
        img_mask = Stair.in_saturation_measurement(self, img)
        return Stair.in_left_rignt(self,img_mask,setting.ARROW)

    def stair_down(self):
        img = img_processor.get_img()
        img_mask = Stair.in_saturation_measurement(self, img) # -->s_mask가 50 이면 좋겠어
        return Stair.in_stair_down(self,img_mask)

if __name__ == "__main__":
    img_processor = ImageProccessor(video="src/stair/1027_23:26.h264")

    while True:
        # alphabet_area, rect_x = img_processor.rect(show=True)
        # alphabet_center_ret = img_processor.alphabet_center_check(rect_x)
        # if alphabet_center_ret==True:
        #     size_calc_ret = img_processor.alphabet_size_calc(alphabet_area,rect_x)
        #
        #     if size_calc_ret==True:
        #         print("계단 지역으로 회전")
        # stair_saturation_check_mask = img_processor.saturation_measurement()
        # a,b,ALLOW = img_processor.left_rignt() # 알파벳 오른쪽 왼쪽 확인하는 함수.,
        # stair_start_rotation 로봇에 모션줄 때 setting.allow 하면 안됨
        # img_processor.stair_start_rotation(a, b)#미완성시 돌아야 할 방향 & 회전완료 => TRUE
        img_processor.stair_down() #계단 내려가기

        if cv.waitKey(20) & 0xFF == 27:
            break