# -*- coding: utf-8 -*-
from enum import Enum, auto
from Core.Robo import Robo
from Setting import cur, Arrow
import time

class Act(Enum):
    START = auto() # 공통

    FIND_LINE = auto()
    ### entrance ###
    DETECT_DIRECTION = auto()
    DETECT_ARROW = auto()

    ### stair ###
    FIRST_ROTATION = auto()
    CENTER_AND_FORWARD = auto()
    SECOND_ROTATION = auto()

    DRAW_STAIR_LINE = auto()
    STAIR_DOWN = auto()

    ### danger ###
    # (예시)
    DETECT_ALPHABET = auto() # 방이름 감지
    FIND_OBJ = auto() # 장애물 찾기
    OUT_OF_DANGER_OBJ = auto() # 위험지역 밖으로 장애물 옮기기
    SPEAKING_ALPHABET = auto() # 알파벳 글자 말하기


    EXIT = auto() # 공통

# class MissonEntrance:
#     act: Act = Act.START
#     robo: Robo = Robo()
#     print("MissionEntrance")
#     print(robo)
#     # print(robo._motion)
#     # robo._image_processor("src/entrance/entr03-1.mp4")
#
#     map_arrow: str # 화살표
#     map_direction: str # 방위
#
#     miss: int = 0
#
#     @classmethod
#     def init_robo(self, robo:Robo):
#         self.robo = robo
#
#     # 방위 감지
#     def detect_direction(self):
#         # 모션 제어
#         # self.robo._motion
#         # time.sleep()
#         if cur.MAP_DIRECTION:
#             self.map_direction = cur.MAP_DIRECTION
#         else:
#             self.map_direction = self.robo._image_processor.get_direction()
#
#         if self.map_direction:
#             # 미션 코드 (motion)
#             return True
#         else: # 인식 실패
#             # motion code
#             self.miss += 1
#             return False
#
#         # 방위 저장할 필요가 있을까??
#
#     # 화살표 방향 감지
#     @classmethod
#     def get_arrow(self):
#         if cur.MAP_ARROW:
#             my_arrow = cur.MAP_ARROW
#         else:
#             my_arrow = self.robo._image_processor.get_arrow()
#
#         if my_arrow:
#             self.robo.arrow = Arrow.LEFT if my_arrow == "LEFT" else Arrow.RIGHT
#             return True
#         else: # 인식 실패
#             # motion code
#             self.miss += 1
#             return False
#
#
#     @classmethod
#     # 입장 미션 순서도
#     def go_robo(self):
#         act = self.act
#
#         if act == act.START:
#             print('ACT: ', act)
#             # self.act = Act.DETECT_DIRECTION
#             self.act = Act.DETECT_ARROW
#
#         # # 방위 인식
#         # elif act == act.DETECT_DIRECTION:
#         #     print('ACT: ', act)
#         #     # self.detect_direction()
#         #     if self.detect_direction():
#         #         self.miss = 0
#         #     else:
#         #         # motion
#         #         self.detect_direction()
#         #         return False
#
#         #     # (motion) 고개 올리기 - 화살표 보이게
#         #     self.act = Act.DETECT_ARROW
#
#         # 화살표 인식
#         elif act == act.DETECT_ARROW:
#             print('ACT: ', act)
#             if self.get_arrow():
#                 # (motion) 고개 내리기 - 노란선 보이게
#                 self.robo._motion.set_head()
#                 self.act = Act.EXIT
#             else:
#                 # motion
#                 self.robo._motion.set_head()
#                 self.detect_arrow()
#                 return False
#
#
#         else: # EXIT
#             print('ACT: ', act)
#             return True
#
#         return False
#
# #############################################################

