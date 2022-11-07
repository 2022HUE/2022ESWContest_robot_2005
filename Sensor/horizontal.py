import cv2 as cv
import numpy as np
STAIR_BLUE = [[102, 30, 30], [130, 255, 255]]

# 허프라인 검출
# 허프라인을 구역 내에만 적용하고 싶지만, 영역을 roi로 지정해서 허프라인을 실행 후 img_color에 표시하게 되면,
# 영역 내의 라인 수치들이 img_color에 +되지 않은 채로 제일 위쪽에 나타나는 문제 발생. ==> img_color에 라인을 그릴 때 해당 수치값을 더해줌.
def HoughLine(img,img_canny,x,y,w,h,linecount=-1):
    img_canny= img_canny[y:y+h,x:x+w]
    hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
    stair_top(hsv, STAIR_BLUE)
    # 허프라인 두번째 인자 rho, 세번째 인자 theta , 두 값은 작을수록 오래걸리지만 정교하다.
    lines = cv.HoughLines(img_canny, 0.8, np.pi/20, 100, None, None, min_theta=0, max_theta= 50)
    if lines is not None:
        #우선 이 부분은 라인에서 처음 인식 되는 라인이 길이가 일정 길이 이상이면 표현하도록 구현됨.
        linecount+=1
        line_length=lines[linecount][0][1]

        if line_length>=1 and line_length<=2: #허프라인 짧은 노이즈 직선 제거
            draw_stair_line(lines,img_color,w,h,300)
        return True #라인 추출 성공
    else:
        # hsv = cv.cvtColor(img, cv.COLOR_BGR2HSV)
        # get_color_mask(hsv, STAIR_BLUE)
        return False #라인 추출 실패


def stair_top(hsv, const):
    lower_hue, upper_hue = np.array(const[0]), np.array(const[1])
    y = 200; x = 0; h = 200; w = 640
    mask = cv.inRange(hsv[y:y+h,x:x+w], lower_hue, upper_hue)
    top = int((np.count_nonzero(mask) / (640 * 480)) * 1000)
    return top

def draw_stair_line(lines,img,w,h,line_height):
    for i in range(len(lines)):
        for rho, theta in lines[i]: # rho = 거리, scale = 각도
            scale = img.shape[0] + img.shape[1]
            a = 0  # 수평인 직선만 추출된다.
            b = np.sin(theta) # print(b) +1, -1 반복
            x0 = 0
            y0 = int(b * rho)
            x1 = int( scale * (-b))
            y1 = int(y0 + scale * (a))
            x2 = int((-scale) * (-b))
            y2 = int(y0 - scale * (a))
            # y1 + h == y2 + h 값이 동일함. print("%d  %d"%(y1+h,y2+h))
            cv.line(img_color, (x1 + w, y1 + h), (x2 + w, y2 + h),[255,0,0],3)  # 라인 그리기.

            if y1+h < line_height:

                return True
            elif y1+h > line_height:
                
                return False

def ROI(x,y,w,h):
    cv.rectangle(img_color, (x, y), (w - 1,h - 1), (0, 255, 0),2)

cap = cv.VideoCapture('src/stair/1027_23:26.h264')  # 제일 쓸만함
# cap = cv.VideoCapture('src/stair/1006_18:40.h264')  # 제일 쓸만함

while(True):
    ret, img_color = cap.read()
    if ret==False: break
    height, width = img_color.shape[:2]
    # img_color = cv.GaussianBlur(img_color, (3,3), 0)
    lines_update=[]
    img_canny = cv.Canny(img_color,20,200)
    temp = np.zeros((img_color.shape[0], img_color.shape[1], 3), dtype=np.uint8)
    # temp = np.zeros((image.shape[0], image.shape[1], 3), dtype=np.uint8)

    x =0; y=200; w=640; h=400;
    ROI(x,y,w,h)
    h=200 #여기도 400 으로 하게되면 200+400으로 인식해서 이상한 영역이 잡힘
    # (h=200의 뜻은 200부터 (200+200=)400까지 라는 뜻)
    HoughLine(img_color,img_canny,x,y,w,h)


    cv.imshow('img_color', img_color)  # 결과 이미지 출력

    if cv.waitKey(10) & 0xFF == 27:
        break

cv.destroyAllWindows()

