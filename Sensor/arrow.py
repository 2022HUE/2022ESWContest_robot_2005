import sys
import cv2 as cv
import cv2
import numpy as np

from Motion import Motion
motion = Motion()

cnt_arrow = 0
def get_arrow_info(origin, arrow_image):
    arrow_info_image = cv2.cvtColor(origin.copy(), cv2.COLOR_GRAY2BGR)
    _, contours, hierarchy = cv2.findContours(arrow_image, cv2.RETR_LIST, cv2.CHAIN_APPROX_SIMPLE)
    
    if hierarchy is not None:
        global cnt_arrow
        for cnt in contours:
            peri = cv2.arcLength(cnt, True)
            approx = cv2.approxPolyDP(cnt, peri * 0.02, True)

            # cv2.drawContours(arrow_info_image, [approx], 0, (0, 255, 0), 3)
            area = cv2.contourArea(cnt)
            vertices = len(approx) # 꼭짓점 개수
            # area 값 조절로 인식 조절
            if area > 30000 and vertices == 7:
                print(cnt_arrow)
                cv2.drawContours(origin, [approx], 0, (0, 255, 0), 3)
                cv2.drawContours(arrow_info_image, [approx], 0, (0, 255, 0), 3)

                x_loc = []
                for i in range(len(approx)):
                    point = (approx[i][0][0], approx[i][0][1])
                    x_loc.append(point[0])
                    # cv2.circle(arrow_info_image, point, 2, (0, 0, 255), 3)
            
    
                x_loc.sort()
                # print(x_loc)
                a = x_loc[:2]
                b = x_loc[len(approx)-2:]
                a_diff = a[1] - a[0]
                b_diff = b[1] - b[0]
                cnt_arrow += 1
                if cnt_arrow == 30:
                    if a_diff > b_diff: Motion.test_arrow(motion, 'LEFT')
                    else: Motion.test_arrow(motion, 'RIGHT')
                if a_diff > b_diff: return arrow_info_image, 'left'
                else: return arrow_info_image, 'right'
            else:
                cnt_arrow = 0

        return arrow_info_image, 'none'

    else:
        return None, None


# video = "data/220922_N.mp4"
video = "0925/entrance/entr03.h264"
cap = cv.VideoCapture(video)

if not cap.isOpened():
    print('Video open failed...')
    sys.exit()

while True:
    _, img = cap.read()
    # img = cv2.resize(img, (320, 240))
    # img = cv2.flip(img, 1)

    if not _:
        print('No ret') 
        break


    # img = cv2.resize(img, (640, 480))
    # _, img = cv2.threshold(img, 0, 255, cv2.THRESH_BINARY_INV)
    # origin = arrow[i]
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    img_copy = img.copy()
    
    blur = cv2.GaussianBlur(img, (7, 7), 1)
    val = 10
    # arr = np.full(blur.shape, (val, val, val), np.uint8)
    # add = cv2.add(blur, arr)
    alpha = 1.0
    dst = np.clip((1+alpha)*blur - 128*alpha, 0, 255).astype(np.uint8)
    _, img = cv2.threshold(dst, 0, 255, cv2.THRESH_BINARY_INV)

    # arrow_image = get_filter_arrow_image(img)
    arrow_info_image, ret_arrow = get_arrow_info(img_copy, img)
    if (ret_arrow != None):

        cv2.putText(img_copy, 'origin img', (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2, cv2.LINE_AA)
        cv2.putText(arrow_info_image, 'arrow: '+ret_arrow, (20, 30), cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2, cv2.LINE_AA)

        img_copy = cv2.cvtColor(img_copy, cv2.COLOR_GRAY2BGR)
        ret = cv2.hconcat([img_copy, arrow_info_image])
        cv2.imshow("ret", ret)
        # cv2.imshow("ret_", img) # 마스킹 바이너리 이미지
    # else: print('################################################')

    # print(f"img[]: {ret_arrow}",)

    
    if cv.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv.destroyAllWindows()