class MissonStair:
    act: Act = Act.START
    robo: Robo = Robo()
    print('MissionStair')
    map_arrow: 'RIGHT' # 화살표
    # robo._image_processor("Sensor/src/stair/1114_21:21.h264")

    # room_name: str # 방 이름
    # room_color: str # 방 이름 색상
    # room_area: RoomArea # 방 지역명 (계단/위험)

    # miss: int = 0

    # def reset(self):
    #     self.act = Act.START
    #     self.init_robo(robo=self.robo)
    #     self.miss = 0

    def init_robo(self, robo:Robo):
        self.robo = robo

    def first_rotation(self):
        return self.robo._image_processor.first_rotation(True)
        # return True
    def center_and_forward(self):
        # return self.robo._image_processor.alphabet_center_check()
        return True

    def second_rotation(self):
        # return self.robo._image_processor.second_rotation()
        return True

    def stair_up(self):
        # return self.robo._image_processor.draw_stair_line()
        return 'Top'

    def stair_down(self):
        return self.robo._image_processor.stair_down()
        # return True

    # def init_debug(self, room_name, room_color, room_area):
    #     self.room_name = room_name
    #     self.room_color = room_color
    #     self.room_area

    @classmethod
    def go_robo(self):
        act = self.act

        if act == act.START:
            print('Act = %s'%act)
            self.act = Act.FIRST_ROTATION

        #현재 상태: 계단을 70도로 바라보고 계단임이 판단됨.
        elif act == act.FIRST_ROTATION: #현재 머리각도 70
            print('Act = %s'%act)

            if self.first_rotation(self)==True: #True 회전완료
                self.act = Act.CENTER_AND_FORWARD
            else: #LEFT, RIGHT 로 반환됨
                self.robo._motion.turn(Robo.arrow,45) #화살표 방향으로 회전해야함
                pass

        elif act == act.CENTER_AND_FORWARD:
            print('Act = %s'%act)

            ret = self.center_and_forward(self)
            if ret == True:
                self.act = Act.SECOND_ROTATION
            elif ret == False: #전진
                pass
                # self.robo._motion.walk(self,'FORWARD',loop=2)
            elif ret == 'Fail':
                pass
                # self.robo._motion.turn(self,Robo.arrow,20,arm=True) #화살표 방향
            else: #return= LEFT or RIGHT
                pass
                # self.robo._motion.turn(self,ret,20,arm=True) #return 값대로 turn


        elif act == act.SECOND_ROTATION:
            print('Act = %s'%act)

            if self.second_rotation(self)==True:
                # self.robo._motion.set_head(self,'DOWN',angle=30) #30도
                # self.robo._motion.walk(self,'FORWARD',loop=4) # 3회 정도
                # self.robo._motion.walk(self,'FORWARD',loop=4,short=True) #좁은 보폭
                self.act = Act.DRAW_STAIR_LINE
            else:
                # turn 인자값 = self.second_rotation()
                # self.robo._motion.turn(self,Robo.disarrow,45) #화살표 반대 방향으로
                pass

        elif act == act.DRAW_STAIR_LINE:
            print('Act = %s'%act)

            ret = self.stair_up(self)
            if ret == True: #1->2로 up, 샤샥 & 2->3로 up 할 때도
                # self.robo._motion.stair(self,'LEFT_UP') # up
                # self.robo._motion.walk(self,'FORWARD',loop=4,short=True) #좁은 보폭
                pass
            elif ret == False: #선이 안 잡힌 경우 샤샥, 2층에서 중앙 아래에 선이 잡힌 경우
                # self.robo._motion.walk(self,'FORWARD',loop=4,short=True) #좁은 보폭
                pass
            elif ret == 'Top':
                # self.robo._motion.walk(self,'FORWARD',loop=4)
                # self.robo._motion.walk_side(self,Robo.arrow,loop=4)
                # self.robo._motion.turn(self,Robo.disarrow,20,loop=2,arm=True)#손들고 턴으로 2회
                self.act = Act.STAIR_DOWN

        elif act == act.STAIR_DOWN:
            print('Act = %s'%act)

            if self.stair_down(self)==True: #1층임
                # self.robo._motion.walk(self,'FORWARD',loop=2) #전진 2회
                # self.robo._motion.turn(self,Robo.disarrow,45,loop=2 ) #화살표 반대 방향으로
                # self.robo._motion.set_head(self,'DOWN',angle=45) #45도
                self.act = Act.EXIT
            else:
                # self.robo._motion.stair(self,'LEFT_DOWN') #down
                pass

        elif act == act.EXIT:
            print('Act = %s'%act)
            return True

        return False

# class MissonDanger:
#     act: Act = Act.START
#
#     miss: int = 0
#     room_color: str
#
#     def init_robo(self, robo:Robo):
#             self.robo = robo
#
#     @classmethod
#     def go_robo(self):
#         act = self.act
#         robo: Robo = Robo
#
#         if act == act.START:
#             self.act = Act.DETECT_ALPHABET
#
#         elif act == act.DETECT_ALPHABET:
#             # motion: 고개 돌리기
#             self.robo._motion.set_head()
#             pass
#             # if self.detect_alphabet():
#             #     self.miss = 0
#             #     # motion
#             # elif self.miss > 1:
#             #     # motion
#             #     self.detect_alphabet()
#             # else:
#             #     self.miss += 1
#
#             # self.act = Act.OUT_OF_DANGER_OBJ
#         elif act == act.OUT_OF_DANGER_OBJ:
#             self.act = Act.SPEAKING_ALPHABET
#
#         elif act == act.SPEAKING_ALPHABET:
#             # motion
#
#             self.act = Act.EXIT
#
#         else: # EXIT
#             return True
