# -*- coding: utf-8 -*-
from enum import Enum, auto
from Core.Robo import Robo
from Setting import cur, setting
import time


class Act(Enum):
    START = auto()  # 공통
    FIND_LINE = auto()

    ### danger ###
    # (예시)출
    SPEAK_DANGER = auto()
    DETECT_ALPHABET = auto()  # 방이름 감지
    DETECT_FIRST_MILKBOX_POS = auto()  # 장애물 초기 위치 찾기
    WALK_TO_MILKBOX = auto()  # 장애물 찾기
    OUT_OF_DANGER = auto()  # 위험지역 밖으로 장애물 옮기기
    REGRAB_MILKBOX = auto()  # 떨어진 장애물 다시 잡기 -> WALK_TO_MILKBOX로 충분할 것 같아서 일단 안씀
    SET_OUT_DIRECTION = auto()
    KICK_MILKBOX = auto()  # 자꾸 장애물을 떨어트릴 경우 이 방법 사용 (발로 차거나 치우기 동작 수행)
    BACK_TO_LINE = auto()
    EXIT = auto()  # 공통


class MissionDanger:
    act: Act = Act.START
    robo: Robo = Robo()
    miss: int = 0
    limits: int = 5
    alphabet_color: str
    alphabet_name: str
    milkbox_pos: int
    head_angle: int = 70
    holding: bool
    first_milkbox_pos: int = cur.FIRST_MILKBOX_POS
    check_backline: int = 0
    out_direction: str = "RIGHT"  # 위험지역 탈출 방향
    
    turn_cnt: int=0

    def init_robo(self, robo: Robo):
        self.robo = robo

    @classmethod
    def is_okay_grab_milkbox(self):
        # print("head angle: ", self.head_angle)
        if self.head_angle == 70:
            self.head_angle = 45
            # motion : 고개 각도 45도로 설정
            self.robo._motion.set_head("DOWN", 45)
            time.sleep(1)
        elif self.head_angle == 45:
            self.head_angle = 30
            # motion : 고개 각도 30도로 설정
            self.robo._motion.set_head("DOWN", 30)
            time.sleep(1)
        else:
            # 집어야하는 우유곽 말고 다른 색상이 잡히는 경우 치우기 모션 수행 (아직 필요성을 못느껴서 안넣었음)
            is_okay = self.robo._image_processor.can_hold_milkbox(
                Robo.alphabet_color)
            # 장애물 잡기 동작 씹히는 에러 발생하여 sleep 줄 필요가 있음
            time.sleep(1)
            if not is_okay:
                # motion : 앞으로 걷기 동작 수행
                self.robo._motion.walk("FORWARD")
                time.sleep(1)
            else:
                if is_okay == True:
                    # motion : 장애물 잡기 동작 수행
                    self.robo._motion.grab("UP")
                    # time.sleep(3)
                    # motion : 장애물 집고 앞으로 한번 걷기 동작 수행
                    self.robo._motion.grab_walk("RIGHT")
                    time.sleep(2)
                    return True
                else:
                    # motion : 왼쪽 혹은 오른쪽으로 걷기 수행
                    self.robo._motion.walk_side(is_okay)
                    time.sleep(1)
        return False

    @classmethod
    def go_robo(self):
        act = self.act

        if act == act.START:
            print("START")
            self.act = Act.SPEAK_DANGER
            # self.act = Act.BACK_TO_LINE # hyerin debug

        elif act == act.SPEAK_DANGER:
            print("SPEAK_DANGER")
            # motion : "위험지역" 음성 말하기
            self.robo._motion.notice_area("BLACK")
            # time.sleep(1.5)
            # motion: 화살표 반대 방향으로 고개 돌리기
            # self.robo._motion.set_head(Robo.dis_arrow, 45)
            time.sleep(2)

            self.act = Act.DETECT_ALPHABET

        elif act == act.DETECT_ALPHABET:
            print("DETECT_ALPHABET")

            # 계속 알파벳 ROI를 못가져오는 듯해서 sleep을 줌
            # time.sleep(1)

            if cur.ALPHABET_COLOR:
                print(cur.ALPHABET_COLOR)
                Robo.alphabet_color = cur.ALPHABET_COLOR
            else:
                time.sleep(0.5)
                self.alphabet_color = self.robo._image_processor.get_alphabet_color()
                if self.alphabet_color:
                    self.miss = 0
                    Robo.alphabet_color = self.alphabet_color
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 빨강으로 지정
                    self.alphabet_color = "BLUE"
                    Robo.alphabet_color = self.alphabet_color
                    self.miss = 0
                # 아직 get_alphabet_color miss 처리 안했음
                else:
                    self.miss += 1
                    return False

            print(Robo.alphabet_color)

            time.sleep(1)
            if cur.BLACK_ROOM_LIST:
                Robo.black_room_list = cur.BLACK_ROOM_LIST
            else:
                # 방 알파벳 글자 인식
                self.alphabet_name = self.robo._image_processor.get_alphabet_name()
                if self.alphabet_name:
                    self.miss = 0
                    Robo.black_room_list.append(self.alphabet_name)
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 글자 D로 지정
                    self.alphabet_name = 'D'
                    Robo.black_room_list.append(self.alphabet_name)
                    self.miss = 0
                else:
                    self.miss += 1
                    return False

            time.sleep(0.5)
            self.robo._motion.turn(self.robo.arrow, 60, arm=True)
            # motion : 정면(위험지역) 바라보기
            # self.robo._motion.set_head("LEFTRIGHT_CENTER")
            time.sleep(1)
            self.act = Act.DETECT_FIRST_MILKBOX_POS

        elif act == act.DETECT_FIRST_MILKBOX_POS:
            print("DETECT_FIRST_MILKBOX_POS")
            # motion : 이미지 가져오는 거 잘 되긴 한데 만약 더 정확하길 바라면 여기에 time.sleep(0.5) 정도 주면 될 듯
            # motion : 처음 장애물 위치 파악이 다양한 숫자로 안나와서 60도 각도에서 어떻게 보이는 지 확인하면 좋을 듯
            # self.head_angle = 60
            # self.robo._motion.set_head("DOWN", 60)

            if cur.FIRST_MILKBOX_POS:
                self.first_milkbox_pos = cur.FIRST_MILKBOX_POS
                Robo.box_pos = self.first_milkbox_pos
            else:
                # 장애물 처음 위치 저장
                self.first_milkbox_pos = self.robo._image_processor.get_milkbox_pos(
                    Robo.alphabet_color)
                Robo.box_pos = self.first_milkbox_pos

            self.out_direction = "RIGHT" if Robo.box_pos in [
                2, 5, 8, 1, 4, 7] else "LEFT"

            print("초기 장애물 위치 in DETECT_FIRST_MILKBOX_POS: ",  Robo.box_pos)
            self.act = Act.WALK_TO_MILKBOX

        elif act == act.WALK_TO_MILKBOX:
            print("WALK_TO_MILKBOX")

            print("초기 장애물 위치 in WALK_TO_MILKBOX: ",  Robo.box_pos)

            while True:
                self.milkbox_pos = self.robo._image_processor.get_milkbox_pos(
                    Robo.alphabet_color)
                # 9개 구역에 따라 다른 모션 수행
                if self.milkbox_pos == 7:
                    if self.is_okay_grab_milkbox():
                        self.head_angle = 40
                        self.robo._motion.set_head("DOWN", 40)
                        time.sleep(1)
                        for _ in range(3):
                            # 장애물 제대로 집고 나왔는지 체크하면 그때 turn 하기 -> 중간에 돌다가 떨어질 경우 고려 안 함...
                            if self.robo._image_processor.is_holding_milkbox(Robo.alphabet_color):
                                # 아예 반대로 나오는 것보다 180도 비스무레하게 turn 한 후에 걸어 나오게끔 변경
                                self.robo._motion.grab_turn(
                                    self.out_direction, 60)
                                time.sleep(2.5)

                            # self.robo._motion.grab_turn(self.out_direction, 45)
                            # time.sleep(2.5)

                            else:
                                self.head_angle = 30
                                self.robo._motion.set_head("DOWN", 30)
                                # time.sleep(1)
                                print("MISS해서 팔 원위치로 돌리기 동작 수행")
                                # motion : 팔 원위치로 돌리기 동작 수행
                                self.robo._motion.grab("MISS")
                                # time.sleep(2)
                                if self.out_direction == "RIGHT":
                                    self.robo._motion.turn("LEFT", 45)
                                else:
                                    self.robo._motion.turn("RIGHT", 45)
                                time.sleep(1)
                                self.miss += 1
                                return False

                        self.act = Act.SET_OUT_DIRECTION
                        self.miss = 0
                        break

                elif self.milkbox_pos == 1 or self.milkbox_pos == 4:
                    # motion : 장애물 접근 걸어가기
                    self.robo._motion.walk("FORWARD")
                    time.sleep(1)
                elif self.milkbox_pos == 0 or self.milkbox_pos == 3 or self.milkbox_pos == 6:
                    # motion : 왼쪽으로 20도 회전 수행
                    self.robo._motion.turn("LEFT", 20)
                    time.sleep(1)
                elif self.milkbox_pos == 2 or self.milkbox_pos == 5 or self.milkbox_pos == 8:
                    # motion : 오른쪽으로 20도 회전 수행
                    self.robo._motion.turn("RIGHT", 20)
                    time.sleep(1)

                # milkbox_pos 를 가져오지 못한 경우
                elif self.miss >= self.limits:
                    self.miss = 0
                    # 계속 못찾으면 그냥 시민 대피 미션 포기 (실패할 경우 EXIT 버전 하나 더 만들어야할 듯)
                    self.act = Act.EXIT
                    return False
                else:
                    self.miss += 1
                    print("장애물 못찾음 miss++")
                    return False

            self.head_angle = 70
            self.robo._motion.set_head('DOWN', 70)
            time.sleep(1)

        elif act == act.REGRAB_MILKBOX:
            print("REGRAB_MILKBOX")

            while True:
                if self.robo._image_processor.is_out_of_black():
                    # motion : 이미 위험 지역 탈출했으니까 BACK_TO_LINE으로 넘어가기

                    self.robo._motion.walk("FORWARD")

                    self.robo._motion.set_head("DOWN", 30)
                    self.act = Act.BACK_TO_LINE
                    self.miss = 0
                    break
                self.milkbox_pos = self.robo._image_processor.get_milkbox_pos(
                    Robo.alphabet_color)
                # 9개 구역에 따라 다른 모션 수행
                if self.milkbox_pos == 7:
                    if self.is_okay_grab_milkbox():
                        self.head_angle = 40
                        self.robo._motion.set_head("DOWN", 40)
                        time.sleep(1)
                        for _ in range(3):
                            # 장애물 제대로 집고 나왔는지 체크하면 그때 turn 하기 -> 중간에 돌다가 떨어질 경우 고려 안 함...
                            if self.robo._image_processor.is_holding_milkbox(Robo.alphabet_color):
                                # 아예 반대로 나오는 것보다 180도 비스무레하게 turn 한 후에 걸어 나오게끔 변경
                                self.robo._motion.grab_turn(
                                    self.out_direction, 60)
                                time.sleep(2.5)

                            # self.robo._motion.grab_turn(self.out_direction, 45)
                            # time.sleep(2.5)

                            else:
                                self.head_angle = 30
                                self.robo._motion.set_head("DOWN", 30)
                                # time.sleep(1)
                                print("MISS해서 팔 원위치로 돌리기 동작 수행")
                                # motion : 팔 원위치로 돌리기 동작 수행
                                self.robo._motion.grab("MISS")
                                # time.sleep(2)
                                if self.out_direction == "RIGHT":
                                    self.robo._motion.turn("LEFT", 45)
                                else:
                                    self.robo._motion.turn("RIGHT", 45)
                                time.sleep(1)
                                self.miss += 1
                                return False

                        self.act = Act.SET_OUT_DIRECTION
                        self.miss = 0
                        break

                elif self.milkbox_pos == 1 or self.milkbox_pos == 4:
                    # motion : 장애물 접근 걸어가기
                    self.robo._motion.walk("FORWARD")
                    time.sleep(0.5)
                elif self.milkbox_pos == 0 or self.milkbox_pos == 3 or self.milkbox_pos == 6:
                    # motion : 왼쪽으로 20도 회전 수행
                    self.robo._motion.turn("LEFT", 20)
                    time.sleep(1)
                elif self.milkbox_pos == 2 or self.milkbox_pos == 5 or self.milkbox_pos == 8:
                    # motion : 오른쪽으로 20도 회전 수행
                    self.robo._motion.turn("RIGHT", 20)
                    time.sleep(1)

                # milkbox_pos 를 가져오지 못한 경우
                elif self.miss >= self.limits:
                    self.miss = 0
                    # 계속 못찾으면 그냥 시민 대피 미션 포기 (실패할 경우 EXIT 버전 하나 더 만들어야할 듯)
                    self.act = Act.EXIT
                else:
                    self.miss += 1
                    self.robo._motion.turn(Robo.arrow, 20)
                    time.sleep(1)
                    print("장애물 못찾음 miss++")
                    return False
 
            self.head_angle = 70
            self.robo._motion.set_head('DOWN', 70)
            time.sleep(1)

        elif act == act.SET_OUT_DIRECTION:
            print("SET_OUT_DIRECTION")
            # 노란선 시야에 보일 때까지(True, False) turn 하기
            if self.robo._image_processor.is_yellow_danger():
                self.head_angle = 30
                self.robo._motion.set_head("DOWN", 30)
                
                ## 긴급긴급!
                time.sleep(1)
                if self.out_direction == "RIGHT":
                    self.robo._motion.grab_turn("LEFT", 20)
                    time.sleep(1.5)
                else:
                    self.robo._motion.grab_turn("RIGHT", 20)
                    time.sleep(1.5)
                
                self.act = Act.OUT_OF_DANGER
            else:
                self.miss += 1
                self.robo._motion.grab_turn(self.out_direction, 45)
                time.sleep(2.5)

        elif act == act.OUT_OF_DANGER:
            print("OUT_OF_DANGER")
            self.first_milkbox_pos = Robo.box_pos
            # 장애물을 들고 있는 채로 위험지역 밖을 벗어날 때까지 아래 과정 반복
            while True:
                self.head_angle = 40
                self.robo._motion.set_head("DOWN", 40)
                time.sleep(1)
                # 장애물을 집지 못하거나 떨어트렸을 경우
                if not self.robo._image_processor.is_holding_milkbox(Robo.alphabet_color):
                    time.sleep(2)
                    print("MISS해서 팔 원위치로 돌리기 동작 수행")
                    # motion : 팔 원위치로 돌리기 동작 수행
                    self.robo._motion.grab("MISS")
                    time.sleep(2)
                    self.act = Act.REGRAB_MILKBOX
                    return False

                self.head_angle = 30
                self.robo._motion.set_head("DOWN", 30)
                time.sleep(1)
                if self.robo._image_processor.is_out_of_black():
                    # motion : 장애물 내려놓기 동작 수행
                    self.robo._motion.grab("DOWN")
                    time.sleep(4)
                    break
                # 무한 루프 갇힐 경우에 대한 예외처리 아직 안함
                else:
                    # if self.first_milkbox_pos == 0:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("LEFT", 45)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 수행
                    #     self.robo._motion.grab_walk()
                    # elif self.first_milkbox_pos == 1:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("LEFT", 45)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    #     self.robo._motion.grab_walk("RIGHT")
                    #     time.sleep(1.5)
                    # elif self.first_milkbox_pos == 2:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 오른쪽으로 45도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("RIGHT", 45)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    #     self.robo._motion.grab_walk("RIGHT")
                    #     time.sleep(1.5)
                    # elif self.first_milkbox_pos == 3:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("LEFT", 60)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    #     # self.robo._motion.grab_walk("RIGHT")
                    #     # time.sleep(1.5)
                    # elif self.first_milkbox_pos == 4:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("LEFT", 45)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    #     # self.robo._motion.grab_walk("RIGHT")
                    #     # time.sleep(1.5)
                    # elif self.first_milkbox_pos == 5:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 오른쪽으로 60도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("RIGHT", 60)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    #     # self.robo._motion.grab_walk("LEFT")
                    #     # time.sleep(1.5)
                    # elif self.first_milkbox_pos == 6:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("LEFT", 60)
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 수행
                    #     self.robo._motion.grab_walk()
                    # elif self.first_milkbox_pos == 7:
                    #     time.sleep(1.5)
                    #     # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("LEFT", 60)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     time.sleep(2)
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    #     # self.robo._motion.grab_walk("LEFT")
                    #     # time.sleep(1.5)
                    # elif self.first_milkbox_pos == 8:
                    #     time.sleep(1)
                    #     # motion: 장애물 집고 오른쪽으로 60도 돌기 동작 수행
                    #     self.robo._motion.grab_turn("RIGHT", 60)
                    #     time.sleep(2)
                    #     # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    #     self.robo._motion.grab_walk()
                    #     time.sleep(2.5)
                    # self.robo._motion.grab_walk("LEFT")
                    # time.sleep(1.5)

                    # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    self.robo._motion.grab_walk()
                    time.sleep(1.5)

            self.robo._motion.walk("FORWARD")

            self.robo._motion.set_head("DOWN", 30)

            self.act = Act.BACK_TO_LINE

        elif act == Act.BACK_TO_LINE:
            # @hyerin
            print("BACK_TO_LINE")
            # time.sleep(0.8)
            # # 임시
            self.robo._motion.set_head("DOWN", 30)
            # self.out_direction
            time.sleep(1)
            state, h_slope, v_slope = self.robo._image_processor.is_yellow()
            print("::  Act.BACK_TO_LINE :: ", state, h_slope, v_slope)

            # if self.out_direction == "LEFT": disdir = "RIGHT"
            # else: disdir = "RIGHT"
            print(self.out_direction, Robo.arrow)
            if (self.out_direction == "LEFT" and Robo.arrow == "RIGHT") or (self.out_direction == "RIGHT" and Robo.arrow == "LEFT"):
                print("fefnjefnj")
                self.act = Act.EXIT
                return True
            print('gqjrgbjr')
            
            
            
            if state == "None":
                # 선 인식 실패
                print()
                print("not state")
                print()
                self.robo._motion.turn(self.out_direction, 45)  # 방향 조절 필요
                self.robo._motion.turn(self.out_direction, 45)  # 방향 조절 필요
                self.robo._motion.turn(self.out_direction, 20)  # 방향 조절 필요
                time.sleep(0.5)
                self.robo._motion.walk("FORWARD")
                time.sleep(1)
            else:
                if h_slope is None:  # state는 있지만 수평선 인식 못함
                    print('ELSE', self.out_direction)
                    self.robo._motion.turn(self.out_direction, 45)  # 방향 조절 필요
                    self.robo._motion.turn(self.out_direction, 45)  # 방향 조절 필요
                    self.robo._motion.turn(self.out_direction, 20)  # 방향 조절 필요
                    
                    self.robo._motion.walk("FORWARD")
                    return False
                if state == "HORIZON" or state=="B_HORIZON":
                    if h_slope <= 10 or 170 <= h_slope:
                        print("웅냥냐양ㅇ")
                        self.robo._motion.walk("FORWARD")
                        # time.sleep()
                        self.robo._motion.walk("FORWARD")
                        # time.sleep(1.5)
                        self.act = Act.EXIT
                    else:
                        # self.robo._motion.walk("FORWARD")
                        if h_slope < 90:
                            self.robo._motion.turn("RIGHT", 20)  # 방향 조절 필요
                        else:
                            self.robo._motion.turn("LEFT", 20)  # 방향 조절 필요
                            
                            
                        # time.sleep(1)
                        # self.robo._motion.turn(self.out_direction, 20)  # 방향 조절 필요
                        # time.sleep(1)

                # elif state == "VERTICAL" or state == "B_VERTICAL":
                #     time.sleep(0.5)
                #     self.act = Act.EXIT
                
                elif state == "VERTICAL" or state == "B_VERTICAL":
                    time.sleep(0.5)
                    self.act = Act.EXIT

                elif state == "BOTH":  # 수직/수평 둘 다 인식
                    if h_slope <= 10 or 170 <= h_slope:  # 수평
                        print("웅냥냐양ㅇ")
                        self.robo._motion.walk("FORWARD", 5, 1)
                        self.act = Act.EXIT
                        return True
                    if setting.VSLOPE1 <= v_slope <= setting.VSLOPE2:  # 수직
                        print("vertical")
                        self.act = Act.EXIT
                        return True

                    if h_slope < 90 or setting.VSLOPE2 < v_slope:
                        print("TURN_RIGHT")
                        self.robo._motion.turn("RIGHT", 20)
                    elif v_slope < setting.VSLOPE1:
                        print("TURN_LEFT")
                        self.robo._motion.turn("LEFT", 20)
                    else:
                        print("TURN_LEFT")
                        self.robo._motion.turn("LEFT", 20)
                else:
                    print('ELSE', self.out_direction)
                    print("????????")
                    self.robo._motion.turn(self.out_direction, 20)  # 방향 조절 필요
                    self.robo._motion.walk("FORWARD")

            return False

        else:  # EXIT
            print("EXIT")
            return True

        return False
