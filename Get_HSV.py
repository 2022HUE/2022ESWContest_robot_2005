# -*- coding: utf-8 -*-
import cv2 as cv
import numpy as np
import os
import time
import platform
from Sensor import DataPath
from imutils.video import WebcamVideoStream
from imutils.video import FileVideoStream
from imutils.video import FPS

import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)  # FutureWarning 제거

 
class Test:
    def __init__(self, video: str = ""):
        if video and os.path.exists(video):
            self._cam = FileVideoStream(path=video).start()
        else:
            print('# image processor #', platform.system())
            if platform.system() == "Linux":
                print('eee')
                self._cam = WebcamVideoStream(src=-1).start()
            else:
                self._cam = WebcamVideoStream(src=0).start()
            # cv.imshow("show", self._cam.read())

            print('Acquire Camera ')

        self.fps = FPS()  # FPS
        print(self.fps)  # debuging: fps
        shape = (self.height, self.width, _) = self.get_img().shape
        print("Shape :: ", shape)  # debuging: image shape => height, width
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


    @classmethod
    def mouse_callback(self, event, x, y, flags, param):
        global hsv, lower_blue1, upper_blue1, lower_blue2, upper_blue2, lower_blue3, upper_blue3

        # 마우스 왼쪽 버튼 누를시 위치에 있는 픽셀값을 읽어와서 HSV로 변환합니다.
        if event == cv.EVENT_LBUTTONDOWN:
            print(img_color[y, x])
            color = img_color[y, x]

            one_pixel = np.uint8([[color]])
            hsv = cv.cvtColor(one_pixel, cv.COLOR_BGR2HSV)
            h, s, v = cv.split(hsv)
            # print("H : {}, S: {}, V: {}".format(h, s, v))
            hsv = hsv[0][0]

            # HSV 색공간에서 마우스 클릭으로 얻은 픽셀값과 유사한 필셀값의 범위를 정합니다.
            if hsv[0] < 10:
                print("case1")
                lower_blue1 = np.array([hsv[0]-10+180, 30, 30])
                upper_blue1 = np.array([180, 255, 255])
                lower_blue2 = np.array([0, 30, 30])
                upper_blue2 = np.array([hsv[0], 255, 255])
                lower_blue3 = np.array([hsv[0], 30, 30])
                upper_blue3 = np.array([hsv[0]+10, 255, 255])
                #     print(i-10+180, 180, 0, i)
                #     print(i, i+10)

            elif hsv[0] > 170:
                print("case2")
                lower_blue1 = np.array([hsv[0], 30, 30])
                upper_blue1 = np.array([180, 255, 255])
                lower_blue2 = np.array([0, 30, 30])
                upper_blue2 = np.array([hsv[0]+10-180, 255, 255])
                lower_blue3 = np.array([hsv[0]-10, 30, 30])
                upper_blue3 = np.array([hsv[0], 255, 255])
                #     print(i, 180, 0, i+10-180)
                #     print(i-10, i)
            else:
                print("case3")
                lower_blue1 = np.array([hsv[0], 30, 30])
                upper_blue1 = np.array([hsv[0]+10, 255, 255])
                lower_blue2 = np.array([hsv[0]-10, 30, 30])
                upper_blue2 = np.array([hsv[0], 255, 255])
                lower_blue3 = np.array([hsv[0]-10, 30, 30])
                upper_blue3 = np.array([hsv[0], 255, 255])
                #     print(i, i+10)
                #     print(i-10, i)

            print('HSV 값: ', hsv)
            print("@1", lower_blue1, "~", upper_blue1)
            print("@2", lower_blue2, "~", upper_blue2)
            print("@3", lower_blue3, "~", upper_blue3)



if __name__ == "__main__":
    test = Test(video="testt.h264")
    # test = Test()
    cv.namedWindow('img_color')
    cv.setMouseCallback('img_color', test.mouse_callback)
    
    hsv = 0
    lower_blue1 = 0
    upper_blue1 = 0
    lower_blue2 = 0
    upper_blue2 = 0
    lower_blue3 = 0
    upper_blue3 = 0
    
    ### Debug Run ###
    while True:
        
        img_color = test.get_img()
        
        # 원본 영상을 HSV 영상으로 변환합니다.
        img_hsv = cv.cvtColor(img_color, cv.COLOR_BGR2HSV)

        # 범위 값으로 HSV 이미지에서 마스크를 생성합니다.
        img_mask1 = cv.inRange(img_hsv, lower_blue1, upper_blue1)
        img_mask2 = cv.inRange(img_hsv, lower_blue2, upper_blue2)
        img_mask3 = cv.inRange(img_hsv, lower_blue3, upper_blue3)
        img_mask = img_mask1 | img_mask2 | img_mask3


        # 마스크 이미지로 원본 이미지에서 범위값에 해당되는 영상 부분을 획득합니다.
        img_result = cv.bitwise_and(img_color, img_color, mask=img_mask)


        cv.imshow('img_color', img_color)
        cv.imshow('img_mask', img_mask)
        cv.imshow('img_result', img_result)
    
        if cv.waitKey(1) & 0xFF == ord('q'):
            break
