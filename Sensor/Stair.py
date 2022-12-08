# -*- coding: utf-8 -*-
import cv2 as cv
import numpy as np
global ALPHABET_GO, ARROW
DANGER_CONST = 10
ROOM_S = 180  # --> if 계단 내려갈 때 수치가 50이면 좋겠어,
ROOM_V = 0
ALPHABET_GO = False
ARROW = ''
MORPH_kernel = 3


class Stair:

    def in_saturation_measurement(self, src, s_vlaue, v_value):
        mask_AND = cv.bitwise_and(self.get_s_mask(
            src, s_vlaue), self.get_v_mask(src, v_value))
        mask_AND = self.mophorlogy(mask_AND)
        return mask_AND

    def in_rect(self, img_color, contours1):
        for pos in range(len(contours1)):
            peri = cv.arcLength(contours1[pos], True)
            approx = cv.approxPolyDP(contours1[pos], peri * 0.1, True)
            points = len(approx)
            area_arr = cv.moments(contours1[pos])
            # x = contours1[pos][0][0][0]  # 알파벳 위치의 x값 좌표 --> 알파벳 중앙에 오게할 때 필요
            rect_y = contours1[pos][0][0][1]  # 가장 위의 y값 좌표
            rect_x = contours1[pos][0][0][0]  # 가장 위의 y값 좌표
            if peri >= 350 and peri <= 1500 and points == 4 and rect_y < 200:
                area = area_arr["m00"]
                cv.drawContours(img_color, [approx], 0, (0, 255, 255), 2)
                return area, rect_x

    def in_alphabet_center_check(self, x, alphabet_area):
        print('x={}'.format(x))
        print('alphabet_area={}'.format(alphabet_area))
        if alphabet_area > 70000:
            return 'False'
        elif (x >= 150 and x <= 380):  # 전진
            return True
        elif x > 380:
            return 'RIGHT'  # , x // 100 #뒤의 리턴값은 옮겨야할 걸음 수
        elif x < 150:  # 왼쪽의 여백이 부족하다.
            return 'LEFT'  # ,x//100 #뒤의 리턴값은 옮겨야할 걸음 수

    # 전진 하면서 크기 측정 함수
    def in_alphabet_size_calc(self, area, size):
        # self.alphabet_center_check(rect_x) # (hr comment)
        if area >= size:
            print("정지 후 계단 지역으로 회전하세요.")  # motion
            return True
        else:
            return False

    # 계단 지역 기준 왼쪽 오른쪽 판단하는 함수 #화살표 방향대로 돌아야 함.

    def in_left_right(self, img_mask, ARROW, x=0, y=0):
        left = int(
            (np.count_nonzero(img_mask[y:y+480, x:x+320]) / (640 * 480))*1000)
        x = 320
        right = int(
            (np.count_nonzero(img_mask[y:y+480, x:x+320]) / (640 * 480))*1000)

        if ARROW == 'LEFT':
            # 왼쪽 값이 작아질 때 까지 돌아야되고
            return left
        elif ARROW == 'RIGHT':
            return right
            # 오른쪽 값이 작아질 때 까지 돌아야되고

    def in_rotation(self, a, comparison, ARROW):  # first_turn, second_turn 에서 쓴다
        # print(a, comparison, ARROW)
        if a <= comparison:  # 이부분 다시 확인.
            return True
        else:
            return ARROW  # 회전 방향대로 돌아라

    def in_stair_down(self, img_mask, ONE_F, TWO_F, THREE_F, x=140, y=100):
        saturation = int(
            (np.count_nonzero(img_mask[y:y+380, x:x+500]) / (640 * 480))*1000)
        print(saturation)
        if saturation >= THREE_F:
            print("3층 입니다.%d" % saturation)
            return False  # 내려가기
        elif saturation >= TWO_F:
            print("2층입니다.%d" % saturation)
            return False  # 내려가기
        elif saturation <= ONE_F:
            print("모두 내려왔습니다.%d" % saturation)
            return True  # 전진

    def in_HoughLine(self, img_canny, linecount=-1):
        # 허프라인 두번째 인자 rho, 세번째 인자 theta , 두 값은 작을수록 오래걸리지만 정교하다.
        lines = cv.HoughLines(img_canny, 0.8, np.pi/20,
                              100, min_theta=0, max_theta=50)
        if lines is not None:
            # 우선 이 부분은 라인에서 처음 인식 되는 라인이 길이가 일정 길이 이상이면 표현하도록 구현됨.
            linecount += 1
            line_length = lines[linecount][0][1]

            if line_length >= 1 and line_length <= 2:  # 허프라인 짧은 노이즈 직선 제거
                return lines
            else:
                print("라인 추출 실패")
                return False  # 라인 추출 실패
        else:
            print("라인 추출 실패")
            return False  # 라인 추출 실패

    def in_draw_stair_line(self, lines, img, w, h, LINE_HIGH):
        cv.rectangle(img, (0, 200), (640-1, 400-1), [0, 255, 0], 2)
        for i in range(len(lines)):
            for rho, theta in lines[i]:  # rho = 거리, scale = 각도
                scale = img.shape[0] + img.shape[1]
                a = 0  # 수평인 직선만 추출된다.
                b = np.sin(theta)  # print(b) +1, -1 반복
                y0 = int(b * rho)
                x1 = int(scale * (-b))
                y1 = int(y0 + scale * (a))
                x2 = int((-scale) * (-b))
                y2 = int(y0 - scale * (a))

                # y1 + h == y2 + h 값이 동일함. print("%d  %d"%(y1+h,y2+h))
                # 라인 그리기.
                cv.line(img, (x1 + w, y1 + h),
                        (x2 + w, y2 + h), [255, 0, 0], 3)
                print(y1 + h)
                if y1 + h < LINE_HIGH:
                    return True
                elif y1 + h > LINE_HIGH:
                    return False

    def in_stair_top(self, hsv, lower_hue, upper_hue):
        y = 200
        x = 0
        h = 280
        w = 640  # ROI 영역 지정을 위해 변수 선언
        mask = cv.inRange(hsv[y:y+h, x:x+w], lower_hue, upper_hue)
        # cv.imshow('mask',mask)
        return mask

    def in_top_processing(self, mask, comparison):
        saturation = int((np.count_nonzero(mask) / (640 * 480))*1000)
        print("꼭대기 전진 채도{},세팅값=200".format(saturation))
        if saturation > comparison:
            print("꼭대기 전진")
            return False
        else:
            print("꼭대기 회전(다음처리해)")
            return True

    def in_stair_obstacle(self, img):
        print("in_stair_obstacle(self,img)")
        y = 250
        x = 200
        h = 200
        w = 310  # ROI 영역 지정을 위해 변수 선언
        # x=0; y=200; w = 640; h = 200  # 계단 영역 ROI지정
        roi = img[y:y + h, x:x + w]

        h, s, v = cv.split(roi)
        blur = cv.GaussianBlur(s, (3, 3), 0)

        ret, th = cv.threshold(
            s, 10, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)

        dst = cv.bitwise_or(s, s, mask=th)

        img_canny = cv.Canny(roi, 10, 100)

        lines = cv.HoughLinesP(img_canny, 0.9, np.pi /
                               200, 68, minLineLength=1, maxLineGap=1000)
        # print(lines)
        cv.rectangle(img, (200, 250), (510, 450), [0, 255, 0], 2)
        if lines is not None:
            line_length = lines[0][0][1]
            if line_length <= 100:
                # print(line_length)
                for line in lines:
                    x1, y1, x2, y2 = line[0]
                    x = [x1, x2]
                    y = [y1, y2]

                    slope, intercept = abs(np.polyfit(x, y, 1))
                    print(slope)
                    if slope >= 0.2:
                        cv.line(roi, (x1, y1), (x2, y2), (0, 255, 0), 1)
                        print("self.stair_obstacle(): TURE")
                        return True
                    else:
                        print("self.stair_obstacle(): False")
                        return False
            else:
                print("self.stair_obstacle(): False")
                return False
        else:
            print("self.stair_obstacle(): False")
            return False
