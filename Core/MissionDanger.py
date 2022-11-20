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
    WALK_TO_MILKBOX = auto()  # 장애물 찾기
    OUT_OF_DANGER = auto()  # 위험지역 밖으로 장애물 옮기기
    REGRAB_MILKBOX = auto() # 떨어진 장애물 다시 잡기 -> WALK_TO_MILKBOX로 충분할 것 같아서 일단 안씀
    KICK_MILKBOX = auto() # 자꾸 장애물을 떨어트릴 경우 이 방법 사용 (발로 차거나 치우기 동작 수행)
    EXIT = auto()  # 공통


class MissionDanger:
    act: Act = Act.START
    robo: Robo = Robo()
    miss: int = 0
    limits: int = 3
    alphabet_color: str
    alphabet_name: str
    milkbox_pos: int
    head_angle: int = 70
    holding: bool
    first_milkbox_pos: int = cur.FIRST_MILKBOX_POS

    def init_robo(self, robo: Robo):
        self.robo = robo

    @classmethod
    def is_okay_grab_milkbox(self):
        if self.head_angle == 70:
            self.head_angle = 45
            # motion : 고개 각도 45도로 설정
            self.robo._motion.set_head("DOWN", 45)
            return False
        elif self.head_angle == 45:
            self.head_angle = 30
            # motion : 고개 각도 30도로 설정
            self.robo._motion.set_head("DOWN", 30)
            return False
        else:
            # motion : 장애물 잡기 동작 수행
            self.robo._motion.grab("UP")
            # motion : 장애물 집고 앞으로 한번 걷기 동작 수행
            self.robo._motion.grab_walk()
            return True

    @classmethod
    def go_robo(self):
        act = self.act

        if act == act.START:
            print("START")
            self.act = Act.SPEAK_DANGER

        elif act == act.SPEAK_DANGER:
            print("SPEAK_DANGER")
            # motion : "위험지역" 음성 말하기
            self.robo._motion.notice_area("BLACK")
            # motion: 화살표 반대 방향으로 고개 돌리기
            self.robo._motion.set_head(Robo.dis_arrow, 45)

            self.act = Act.DETECT_ALPHABET

        elif act == act.DETECT_ALPHABET:
            print("DETECT_ALPHABET")
            # 방 알파벳 색상 인식 -> 보기 불편해서 함수로 빼는 게 좋을 듯
            # 색상 고정이면 이렇게 하고 싶은데 위험 지역 2개 돌 경우,
            # 이전 세팅에 저장되어있는 값 사용하게 되어 다른 색상을 집을 수 있는 문제 발생
            if cur.ALPHABET_COLOR:
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
                # 아직 get_alphabet_color miss 처리 안했음
                else:
                    self.miss += 1
                    return False

            if cur.BLACK_ROOM_LIST:
                # self.robo 다 Robo로 바꿔야 할 듯 -> self.robo로 하면 각 미션에서 쓰는 robo 인스턴스에 저장하는 거라서 각자 다를 듯
                Robo.black_room_list = cur.BLACK_ROOM_LIST
            else:
                # 방 알파벳 글자 인식
                self.alphabet_name = self.robo._image_processor.get_alphabet_name()
                if self.alphabet_name:
                    self.miss = 0
                    Robo.black_room_list.append(self.alphabet_name)
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 글자 B로 지정
                    self.alphabet_name = 'B'
                    Robo.black_room_list.append(self.alphabet_name)
                else:
                    self.miss += 1
                    return False

            # motion : 정면(위험지역) 바라보기
            self.robo._motion.set_head("LEFTRIGHT_CENTER")

            self.act = Act.WALK_TO_MILKBOX

        elif act == act.WALK_TO_MILKBOX:
            print("WALK_TO_MILKBOX")
            if cur.FIRST_MILKBOX_POS:
                self.first_milkbox_pos = cur.FIRST_MILKBOX_POS
            else:
                # 장애물 처음 위치 저장 -> 선언 위치가 여기가 맞을 지 모르겠지만 일단 여기에 둠
                self.first_milkbox_pos = self.robo._image_processor.get_milkbox_pos(Robo.alphabet_color)
            while True:
                self.milkbox_pos = self.robo._image_processor.get_milkbox_pos(Robo.alphabet_color)
                # 9개 구역에 따라 다른 모션 수행
                if self.milkbox_pos == 7:
                    if self.is_okay_grab_milkbox():
                        self.act = Act.OUT_OF_DANGER
                        break
                elif self.milkbox_pos == 1 or self.milkbox_pos == 4:
                    # motion : 장애물 접근 걸어가기
                    self.robo._motion.walk("FORWARD")
                elif self.milkbox_pos == 0 or self.milkbox_pos == 3 or self.milkbox_pos == 6:
                    # motion : 왼쪽으로 20도 회전 수행
                    self.robo._motion.turn("LEFT", 20)
                elif self.milkbox_pos == 2 or self.milkbox_pos == 5 or self.milkbox_pos == 8:
                    # motion : 오른쪽으로 20도 회전 수행
                    self.robo._motion.turn("RIGHT", 20)

                # milkbox_pos 를 가져오지 못한 경우
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 시민 대피 미션 포기 (실패할 경우 EXIT 버전 하나 더 만들어야할 듯)
                    self.act = Act.EXIT
                else:
                    self.miss += 1
                    return False


        elif act == act.OUT_OF_DANGER:
            print("OUT_OF_DANGER")
            # 장애물을 들고 있는 채로 위험지역 밖을 벗어날 때까지 아래 과정 반복
            while True:
                if not self.robo._image_processor.is_holding_milkbox(Robo.alphabet_color):
                    # motion : 장애물 내려놓기 동작 수행
                    self.robo._motion.grab("DOWN")
                    self.act = Act.WALK_TO_MILKBOX
                    return False
                if self.robo._image_processor.is_out_of_black():
                    # motion : 장애물 내려놓기 동작 수행
                    self.robo._motion.grab("DOWN")
                    break
                # 무한 루프 갇힐 경우에 대한 예외처리 아직 안함
                else:
                    if self.first_milkbox_pos == 0:
                        # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행
                        self.robo._motion.grab_turn("LEFT", 45)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 수행
                        self.robo._motion.grab_walk()
                    elif self.first_milkbox_pos == 1:
                        # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행
                        self.robo._motion.grab_turn("LEFT", 45)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)
                    elif self.first_milkbox_pos == 2:
                        # motion: 장애물 집고 오른쪽으로 45도 돌기 동작 수행
                        self.robo._motion.grab_turn("RIGHT", 45)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)
                    elif self.first_milkbox_pos == 3:
                        # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행
                        self.robo._motion.grab_turn("LEFT", 60)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)
                    elif self.first_milkbox_pos == 4:
                        # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행
                        self.robo._motion.grab_turn("LEFT", 45)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)
                    elif self.first_milkbox_pos == 5:
                        # motion: 장애물 집고 오른쪽으로 60도 돌기 동작 수행
                        self.robo._motion.grab_turn("RIGHT", 60)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)
                    elif self.first_milkbox_pos == 6:
                        # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행
                        self.robo._motion.grab_turn("LEFT", 60)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 수행
                        self.robo._motion.grab_walk()
                    elif self.first_milkbox_pos == 7:
                        # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행
                        self.robo._motion.grab_turn("LEFT", 60)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)
                    elif self.first_milkbox_pos == 8:
                        # motion: 장애물 집고 오른쪽으로 60도 돌기 동작 수행
                        self.robo._motion.grab_turn("RIGHT", 60)
                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        self.robo._motion.grab_walk(2)

            self.act = Act.EXIT

        else:  # EXIT
            print("EXIT")
            return True

        return False