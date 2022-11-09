from enum import Enum, auto
from Core.Robo import Robo
from Core.Misson import MissonEntrance, MissonStair, MissonDanger
from Setting import cur
import time

limits: int=2

class Act(Enum): # 맵 전체 수행 순서도
    # (미션)이 적혀진 순서에서는 Misson.py에서 과제를 수행합니다.
    START = auto() # 시작
    GO_ENTRANCE = auto() # 입장
    ENTRANCE = auto() # (미션)입장
    GO_NEXTROOM = auto() # 다음 지역으로 이동
    STAIR = auto() # (미션)계단지역미션
    DANGER = auto() # (미션)위험지역
    GO_EXIT = auto() # 퇴장
    EXIT = auto() # 종료

class Controller:
    robo: Robo = Robo
    act: Act = Act.START

    # 방문한 미션 지역의 수
    count_area: int=0 # 위험/계단 지역만 카운트합니다.
    count_misson: int=0
    goto_rotate: bool = False
    area: str = ""

    miss: int=0

    # Misson.py
    _entr: MissonEntrance = MissonEntrance
    _stair: MissonStair = MissonStair
    _danger: MissonDanger = MissonDanger

    MissonEntrance.init_robo(_entr, robo)
    MissonStair.init_robo(_stair, robo)
    MissonDanger.init_robo(_danger, robo)



    # 위험 지역인지 계단 지역인지 판단
    def check_area(self):
        if self.count_area == 0: # 최초 방문
            if cur.AREA:
                self.area = cur.AREA
            else:
                self.area = self.robo._image_processor.is_danger()
        else:
            if self.area == "STAIR":self.area = "DANGER"
            else: self.area = "STAIR"


    def is_horizon(self):
        state = self.robo._image_processor.is_line_horizon_vertical()
        if state == "HORIZON":
            return True
        elif state == "VERTICAL":
            return "GO"
        elif state == "LEFT" or state == "RIGHT":
            return state
        else:
            return False
        
    def line_rotate(self):
        state = self.robo._image_processor.is_line_horizon_vertical()
        if state == "LEFT" or state == "RIGHT":
            # motion) state 방향으로 회전
            return False
        elif state == "VERTICAL" or state == "BOTH":
            return True
        else: # state: "HORIZON"
            # motion을 어떻게 넣을까요?
            return False
        

    def go_robo(self):
        act = self.act
        robo: Robo = Robo

        if act == act.START:
            print("ACT: ", act) # Debug

            print("current area: ", cur.AREA, "(Setting.py Hard Coding for Debuging)")
            # self.act = act.GO_ENTRANCE
            self.act = act.GO_NEXTROOM # Debug
            
        # elif act == act.GO_ENTRANCE:
        #     # motion: 고개 내리기
        #     goto_ = self.is_horizon()
        #     if goto_ is True:
        #         # motion: 고개 올리기 up
        #         self.act = act.ENTRANCE
        #     elif goto_ == "GO":
        #         # motion: 전진
        #         return False
        #     elif goto_ == "LEFT":
        #         # motion: 왼쪽으로 조금  회전+이동
        #         return False
        #     elif goto_ == "RIGHT":
        #         # motion: 오른쪽으로 조금 회전+이동
        #         return False
        #     else:
        #         # 여기도 전진을 넣어도 될까?
        #         return False


        # elif act == act.ENTRANCE:
        #     if MissonEntrance.go_robo():
        #         self.check_cur_area()
        #         if self.area == "STAIR":
        #             self.act = act.GO_STAIR
        #         else:
        #             self.act = act.GO_DANGER
        #     else:
        #         return False

        elif act == act.GO_NEXTROOM:
            print("ACT: ", act) # Debug

            # motion: 화살표 방향으로 회전
            # if self.goto_rotate: 
            #     goto_ = self.is_horizon()
            # else: 
            #     goto_ = self.line_rotate()
            # if goto_:
            #     # motion 전진
            #     if self.goto_rotate:
            #         self.act = act.STAIR
            #     else:
            #         self.goto_rotate = True
            
            # 방 입구 도착 -> 위험/계단지역 판단
            # [motion] 로봇 머리만 화살표 방향으로 45도 회전
            # self.robo._motion.set_head()
            self.check_area()
            print("----Current Area", self.area, "----")
            if self.area == "STAIR":
                self.act = act.STAIR
            else: self.act = act.DANGER

            # else:
            #     return False

        elif act == act.STAIR:
            print("ACT: ", act) # Debug

            self.count_area += 1
            if self.count_area < limits: 
                self.act = act.GO_NEXTROOM
            else:
                self.act = act.EXIT

        elif act == act.DANGER:
            print("ACT: ", act) # Debug

            self.count_area += 1
            if self.count_area < limits: 
                self.act = act.GO_NEXTROOM
            else:
                self.act = act.EXIT

        elif act == act.GO_EXIT:
            print("ACT: ", act) # Debug
            pass

        else: # EXIT
            print("ACT: ", act) # Debug
            return True
        return False
