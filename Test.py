# -*- coding: utf-8 -*-
# Misson Debuging Code
# from Core.Mission import MissionEntrance
from Core.Mission import Mission
# from Core.Mission import MissionStair
# from Core.Mission import MissionDanger

# def entrance():
#     while not MissionEntrance.go_robo():
#         print("<ENTRANCE>")
#         continue

# def danger():
#     while not MissionDanger.go_robo():
#         print("<DANGER>")
#         continue

def stair():
    Mission("stair")
    # stair_ = MissionStair.go_robo()
    # print('STAIR', stair_)
    # while not stair_:
    #     continue


if __name__ == "__main__":
    # 디버깅시 원하는 미션 구역 주석 해제 후 실행
    # entrance()
    # danger()
    stair() 
