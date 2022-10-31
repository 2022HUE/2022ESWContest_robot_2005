import cv2 as cv
import numpy as np

# 허프라인 검출
# 허프라인을 구역 내에만 적용하고 싶지만, 영역을 roi로 지정해서 허프라인을 실행 후 img_color에 표시하게 되면,
# 영역 내의 라인 수치들이 img_color에 +되지 않은 채로 제일 위쪽에 나타나는 문제 발생. ==> img_color에 라인을 그릴 때 해당 수치값을 더해줌.
def HoughLine(img_canny,x,y,w,h,linecount=-1):
    img_canny= img_canny[y:y+h,x:x+w]

    # 허프라인 두번째 인자 rho, 세번째 인자 theta , 두 값은 작을수록 오래걸리지만 정교하다.
    lines = cv.HoughLines(img_canny, 0.8, np.pi/20, 100, None, None, min_theta=0, max_theta= 20)
    print(lines)
    if lines is not None:
        #우선 이 부분은 라인에서 처음 인식 되는 라인이 길이가 일정 길이 이상이면 표현하도록 구현됨.
        linecount+=1
        line_length=lines[linecount][0][1]

        # print('line=%s' % lines)
        ban  = np.ravel(lines, order='C') #다차원의 반환값을 일차원 배열로 바꿈.
        # print(ban)
        # 첫 번째 값= rho, 두 번째 값= theta
        # 우리가 원하는 값은 theta
        # 허프라인이 뭘 반환하는지 모르겠네,,
        # 4.712389, 10.995575, 17.27876 이런식으로 반환되는데 이는 미분관련 숫자라는디?
        try:
            ban = ban[1::2]
            ban1 = ban[0::2]
            ban2 = ban[1::2]
            ban = ban2 - ban1
            # print(ban2)
        except:
            pass
        if line_length>=1 and line_length<=2: #허프라인 짧은 노이즈 직서 제거
            draw_stair_line(lines,img_color,x,y,w,h)

def draw_stair_line(lines,img_canny,x,y,w,h):
    for i in range(len(lines)):
        for rho, theta in lines[i]: # rho = 거리, scale = 각도
            scale = img_canny.shape[0] + img_canny.shape[1]
            a = 0  # 수평인 직선만 추출된다.
            b = np.sin(theta) # print(b) +1, -1 반복
            x0 = 0
            y0 = int(b * rho)
            x1 = int( scale * (-b))
            y1 = int(y0 + scale * (a))
            x2 = int((-scale) * (-b))
            y2 = int(y0 - scale * (a))
            # b = np.sin(theta)
            # y0 = b * rho
            # x1 = int(scale * (-b))
            # x2 = -x1
            # y1, y2 = int(y0), int(y0)
            # lines_update.append([x1 + w, y1 + h, x2 + w, y2 + h])
            draw_fit_line(img_color, [x1 + w, y1 + h, x2 + w, y2 + h])  # 라인 그리기.
    # # print(lines_update)
    # fitline = get_fitline(img_color, lines_update )
    # draw_fit_line(img_color,fitline)

        # cv.line(img_color, (x1 + w, y1 + h), (x2 + w, y2 + h), (0, 0, 255), 2)

def get_fitline(img, f_lines):  # 대표선 구하기 ((모르겠어!!!))
        lines = np.squeeze(f_lines)
        print(lines)
        if len(lines)==0:return 'failed_to_find_line'
        else:
            if len(lines)>0:
                print(lines)
                lines = lines.reshape(lines.shape[0] * 2,2)
                output = cv.fitLine(lines, cv.DIST_L2, 0, 0.01, 0.01)
                vx, vy, x, y = output[0], output[1], output[2], output[3]
                x1, y1 = int(((img.shape[0] - 1) - y) / vy * vx + x), img.shape[0] - 1
                x2, y2 = int(((img.shape[0] / 2 + 100) - y) / vy * vx + x), int(img.shape[0] / 2 + 100)

                result = [x1, y1, x2, y2]

                return result
            else:
                return 'faied_to_find_line'
def draw_fit_line(img_color, lines, color=[255, 0, 0], thickness=3):  # line 그리기
        cv.line(img_color, (lines[0], lines[1]), (lines[2], lines[3]), color, thickness)

def ROI(x,y,w,h):
    roi = img_color[y:y+h,x:x+w]
    cv.rectangle(img_color, (x, y), (w - 1,h - 1), (0, 255, 0))

# cap = cv.VideoCapture('src/stair/1027_23:21.h264')  # 제일 쓸만함
cap = cv.VideoCapture('src/stair/1006_18:40.h264')  # 제일 쓸만함
# cap = cv.VideoCapture('src/stair/1027_23:24.h264')  # 제일 쓸만함

while(True):
    ret, img_color = cap.read()
    if ret==False: break
    height, width = img_color.shape[:2]
    img_color = cv.GaussianBlur(img_color, (3,3), 0)
    lines_update=[]
    img_canny = cv.Canny(img_color,20,200)
    temp = np.zeros((img_color.shape[0], img_color.shape[1], 3), dtype=np.uint8)
    # temp = np.zeros((image.shape[0], image.shape[1], 3), dtype=np.uint8)

    x =0; y=200; w=640; h=400;
    ROI(x,y,w,h)
    h=200 #여기도 400 으로 하게되면 200+400으로 인식해서 이상한 영역이 잡힘
    # (h=200의 뜻은 200부터 (200+200=)400까지 라는 뜻)
    HoughLine(img_canny,x,y,w,h)


    cv.imshow('img_color', img_color)  # 결과 이미지 출력

    if cv.waitKey(10) & 0xFF == 27:
        break

cv.destroyAllWindows()

# #라벨링 진행
# nlabels, labels, stats, centroids = cv.connectedComponentsWithStats(img_mask[y:y+h,x:x+w]) #흰색과 검은색 분리.
#
# #가장 큰 영역이 파란색 공이라고 가정할 것이다.
# max = 1000
# max_index = -1
#
# for i in range(nlabels):
#     if i < 1:
#         continue
#     area = stats[i, cv.CC_STAT_AREA]
#
#     if area > max: # 노이즈 제거
#         max_index = i
#     # else:
#     #     max_index = -1
#
# # print(area)
# if max_index != -1 :
#     center_x = int(centroids[max_index, 0])
#     center_y = int(centroids[max_index, 1])
#     left = stats[max_index, cv.CC_STAT_LEFT]
#     top = stats[max_index, cv.CC_STAT_TOP]
#     width = stats[max_index, cv.CC_STAT_WIDTH]
#     height = stats[max_index, cv.CC_STAT_HEIGHT]
#
#     cv.rectangle(img_color, (left, top), (left + width, top + height), (0, 0, 255), 5)
