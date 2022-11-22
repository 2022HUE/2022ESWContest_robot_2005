# -*- coding: utf-8 -*-

from enum import Enum, auto
from Core.Robo import Robo
from Setting import cur
import time


class Act(Enum):
    START = auto()  # 공통
    FIND_LINE = auto()
    DETECT_DIRECTION = auto()
    DETECT_ARROW = auto()
    EXIT = auto()  # 공통


print('code: MissonEntrance.py - ## Debug')
class MissionEntrance:
    print('# entrance #')
    act: Act = Act.START
    robo: Robo = Robo()
    # print(robo)
    # print(robo._motion)
    # print('##########################')
    # robo._image_processor("src/entrance/entr03-1.mp4")

    map_arrow: str  # 화살표
    map_direction: str  # 방위

    miss: int = 0

    @classmethod
    def init_robo(self, robo: Robo):
        self.robo = robo

    # 방위 감지
    @classmethod
    def get_direction(self):
        if cur.MAP_DIRECTION:
            self.map_direction = cur.MAP_DIRECTION
        else:
            print('check direction')
            self.map_direction = self.robo._image_processor.get_ewsn()
        
        if self.map_direction:
            self.robo._motion.notice_direction(self.map_direction)
            time.sleep(2.5) # Lock
            return True
        else: # 인식 실패 
            return False
        
    # 화살표 방향 감지
    @classmethod
    def get_arrow(self):
        if cur.MAP_ARROW:
            my_arrow = cur.MAP_ARROW
        else:
            my_arrow = self.robo._image_processor.get_arrow()

        if my_arrow:
            Robo.arrow = "LEFT" if my_arrow == "LEFT" else "RIGHT"
            return True
        else: # 인식 실패
            return False

    @classmethod
    # 입장 미션 순서도
    def go_robo(self):
        act = self.act

        print('GO ROBO')

        if act == act.START:
            print('ACT: ', act)
            # (motion) 고개 올리기 70도 - 방위 보이게
            time.sleep(1)
            self.robo._motion.set_head("DOWN", 70)

            self.act = Act.DETECT_DIRECTION

        # 방위 인식
        elif act == act.DETECT_DIRECTION:
            print('ACT: ', act) # Debug
            if self.get_direction():
                self.miss = 0
            else:
                # motion? 인식 잘 안될경우 -> 알파벳이 중앙에 있는지 판단하는 알고리즘 연결
                return False

            # (motion) 고개 올리기 100도 - 화살표 보이게 (11/20 110도 -> 100도 수정)
            self.robo._motion.set_head("DOWN", 100)
            self.act = Act.DETECT_ARROW
        
        # 화살표 인식
        elif act == act.DETECT_ARROW:
            print('ACT: ', act) # Debug
            if self.get_arrow(): # 인식 성공
                # (motion) 고개 내리기 30 - 노란선 보이게
                self.robo._motion.set_head("DOWN", 30)
                self.act = Act.EXIT
            else:
                return False


        else:  # EXIT
            print('ACT: ', act)
            return True

        return False