# -*- coding: utf-8 -*-
import cv2 as cv
import numpy as np

class Direction:
    def __init__(self): 
        self.matching_num: int
  
    @classmethod
    def text_masking(self, text):
        hsv = cv.cvtColor(text, cv.COLOR_BGR2HSV)
        h, s, v = cv.split(hsv)
        
        # 폰트 이미지와 유사하게 만들기 위해 inverse해줌
        # ret_s, th_s = cv.threshold(s, 120, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
        # ret_v, th_v = cv.threshold(v, 100, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)
        ret_s, th_s = cv.threshold(s, 120, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
        ret_v, th_v = cv.threshold(v, 100, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)
        # cv.imshow("show3", th_s)
        
        # _, th_s = cv.threshold(s, 120, 255, cv2.THRESH_BINARY)
        # _, th_v = cv.threshold(v, 100, 255, cv2.THRESH_BINARY_INV)
        text_mask = cv.bitwise_and(th_s, th_v)
        # text_dst = cv.bitwise_and(img_crop, img_crop, mask = text_mask) # remove background

        # return text_mask
        return th_s

    @classmethod
    def match_sam(self, sam_l, tar, num):
        target_h, target_w = tar.shape
        ms_score = 100 # matchShape score
        mt_score = 0 # matchTemplate score
        for i in range(num):
            sample = sam_l[i]
            h, w = sample.shape
            ratio = w / h

            padding_bottom, padding_right = 0, 0 # init

            if h > target_h or w > target_w:
                interp = cv.INTER_AREA
            else:
                interp = cv.INTER_CUBIC
            
            w = target_w
            h = round(w / ratio)

            if h > target_h:
                h = target_h
                w = round(h*ratio)
            padding_bottom = abs(target_h - h)
            padding_right = abs(target_w - w)

            scaled_img = cv.resize(sample, (w, h), interpolation=interp)
            padding_img = cv.copyMakeBorder(scaled_img, padding_bottom//2, padding_bottom//2, padding_right//2, padding_right//2, 
                                            borderType=cv.BORDER_CONSTANT, value=[255,255,255])

            ms = cv.matchShapes(padding_img, tar, cv.CONTOURS_MATCH_I3, 0)
            mt = cv.matchTemplate(padding_img, tar, cv.TM_CCOEFF_NORMED)
            _, maxv, _, _ = cv.minMaxLoc(mt)

            if ms_score > ms:
                ms_score = ms

            if maxv > mt_score:
                mt_score = maxv


        return mt_score

    @classmethod
    def matching(self, sam, tar, params, option): # [Option] "EWSN", "ABCD"
        # sample_img: list
        n = len(sam[0])
        match1 = (option[0], self.match_sam(sam[0], tar, n))
        match2 = (option[1], self.match_sam(sam[1], tar, n))
        match3 = (option[2], self.match_sam(sam[2], tar, n))
        match4 = (option[3], self.match_sam(sam[3], tar, n))

        match_list = [match1, match2, match3, match4]
        ret_mt = max(match_list, key=lambda x: x[1])[0]
        ret_match_val = round(min(match_list, key=lambda x: x[1])[1], 4)

        if ret_match_val < params: return ret_mt
        else: return ret_mt
    
    @classmethod
    def match_font(self, font_img,tar, danger=False):
        target_h, target_w = tar.shape
        match = 100
        mt_score = 0
        self.matching_num = 99
        for i in range(4):
            sample = font_img[i]
            h, w = sample.shape[:2]
            ratio = w / h

            padding_bottom, padding_right = 0, 0 # init

            if h > target_h or w > target_w:
                interp = cv.INTER_AREA
            else:
                interp = cv.INTER_CUBIC
            
            w = target_w
            h = round(w / ratio)

            if h > target_h:
                h = target_h
                w = round(h*ratio)
            padding_bottom = abs(target_h - h)
            padding_right = abs(target_w - w)

            scaled_img = cv.resize(sample, (w, h), interpolation=interp)
            padding_img = cv.copyMakeBorder(scaled_img, padding_bottom//2, padding_bottom//2, padding_right//2, padding_right//2, 
                                            borderType=cv.BORDER_CONSTANT, value=[255,255,255])

            tmp = cv.matchShapes(padding_img, tar, cv.CONTOURS_MATCH_I3, 0)
            mt = cv.matchTemplate(padding_img, tar, cv.TM_CCOEFF_NORMED)
            _, maxv, _, _ = cv.minMaxLoc(mt)

            if match > tmp:
                match = tmp

            if maxv > mt_score:
                mt_score = maxv
                self.matching_num = i
        if danger:
            if self.matching_num == 0: 
                return "A"
            elif self.matching_num == 1: 
                return "B"
            elif self.matching_num == 2: 
                return "C"
            elif self.matching_num == 3:
                return "D"
            else: return None
        else:
            if self.matching_num == 0: 
                return "E"
            elif self.matching_num == 1: 
                return "W"
            elif self.matching_num == 2: 
                return "S"
            elif self.matching_num == 3:
                return "N"
            else: return None

# Debug
if __name__ == "__main__":
    dir = Direction()
    path = "src/entrance/entr03-1.mp4"
    # path = "src/entrance/1027_/23:14.h264"
    cap = cv.VideoCapture(path)

    while cap.isOpened():
        _, img = cap.read()

        if not _:
            break
        
        img_copy = img.copy()
        gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
        dst = cv.GaussianBlur(gray, (7, 7), 0)

        _,th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV+cv.THRESH_OTSU)
        dst = cv.bitwise_and(img, img, mask = th)

        kernel=cv.getStructuringElement(cv.MORPH_RECT,(1,1))
        dst=cv.dilate(dst,kernel,iterations=1)
        
        contours, hierarchy = cv.findContours(th,  cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)

        roi_contour = []
        for pos in range(len(contours)):
            peri = cv.arcLength(contours[pos], True)
            approx = cv.approxPolyDP(contours[pos], peri * 0.02, True)
            points = len(approx)
            if peri > 900 and points == 4:
                roi_contour.append(contours[pos])
                # cv.drawContours(img, [approx], 0, (0, 255, 255), 1) # Debug: Drawing Contours

        roi_contour_pos = []
        for pos in range(len(roi_contour)):
            area = cv.contourArea(roi_contour[pos])
            if area > 20000:
                roi_contour_pos.append(pos)

        if roi_contour: 
            x, y, w, h = cv.boundingRect(roi_contour[0])
            img_crop = img_copy[y:y+h, x:x+w]
            text_gray = cv.cvtColor(img_crop, cv.COLOR_BGR2GRAY)
            text = img_crop.copy()

            text_mask = dir.text_masking(text)

            mt_gray = dir.matching(dir.sample_list, text_gray, 0.001) # matchTemplate - Gray Scale
            mt_mask = dir.matching(dir.sample_list, text_mask, 1) # matchTemplate - Masking
            match_mask_font = dir.match_font(dir.font_img, text_mask)
            match_gray_font = dir.match_font(dir.font_img, text_gray) # ???

            print('match: ', mt_gray, mt_mask, match_gray_font, match_mask_font) # Debug: printing
            # cv.imshow('show2', img_crop)

            ## image processor 코드에서 지워둔 부분 -> 필요하면 복사하여 사용
            img_crop = img_copy
            for pos in roi_contour_pos:
                x, y, w, h = cv.boundingRect(roi_contour[pos])

                img_crop = img_copy[y:y + h, x:x + w]
            
        else:
            pass
        

        
        cv.imshow('show1', img)
        if cv.waitKey(20) & 0xFF == ord('q'):
            break

# cap.release()
# cv.destroyAllWindows()
