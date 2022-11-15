from enum import Enum, auto
from Core.Robo import Robo
from Setting import cur, Arrow
import time


class Act(Enum):
    START = auto()  # 공통
    FIND_LINE = auto()
    ### entrance ###
    DETECT_DIRECTION = auto()
    DETECT_ARROW = auto()

    ### stair ###

    ### danger ###
    # (예시)출
    SPEAK_DANGER = auto()
    DETECT_ALPHABET = auto()  # 방이름 감지
    WALK_TO_MILKBOX = auto()  # 장애물 찾기
    OUT_OF_DANGER = auto()  # 위험지역 밖으로 장애물 옮기기
    REGRAB_MILKBOX = auto() # 떨어진 장애물 다시 잡기 -> WALK_TO_MILKBOX로 충분할 것 같아서 일단 안씀
    KICK_MILKBOX = auto() # 자꾸 장애물을 떨어트릴 경우 이 방법 사용 (발로 차거나 치우기 동작 수행)
    EXIT = auto()  # 공통


class MissonEntrance:
    act: Act = Act.START
    robo: Robo = Robo()
    print(robo)
    print(robo._motion)
    print('##########################')
    # robo._image_processor("src/entrance/entr03-1.mp4")

    map_arrow: str  # 화살표
    map_direction: str  # 방위

    miss: int = 0

    @classmethod
    def init_robo(self, robo: Robo):
        self.robo = robo

    # 방위 감지
    def detect_direction(self):
        # 모션 제어
        # self.robo._motion
        # time.sleep()
        if cur.MAP_DIRECTION:
            self.map_direction = cur.MAP_DIRECTION
        else:

            self.map_direction = self.robo._image_processor.get_direction()

        if self.map_direction:
            # 미션 코드 (motion)
            return True
        else:  # 인식 실패
            # motion code
            self.miss += 1
            return False

        # 방위 저장할 필요가 있을까??

    # 화살표 방향 감지
    @classmethod
    def get_arrow(self):
        if cur.MAP_ARROW:
            my_arrow = cur.MAP_ARROW
        else:
            my_arrow = self.robo._image_processor.get_arrow()

        if my_arrow:
            self.robo.arrow = Arrow.LEFT if my_arrow == "LEFT" else Arrow.RIGHT
            return True
        else:  # 인식 실패
            # motion code
            self.miss += 1
            return False

    @classmethod
    # 입장 미션 순서도
    def go_robo(self):
        act = self.act

        if act == act.START:
            print('ACT: ', act)
            # self.act = Act.DETECT_DIRECTION
            self.act = Act.DETECT_ARROW

        # # 방위 인식
        # elif act == act.DETECT_DIRECTION:
        #     print('ACT: ', act)
        #     # self.detect_direction()
        #     if self.detect_direction():
        #         self.miss = 0
        #     else:
        #         # motion
        #         self.detect_direction()
        #         return False

        #     # (motion) 고개 올리기 - 화살표 보이게
        #     self.act = Act.DETECT_ARROW

        # 화살표 인식
        elif act == act.DETECT_ARROW:
            print('ACT: ', act)
            if self.get_arrow():
                # (motion) 고개 내리기 - 노란선 보이게
                self.robo._motion.set_head()
                self.act = Act.EXIT
            else:
                # motion
                self.robo._motion.set_head()
                self.detect_arrow()
                return False


        else:  # EXIT
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

    def init_robo(self, robo: Robo):
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


##############################################

