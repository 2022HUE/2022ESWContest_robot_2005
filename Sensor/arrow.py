import sys
import cv2 as cv
import numpy as np

from Motion import Motion
motion = Motion()

cnt_arrow = 0
def get_arrow_info(origin, arrow_image):
    arrow_info_image = cv.cvtColor(origin.copy(), cv.COLOR_GRAY2BGR)
    _, contours, hierarchy = cv.findContours(arrow_image, cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)
    
    if hierarchy is not None:
        global cnt_arrow
        for cnt in contours:
            peri = cv.arcLength(cnt, True)
            approx = cv.approxPolyDP(cnt, peri * 0.02, True)

            # cv2.drawContours(arrow_info_image, [approx], 0, (0, 255, 0), 3)
            area = cv.contourArea(cnt)
            vertices = len(approx) # 꼭짓점 개수
            # area 값 조절로 인식 조절
            if area > 30000 and vertices == 7:
                print(cnt_arrow)
                cv.drawContours(origin, [approx], 0, (0, 255, 0), 3)
                cv.drawContours(arrow_info_image, [approx], 0, (0, 255, 0), 3)

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


    # img = cv.resize(img, (640, 480))
    # _, img = cv.threshold(img, 0, 255, cv.THRESH_BINARY_INV)
    # origin = arrow[i]
    img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
    img_copy = img.copy()
    
    blur = cv.GaussianBlur(img, (7, 7), 1)
    val = 10
    # arr = np.full(blur.shape, (val, val, val), np.uint8)
    # add = cv2.add(blur, arr)
    alpha = 1.0
    dst = np.clip((1+alpha)*blur - 128*alpha, 0, 255).astype(np.uint8)
    _, img = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV)

    # arrow_image = get_filter_arrow_image(img)
    arrow_info_image, ret_arrow = get_arrow_info(img_copy, img)
    if (ret_arrow != None):

        cv.putText(img_copy, 'origin img', (20, 30), cv.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2, cv.LINE_AA)
        cv.putText(arrow_info_image, 'arrow: '+ret_arrow, (20, 30), cv.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2, cv.LINE_AA)

        img_copy = cv.cvtColor(img_copy, cv.COLOR_GRAY2BGR)
        ret = cv.hconcat([img_copy, arrow_info_image])
        cv.imshow("ret", ret)
        # cv.imshow("ret_", img) # 마스킹 바이너리 이미지
    # else: print('################################################')

    # print(f"img[]: {ret_arrow}",)

    
    if cv.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv.destroyAllWindows()


