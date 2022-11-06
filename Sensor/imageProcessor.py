import cv2 as cv
import numpy as np
import os
import time
import platform
from imutils.video import WebcamVideoStream
from imutils.video import FileVideoStream
from imutils.video import FPS
  
if __name__ == "__main__":
    from Line import Line
    from Arrow import Arrow
    from Direction import Direction
    from Setting import setting, LineColor

else:
    from Sensor.Line import Line
    from Sensor.Arrow import Arrow
    from Sensor.Direction import Direction
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
    def blur(self, img, val):
        return cv.GaussianBlur(img, (val, val), 1)
    def light(self, img, val): # 밝기
        arr = np.full(img.shape, (val, val, val), np.uint8)
        return cv.add(img, arr)
    def bright(self, img, alpha): # 명도
        return np.clip((1+alpha)*img - 128*alpha, 0, 255).astype(np.uint8)
    def correction(self, img, val):
        img = self.blur(img, val)
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
    # 라인이 수평선인지 수직선인지 return해줌
    def is_line_horizon_vertical(self, show):
        img = self.get_img()
        origin = img.copy()

        img = self.correction(img, 7)
        hsv = self.hsv_mask(img)
        line_mask = Line.yellow_mask(self, hsv, setting.YELLOW_DATA)
        line_mask = self.HSV2BGR(line_mask)
        line_gray = self.RGB2GRAY(line_mask)
        
        roi_img = Line.ROI(self, line_gray, self.height, self.width)
        # get Line
        line_arr = Line.hough_lines(self, roi_img, 1, 1 * np.pi/180, 30, 10, 20) # 허프 변환
        line_arr = np.squeeze(line_arr)
        if line_arr != 'None':

            # tmp_zero = np.zeros((origin.shape[0], origin.shape[1], 3), dtype=np.uint8)
            left_line_arr, right_line_arr = Line.slope_filter(self, line_arr)
            if left_line_arr == "None": return False
            left_line, right_line = Line.find_fitline(self, origin, left_line_arr), Line.find_fitline(self, origin, right_line_arr)
            Line.draw_lines(self, origin, line_arr, [0, 0, 255], 2)
            
            # init
            horizon = False
            vertical = False

            # check line "Horizontal or Vericality"
            if left_line and Line.slope_cal(self, left_line):
                if Line.slope_cal(self, left_line) < 10:
                    # print('수평선!입니다!') # Debug
                    Line.draw_fitline(self, origin, left_line, [0, 255, 0]) # Debug
                    horizon = True
                if 85 < Line.slope_cal(self, left_line) < 105:
                    # print('수직선!입니다!') # Debug
                    Line.draw_fitline(self, origin, left_line, [0, 255, 255]) # Debug
                    vertical = True
                print(int(Line.slope_cal(self, left_line)))

            if right_line and Line.slope_cal(self, right_line):
                # [ISSUE] 수평선 각도 179.xx 일 때도 있음
                if Line.slope_cal(self, right_line) < 10:
                    # print('수평선!입니다!') # Debug
                    Line.draw_fitline(self, origin, right_line, [0, 255, 0]) # Debug
                    horizon = True
                if 85 < Line.slope_cal(self, right_line) < 105:
                    # print('수직선!입니다!') # Debug
                    Line.draw_fitline(self, origin, right_line, [0, 255, 255]) # Debug
                    vertical = True
                print(int(Line.slope_cal(self, right_line)))

            ########### [Option] Show ##########
            if show:
                cv.imshow("show", origin)
                cv.waitKey(10) & 0xFF == ord('q')
            ####################################

            if horizon and vertical: 
                print("BOTH")
                return "BOTH" # 수직, 수평선 둘 다 인식
            elif horizon: 
                print("HORIZON")
                return "HORIZON" # 수직선만 인식
            elif vertical: 
                print("VERTICAL")
                return "VERTICAL" # 수평선만 인식
            else:
                if left_line: 
                    # print('left', Line.slope_cal(self, left_line))
                    return "LEFT"
                if right_line: 
                    # print('right', Line.slope_cal(self, right_line))
                    return "RIGHT"
                # return False

        else: # 라인 자체를 인식 못할 경우 False 리턴
            print('false')
            # return False
        

        
    ########### ENTRANCE PROCESSING ###########
    # 화살표 방향 인식 후 리턴
    def get_arrow(self, show):
        img = self.get_img()
        origin = img.copy()

        img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        img = self.blur(img, setting.ARROW_BLUR)
        img = self.bright(img, setting.ARROW_BRIGHT)
        _, img = cv.threshold(img, 0, 255, cv.THRESH_BINARY_INV)
        ret_arrow = Arrow.get_arrow_info(self, img, origin)
        if ret_arrow: print(ret_arrow) # Debug: print arrow
 
        ########### [Option] Show ##########
        if show:
            cv.imshow("show", origin)
            cv.waitKey(1) & 0xFF == ord('q')
        ####################################

        return ret_arrow
    
    # 방위 글자 인식 후 방위 리턴
    def get_direction(self, show):
        img = self.get_img()
        origin = img.copy()
        dir = Direction

        gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        dst = self.blur(gray, setting.DIR_BLUR)

        _,th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV+cv.THRESH_OTSU)
        dst = cv.bitwise_and(img, img, mask = th)
        edges = cv.Canny(th, 100, 200, apertureSize=3)

        kernel=cv.getStructuringElement(cv.MORPH_RECT,(1,1))
        dst=cv.dilate(dst,kernel,iterations=1)
        
        contours, hierarchy = cv.findContours(th,  cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)
        contours_, _ = cv.findContours(edges,  cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)

        roi_contour = []
        for pos in range(len(contours)):
            peri = cv.arcLength(contours[pos], True)
            approx = cv.approxPolyDP(contours[pos], peri * 0.02, True)
            points = len(approx)
            if peri > 900 and points == 4:
                roi_contour.append(contours[pos])
                cv.drawContours(img, [approx], 0, (0, 255, 255), 1) # Debug: Drawing Contours
        for pos in range(len(contours_)):
            peri = cv.arcLength(contours_[pos], True)
            approx = cv.approxPolyDP(contours_[pos], peri * 0.02, True)
            points = len(approx)
            if peri > 900 and points == 4:
                # roi_contour.append(contours_[pos])
                cv.drawContours(img, [approx], 0, (255, 255, 0), 1) # Debug: Drawing Contours

        roi_contour_pos = []
        for pos in range(len(roi_contour)):
            area = cv.contourArea(roi_contour[pos])
            if area > 20000:
                roi_contour_pos.append(pos)

        if roi_contour: 
            x, y, w, h = cv.boundingRect(roi_contour[0])
            img_crop = origin[y:y+h, x:x+h]
            text_gray = cv.cvtColor(img_crop, cv.COLOR_BGR2GRAY)
            text = img_crop.copy()

            '''
            [Issue]
            현재 mt_gray(gray처리된 roi 부분을 matchTemplate 비교)값을 대표로 리턴함.
            mt_gray, mt_mask가 정확도가 가장 높으며 두 값은 항상 유사한 결과를 가짐.
            font 이미지와 비교한 2가지 값도 정확도가 낮지는 않으나, 가끔 로봇의 고개 각도에 따라 튀는 값이 나올 때가 있음
            '''
            
            mt_gray = Direction.matching(dir, Direction.sample_list, text_gray, 0.001) # 1. matchTemplate - Gray Scale
            text_mask = Direction.text_masking(dir, text)
            mt_mask = Direction.matching(dir, Direction.sample_list, text_mask, 1) # 2. matchTemplate - Masking
            match_mask_font = Direction.match_font(dir, Direction.font_img, text_mask) # 3. font <-> masking
            match_gray_font = Direction.match_font(dir, Direction.font_img, text_gray) # 4. font <-> gray scale
            
            print('match: ', mt_gray, mt_mask, match_gray_font, match_mask_font) # Debug: printing

            ########### [Option] Show ##########
            if show:
                cv.imshow("show", text_gray)
                # cv.imshow("show", img_crop)
                cv.waitKey(1) & 0xFF == ord('q')
            ####################################

            # print(mt_gray, match_gray_font) # Debug: print return value
            return mt_gray
        else: # False
            return ''

if __name__ == "__main__":
    ### Debug Path List ###
    # entrance
    arrow_path01 = "src/entrance/entr03-1.mp4"
    arrow_path02 = "src/entrance/1027_23:14.h264"
    arrow_path03 = "src/entrance/1027_23:19.h264"
    # line
    line_path01 = "src/line/1003_line2.mp4"
    img_processor = ImageProccessor(video=arrow_path02)
    
    ### Debug Run ###
    while True:
        img_processor.get_arrow(show=True)
        # img_processor.get_direction(show=True)
        # img_processor.is_line_horizon_vertical(show=True)
