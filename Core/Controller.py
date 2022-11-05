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

            

    def go_robo(self):
        act = self.act
        robo: Robo = Robo

        if act == act.START:
            self.act = act.GO_ENTRANCE
            
        elif act == act.GO_ENTRANCE:
            # motion
            # 고개 내려서 선 인식
            # 수평선이 나올 때까지 직진
            # 고개 올리기
            self.act = act.ENTRANCE

        elif act == act.ENTRANCE:
            robo.entrance = True
            self.check_cur_area()
            if self.area == "STAIR":
                self.act = act.GO_STAIR
            else:
                self.act = act.GO_DANGER

        elif act == act.GO_STAIR:
            self.act = act.STAIR

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