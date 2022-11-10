import cv2 as cv
import numpy as np

class Arrow:
    def __init__(self):
        pass
    cnt_arrow = 0
    def get_arrow_info(self, arrow_image, debug):
        # arrow_info_image = cv.cvtColor(origin.copy(), cv.COLOR_GRAY2BGR)
        x, y, w, h = 50, 100, 540, 480
        arrow_image = arrow_image[y:y+h, x:x+w]
        contours, hierarchy = cv.findContours(arrow_image, cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)
         
        if hierarchy is not None:
            global cnt_arrow
            for cnt in contours:
                peri = cv.arcLength(cnt, True)
                approx = cv.approxPolyDP(cnt, peri * 0.02, True)
                area = cv.contourArea(cnt)
                vertices = len(approx) # 꼭짓점 개수

                # area 값 조절로 인식 조절
                cv.rectangle(debug,(50,100),(540-1,480-1),[0,255,0],2)
                cv.drawContours(debug, [approx], 0, (0, 255, 0), 3)
                if 20000< area < 26000 and vertices == 7:
                    # print(cnt_arrow)
                    # Debug: drea contours
                    # cv.drawContours(debug, [approx], 0, (0, 255, 0), 3)


                    x_loc = []
                    for i in range(len(approx)):
                        point = (approx[i][0][0], approx[i][0][1])
                        x_loc.append(point[0])
                
        
                    x_loc.sort()
                    a = x_loc[:2]
                    b = x_loc[len(approx)-2:]
                    a_diff = a[1] - a[0]
                    b_diff = b[1] - b[0]
                    # cnt_arrow += 1
                    # if cnt_arrow == 30:
                    #     # motion 통신
                    #     # if a_diff > b_diff: Motion.test_arrow(motion, 'LEFT')
                    #     # else: Motion.test_arrow(motion, 'RIGHT')

                    #     # local test code
                    #     if a_diff > b_diff: print('LEFT')
                    #     else: print('RIGHT')
                    #     break
                    # return: 화살표 방향: str


                    if a_diff > b_diff: return 'LEFT'
                    else: return 'RIGHT'
                else:
                    cnt_arrow = 0

            return ''

        else:
            return None


# Debug
if __name__ == "__main__":
    arrow = Arrow()
    # path = "src/entrance/entr03-1.mp4"
    path = "src/entrance/1027_23:14.h264"
    cap = cv.VideoCapture(path)

    while cap.isOpened():
        _, img = cap.read()

        if not _:
            break

        img = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        img_copy = img.copy()
        
        blur = cv.GaussianBlur(img, (7, 7), 1)
        val = 10
        alpha = 1.0
        dst = np.clip((1+alpha)*blur - 128*alpha, 0, 255).astype(np.uint8)
        _, img = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV)
        ret = arrow.get_arrow_info(img)
        if ret: print(ret)

        cv.imshow('show', img_copy)
        if cv.waitKey(1) & 0xFF == ord('q'):
            break