class MissonDanger:
    act: Act = Act.START
    robo: Robo = Robo()
    miss: int = 0
    limits: int = 3
    alphabet_color: str
    alphabet_name: str
    milkbox_pos: int
    head_angle: int = 70
    holding: bool
    first_milkbox_pos: int

    def init_robo(self, robo: Robo):
        self.robo = robo

    @classmethod
    def is_okay_grab_milkbox(self):
        if self.head_angle == 70:
            self.head_angle = 45
            # motion : 고개 각도 45도로 설정

            return False
        elif self.head_angle == 45:
            self.head_angle = 30
            # motion : 고개 각도 30도로 설정

            return False
        else:
            # motion : 장애물 잡기 동작 수행

            # motion : 장애물 집고 앞으로 한번 걷기 동작 수행

            return True

    @classmethod
    def go_robo(self):
        act = self.act

        if act == act.START:
            self.act = Act.SPEAK_DANGER

        elif act == act.SPEAK_DANGER:

            # motion : "위험지역" 음성 말하기

            # motion: 화살표 반대 방향으로 고개 돌리기

            self.act = Act.DETECT_ALPHABET

        elif act == act.DETECT_ALPHABET:
            # 방 알파벳 색상 인식 -> 보기 불편해서 함수로 빼는 게 좋을 듯
            # 색상 고정이면 이렇게 하고 싶은데 위험 지역 2개 돌 경우,
            # 이전 세팅에 저장되어있는 값 사용하게 되어 다른 색상을 집을 수 있는 문제 발생
            # if not cur.ALPHABET_COLOR:
            self.alphabet_color = self.robo._image_processor.get_alphabet_color()
            if self.alphabet_color:
                self.miss = 0
                cur.ALPHABET_COLOR = self.alphabet_color
            elif self.miss >= self.limits:
                # 계속 못찾으면 그냥 빨강으로 지정
                cur.ALPHABET_COLOR = "RED"
            # 아직 get_alphabet_color miss 처리 안했음
            else:
                self.miss += 1
                return False

            # 방 알파벳 글자 인식
            self.alphabet_name = self.robo._image_processor.get_alphabet_name()
            if self.alphabet_name:
                self.miss = 0
                cur.ALPHABET_NAME.append(self.alphabet_name)
            elif self.miss >= self.limits:
                # 계속 못찾으면 그냥 글자 B로 지정
                self.alphabet_name = 'B'
                cur.ALPHABET_NAME.append(self.alphabet_name)
            else:
                self.miss += 1
                return False

            self.act = Act.WALK_TO_MILKBOX

        elif act == act.WALK_TO_MILKBOX:
            # 위치가 여기가 맞을 지 모르겠지만 일단 여기에 둠
            self.first_milkbox_pos = self.robo._image_processor.get_milkbox_pos(cur.ALPHABET_COLOR)
            while True:
                self.milkbox_pos = self.robo._image_processor.get_milkbox_pos(cur.ALPHABET_COLOR)
                # 9개 구역에 따라 다른 모션 수행
                if self.milkbox_pos == 7:
                    if self.is_okay_grab_milkbox():
                        self.act = Act.OUT_OF_DANGER_OBJ
                        break
                elif self.milkbox_pos == 1 or self.milkbox_pos == 4:
                    # motion : 앞으로 걷기 1번 수행
                    pass
                elif self.milkbox_pos == 0 or self.milkbox_pos == 3 or self.milkbox_pos == 6:
                    # motion : 왼쪽으로 20도 회전 수행
                    pass
                elif self.milkbox_pos == 2 or self.milkbox_pos == 5 or self.milkbox_pos == 8:
                    # motion : 오른쪽으로 20도 회전 수행
                    pass

                # milkbox_pos 를 가져오지 못한 경우
                elif self.miss >= self.limits:
                    # 계속 못찾으면 그냥 시민 대피 미션 포기 (실패할 경우 EXIT 버전 하나 더 만들어야할 듯)
                    self.act = Act.EXIT
                else:
                    self.miss += 1
                    return False

            self.act = Act.OUT_OF_DANGER


        elif act == act.OUT_OF_DANGER:
            # 장애물을 들고 있는 채로 위험지역 밖을 벗어날 때까지 아래 과정 반복
            while True:
                if not self.robo._image_processor.is_holding_milkbox():
                    # motion : 장애물 내려놓기 동작 수행

                    self.act = Act.WALK_TO_MILKBOX
                    return False
                if self.robo._image_processor.is_out_of_black():
                    # motion : 장애물 내려놓기 동작 수행

                    break
                # 무한 루프 갇힐 경우에 대한 예외처리 미처리
                else:
                    if self.first_milkbox_pos == 0:
                        # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 수행
                        pass
                    elif self.first_milkbox_pos == 1:
                        # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass
                    elif self.first_milkbox_pos == 2:
                        # motion: 장애물 집고 오쪽으로 45도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass
                    elif self.first_milkbox_pos == 3:
                        # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass
                    elif self.first_milkbox_pos == 4:
                        # motion: 장애물 집고 왼쪽으로 45도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass
                    elif self.first_milkbox_pos == 5:
                        # motion: 장애물 집고 오른쪽으로 60도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass
                    elif self.first_milkbox_pos == 6:
                        # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 수행
                        pass
                    elif self.first_milkbox_pos == 7:
                        # motion: 장애물 집고 왼쪽으로 60도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass
                    elif self.first_milkbox_pos == 8:
                        # motion: 장애물 집고 오른쪽으로 60도 돌기 동작 수행

                        # motion: 장애물 집고 앞으로 두 발자국 걷기 동작 2번 수행
                        pass

            self.act = Act.EXIT


        else:  # EXIT
            return True

        return False
