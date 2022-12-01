# -*- coding: utf-8 -*-
from enum import Enum, auto
from Core.Robo import Robo
from Setting import cur
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
    right_out = [2, 5, 8]  # 위험지역 오른쪽 탈출

    def init_robo(self, robo: Robo):
        self.robo = robo

    @classmethod
    def is_okay_grab_milkbox(self):
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
            is_okay = self.robo._image_processor.can_hold_milkbox(Robo.alphabet_color)
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
                    time.sleep(3)
                    # motion : 장애물 집고 앞으로 한번 걷기 동작 수행
                    self.robo._motion.grab_walk("RIGHT")
                    time.sleep(2)
                    return True
                else:
                    # motion : 왼쪽 혹은 오른쪽으로 걷기 수행
                    self.robo._motion.walk(is_okay)
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
            time.sleep(1.5)
            # motion: 화살표 반대 방향으로 고개 돌리기
            self.robo._motion.set_head(Robo.dis_arrow, 45)
            time.sleep(1)

            self.act = Act.DETECT_ALPHABET

        elif act == act.DETECT_ALPHABET:
            print("DETECT_ALPHABET")

            # 계속 알파벳 ROI를 못가져오는 듯해서 sleep을 줌
            # time.sleep(1)

            if cur.ALPHABET_COLOR:
                print(cur.ALPHABET_COLOR)
                Robo.alphabet_color = cur.ALPHABET_COLOR
            else:
                self.alphabet_color = self.robo._image_processor.get_alphabet_color()
                if self.alphabet_color:
                    self.miss = 0
                    Robo.alphabet_color = self.alphabet_color
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 빨강으로 지정
                    self.alphabet_color = "RED"
                    Robo.alphabet_color = self.alphabet_color
                    self.miss = 0
                # 아직 get_alphabet_color miss 처리 안했음
                else:
                    self.miss += 1
                    return False

            print(Robo.alphabet_color)

            # 알파벳 D를 A로 인식해서 sleep 줬는데 그거 문제가 아닌 듯
            # time.sleep(1)
            if cur.BLACK_ROOM_LIST:
                Robo.black_room_list = cur.BLACK_ROOM_LIST
            else:
                # 방 알파벳 글자 인식
                self.alphabet_name = self.robo._image_processor.get_alphabet_name()
                if self.alphabet_name:
                    self.miss = 0
                    Robo.black_room_list.append(self.alphabet_name)
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 글자 B로 지정
                    self.alphabet_name = 'D'
                    Robo.black_room_list.append(self.alphabet_name)
                    self.miss = 0
                else:
                    self.miss += 1
                    return False

            time.sleep(0.5)
            # motion : 정면(위험지역) 바라보기
            self.robo._motion.set_head("LEFTRIGHT_CENTER")
            time.sleep(1)

            # self.act = Act.DETECT_FIRST_MILKBOX_POS
            self.act = Act.WALK_TO_MILKBOX

        # elif act == act.DETECT_FIRST_MILKBOX_POS:
        #     print("DETECT_FIRST_MILKBOX_POS")
        #     # motion : 이미지 가져오는 거 잘 되긴 한데 만약 더 정화하길 바라면 여기에 time.sleep(0.5) 정도 주면 될 듯
        #     if cur.FIRST_MILKBOX_POS:
        #         self.first_milkbox_pos = cur.FIRST_MILKBOX_POS
        #         Robo.box_pos = self.first_milkbox_pos
        #     else:
        #         # 장애물 처음 위치 저장 -> 선언 위치가 여기가 맞을 지 모르겠지만 일단 여기에 둠
        #         self.first_milkbox_pos = self.robo._image_processor.get_milkbox_pos(Robo.alphabet_color)
        #         Robo.box_pos = self.first_milkbox_pos

        #     print("초기 장애물 위치 : ",  Robo.box_pos)
        #     self.act = Act.WALK_TO_MILKBOX

        elif act == act.WALK_TO_MILKBOX:
            print("WALK_TO_MILKBOX")
            # motion : 이미지 가져오는 거 잘 되긴 한데 만약 더 정확하길 바라면 여기에 time.sleep(0.5) 정도 주면 될 듯
            if cur.FIRST_MILKBOX_POS:
                self.first_milkbox_pos = cur.FIRST_MILKBOX_POS
                Robo.box_pos = self.first_milkbox_pos
            else:
                # 장애물 처음 위치 저장 -> 선언 위치가 여기가 맞을 지 모르겠지만 일단 여기에 둠
                self.first_milkbox_pos = self.robo._image_processor.get_milkbox_pos(Robo.alphabet_color)
                Robo.box_pos = self.first_milkbox_pos

            print("초기 장애물 위치 : ",  Robo.box_pos)

            while True:
                self.milkbox_pos = self.robo._image_processor.get_milkbox_pos(Robo.alphabet_color)
                # 9개 구역에 따라 다른 모션 수행
                if self.milkbox_pos == 7:
                    if self.is_okay_grab_milkbox():
                        ### 1124 혜린 언니가 추가한 코드 ###
                        # if self.first_milkbox_pos:
                        #     Robo.box_pos = self.first_milkbox_pos
                        ###################################
                        # 무지성으로 반대 방향으로 돌아서 나오기
                        self.robo._motion.grab_turn(Robo.dis_arrow, 60)
                        time.sleep(2.5)
                        self.robo._motion.grab_turn(Robo.dis_arrow, 60)
                        time.sleep(2.5)
                        self.robo._motion.grab_turn(Robo.dis_arrow, 60)
                        time.sleep(2.5)
                        
                        self.act = Act.OUT_OF_DANGER
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
                    print("장애물 못찾음 miss++")
                    return False

        elif act == act.REGRAB_MILKBOX:
            print("REGRAB_MILKBOX")

            while True:
                self.milkbox_pos = self.robo._image_processor.get_milkbox_pos(Robo.alphabet_color)
                # 9개 구역에 따라 다른 모션 수행
                if self.milkbox_pos == 7:
                    if self.is_okay_grab_milkbox():
                        self.act = Act.OUT_OF_DANGER
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

        elif act == act.OUT_OF_DANGER:
            print("OUT_OF_DANGER")
            print("처음 우유곽 위치 : ", self.first_milkbox_pos)
            self.first_milkbox_pos = Robo.box_pos
            # 장애물을 들고 있는 채로 위험지역 밖을 벗어날 때까지 아래 과정 반복
            while True:
                # 장애물을 집지 못하거나 떨어트렸을 경우
                if not self.robo._image_processor.is_holding_milkbox(Robo.alphabet_color):
                    time.sleep(2)
                    print("MISS해서 팔 원위치로 돌리기 동작 수행")
                    # motion : 팔 원위치로 돌리기 동작 수행
                    self.robo._motion.grab("MISS")
                    time.sleep(2)
                    self.act = Act.REGRAB_MILKBOX
                    return False
                if self.robo._image_processor.is_out_of_black():
                    # motion : 장애물 내려놓기 동작 수행
                    self.robo._motion.grab("DOWN")
                    time.sleep(5)
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
                    #     # self.robo._motion.grab_walk("LEFT")
                    #     # time.sleep(1.5)
                    
                    # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                    self.robo._motion.grab_walk()
                    time.sleep(2.5)

            self.act = Act.BACK_TO_LINE

        elif act == Act.BACK_TO_LINE:
            print("BACK_TO_LINE")
            time.sleep(0.8)
            # # 임시
            # self.robo._motion.set_head("DOWN", 30)
            # 나중에 효율적으로 수정할 예정
            if Robo.box_pos in self.right_out:
                print('RIGHT_OUT')
                if Robo.arrow == "RIGHT":
                    my_arrow = "RIGHT"
                else:
                    my_arrow = "LEFT"
                print(my_arrow)
            else:
                if Robo.arrow == "RIGHT":
                    my_arrow = "LEFT"
                else:
                    my_arrow = "LEFT"
                # my_arrow = "LEFT"
            # self.robo._motion.walk("BACKWARD",2,2)
            # time.sleep(1)

            state, h_slope = self.robo._image_processor.is_yellow()
            print(state, h_slope)
            if h_slope is None:
                print('ELSE', my_arrow)
                self.robo._motion.turn(my_arrow, 20)  # 방향 조절 필요
                time.sleep(1)
                self.robo._motion.walk("FORWARD")
                time.sleep(1)
            if state == "HORIZON":
                self.robo._motion.walk("FORWARD")
                time.sleep(1)
                self.robo._motion.turn(my_arrow, 20)  # 방향 조절 필요
                time.sleep(1)
            elif state == "BOTH":
                if h_slope <= 10 or 170 <= h_slope:
                    self.robo._motion.walk("FORWARD")
                    time.sleep(1.5)
                    self.robo._motion.walk("FORWARD")
                    time.sleep(1.5)
                    self.act = Act.EXIT
                if h_slope < 90:
                    # cv.putText(origin, "motion: {}".format("TURN_RIGHT"), (100, 50), cv.FONT_HERSHEY_SIMPLEX, 1, [0,255,255], 2)
                    print("TURN_RIGHT")
                    self.robo._motion.turn(my_arrow, 20)
                else:
                    # cv.putText(origin, "motion: {}".format("TURN_LEFT"), (100, 50), cv.FONT_HERSHEY_SIMPLEX, 1, [0,255,255], 2)
                    print("ELSE_TURN_LEFT")
                    self.robo._motion.walk("FORWARD")
                    time.sleep(1)
                    self.robo._motion.turn(my_arrow, 20)
            else:
                print('ELSE', my_arrow)
                time.sleep(1)
                self.robo._motion.turn(my_arrow, 20)  # 방향 조절 필요
                time.sleep(1)
                self.robo._motion.walk("FORWARD")
                time.sleep(1)

            # if self.check_backline > 0:
            #     state = self.robo._image_processor.black_line()
            #     print(state)
            #     if state:
            #         self.robo._motion.walk("FORWARD")
            #         self.act = Act.EXIT
            #     elif state == "TURN_LEFT":
            #         self.robo._motion.turn("LEFT", 10)
            #     elif state == "TURN_RIGHT":
            #         self.robo._motion.turn("RIGHT", 10)
            #     else:
            #         self.robo._motion.walk("BACKWARD")
            #         time.sleep(3)
            # else:
            #     is_danger = self.robo._image_processor.is_danger()
            #     if is_danger:
            #         self.check_backline += 1
            #         return False
            #     else:
            #         self.robo._motion.walk("BACKWARD")
            #         time.sleep(3)

        else:  # EXIT
            print("EXIT")
            return True

        return False
