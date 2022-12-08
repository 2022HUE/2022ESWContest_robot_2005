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
    STAIR_OBSTACLE = auto()
    STAIR_DOWN = auto()
    TOP_PROCESSING = auto()
    TOP_TURN = auto()
    CLOSE_TO_DESCENT = auto()
    WALL_MOVE = auto()
    STAIR_FORWARD = auto()
    EXIT = auto()  # 공통


class MissionStair:
    act: Act = Act.START
    robo: Robo = Robo()

    @classmethod
    def init_robo(self, robo: Robo):
        self.robo = robo

    @classmethod
    def stair_obstacle(self):
        print('dddd')
        return self.robo._image_processor.stair_obstacle()

    @classmethod
    def stair_forward(self):
        return self.robo._image_processor.stair_forward()

    @classmethod
    def close_to_descent(self):
        return self.robo._image_processor.close_to_descent()

    @classmethod
    def top_processing(self):
        return self.robo._image_processor.top_processing()

    @classmethod
    def first_rotation(self):
        return self.robo._image_processor.first_rotation(Robo.dis_arrow)
        # return True

    @classmethod
    def center_and_forward(self):
        return self.robo._image_processor.alphabet_center_check()
        # return True

    @classmethod
    def second_rotation(self, Arrow, k):
        return self.robo._image_processor.second_rotation(Arrow, k)
        # return True

    @classmethod
    def stair_up(self):
        return self.robo._image_processor.draw_stair_line()
        # return 'Top'

    @classmethod
    def stair_down(self):
        return self.robo._image_processor.stair_down()
        # return True

    @classmethod
    def wall_move(self):
        return self.robo._image_processor.wall_move(Robo.arrow)

    @classmethod
    def go_robo(self):
        act = self.act

        if act == act.START:
            print('Act = %s' % act)
            self.act = Act.FIRST_ROTATION
            # self.act = Act.EXIT
            # self.act = Act.DRAW_STAIR_LINE
            # self.act = Act.FIRST_ROTATION

        # 현재 상태: 계단을 70도로 바라보고 계단임이 판단됨.
        elif act == act.FIRST_ROTATION:  # 현재 머리각도 70
            print('Act = %s' % act)
            self.robo._motion.turn(
                Robo.dis_arrow, 45, arm=True)  # 화살표 방향으로 회전해야함
            self.act = Act.WALL_MOVE

        elif act == act.WALL_MOVE:  # 머리각도 45도
            self.robo._motion.set_head('DOWN', 40)
            time.sleep(0.3)
            ret = self.wall_move()
            print(ret)
            if ret == True:
                self.robo._motion.walk('FORWARD')  # 3회 정도
                self.robo._motion.kick(Robo.arrow)
                self.robo._motion.kick(Robo.arrow)
                self.robo._motion.kick(Robo.arrow)
                self.robo._motion.walk('FORWARD')  # 3회 정도
                self.robo._motion.walk('FORWARD')  # 3회 정도
                
                self.robo._motion.set_head('DOWN', 30)
                time.sleep(1)
                self.act = Act.DRAW_STAIR_LINE
            else:
                self.robo._motion.walk_side(ret, long=70)  # 벽쪽으로 이동
        # elif act == act.SECOND_ROTATION:
        #     print('Act = %s' % act)
        #     ret = self.second_rotation(Robo.dis_arrow, setting.STAIR_ROTATION)
        #     if ret == True:
        #         self.robo._motion.set_head('DOWN', angle=30)  # 30도
        #         time.sleep(1)
        #         self.robo._motion.walk('FORWARD', loop=5, sleep=1)  # 3회 정도
        #         self.robo._motion.walk('FORWARD', sleep=1, short=True)  # 3회 정도
        #         time.sleep(2)
        #         self.robo._motion.kick(Robo.arrow)
        #         time.sleep(3.5)
        #         self.robo._motion.kick(Robo.arrow)
        #         time.sleep(3.5)
        #         self.robo._motion.kick(Robo.arrow)
        #         time.sleep(3.5)
        #         self.act = Act.DRAW_STAIR_LINE
        #     else:
        #         # print("들어옴")
        #         self.robo._motion.turn(
        #             Robo.dis_arrow, 45, sleep=1)  # 화살표 반대 방향으로
        elif act == act.STAIR_FORWARD:
            ret = self.stair_forward()
            if ret == True:
                self.robo._motion.walk('FORWARD')
            else:
                
                self.act = Act.DRAW_STAIR_LINE

        elif act == act.DRAW_STAIR_LINE:
            print('Act = %s' % act)
            ret = self.stair_up()
            print(ret)
            print(setting.STAIR_LEVEL)

            if ret == True:  # 1->2로 up, 샤샥 & 2->3로 up 할 때도
                wall = self.wall_move()
                if wall == True:
                    self.robo._motion.stair('RIGHT_UP')  # up
                    self.robo._motion.walk(
                        'FORWARD', loop=2, short=True, sleep=1.5)  # 좁은 보폭

                    setting.STAIR_LEVEL += 1  # stair = 2
                else:
                    self.robo._motion.walk_side(wall)  # 벽쪽으로 이동
                    time.sleep(1)

            elif ret == False:  # 선이 안 잡힌 경우 샤샥, 2층에서 중앙 아래에 선이 잡힌 경우
                self.robo._motion.walk(
                    'FORWARD', short=True)  # 좁은 보폭
                time.sleep(0.3)

            elif ret == 'Top':
                self.robo._motion.walk('FORWARD', loop=2)
                # self.robo._motion.walk('FORWARD', short=True)
                self.act = Act.TOP_TURN

        # elif act == act.TOP_PROCESSING:
        #     ret = self.top_processing()
        #     if ret == True:  # 앞으로 어느정도 전진했다.
        #         self.act = Act.TOP_TURN
        #     else:
        #         self.robo._motion.walk('FORWARD',loop=2, sleep=0.2) #손 안 들고 도는 코드로 변경
        #         # self.robo._motion.handsUp_walk(loop=2)  # 전진 2회
        #         # time.sleep(1.5)

        elif act == act.TOP_TURN:
            rotation = self.second_rotation(
                Robo.dis_arrow, setting.top_saturation)
            if rotation == True:
                self.robo._motion.set_head('DOWN', 30)
                time.sleep(1)
                self.act = Act.CLOSE_TO_DESCENT
            else:
                self.robo._motion.turn(rotation, 20, sleep=1)
                time.sleep(0.5)

        elif act == act.CLOSE_TO_DESCENT:
            ret, rotation = self.close_to_descent()
            if ret == True:
                self.robo._motion.notice_area('STAIR')
                time.sleep(1)
                Robo.feet_down = rotation
                self.act = act.STAIR_DOWN
            else:
                self.robo._motion.walk('FORWARD')
                time.sleep(0.5)

        elif act == act.STAIR_DOWN:
            print('Act = %s' % act)

            if self.stair_down() == True:  # 1층임
                self.robo._motion.walk('FORWARD')  # 전진 2회
                self.robo._motion.walk_side(Robo.dis_arrow)  # 옆으로 이동
                self.robo._motion.walk_side(Robo.dis_arrow)  # 옆으로 이동
                self.act = Act.EXIT
            else:
                self.robo._motion.crawl()
                # self.robo._motion.stair(Robo.feet_down)  # down
                # time.sleep(5)
                # # def walk(self, dir, loop=1, sleep=0.1, short=False):
                # self.robo._motion.walk(
                #     'BACKWARD', loop=2, short=True, sleep=1.5)  # 좁은 보폭
                # time.sleep(1)
                #
                # if Robo.feet_down == 'LEFT_DOWN':
                #     Robo.feet_down = 'RIGHT_DOWN'
                # else:
                #     Robo.feet_down = 'LEFT_DOWN'
                # pass

        elif act == act.EXIT:
            print('Act = %s' % act)
            self.robo._motion.set_head('DOWN', angle=30)  # 머리 45도
            return True

        return False