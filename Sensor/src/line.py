import sys, os
import cv2 as cv
import numpy as np

# sys.path.append(os.path.dirname(os.path.abspath(os.path.dirname(__file__))))
# from Motion import Motion
# motion = Motion.Motion()

def blur(img):
    return cv.GaussianBlur(img, (7, 7), 1)
def light(img, val): # 밝기
    arr = np.full(img.shape, (val, val, val), np.uint8)
    return cv.add(img, arr)
def bright(img, alpha): # 명도
    return np.clip((1+alpha)*img - 128*alpha, 0, 255).astype(np.uint8)
def grayscale(img):
    return cv.cvtColor(img, cv.COLOR_RGB2GRAY)

def correction(img):
    img = blur(img)
    img = light(img, 0)
    img = bright(img, 0)

def yellow_mask(hsv, lower_data, upper_data):
    lower = lower_data
    upper = upper_data
    mask = cv.inRange(hsv, lower, upper)

    kernel = cv.getStructuringElement(cv.MORPH_RECT, (3,3))

    mask = cv.morphologyEx(mask, cv.MORPH_DILATE, kernel, iterations=3)
    mask = cv.bitwise_and(hsv, hsv, mask = mask)

    return mask

video = "./src/line/1003_line1.mp4"
cap = cv.VideoCapture(video)

while True:
    _, img = cap.read()
    # img = cv2.flip(img, 1)

    if not _:
        print('No ret') 
        break

    cv.imshow('tmp', img)
    
    if cv.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv.destroyAllWindows()


