from enum import Enum, auto
from Core.Robo import Robo
import Robo
from Setting import cur, Arrow
import time

class Act(Enum):
    START = auto()
    FIND_LINE = auto()
    ### entrance ###
    DETECT_DIRECTION = auto()
    DETECT_ARROW = auto()

    ### stair ###

    ### danger ###
    DETECT_ALPHABET = auto() # 방이름 감지
    FIND_OBJ = auto() # 장애물 찾기
    OUT_OF_DANGER_OBJ = auto() # 위험지역 밖으로 장애물 옮기기
    SPEAKING_ALPHABET = auto() # 알파벳 글자 말하기


    EXIT = auto()

class MissonEntrance:
    act: Act = Act.START
    robo: Robo = Robo

    map_arrow: str # 화살표
    map_direction: str # 방위

    miss: int = 0

    def init_robo(self, robo:Robo):
        self.robo = robo

    # 방위 감지
    def detect_direction(self):
        # 모션 제어
        # self.robo._motion
        # time.sleep()
        if cur.MAP_DIRECTION:
            self.map_direction = cur.MAP_DIRECTION
        else:
            self.map_direction = self.robo._image_processor.get_map_direction()
        
        if self.map_direction:
            # 미션 코드 (motion)
            return True
        else: # 인식 실패
            # motion code
            self.miss += 1
            return False
        
        # 방위 저장할 필요가 있을까??
        
    
    # 화살표 방향 감지
    def detect_arrow(self):
        if cur.MAP_ARROW:
            map_arrow = cur.MAP_ARROW
        else:
            map_arrow = self.robo._image_processor.get_map_arrow()

        
        if map_arrow:
            self.map_arrow = Arrow.LEFT if map_arrow == "LEFT" else Arrow.RIGHT
            return True
        else: # 인식 실패
            # motion code
            self.miss += 1
            return False
        
        
    
    # 입장 미션 순서도
    def go_robo(self):
        act = self.act

        if act == act.START:
            print('ACT: ', act)
            self.act = Act.DETECT_DIRECTION

        elif act == act.DETECT_DIRECTION:
            print('ACT: ', act)
            # self.detect_direction()
            # (motion) 고개 올리기 - 화살표 보이게
            self.act = Act.DETECT_ARROW
        
        
        elif act == act.DETECT_ARROW:
            print('ACT: ', act)
            if self.detect_arrow():
                print(self.map_arrow)
                print('before', Robo)
                self.robo.map_arrow = self.map_arrow
                # print('after', self.robo.map_arrow)
                self.miss = 0
                # motion
            else:
                # motion
                self.detect_arrow()
                return False


            # (motion) 고개 내리기 - 노란선 보이게
            self.act = Act.EXIT


        else: # EXIT
            print('ACT: ', act)
            return True

        return False




#############################################################

class MissonStair:
    act: Act = Act.START

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
    
    # def init_debug(self, room_name, room_color, room_area):
    #     self.room_name = room_name
    #     self.room_color = room_color
    #     self.room_area
    
    # # 지역(계단/위험) 확인하는 함수
    # def chk_room_area(self):
    #     # 모션 제어 코드
    #     pass 

    def go_robo(self):
        act = self.act
        
    
    
class MissonDanger:
    act: Act = Act.START

    miss: int = 0

    def init_robo(self, robo:Robo):
            self.robo = robo  

    
    
    def detect_alphabet(self):
        pass

    def go_robo(self):
        act = self.act
        robo: Robo = Robo

        if act == act.START:
            self.act = Act.DETECT_ALPHABET
        
        elif act == act.DETECT_ALPHABET:
            if self.detect_alphabet():
                self.miss = 0
                # motion
            elif self.miss > 1:
                # motion
                self.detect_alphabet()
            else:
                self.miss += 1

            self.act = Act.OUT_OF_DANGER_OBJ

        elif act == act.OUT_OF_DANGER_OBJ:
            self.act = Act.SPEAKING_ALPHABET

        elif act == act.SPEAKING_ALPHABET:
            # motion

            self.act = Act.EXIT
        
        else: # EXIT
            return True
