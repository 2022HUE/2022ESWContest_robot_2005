# -*- coding: utf-8 -*-
from enum import Enum, auto
from Core.Robo import Robo
from Sensor.Setting import setting
import time


class Act(Enum):
    START = auto()  # 공통
    FIND_LINE = auto()
    FIRST_ROTATION = auto()
    CENTER_AND_FORWARD = auto()
    SECOND_ROTATION = auto()
    DRAW_STAIR_LINE = auto()
    STAIR_DOWN = auto()
    EXIT = auto()  # 공통


class MissionStair:
    act: Act = Act.START
    robo: Robo = Robo()
    # robo._image_processor("Sensor/src/stair/1114_21:21.h264")

    # room_name: str # 방 이름
    # room_color: str # 방 이름 색상
    # room_area: RoomArea # 방 지역명 (계단/위험)

    # miss: int = 0

    # def reset(self):
    #     self.act = Act.START
    #     self.init_robo(robo=self.robo)
    #     self.miss = 0
    @classmethod
    def init_robo(self, robo: Robo):
        self.robo = robo

    @classmethod
    def first_rotation(self):
        # return self.robo._image_processor.first_rotation(Robo.arrow, True)
        return True

    @classmethod
    def center_and_forward(self):
        # return self.robo._image_processor.alphabet_center_check()
        return True

    @classmethod
    def second_rotation(self):
        # return self.robo._image_processor.second_rotation(Robo.dis_arrow)
        return True

    @classmethod
    def stair_up(self):
        return self.robo._image_processor.draw_stair_line()
        # return 'Top'

    @classmethod
    def stair_down(self):
        # return self.robo._image_processor.stair_down()
        return True

    @classmethod
    def go_robo(self):
        act = self.act

        if act == act.START:
            print('Act = %s' % act)
            self.act = Act.FIRST_ROTATION

        # 현재 상태: 계단을 70도로 바라보고 계단임이 판단됨.
        elif act == act.FIRST_ROTATION:  # 현재 머리각도 70
            print('Act = %s' % act)
            ret = self.first_rotation()
            if ret == True:  # True 회전완료
                self.act = Act.CENTER_AND_FORWARD
            else:  # LEFT, RIGHT 로 반환됨
                # self.robo._motion.turn(ret, 20)  # 화살표 방향으로 회전해야함
                pass

        elif act == act.CENTER_AND_FORWARD:
            print('Act = %s' % act)
            ret = self.center_and_forward()
            print("ret = %s" % ret)
            if ret == True:
                self.act = Act.SECOND_ROTATION
            elif ret == False:  # 전진
                pass
                # self.robo._motion.walk('FORWARD')
                # time.sleep(2)
            elif ret == 'fail':
                pass
                # self.robo._motion.turn(Robo.arrow, 10)  # 화살표 방향
                # time.sleep(2)
            else:  # return= LEFT or RIGHT
                pass
                # self.robo._motion.turn(ret, 20)  # return 값대로 turn
                # time.sleep(2)

        elif act == act.SECOND_ROTATION:
            print('Act = %s' % act)

            if self.second_rotation() == True:
                # self.robo._motion.set_head('DOWN', angle=30)  # 30도
                # self.robo._motion.walk('FORWARD', loop=4)  # 3회 정도
                # self.robo._motion.walk('FORWARD', loop=4, short=True)  # 좁은 보폭
                self.act = Act.DRAW_STAIR_LINE
            else:
                # turn 인자값 = self.second_rotation()
                # self.robo._motion.turn(
                #     Robo.dis_arrow, 45, arm=False)  # 화살표 반대 방향으로
                pass

        elif act == act.DRAW_STAIR_LINE:
            print('Act = %s' % act)
            ret = self.stair_up()

            if ret == True:  # 1->2로 up, 샤샥 & 2->3로 up 할 때도
                self.robo._motion.stair('LEFT_UP')  # up
                time.sleep(5)
                self.robo._motion.walk('FORWARD', loop=4, short=True)  # 좁은 보폭
                setting.STAIR_LEVEL += 1  # stair = 2
                time.sleep(2)
                pass
            elif ret == False:  # 선이 안 잡힌 경우 샤샥, 2층에서 중앙 아래에 선이 잡힌 경우
                self.robo._motion.walk('FORWARD', loop=1, short=True)  # 좁은 보폭
                time.sleep(2)
                pass
            elif ret == 'Top':
                self.robo._motion.walk('FORWARD', loop=4)  # 3층 도착해서 전진
                self.robo._motion.walk_side(Robo.arrow, loop=1)  # 옆으로 이동
                self.robo._motion.turn(
                    Robo.dis_arrow, 20, loop=2, arm=True)  # 손들고 턴으로 2회
                self.robo._motion.walk('FORWARD', loop=2)  # 3층 도착해서 전진
                self.robo._motion.notice_alpha('STAIR')
                self.act = Act.STAIR_DOWN

        elif act == act.STAIR_DOWN:
            print('Act = %s' % act)

            if self.stair_down() == True:  # 1층임
                # self.robo._motion.walk('FORWARD',loop=2) #전진 2회
                # self.robo._motion.turn(Robo.dis_arrow,45,loop=2 ) #화살표 반대 방향으로
                # self.robo._motion.set_head('DOWN',angle=45) #45도
                self.act = Act.EXIT
            else:
                # self.robo._motion.stair('LEFT_DOWN') #down
                pass

        elif act == act.EXIT:
            print('Act = %s' % act)
            return True

        return False
