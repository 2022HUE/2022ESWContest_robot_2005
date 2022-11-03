import cv2 as cv
import numpy as np
global ALPHABET_GO,ARROW
DANGER_CONST = 10
ROOM_S = 180 #--> if 계단 내려갈 때 수치가 50이면 좋겠어,
ROOM_V = 0
ALPHABET_GO= False
ARROW = ''

class Stair:
    def mophorlogy(self,mask):
        kernel = np.ones((3, 3), np.uint8)
        mask = cv.morphologyEx(mask, cv.MORPH_OPEN, kernel)
        mask = cv.morphologyEx(mask, cv.MORPH_CLOSE, kernel)
        return mask

    def get_s_mask(self,src):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)
        # ret_s, s_bin = cv.threshold(s, ROOM_S, 255, cv.THRESH_BINARY)
        ret_s, s_bin = cv.threshold(s, ROOM_S, 255, cv.THRESH_BINARY)

        s_bin = self.mophorlogy(s_bin) # morphology 연산으로 노이즈 제거
        return s_bin

    def get_v_mask(self,src):
        hsv = cv.cvtColor(src, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)
        ret_v, v_bin = cv.threshold(v, ROOM_V, 255, cv.THRESH_BINARY)
        # morphology 연산으로 노이즈 제거
        v_bin = self.mophorlogy(v_bin)
        return v_bin

    def in_saturation_measurement(self,src):
        mask_AND = cv.bitwise_and(self.get_s_mask(src), self.get_v_mask(src))
        mask_AND = self.mophorlogy(mask_AND)
        return mask_AND

    def in_rect( self,img_color, contours1):
        for pos in range(len(contours1)):
            peri = cv.arcLength(contours1[pos], True)
            approx = cv.approxPolyDP(contours1[pos], peri * 0.1, True)
            points = len(approx)
            area_arr = cv.moments(contours1[pos])
            # x = contours1[pos][0][0][0]  # 알파벳 위치의 x값 좌표 --> 알파벳 중앙에 오게할 때 필요
            rect_y = contours1[pos][0][0][1] #가장 위의 y값 좌표
            rect_x = contours1[pos][0][0][0]  # 가장 위의 y값 좌표

            if peri >= 300 and peri <= 1000 and points == 4 and rect_y < 150:
                area = area_arr["m00"]
                cv.drawContours(img_color, [approx], 0, (0, 255, 255), 2)
                cv.imshow('img',img_color)
                return area, rect_x


    def in_alphabet_center_check(self,x):
        if (x >= 310 and x <= 340) or x//100==0:
            print("전진")   # print("알파벳의 위치는 중앙입니다. 전진하세요")
            return True
        elif x<300: #왼쪽의 여백이 부족하다.
            # print("왼쪽 %d걸음 이동하세요"%(x//100))
            return 'left',x//100 #뒤의 리턴값은 옮겨야할 걸음 수
        elif x>350:
            # print("오른쪽 %d걸음 이동하세요" % (x // 100))
            return 'right', x // 100 #뒤의 리턴값은 옮겨야할 걸음 수

    #전진 하면서 크기 측정 함수
    def in_alphabet_size_calc(self,area, rect_x):
        self.alphabet_center_check(rect_x)

        if area >= 43000:
            print("정지 후 계단 지역으로 회전하세요.")
            return True

        else:
            return False

        cv.imshow('img', img_color)


    #계단 지역 기준 왼쪽 오른쪽 판단하는 함수 #화살표 방향대로 돌아야 함.
    def in_left_rignt(self,img_mask,ARROW,x=0,y=0):
        # rotation = False
        left = int((np.count_nonzero(img_mask[y:y+480,x:x+320]) / (640 * 480))*1000 )
        x =320;
        right = int((np.count_nonzero(img_mask[y:y+480,x:x+320]) / (640 * 480))*1000)

        if ARROW == 'LEFT':
            # 왼쪽 값이 작아질 때 까지 돌아야되고
            ret = left, right, ARROW
        elif ARROW == 'RIGHT':
            ret = right, left, ARROW
            # 오른쪽 값이 작아질 때 까지 돌아야되고

        return ret

    def in_stair_start_rotation(self,a,b,ARROW):
        if a <= 10:  # 이부분 다시 확인.
            print("회전 완료")  # 여기서 함수 끝!!
            return True
        elif a>b:
            return ARROW #회전 방향대로 돌아라
        elif a<b:
            if ARROW=='LEFT': return 'RIGHT'
            else: return 'LEFT'

    def in_stair_down(self,img_mask,x=140,y=100):
        saturation = int((np.count_nonzero(img_mask[y:y+380,x:x+500]) / (640 * 480))*1000 )
        cv.imshow('saturation',img_mask[y:y+480,x:x+640])
        if saturation>=400:
            print("3층 입니다.%d"%saturation)
            return False #내려가기
        elif saturation>=100:
            print("2층입니다.%d"%saturation)
            return False  # 내려가기
        elif saturation<=90:
            print("모두 내려왔습니다.%d"%saturation)
            return True #전진

    # 허프라인 검출
    def HoughLine(self,img_canny, img_color):
        lines = cv.HoughLines(img_canny, 1, np.pi / 45, 80, None, None, None, None)
        if lines is not None:
            for i in range(len(lines)):
                # rho = 거리, scale = 각도
                for rho, theta in lines[i]:
                    # scale = img_color.shape[0] + img_color.shape[1]
                    scale = 1000
                    a = np.cos(theta)
                    b = np.sin(theta)
                    x0 = a * rho
                    y0 = b * rho
                    x1 = int(x0 + scale * (-b))
                    y1 = int(y0 + scale * (a))
                    x2 = int(x0 - scale * (-b))
                    y2 = int(y0 - scale * (a))
                cv.line(img_color, (x1, y1), (x2, y2), (0, 0, 255), 2)


#     # tmp = Stair()
#
# path = "src/stair/1027_23:22.h264"
# cap = cv.VideoCapture(path)
# while cap.isOpened():
#     _, img = cap.read()
#
#     img_hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
#     img_gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
#
#     img_canny = cv.Canny(img, 50, 150)
#
#     blur = cv.GaussianBlur(img_gray, (9, 9), 0)
#     add = cv.add(blur, 0)
#     alpha = 0.0
#     dst = np.clip((1 + alpha) * add - 128 * alpha, 0, 255).astype(np.uint8)
#
#     ret, th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
#     dst = cv.bitwise_or(dst, dst, mask=th)
#
#     kernel = cv.getStructuringElement(cv.MORPH_RECT, (5, 5))
#     dst = cv.dilate(dst, kernel, iterations=1)
#
#     contours1, hierarchy1 = cv.findContours(dst, cv.RETR_LIST, cv.CHAIN_APPROX_TC89_L1)
#
#     x, y, w, h = 0, 0, 600, 400
#     # 알파벳 영역 추적
#     # rect(th[y:y+h, x:x+w], img_color, contours1)
#     Stair.in_rect(img,contours1)
#     # cv.imshow('img',img)
#
#     if cv.waitKey(10) & 0xFF == 27:
#         break
#
# cv.destroyAllWindows()
