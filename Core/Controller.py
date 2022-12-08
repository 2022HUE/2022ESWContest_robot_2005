# -*- coding: utf-8 -*-
from enum import Enum, auto
from Core.Robo import Robo
from Core.MissionStair import MissionStair
from Core.MissionEntrance import MissionEntrance
from Core.MissionDanger import MissionDanger
from Setting import cur, setting
import time

limits: int = 2  # 방 개수


class Act(Enum):  # 맵 전체 수행 순서도
    # (미션)이 적혀진 순서에서는 Misson.py에서 과제를 수행합니다.

    START = auto()  # 시작
    GO_ENTRANCE = auto()  # 입장
    ENTRANCE = auto()  # (미션)입장
    GO_NEXTROOM = auto()  # 다음 지역으로 이동
    STAIR = auto()  # (미션)계단지역미션
    DANGER = auto()  # (미션)위험지역
    GO_EXIT = auto()  # 퇴장
    EXIT = auto()  # 종료


class Controller:
    robo: Robo = Robo()
    act: Act = Act.START

    count_area: int = 0  # 방문한 미션 지역의 수 - 위험/계단 지역만 카운트합니다.
    count_misson: int = 0
    check_exit: int = 0  # 퇴장시 사용
    check_entrance: int = 0  # 입장시 사용
    check_nextroom: int = 0  # 방 이동시 사용
    check_stair: int = 0
    check_danger: int = 0
    area: str = ""  # 현재 지역
    stair_level: int = 0  # 계단을 오른 횟수

    danger_right_out = [2, 5, 8]  # 위험지역 오른쪽 탈출
    danger_turn_flag: int = 0
    danger_line_flag: int = 0

    stair_turn: int = 0
    stair_exit_hor: int = 0

    miss: int = 0

    # Misson.py
    _entr: MissionEntrance = MissionEntrance()
    _stair: MissionStair = MissionStair()
    _danger: MissionDanger = MissionDanger()

    # MissionEntrance.init_robo(_entr, robo)
    # MissionStair.init_robo(_stair, robo)
    # MissionDanger.init_robo(_danger, robo)

    # 위험 지역인지 계단 지역인지 판단
    @classmethod
    def check_area(self):
        time.sleep(1)
        # [motion] 로봇 화살표 방향으로 45도 회전
        # self.robo._motion.turn(self.robo.arrow, 45, 2, 0.8)
        self.robo._motion.turn(self.robo.arrow, 60, arm=True)
        # time.sleep(0.5)
        # self.robo._motion.walk_side(Robo.dis_arrow)

        self.robo._motion.set_head("DOWN", 70)
        if self.count_area == 0:  # 최초 방문
            # time.sleep(1.2)
            if cur.AREA:  # 고정 값 존재시 (Setting - current)
                self.area = cur.AREA
            else:
                time.sleep(2)
                self.area = self.robo._image_processor.is_danger()

        else:
            if self.area == "STAIR":
                self.area = "DANGER"
            else:
                self.area = "STAIR"

    @classmethod
    def check_line(self):
        state = self.robo._image_processor.is_line_horizon_vertical()
        if not state:
            return False
        else:
            return state

    @classmethod
    def is_vertical(self):  # 수직선인지
        # self.robo._motion.turn(Robo.arrow, 10)
        state = self.robo._image_processor.is_line_horizon_vertical()
        if state == "VERTICAL":
            return True
        elif state == "MOVE_LEFT":
            self.robo._motion.walk_side("LEFT")
        elif state == "MOVE_RIGHT":
            self.robo._motion.walk_side("RIGHT")
        elif state == "TURN_LEFT":
            self.robo._motion.turn("LEFT", 10)
        elif state == "TURN_RIGHT":
            self.robo._motion.turn("RIGHT", 10)
        else:
            # 수정 필요
            # self.robo._motion.turn(Robo.arrow, 20)
            self.robo._motion.walk("FORWARD")
            # return True
            # self.robo._motion.turn(self.robo.arrow, 10)
        return False

    @classmethod
    def danger_to_line(self, option):  # option: L, R
        state = self.robo._image_processor.is_line_horizon_vertical()
        print("danger_to_line", state)
        time.sleep(1)
        if option == "L":
            if state == "VERTICAL":
                print('ENDENDENDNENDNENENN')
                time.sleep(1)
                return True
            elif state == "MOVE_LEFT":
                self.robo._motion.walk_side("LEFT")
            elif state == "MOVE_RIGHT":
                self.robo._motion.walk_side("RIGHT")
            elif state == "TURN_LEFT":
                self.robo._motion.turn("LEFT", 10)
            elif state == "TURN_RIGHT":
                self.robo._motion.turn("RIGHT", 10)
            elif state == "BOTH":  # 선 둘 다 인식
                # self.robo._motion.walk_side("LEFT")
                self.robo._motion.walk("FORWARD")

            elif state == "HORIZON":
                # self.robo._motion.walk_side("LEFT")
                # time.sleep(0.8)
                # self.robo._motion.walk("FORWARD")
                self.robo._motion.turn("RIGHT", 20)
                time.sleep(0.8)

            else:
                self.robo._motion.walk_side("LEFT")
                time.sleep(0.8)
                self.robo._motion.walk("FORWARD")
            return False
        else:
            if state == "HORIZON":
                return True
            elif state == "MOVE_LEFT":
                self.robo._motion.walk_side("LEFT")
            elif state == "MOVE_RIGHT":
                self.robo._motion.walk_side("RIGHT")
            elif state == "TURN_LEFT":
                self.robo._motion.turn("LEFT", 10)
            elif state == "TURN_RIGHT":
                self.robo._motion.turn("RIGHT", 10)

            elif state == "BOTH":  # 선 둘 다 인식
                self.robo._motion.walk_side("RIGHT")
            else:
                self.robo._motion.walk_side("RIGHT")
                time.sleep(1)
                self.robo._motion.walk("FORWARD")

    @classmethod
    def check_horizon(self):
        state = self.robo._image_processor.is_line_horizon_vertical()
        print("check_horizon", state)

        if not state:
            self.robo._motion.walk("FORWARD")
            time.sleep(1)
        elif state == "HORIZON" or state == "BOTH":
            return True
        elif state == "MOVE_LEFT":
            self.robo._motion.walk_side("LEFT")
        elif state == "MOVE_RIGHT":
            self.robo._motion.walk_side("RIGHT")
        elif state == "TURN_LEFT":
            self.robo._motion.turn("LEFT", 10)
        elif state == "TURN_RIGHT":
            self.robo._motion.turn("RIGHT", 10)
        else:
            # 디버깅 필요
            self.robo._motion.walk("FORWARD")
        return False

    @classmethod
    def exit_stair(self):

        if self.stair_exit_hor == 1:
            return self.check_horizon()
        if self.stair_turn == 0:
            # self.robo._motion.turn(Robo.dis_arrow, 60)
            # self.robo._motion.turn(Robo.dis_arrow, 60)
            self.robo._motion.turn(Robo.dis_arrow, 45, arm=True)
            self.robo._motion.turn(Robo.dis_arrow, 45, arm=True)

            self.stair_turn += 1

        state, h_slope, v_slope = self.robo._image_processor.is_yellow()
        if not h_slope:
            self.robo._motion.turn(Robo.dis_arrow, 10)
            time.sleep(1)
            self.robo._motion.walk("FORWARD")
            return False

        if state == "HORIZON" and h_slope <= 10 or 170 <= h_slope:
            print("앞으로 걸어라!")
            self.robo._motion.walk("FORWARD", 2)
            self.stair_exit_hor = 1

        # if state == "HORIZON" or h_slope <= 10 or 170 <= h_slope or state == "VERTICAL":
            # return True
        elif state == "MOVE_LEFT":
            self.robo._motion.walk_side("LEFT")
        elif state == "MOVE_RIGHT":
            self.robo._motion.walk_side("RIGHT")
        elif state == "TURN_LEFT":
            self.robo._motion.turn("LEFT", 10)
        elif state == "TURN_RIGHT":
            self.robo._motion.turn("RIGHT", 10)
        elif state == "BOTH":
            if h_slope < 90:
                self.robo._motion.turn("RIGHT", 10)
            else:
                self.robo._motion.turn("LEFT", 10)
        else:
            self.robo._motion.walk("FORWARD")
        return False

    @classmethod
    def escape_room(self):
        self.robo._motion.turn(Robo.dis_arrow, 60, 3, arm=True)  # arm = True
        self.robo._motion.turn(Robo.dis_arrow, 45)  # arm = True
        self.robo._motion.set_head("DOWN", 30)

    @classmethod
    def go_robo(self):
        act = self.act
        robo: Robo = Robo()

        if act == act.START:
            print("ACT - controller: ", act)  # Debug
            # print("current area: ", cur.AREA, "(Setting.py Hard Coding for Debuging)")
            # motion: 고개 내리기 30
            self.robo._motion.set_head("DOWN", 30)
            self.act = act.GO_ENTRANCE

            # debug
            ######## 바꿔
            # self.act = act.ENTRANCE
            # self.act = act.GO_NEXTROOM
            # self.act = act.GO_EXIT
            # self.act = act.EXIT

            # self.robo._motion.set_head("LEFTRIGHT_CENTER")
            # self.robo._motion.set_head("DOWN", 70)
            # self.act = act.DANGER
            # self.act = act.STAIR

        elif act == act.GO_ENTRANCE:
            print("ACT - controller: ", act)  # Debug
            # time.sleep(0.5)

            state = self.robo._image_processor.is_line_horizon_vertical()
            print(state)
            if state == "VERTICAL":
                self.robo._motion.walk("FORWARD")
            elif state == "MOVE_LEFT":
                self.robo._motion.walk_side("LEFT")
            elif state == "MOVE_RIGHT":
                self.robo._motion.walk_side("RIGHT")
            elif state == "TURN_LEFT":
                self.robo._motion.turn("LEFT", 10)
            elif state == "TURN_RIGHT":
                self.robo._motion.turn("RIGHT", 10)
            elif state == "BOTH":  # 선 둘 다 인식
                self.check_entrance += 1
                setting.SICK = 0  # 넘어짐 초기화
                self.act = act.ENTRANCE
                # self.robo._motion.walk("FORWARD") # 1206 주석 할지 말지
            elif state == "HORIZON":  # 1208
                # self.robo._motion.walk("FORWARD")
                self.act = act.ENTRANCE

            else:
                if self.check_entrance > 0:
                    # self.robo._motion.walk("FORWARD")
                    self.act = act.ENTRANCE

                else:
                    # self.robo._motion.kick("RIGHT")  # test
                    # time.sleep(3)
                    return False
            return False

        elif act == act.ENTRANCE:
            if self.miss > 0:
                print("MISS MISS MISS MISS MISS MISS MISS MISS")
                if self.is_vertical():
                    self.miss = 0
                    self.robo._motion.set_head("DOWN", 30)
                    self.act = act.GO_NEXTROOM
                else:
                    print('수직선 못찾음')
                    # self.robo._motion.walk_side(Robo.dis_arrow)
                    # self.robo._motion.walk("FORWARD")
                    # time.sleep(0.5)
                    self.miss += 1
                    return False
            elif MissionEntrance.go_robo():
                print(self.robo.arrow)  # Debug

                # motion: 회전 (수직선이 보일 때 까지)
                self.robo._motion.walk("FORWARD")
                self.robo._motion.turn(
                    Robo.arrow, 60, 2, 3, True)  # arm = True
                # time.sleep(3)
                self.robo._motion.turn(Robo.arrow, 20)
                self.miss += 1
                return False
            else:
                return False

        elif act == act.GO_NEXTROOM:
            print("ACT - controller: ", act)  # Debug
            # time.sleep(0.5)
            state = self.robo._image_processor.is_line_horizon_vertical()
            if state == "HORIZON":
                self.check_nextroom += 1
                self.robo._motion.walk("FORWARD")
            if state == "VERTICAL":
                self.robo._motion.walk("FORWARD")
            elif state == "MOVE_LEFT":
                self.robo._motion.walk_side("LEFT")
                # time.sleep(0.8)
                # self.robo._motion.turn("LEFT", 10)
            elif state == "MOVE_RIGHT":
                self.robo._motion.walk_side("RIGHT")
                # time.sleep(0.8)
                # self.robo._motion.turn("RIGHT", 10)
            elif state == "TURN_LEFT":
                self.robo._motion.turn("LEFT", 10)
            elif state == "TURN_RIGHT":
                self.robo._motion.turn("RIGHT", 10)
            elif state == "BOTH":  # 선 둘 다 인식
                self.check_nextroom += 1
                # print('efnenfwlenfjw')
                self.robo._motion.walk("FORWARD")
            # else:
            #     if self.check_nextroom > 0:
            #         self.robo._motion.walk("FORWARD")
            #         # self.robo._motion.walk("FORWARD")
            #         time.sleep(0.5)
            #         # self.robo._motion.set_head("DOWN", 70)
            #         print("END")
            #         # 방 입구 도착 -> 위험/계단지역 판단
            #         self.check_nextroom = 0  # init
            #         self.check_area()
            #         print("----Current Area", self.area, "----")  # Debug
            #         # return True ## debug
            #         setting.SICK = 0 # 넘어짐 초기화
            #         if self.area == "STAIR":
            #             self.act = act.STAIR
            #         else:
            #             self.act = act.DANGER
            #         # return True # Debug
            #     else:
            #         # 장애물??
            #         self.robo._motion.kick("RIGHT")  # test
            #         time.sleep(3)
            #         return False
            else:
                if self.check_nextroom > 0:
                    # self.robo._motion.walk("FORWARD")
                    # time.sleep(0.5)
                    # self.robo._motion.set_head("DOWN", 70)
                    print("END")
                    # 방 입구 도착 -> 위험/계단지역 판단
                    self.check_nextroom = 0  # init
                    self.check_area()
                    print("----Current Area", self.area, "----")  # Debug
                    # return True ## debug
                    setting.SICK = 0  # 넘어짐 초기화
                    if self.area == "STAIR":
                        self.act = act.STAIR
                    else:
                        self.act = act.DANGER
                    # return True # Debug
                else:
                    # 장애물??
                    self.robo._motion.kick("RIGHT")  # test
                    time.sleep(3)
                    return False
            return False

        elif act == act.STAIR:
            print("ACT - controller: ", act)  # Debug

            ########## 즉시 탈출문 ##########
            # self.escape_room()
            # self.count_area += 1
            # print("count_area: ", self.count_area)
            # setting.SICK = 0 # 넘어짐 초기화
            # if self.count_area < limits:
            #     self.act = act.GO_NEXTROOM
            # else:
            #     self.act = act.GO_EXIT
            ##############################

            if MissionStair.go_robo():
                # return True  # debug
                if self.check_stair > 0:
                    if self.is_vertical():
                        self.count_area += 1
                        print("count_area: ", self.count_area)
                        setting.SICK = 0  # 넘어짐 초기화
                        if self.count_area < limits:
                            self.act = act.GO_NEXTROOM
                        else:
                            self.act = act.GO_EXIT
                    else:
                        print('수직선 못찾음')
                        self.robo._motion.walk("FORWARD")
                        return False
                else:
                    self.robo._motion.set_head("DOWN", 30)
                    print('exit stair')
                    if self.exit_stair():
                        print('exit stair 성공')

                        # time.sleep(1)
                        self.check_stair += 1

                        # ROTATE - 수직선 나오도록 (하드)
                        self.robo._motion.turn(
                            Robo.arrow, 45, 3, True)  # arm = True
                        # time.sleep(3)
                        self.robo._motion.turn(Robo.arrow, 20)

                        self.robo._motion.walk_side(Robo.dis_arrow)
                        self.robo._motion.walk_side(Robo.dis_arrow)

                        return False
                    else:
                        return False

            else:
                return False

        elif act == act.DANGER:
            print("ACT-controller: ", act)  # Debug

            if self.check_danger > 0:
                if self.danger_line_flag > 0:
                    print('냥냥냥')
                    if self.is_vertical():
                        print('-------TRUE?------')
                        # return True # debug
                        print("self.count_area: ", self.count_area)
                        setting.SICK = 0  # 넘어짐 초기화
                        if self.count_area < limits:
                            self.act = act.GO_NEXTROOM
                        else:
                            self.act = act.GO_EXIT
                    else:
                        print('수직선 못찾음')
                        # self.robo._motion.turn(Robo.arrow, 10)
                        # self.robo._motion.walk("FORWARD")
                        return False
                else:
                    # 직진
                    if (Robo.box_pos in self.danger_right_out and Robo.arrow == "RIGHT") or (Robo.box_pos not in self.danger_right_out and Robo.arrow == "LEFT"):
                        print("컨트롤러 위험지역 탈출 - 직진")
                        self.danger_line_flag += 1
                        return False
                        # if self.danger_turn_flag < 1:
                        #     self.danger_turn_flag += 1
                        #     return False
                        # else:
                        #     if self.danger_to_line("R"):  # horizion is True
                        #         self.danger_line_flag += 1

                        #     else:
                        #         return False

                    else:  # 회전 필요
                        if self.danger_turn_flag > 1:
                            if self.robo._image_processor.is_yellow_danger:
                                self.danger_line_flag += 1
                                self.robo._motion.walk_side(Robo.dis_arrow)
                            else:
                                self.robo._motion.walk_side(Robo.dis_arrow)
                                self.robo._motion.walk_side(Robo.dis_arrow)
                                self.robo._motion.walk_side(Robo.dis_arrow)

                        else:
                            print("컨트롤러 위험지역 탈출 - 회전", Robo.arrow)
                            time.sleep(1)
                            self.robo._motion.turn(
                                Robo.arrow, 45, 2, arm=True)  # arm = True
                            # time.sleep(3)

                            self.danger_line_flag += 1
                        return False
                        # if self.danger_turn_flag < 1:
                        #     time.sleep(1)
                        #     self.robo._motion.turn(Robo.arrow, 60, arm=True)
                        #     time.sleep(2)
                        #     self.robo._motion.turn(Robo.arrow, 20)
                        #     time.sleep(1)

                        #     self.danger_turn_flag += 1
                        #     return False
                        # else:
                        #     if self.is_vertical():  # vertical is True
                        #         self.danger_line_flag += 1
                        #         time.sleep(1)
                        #         return False
                        #     else:
                        #         # self.robo._motion.walk("FORWARD", short=True)
                        #         self.robo._motion.turn(Robo.arrow, 10)
                        #         return False

            elif MissionDanger.go_robo():
                self.count_area += 1
                self.check_danger += 1
                return False
            else:
                return False

        elif act == act.GO_EXIT:
            print("ACT - controller: ", act)  # Debug
            # time.sleep(0.5)
            state = self.robo._image_processor.is_line_horizon_vertical()
            if state == "VERTICAL" and self.check_exit > 0:
                self.robo._motion.turn(
                    Robo.arrow, 45, 3, arm=True)  # arm = True
                setting.SICK = 0  # 넘어짐 초기화
                self.act = act.EXIT
            elif state == "VERTICAL" and self.check_exit == 0:
                self.robo._motion.walk("FORWARD")
            elif state == "MOVE_LEFT":
                self.robo._motion.walk_side("LEFT")
            elif state == "MOVE_RIGHT":
                self.robo._motion.walk_side("RIGHT")
            elif state == "TURN_LEFT":
                self.robo._motion.turn("LEFT", 10)
            elif state == "TURN_RIGHT":
                self.robo._motion.turn("RIGHT", 10)
            elif state == "BOTH":  # 선 둘 다 인식
                self.check_exit += 1
                self.robo._motion.walk("FORWARD", 2, 1)

            # elif state == "HORIZON": # (일단 사용 x) BOTH가 잘 인식 안될경우 사용
            #     self.check_exit += 1
            #     self.robo._motion.walk("FORWARD")
            else:
                self.robo._motion.walk("FORWARD")
                return False
            return False

        else:  # EXIT
            print("ACT - controller: ", act)  # Debug
            time.sleep(0.5)
            state = self.robo._image_processor.is_line_horizon_vertical()
            if state == "VERTICAL":
                self.robo._motion.walk("FORWARD")
            elif state == "MOVE_LEFT":
                self.robo._motion.walk_side("LEFT")
            elif state == "MOVE_RIGHT":
                self.robo._motion.walk_side("RIGHT")
            elif state == "TURN_LEFT":
                self.robo._motion.turn("LEFT", 10)
            elif state == "TURN_RIGHT":
                self.robo._motion.turn("RIGHT", 10)
            else:  # 아무것도 인식 X -> 종료 조건
                self.robo._motion.walk("FORWARD", 1)
                time.sleep(1)
                if len(Robo.black_room_list) > 1:
                    for i in Robo.black_room_list:
                        self.robo._motion.notice_alpha(i)
                        time.sleep(1)
                else:
                    self.robo._motion.notice_alpha(Robo.black_room_list[0])
                # return False # Debug
                return True
            return False
        return False
