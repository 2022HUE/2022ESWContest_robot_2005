import cv2 as cv
import numpy as np

# 허프라인 검출
def HoughLine(img_canny):
    lines = cv.HoughLines(img_canny, 0.8, np.pi/10, 100, None, None, min_theta=0,max_theta= 100)
    if lines is not None:
        for i in range(len(lines)):
            # rho = 거리, scale = 각도
            print(lines[i])
            for rho, theta in lines[i]:
                scale = img_color.shape[0] + img_color.shape[1]
                # scale = 1000
                a = np.cos(theta)
                b = np.sin(theta)
                x0 = 0
                y0 = b * rho
                x1 = int(x0 + scale * (-b))
                y1 = int(y0 + scale * (a))
                x2 = int(x0 - scale * (-b))
                y2 = int(y0 - scale * (a))

            cv.line(img_color, (x1, y1), (x2, y2), (0, 0, 255), 2)

def ROI(x,y,w,h):
    roi = img_color[y:y+h,x:x+w]
    cv.rectangle(img_color, (0, 0), (w - 1,h - 1), (0, 255, 0))

cap = cv.VideoCapture('src/stair/0925_19:27.h264')  # 제일 쓸만함

while(True):

    ret, img_color = cap.read()
    if ret==False: break
    height, width = img_color.shape[:2]

    img_canny = cv.Canny(img_color,50,100)

    x =0; y=0; w=640; h=300;
    ROI(x,y,w,h)
    HoughLine(img_canny[y:y+h,x:x+w])

    cv.imshow('img_color', img_color)  # 결과 이미지 출력

    if cv.waitKey(10) & 0xFF == 27:
        break

cv.destroyAllWindows()