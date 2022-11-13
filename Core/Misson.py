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

    ### danger ###
    # (예시)
    DETECT_ALPHABET = auto() # 방이름 감지
    FIND_OBJ = auto() # 장애물 찾기
    OUT_OF_DANGER_OBJ = auto() # 위험지역 밖으로 장애물 옮기기
    SPEAKING_ALPHABET = auto() # 알파벳 글자 말하기


    EXIT = auto() # 공통

class MissonEntrance:
    act: Act = Act.START
    robo: Robo = Robo()
    print(robo)
    print(robo._motion)
    print('##########################')
    # robo._image_processor("src/entrance/entr03-1.mp4")

    map_arrow: str # 화살표
    map_direction: str # 방위

    miss: int = 0

    @classmethod
    def init_robo(self, robo:Robo):
        self.robo = robo

    # 방위 감지
    @classmethod
    def get_direction(self):
        if cur.MAP_DIRECTION:
            self.map_direction = cur.MAP_DIRECTION
        else:
            self.map_direction = self.robo._image_processor.get_ewsn()
        
        if self.map_direction:
            self.robo._motion.notice_direction(self.map_direction) # 미션 코드 (motion)
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
            self.robo.arrow = "LEFT" if my_arrow == "LEFT" else "RIGHT"
            return True
        else: # 인식 실패
            return False
        
        
    @classmethod
    # 입장 미션 순서도
    def go_robo(self):
        act = self.act

        if act == act.START:
            print('ACT: ', act)
            self.act = Act.DETECT_DIRECTION

        # 방위 인식
        elif act == act.DETECT_DIRECTION:
            print('ACT: ', act) # Debug
            # (motion) 고개 올리기 70도 - 방위 보이게
            self.robo._motion.set_head("DOWN", 70)

            if self.get_direction():
                self.miss = 0
            else:
                # motion? 인식 잘 안될경우 -> 알파벳이 중앙에 있는지 판단하는 알고리즘 연결
                return False

            # (motion) 고개 올리기 110도 - 화살표 보이게
            self.robo._motion.set_head("DOWN", 110)
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

    @classmethod
    def go_robo(self):
        act = self.act

        
    
    
class MissonDanger:
    act: Act = Act.START

    miss: int = 0
    room_color: str

    def init_robo(self, robo:Robo):
            self.robo = robo  

    @classmethod
    def go_robo(self):
        act = self.act
        robo: Robo = Robo

        if act == act.START:
            self.act = Act.DETECT_ALPHABET
        
        elif act == act.DETECT_ALPHABET:
            # motion: 고개 돌리기
            self.robo._motion.set_head()
            pass
            # if self.detect_alphabet():
            #     self.miss = 0
            #     # motion
            # elif self.miss > 1:
            #     # motion
            #     self.detect_alphabet()
            # else:
            #     self.miss += 1

            # self.act = Act.OUT_OF_DANGER_OBJ
        elif act == act.OUT_OF_DANGER_OBJ:
            self.act = Act.SPEAKING_ALPHABET

        elif act == act.SPEAKING_ALPHABET:
            # motion

            self.act = Act.EXIT
        
        else: # EXIT
            return True
