import cv2 as cv
import sys
import numpy as np

from Motion import Motion
motion = Motion()

cnt_text = 0
# cap = cv2.VideoCapture('./src/S.h264')
cap = cv.VideoCapture('./0925/entrance/entr03-1.mp4')
# none_img = cv2.imread('src/none.jpg',cv2.IMREAD_GRAYSCALE)

if not cap.isOpened():
    print('Video open failed...')
    sys.exit()


def text_masking(text):
  hsv = cv.cvtColor(text, cv.COLOR_BGR2HSV)
  h, s, v = cv.split(hsv)
  
  # 폰트 이미지와 유사하게 만들기 위해 inverse해줌
  ret_s, th_s = cv.threshold(s, 120, 255, cv.THRESH_BINARY_INV + cv.THRESH_OTSU)
  ret_v, th_v = cv.threshold(v, 100, 255, cv.THRESH_BINARY + cv.THRESH_OTSU)
  # _, th_s = cv.threshold(s, 120, 255, cv2.THRESH_BINARY)
  # _, th_v = cv.threshold(v, 100, 255, cv2.THRESH_BINARY_INV)
  text_mask = cv.bitwise_and(th_s, th_v)
  # text_dst = cv.bitwise_and(img_crop, img_crop, mask = text_mask) # remove background

  return text_mask


def match_sam(sam_l, tar):
  target_h, target_w = tar.shape
  ms_score = 100 # matchShape score
  mt_score = 0 # matchTemplate score
  for i in range(5):
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

    # match = min(match, cv2.matchShapes(padding_img, tar, cv2.CONTOURS_MATCH_I3, 0))
    ms = cv.matchShapes(padding_img, tar, cv.CONTOURS_MATCH_I3, 0)
    mt = cv.matchTemplate(padding_img, tar, cv.TM_CCOEFF_NORMED)
    _, maxv, _, _ = cv.minMaxLoc(mt)

    if ms_score > ms:
      ms_score = ms
      matching_img = padding_img

    if maxv > mt_score:
      mt_score = maxv


  return ms_score, mt_score, matching_img

def matching(sam, tar, params):
  # sample_img: list
  match_e = ('E', match_sam(sam[0], tar))
  match_w = ('W', match_sam(sam[1], tar))
  match_s = ('S', match_sam(sam[2], tar))
  match_n = ('N', match_sam(sam[3], tar))

  match_list = [match_e, match_w, match_s, match_n]

  ret_ms = min(match_list, key=lambda x: x[1][0])[0]
  ret_mt = max(match_list, key=lambda x: x[1][1])[0]
  sample_img = max(match_list, key=lambda x: x[1][1])[1][2]
  ret_match_val = round(min(match_list, key=lambda x: x[1])[1][0], 4)

  cv.putText(sample_img,'[sample img] '+ret_mt, (10, 20), cv.FONT_HERSHEY_SIMPLEX, 0.3, (255, 255, 255),1, cv.LINE_AA)
  
  # test print
  # print('sample', ret_match, ret_match_val)
  if ret_match_val < params: return ret_ms, ret_mt, sample_img
  else: return None, ret_mt, sample_img

# font_img matching
font_img = [cv.imread(f'./data/sample/font_img/{x}.jpg', cv.IMREAD_GRAYSCALE) for x in range(4)]
def match_font(font_img,tar, params, name):
  target_h, target_w = tar.shape
  match = 100
  mt_score = 0
  matching_num = 99
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
      # matching_num = i
      # matching_img = padding_img

    if maxv > mt_score:
      mt_score = maxv
      matching_num = i
      matching_img = padding_img


  # test print
  # if matching_num == 0: print('fonts  ', 'E', match)
  # elif matching_num == 1: print('fonts  ', 'W', match)
  # elif matching_num == 2: print('fonts  ', 'S', match)
  # else:print('fonts ', 'N', match)

  # print(match)
  # if match < params: 

  def show(matching_img, ret_val):
    # cv.cvtColor(matching_img, cv2.COLOR_GRAY2BGR)
    cv.rectangle(matching_img, (10,10), (100,20), (255, 255, 255), 10)
    cv.rectangle(matching_img, (10,10), (100,25), (0, 0, 0), 1)
    cv.putText(matching_img,'[font img] '+ret_val, (20, 20), cv.FONT_HERSHEY_SIMPLEX, 0.3, (0, 0, 0),1, cv.LINE_AA)
    return matching_img

  if matching_num == 0: 
    matching_img = show(matching_img, "E")
    return "E", matching_img
  elif matching_num == 1: 
    matching_img = show(matching_img, "W")
    return "W", matching_img
  elif matching_num == 2: 
    matching_img = show(matching_img, "S")
    return "S", matching_img
  elif matching_num == 3:
    matching_img = show(matching_img, "N")
    return "N", matching_img
  else: return None, img_crop
  



# sample E
sample_e = [cv.imread(f'./data/sample/sam_e0{x}.png', cv.IMREAD_GRAYSCALE) for x in range(1, 6)]
# sample W
sample_w = [cv.imread(f'./data/sample/sam_w0{x}.png', cv.IMREAD_GRAYSCALE) for x in range(1, 6)]
# sample N
sample_n = [cv.imread(f'./data/sample/sam_n0{x}.png', cv.IMREAD_GRAYSCALE) for x in range(1, 6)]
# sample S
sample_s = [cv.imread(f'./data/sample/sam_s0{x}.png', cv.IMREAD_GRAYSCALE) for x in range(1, 6)]

