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

    tleft: int = 0
    tright: int = 0

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
            time.sleep(2)
            self.map_direction = self.robo._image_processor.get_ewsn()

        if self.map_direction:
            self.robo._motion.notice_direction(self.map_direction)
            time.sleep(3)  # Lock
            return True
        else:  # 인식 실패
            return False

    # 화살표 방향 감지
    @classmethod
    def get_arrow(self):
        print('misson_entrance_get_arrow')
        time.sleep(1)
        if cur.MAP_ARROW:
            Robo.arrow = cur.MAP_ARROW
        else:
            Robo.arrow = self.robo._image_processor.get_arrow()
            print("Robo arrow:: ", Robo.arrow)
        if Robo.arrow:
            # Robo.arrow = "LEFT" if my_arrow == "LEFT" else "RIGHT"
            Robo.dis_arrow = "RIGHT" if Robo.arrow == "LEFT" else "LEFT"
            return True
        else:  # 인식 실패
            print('arrow - 인식실패')
            return False

    @classmethod
    # 입장 미션 순서도
    def go_robo(self):
        act = self.act

        print('GO ROBO')

        if act == act.START:
            print('ACT - Entrance: ', act)
            # (motion) 고개 올리기 70도 - 방위 보이게
            # time.sleep(1)
            # self.robo._motion.set_head("DOWN", 70)
            # self.robo._motion.set_head("DOWN", 80)
            self.robo._motion.set_head("DOWN", 90)
            time.sleep(1)
            self.act = Act.DETECT_DIRECTION

            # arrow debuging
            # self.robo._motion.set_head("DOWN", 100)
            # self.act = Act.DETECT_ARROW

        # 방위 인식
        elif act == act.DETECT_DIRECTION:
            print('ACT - Entrance: ', act)  # Debug
            if self.get_direction():
                # for i in range(self.tleft):
                #     self.robo._motion.turn("RIGHT", 10)
                #     # self.robo._motion.walk_side("RIGHT")
                # for i in range(self.tright):
                #     self.robo._motion.turn("LEFT", 10)
                # self.robo._motion.walk_side("LEFT")
                self.miss = 0
            else:
                self.miss += 1
                print(self.miss)
                # time.sleep(1)
                # motion? 인식 잘 안될경우 -> 알파벳이 중앙에 있는지 판단하는 알고리즘 연결
                if 0 < self.miss < 5:
                    if self.miss == 1:
                        print("ee")
                        self.robo._motion.walk("FORWARD")
                        time.sleep(1)
                        return False

                    self.robo._motion.turn("LEFT", 10)
                    self.tleft += 1
                    # time.sleep(0.5)
                    self.robo._motion.walk_side("LEFT")
                else:
                    self.robo._motion.turn("RIGHT", 10)
                    # time.sleep(0.5)
                    self.robo._motion.walk_side("RIGHT")
                return False

            # (motion) 고개 올리기 100도 - 화살표 보이게 (11/20 110도 -> 100도 수정)

            self.robo._motion.set_head("DOWN", 100)
            self.act = Act.DETECT_ARROW

        # 화살표 인식
        elif act == act.DETECT_ARROW:
            print('ACT - Entrance: ', act)  # Debug
            if self.get_arrow():  # 인식 성공
                # (motion) 고개 내리기 30 - 노란선 보이게
                # time.sleep(1)
                self.robo._motion.set_head("DOWN", 30)
                time.sleep(1)
                self.act = Act.EXIT
            else:
                # motion add
                self.miss += 1
                time.sleep(1)
                if 0 < self.miss < 4:
                    if self.miss == 1:
                        time.sleep(1)
                        self.robo._motion.walk("FORWARD")
                        time.sleep(1)
                        return False
                    self.robo._motion.turn("LEFT", 10)
                    self.tleft += 1
                    # time.sleep(0.5)
                    self.robo._motion.walk_side("LEFT")
                # elif self.miss < 9:
                else:
                    self.robo._motion.turn("RIGHT", 10)
                    # time.sleep(0.5)
                    self.robo._motion.walk_side("RIGHT")
                # else:
                #     # self.robo._motion.walk("BACKWARD")
                #     time.sleep(5)

                return False

        else:  # EXIT
            print('ACT - Entrance: ', act)
            return True

        return False
