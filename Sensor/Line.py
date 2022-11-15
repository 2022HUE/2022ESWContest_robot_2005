import cv2 as cv
import numpy as np

# sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
# from Motion import Motion
# motion = Motion.Motion()

class Line:
    def __init__(self):
        pass

    # video = "./src/line/1003_line2.mp4"
    # cap = cv.VideoCapture(video)

    def yellow_mask(self, hsv, color_data):
        lower = np.array(color_data[0], np.uint8)
        upper = np.array(color_data[1], np.uint8)
        # print(color_data, lower, upper)
        mask = cv.inRange(hsv, lower, upper)

        kernel = cv.getStructuringElement(cv.MORPH_RECT, (3,3))

        mask = cv.morphologyEx(mask, cv.MORPH_DILATE, kernel, iterations=3)
        mask = cv.bitwise_and(hsv, hsv, mask = mask)

        return mask

    ### 직선 인식 관련 함수 ###
    # 캐니
    def canny(self, img, low, high):
        return cv.Canny(img, low, high)
    # 허프 변환
    def hough_lines(self, img, rho, theta, threshold, min_line_len, max_line_gap):
        rho, theta = 1, 1 * np.pi/180
        threshold = 30
        min_line_len, max_line_gap = 10, 30
        lines = cv.HoughLinesP(img, rho, theta, threshold, np.array([]), 
                                minLineLength=min_line_len, maxLineGap=max_line_gap)
        if type(lines) == type(None):
            return 'None'
        else: 
            return lines

    def ROI(self, img, height, width, debug, color3=(255,255,255), color1=255):
        vertices = np.array([[(0,height-100),(0, height/2), (width, height/2), (width,height-100)]], dtype=np.int32)
        mask = np.zeros_like(img)

        if len(img.shape) > 2: # Color 이미지
            color = color3
        else: # 흑백 이미지
            color = color1
            
        cv.fillPoly(mask, vertices, color)
        cv.fillPoly(debug, vertices, color)
        ROI_image = cv.bitwise_and(img, mask)
        return ROI_image

    # 선 그리기
    def draw_lines(self, img, lines, color=[0, 0, 255], thickness=2):
        for line in lines:
            x1, y1, x2, y2 = line[0], line[1], line[2], line[3]
            cv.line(img, (x1, y1), (x2, y2), color, thickness)

    # 대표선 그리기
    def draw_fitline(self, img, lines, color, thickness=10):
        cv.line(img, (lines[0], lines[1]), (lines[2], lines[3]), color, thickness)

    # 대표선 찾기
    def get_fitline(self, img, f_lines): 
        lines = np.squeeze(f_lines)
        print(lines)
        if lines.size == 0: return False
        else:
            if lines.size > 8:
                lines = lines.reshape(lines.shape[0]*2,2)
                output = cv.fitLine(lines,cv.DIST_L2,0, 0.01, 0.01)
                vx, vy, x, y = output[0], output[1], output[2], output[3]
                x1, y1 = int(((img.shape[0]-1)-y)/vy*vx + x) , img.shape[0]-1
                x2, y2 = int(((img.shape[0]/2+50)-y)/vy*vx + x) , int(img.shape[0]/2+50)
                res = [x1,y1,x2,y2]
                return res
            else: return False
            
    
    def is_center(self, img, line):
        x1, y1, x2, y2 = line[0], line[1], line[2], line[3]
        cv.rectangle(img,(260,100),(420-1,480-1),[0,255,0],2) # roi
        if 260 <= x1 < 420 and 260 <= x2 < 420:
            return True
        else:
            if x1 < 260 or x2 < 260:
                return "MOVE_LEFT" # 왼쪽으로 이동 필요
            else:
                return "MOVE_RIGHT" # 오른쪽로 이동 필요


    # 기울기 필터링
    def slope_cal(self, line):
        if line != 'None':
            slope = (np.arctan2(line[1] - line[3], line[0] - line[2]) * 180) / np.pi
            return slope
    
    def slope_filter(self, line_arr):
        # print(len(line_arr))
        if len(line_arr) <= 4: return "None", "None", "None"
        slope = (np.arctan2(line_arr[:,1] - line_arr[:,3], line_arr[:,0] - line_arr[:,2]) * 180) / np.pi
        # print(slope)
        # 수직/수평 필터링
        # 수평 기울기 range
        line_arr = line_arr[np.abs(slope)<181]
        slope = slope[np.abs(slope)<181]
        # 수직 기울기 range
        line_arr = line_arr[np.abs(slope)>85]
        slope = slope[np.abs(slope)>85]
        # 필터링한 좌우 직선 배열
        # left_line_arr = line_arr[(slope>0),:]
        # left_line_arr = left_line_arr[:,None]
        # right_line_arr = line_arr[(slope<0),:]
        # right_line_arr = right_line_arr[:,None]
        # print(np.abs(slope)<105)
        tmp = np.abs(slope)<120
        if set(list(tmp)) == {True}: 
            state = "VERTICAL"
            print('수직')
        elif set(list(tmp)) == {False}:
            state = "HORIZON" 
            print('수평')
        else:
            state = "BOTH"
            print("BOTH")
        # print(tmp)
        slope_ = np.abs(slope)
        horizon_arr = line_arr[(slope_>169),:]
        horizon_arr = horizon_arr[:,None]
        vertical_arr = line_arr[(slope_<120),:]
        vertical_arr = vertical_arr[:,None]
        
        return state, horizon_arr, vertical_arr

    #########################################################################