sample_list = [sample_e, sample_w, sample_s, sample_n]


while True:
  ret, img = cap.read()
  # img = cv.resize(img, (640, 480))
  if not ret:
    print('No ret') 
    break



  img_copy = img.copy()
  gray = cv.cvtColor(img, cv.COLOR_BGR2GRAY)
  blur = cv.GaussianBlur(gray, (7, 7), 0)
  val = 0
  add = cv.add(blur, val)
  alpha = 0.0
  dst = np.clip((1+alpha)*add - 128*alpha, 0, 255).astype(np.uint8)

  ret,th = cv.threshold(dst, 0, 255, cv.THRESH_BINARY_INV+cv.THRESH_OTSU)
  dst = cv.bitwise_and(dst, dst, mask = th)


  kernel=cv.getStructuringElement(cv.MORPH_RECT,(1,1))
  dst=cv.dilate(dst,kernel,iterations=1)


  edges = cv.Canny(th, 100, 200, apertureSize=3)

  # lines = cv2.HoughLinesP(edges, 1, np.pi / 180, 70, maxLineGap=50)
  
  _, contours1, hierarchy1 = cv.findContours(th,  cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)
  _, contours2, hierarchy2 = cv.findContours(edges, cv.RETR_LIST, cv.CHAIN_APPROX_SIMPLE)

  text_cont = []
  for pos in range(len(contours1)):
    peri = cv.arcLength(contours1[pos], True)
    approx = cv.approxPolyDP(contours1[pos], peri * 0.02, True)
    points = len(approx)
    if peri > 900 and points == 4:
      text_cont.append(contours1[pos])
      # match = matching(cont_s01, contours1[pos])
      # match = matching(cont_n02, contours1[pos])
      cv.drawContours(img, [approx], 0, (0, 255, 255), 1)


  # print(text_cont)
  # for cnt in contours2:
  #   peri = cv.arcLength(contours2[pos], True)
  #   approx = cv.approxPolyDP(contours2[pos], peri * 0.02, True)
  #   points = len(approx)
  #   # if peri > 600 and points == 4:
  #   # text_cont.append(contours2[pos])
  #   cv.drawContours(img, [approx], 0, (255, 0, 255), 1)

  #   cv.drawContours(img, [approx], 0, (255, 0, 255), 1)


  # for pos in range(len(contours1)):
  #   area = cv.contourArea(contours1[pos])
  #   if area > 20000:
  #       contour_pos.append(pos)


  contour_pos = []
  for pos in range(len(text_cont)):
    area = cv.contourArea(text_cont[pos])
    if area > 20000:
      contour_pos.append(pos)

  ##########################################################################
  # text count
  if text_cont: 
    x, y, w, h = cv.boundingRect(text_cont[0])
    img_crop = img_copy[y:y+h, x:x+h]
    # cv2.imshow('tmp', img_crop)
    text_gray = cv.cvtColor(img_crop, cv.COLOR_BGR2GRAY)
    text = img_crop.copy()
    cnt_text += 1
    print('text_cont:', cnt_text) # debuging

  else:
    text = img.copy()
    text_gray = cv.cvtColor(text, cv.COLOR_BGR2GRAY)
    cnt_text = 0
  ##########################################################################
    

  img_crop = img_copy
  for pos in contour_pos:
      # print(pos)
      x, y, w, h = cv.boundingRect(text_cont[pos])
      # print('x, y, w, h:', x, y, w, h)
      img_crop = img_copy[y:y + h, x:x + w]
  
  if cnt_text > 0:
    text_mask = text_masking(text)
    text_edges = cv.Canny(text_mask, 50, 150, apertureSize=3)
    lines = cv.HoughLinesP(text_edges,1,np.pi/180,40, minLineLength=0, maxLineGap=80)

    ms_gray, mt_gray, gimg = matching(sample_list, text_gray, 0.001)
    ms_mask, mt_mask, mimg = matching(sample_list, text_mask, 1) # ???
    match_mask_font, mmimg = match_font(font_img, text_mask, 0.05, 'm')
    match_gray_font , mgimg = match_font(font_img, text_gray, 0.2, 'gf') # ???

    print('match: ', mt_gray, mt_mask, match_gray_font, match_mask_font)

    if cnt_text == 10:
        Motion.test_text(motion, mt_gray)
        break

  
 
  

  if cv.waitKey(1) & 0xFF == ord('q'):
    break
  
  # 출력 디버깅
  sz = text_mask.shape
  # print(sz)
  # h1 = cv.hconcat([text_mask, text_gray])
  # if match_mask_font and sz[0] < 300: 
  #   # print(sz[0], sz[1])
  #   gimg = cv.resize(gimg, (sz[1], sz[0]))
  #   # mmimg = cv.resize(mmimg, sz)
  #   # print(gimg.shape, mmimg.shape, text_mask.shape, text_gray.shape)
  #   h2 = cv.hconcat([gimg, mmimg])
  #   ret = cv.vconcat([h1, h2])
  #   cv.imshow('ret', ret)
  # else:
  #   # cv.imshow('ret', none_img)
  #   pass

  cv.imshow('origin', img)

cap.release()
cv.destroyAllWindows()