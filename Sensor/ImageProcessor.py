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
    from Danger import Danger
    from Stair import Stair
    from Setting import setting

else:
    from Sensor.Line import Line
    from Sensor.Arrow import Arrow
    from Sensor.Direction import Direction
    from Sensor.Danger import Danger
    from Sensor.Stair import Stair
    from Sensor.Setting import setting
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
            Line.draw_lines(self, origin, line_arr, [0, 0, 255], 2)

            # tmp_zero = np.zeros((origin.shape[0], origin.shape[1], 3), dtype=np.uint8)
            left_line_arr, right_line_arr = Line.slope_filter(self, line_arr)
            left_line, right_line = Line.find_fitline(self, origin, left_line_arr), Line.find_fitline(self, origin, right_line_arr)
            
            # init
            horizon = False
            vertical = False

            # check line "Horizontal or Vericality"
            if left_line and Line.slope_cal(self, left_line):
                if Line.slope_cal(self, left_line) < 10:
                    # print('수평선!입니다!') # Debug
                    # Line.draw_fitline(self, origin, left_line, [0, 255, 0]) # Debug
                    horizon = True
                elif 85 < Line.slope_cal(self, left_line) < 95:
                    # print('수직선!입니다!') # Debug
                    # Line.draw_fitline(self, origin, left_line, [0, 255, 255]) # Debug
                    vertical = True

            if right_line and Line.slope_cal(self, right_line):
                if Line.slope_cal(self, right_line) < 10:
                    # print('수평선!입니다!') # Debug
                    # Line.draw_fitline(self, origin, right_line, [0, 255, 0]) # Debug
                    horizon = True
                elif 85 < Line.slope_cal(self, right_line) < 95:
                    # print('수직선!입니다!') # Debug
                    # Line.draw_fitline(self, origin, right_line, [0, 255, 255]) # Debug
                    vertical = True

            ########### [Option] Show ##########
            if show:
                cv.imshow("show", origin)
                cv.waitKey(1) & 0xFF == ord('q')
            ####################################

            if horizon and vertical: return "BOTH" # 수직, 수평선 둘 다 인식
            elif horizon: return "HORIZON" # 수직선만 인식
            elif vertical: return "VERTICAL" # 수평선만 인식
            else: return False

        else: # 라인 자체를 인식 못할 경우 False 리턴
            return False
        

        
    ########### ENTRANCE PROCESSING ###########
    # 화살표 방향 인식 후 리턴
    def get_arrow(self, show):
        img = self.get_img()
        origin = img.copy()

        img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        img = self.blur(img, setting.ARROW_BLUR)
        img = self.bright(img, setting.ARROW_BRIGHT)
        _, img = cv.threshold(img, 0, 255, cv.THRESH_BINARY_INV)
        ret_arrow = Arrow.get_arrow_info(self, img)
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

        kernel=cv.getStructuringElement(cv.MORPH_RECT,(1,1))
        dst=cv.dilate(dst,kernel,iterations=1)
        
        contours, hierarchy = cv.findContours(th,  cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)

        roi_contour = []
        for pos in range(len(contours)):
            peri = cv.arcLength(contours[pos], True)
            approx = cv.approxPolyDP(contours[pos], peri * 0.02, True)
            points = len(approx)
            if peri > 900 and points == 4:
                roi_contour.append(contours[pos])
                # cv.drawContours(img, [approx], 0, (0, 255, 255), 1) # Debug: Drawing Contours

        roi_contour_pos = []
        for pos in range(len(roi_contour)):
            area = cv.contourArea(roi_contour[pos])
            if area > 20000:
                roi_contour_pos.append(pos)

        if roi_contour: 
            x, y, w, h = cv.boundingRect(roi_contour[0])
            img_crop = origin[y:y+h, x:x+h]
            text_gray = cv.cvtColor(img_crop, cv.COLOR_BGR2GRAY)
            # text = img_crop.copy()

            '''
            [Issue]
            현재 mt_gray(gray처리된 roi 부분을 matchTemplate 비교)값을 대표로 리턴함.
            mt_gray, mt_mask가 정확도가 가장 높으며 두 값은 항상 유사한 결과를 가짐.
            font 이미지와 비교한 2가지 값도 정확도가 낮지는 않으나, 가끔 로봇의 고개 각도에 따라 튀는 값이 나올 때가 있음
            '''
            mt_gray = Direction.matching(self, Direction.sample_list, text_gray, 0.001, "EWSN") # 1. matchTemplate - Gray Scale
            # mt_mask = dir.matching(dir.sample_list, text_mask, 1, "EWSN") # 2. matchTemplate - Masking
            # text_mask = dir.text_masking(text)
            # match_mask_font = dir.match_font(dir.font_img, text_mask) # 3. font <-> masking
            # match_gray_font = dir.match_font(dir.font_img, text_gray) # 4. font <-> gray scale
            
            # print('match: ', mt_gray, mt_mask, match_gray_font, match_mask_font) # Debug: printing

            ########### [Option] Show ##########
            if show:
                cv.imshow("show", origin)
                # cv.imshow("show", img_crop)
                cv.waitKey(1) & 0xFF == ord('q')
            ####################################

            print(mt_gray) # Debug: print return value
            return mt_gray
        else: # False
            return ''
    





    ############ DANGER PROCESSING #############
    # 계단 지역인지(False) 위험 지역인지(True) detection
    def is_danger(self):
        img = self.get_img()
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        return Danger.is_danger(hsv) # [return] DANGER / STAIR
 
    # 방 이름이 적힌 글자(A, B, C, D)의 색상 판단
    def get_alphabet_color(self):
        img = self.get_img()
        return Danger.get_alphabet_color(img) # [return] RED / BLUE

    # 방 이름(알파벳) 인식
    def get_alphabet_name(self, show):
        img = self.get_img()

        roi = Danger.get_alphabet_roi(self, img, "GRAY")
        arr_a = [cv.imread('src/alphabet_data/a{}.png'.format(x), cv.IMREAD_GRAYSCALE) for x in range(4)]
        arr_b = [cv.imread('src/alphabet_data/b{}.png'.format(x), cv.IMREAD_GRAYSCALE) for x in range(4)]
        arr_c = [cv.imread('src/alphabet_data/c{}.png'.format(x), cv.IMREAD_GRAYSCALE) for x in range(4)]
        arr_d = [cv.imread('src/alphabet_data/d{}.png'.format(x), cv.IMREAD_GRAYSCALE) for x in range(4)]
        arr = [arr_a, arr_b, arr_c, arr_d]
        if roi != "Failed":
            mt_gray = Direction.matching(Direction, arr, roi, 0.001, "ABCD")
            print(mt_gray)
            ########### [Option] Show ##########
            if show:
                cv.imshow("show", roi)
            ####################################
            return mt_gray # [return] 인식한 알파벳: A, B, C, D
        return False # 인식 실패

    # 장애물 들고 위험 지역에서 벗어났는지 확인 (show : imshow() 해줄 건지에 대한 여부)
    def is_out_of_black(self, show=False):
        img = self.get_img()
        return Danger.is_out_of_black(img, show) # [return] T/F

    # 장애물을 떨어트리지 않고 여전히 들고 있는 지에 대한 체크
    def is_holding_milkbox(self, color):
        img = self.get_img()
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        return Danger.is_holding_milkbox(hsv, color) # [return] T/F

    # 장애물 위치 파악을 위한 함수
    def get_milkbox_pos(self, color):
        img = self.get_img()
        hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        return Danger.get_milkbox_pos(hsv)
    
    ############# DANGER PROCESSING #############
    




    ############# STAIR PROCESSING #############
    # 로봇의 회전 완료 여부 반환
    def alphabet_to_stair_rotation(self, show):  # 계단 지역 기준 왼쪽 오른쪽 판단하는 함수 #화살표 방향대로 돌아야 함.
        img = img_processor.get_img()
        s_mask = Stair.in_saturation_measurement(self, img,setting.ROOM_S,setting.ROOM_V)
        cur_s_val = Stair.in_left_rignt(self,s_mask,setting.ARROW) # (Current_saturation_value) setting.Arrow: 화살표 방향
        ret = Stair.in_rotation(self,cur_s_val,setting.ALPHABET_ROTATION, setting.ARROW)
        '''motion
        # T: (회전완료) 머리 아래 30도 변경
        # LEFT: 왼쪽으로 회전
        # RIGHT: 오른쪽으로 회전
        '''
        print("alphabet_to_stair_rotation", ret) # Debug
        return ret
    
    def stair_to_alphabet_rotation(self, show):  # 계단 지역 기준 왼쪽 오른쪽 판단하는 함수 #화살표 방향대로 돌아야 함.
        img = img_processor.get_img()
        s_mask = Stair.in_saturation_measurement(self, img,setting.ROOM_S,setting.ROOM_V)
        s_val = int((np.count_nonzero(s_mask) / (640 * 480)) * 1000)
        if setting.ARROW =="LEFT": arrow_ ="RIGHT"
        else: arrow_ = "LEFT"
        ret = Stair.in_rotation(self,setting.STAIR_ROTATION, s_val, arrow_)
        '''motion
        # T: (회전완료) 머리 아래 30도 변경
        # LEFT: 왼쪽으로 회전
        # RIGHT: 오른쪽으로 회전
        '''
        print("stair_to_alphabet_rotation", ret) # Debug
        return ret
    
    def rect(self):
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

        contours, hierarchy = cv.findContours(dst, cv.RETR_LIST, cv.CHAIN_APPROX_TC89_L1)
        alphabet_area, rect_x = Stair.in_rect(self, img, contours)

        return alphabet_area, rect_x

    def alphabet_center_check(self,alphabet_area, rect_x):
        is_center = Stair.in_alphabet_center_check(self,rect_x)
        if is_center == True: # [return] True
            sz_check = Stair.in_alphabet_size_calc(self, alphabet_area)
            '''motion
            # T: 계단방향으로 회전
            # F: 전진
            '''
            return sz_check
        else: # [return] LEFT, RIGHT
            '''motion
            # LEFT: 왼쪽으로 이동
            # RIGHT: 오른쪽으로 이동
            '''
            return is_center

    def stair_top(self):
        img = img_processor.get_img()
        hsv = cv.cvtColor(img,cv.COLOR_BGR2HSV)
        lower_hue, upper_hue = np.array(setting.STAIR_BLUE[0]), np.array(setting.STAIR_BLUE[1])
        b_mask = Stair.in_stair_top(self,hsv,lower_hue,upper_hue) # roi blue mask
        top_ret = int((np.count_nonzero(b_mask) / (640 * 480)) * 1000)
        if top_ret >= setting.STAIR_UP:
            print("2층이다 올라가") #2층->3층 올라가는 모션 실행 후
            ''' motion
            cnt = 1
            2층->3층 올라가기
            샤샤샥 

            cnt = 2
            잘 올라갔는지 판단
            '''
            #stair_stage_check는 외부에서 계단 올라간거 체크하는 변수 만들어야 함.
            # if img_processor.stair_top() > setting.STAIR_UP and stair_stage_check ==2 :
            #     print("정상 도달")
            return True
        else:
            print("샤샤샤샥") # motion: 2층에서 샤샤샥
            return False
    
    # 계단 내려가기
    def stair_down(self):
        img = img_processor.get_img()
        img_mask = Stair.in_saturation_measurement(self, img,setting.STAIR_S,setting.ROOM_V) # -->s_mask가 50 이면 좋겠어
        ''' motion 
        # T: 방 탈출
        # F: 계단 내려가기 '''
        return Stair.in_stair_down(self,img_mask, setting.ONE_F, setting.TWO_F, setting.THREE_F)

    # 허프라인 잡히면 2층으로 올라가기
    def draw_stair_line(self):
        img = img_processor.get_img()
        x, y, w, h = 0, 200, 640, 200
        # x=0; y=200; w = 640; h = 200  # 계단 영역 ROI지정
        roi = img[y:y+h, x:x+w]
        img_canny = cv.Canny(roi, 20, 200)
        lines = cv.HoughLines(img_canny, 0.8, np.pi/20, 100, None, None, min_theta=0, max_theta= 50)
        if lines is not None:
            line_length=lines[0][0][1]

            if line_length>=1 and line_length<=2: #허프라인 짧은 노이즈 직선 제거
                ret = Stair.in_draw_stair_line(self,lines,img,w,h,setting.LINE_HIGH) 
                ''' motion 
                # T: 1층 -> 2층 계단 올라가기 + 샤샤샥 -> draw_stair_line() 재실행
                # F: 샤샤샥 '''
                return ret # bool(T/F)
            else: 
                print("라인 추출 실패")
                return False  # 라인 추출 실패
        else:
            print("라인 추출 실패")
            # cv.imshow('simg',img_canny)
            return self.stair_top() # 라인 추출 실패
    ############# STAIR PROCESSING #############

if __name__ == "__main__":
    ### Debug Path List ###
    # entrance
    entr01 = "src/entrance/entr03-1.mp4"
    entr02 = "src/entrance/1027_23:14.h264"
    # line
    line01 = "src/line/1003_line2.mp4"
    line02 = "src/entrance/1027_23:19.h264"
    # danger
    danger01 = "src/danger/1027_23:41.h264" # A
    danger02 = "src/danger/1031_20:56.h264" # C
    danger03 = "src/danger/1027_23:32.h264" # D
    danger04 = "src/danger/1031_20:49.h264" # B
    img_processor = ImageProccessor(video=danger02)
    
    ### Debug Run ###
    while True:
        # img_processor.get_arrow(show=True)
        # img_processor.get_direction(show=True)
        # img_processor.is_line_horizon_vertical(show=True)
        img_processor.get_alphabet_name(show=True)

        ### stair ###
        img_processor.alphabet_to_stair_rotation(show=False)
        alphabet_area, rect_x = img_processor.rect()
        img_processor.alphabet_center_check(rect_x)
        img_processor.alphabet_size_calc(alphabet_area)
        img_processor.stair_to_alphabet_rotation(show=False)
        img_processor.draw_stair_line()
        img_processor.stair_down()
