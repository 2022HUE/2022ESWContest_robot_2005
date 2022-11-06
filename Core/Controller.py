from enum import Enum, auto
from Robo import Robo
from Misson import MissonEntrance, MissonStair, MissonDanger
from Setting import cur
import time

room_limits: int=2

class Act(Enum): # 맵 전체 수행 순서도
    START = auto()
    GO_ENTRANCE = auto()
    ENTRANCE = auto()
    GO_STAIR = auto()
    STAIR = auto()
    GO_DANGER = auto()
    DANGER = auto()
    GO_EXIT = auto()
    EXIT = auto()

class Controller:
    robo: Robo = Robo
    act: Act = Act.START
    count_room: int=0
    count_misson: int=0
    goto_rotate: bool = False
    area: str

    MissonEntrance.init_robo(robo)
    MissonStair.init_robo(robo)
    MissonDanger.init_robo(robo)



    # 위험 지역인지 계단 지역인지 판단
    def check_cur_area(self):
        if self.count_room == 0:
            # motion
            '''
            - 화살표 반대방향으로 회전
            - 고개 각도 조정(70도?)
            '''
            while miss != 0:
                # IPC -return: str -> "DANGER" or "STAIR"
                area = self.robo._image_processor.is_danger()
                if area: # return 값이 있음
                    self.area = area
                    miss = 0
                else:
                    # motion
                    '원위치로 이동'
                    miss += 1

        else: # count_room >= 1
            # 이미 위험지역을 이전에 수행했을 경우
            if self.robo.danger:
                self.area = "STAIR"
            else:
                self.area = "DANGER"

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
            self.act = act.GO_ENTRANCE
            
        elif act == act.GO_ENTRANCE:
            # motion: 고개 내리기
            goto_ = self.is_horizon()
            if goto_ is True:
                # motion: 고개 올리기 up
                self.act = act.ENTRANCE
            elif goto_ == "GO":
                # motion: 전진
                return False
            elif goto_ == "LEFT":
                # motion: 왼쪽으로 조금  회전+이동
                return False
            elif goto_ == "RIGHT":
                # motion: 오른쪽으로 조금 회전+이동
                return False
            else:
                # 여기도 전진을 넣어도 될까?
                return False


        elif act == act.ENTRANCE:
            if MissonEntrance.go_robo():
                self.check_cur_area()
                if self.area == "STAIR":
                    self.act = act.GO_STAIR
                else:
                    self.act = act.GO_DANGER
            else:
                return False

        elif act == act.GO_STAIR:
            # motion: 화살표 방향으로 회전
            if self.goto_rotate: 
                goto_ = self.is_horizon()
            else: 
                goto_ = self.line_rotate()
            if goto_:
                # motion 전진
                if self.goto_rotate:
                    self.act = act.STAIR
                else:
                    self.goto_rotate = True
            else:
                return False

        elif act == act.STAIR:
            robo.stair = True
            self.count_room += 1
            if self.count_room > 1: 
                self.act = act.EXIT
            else:
                self.act = act.GO_DANGER

        elif act == act.GO_DANGER:
            self.act = act.DANGER

        elif act == act.DANGER:
            robo.danger = True
            self.count_room += 1
            if self.count_room > 1: 
                self.act = act.EXIT
            else:
                self.act = act.GO_STAIR

        elif act == act.GO_EXIT:
            pass

        else: # EXIT
            pass