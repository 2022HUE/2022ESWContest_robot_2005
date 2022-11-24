# -*- coding: utf-8 -*-
# Misson Debuging Code
from Core.MissionStair import MissionStair
from Core.MissionEntrance import MissionEntrance
from Core.MissionDanger import MissionDanger


def entrance():
    while not MissionEntrance.go_robo():
        print("<ENTRANCE>")
        continue


def danger():
    while not MissionDanger.go_robo():
        print("<DANGER>")
        continue


def stair():
    # stair_ = MissionStair.go_robo()
    while not MissionStair.go_robo():
        print("<STAIR>")
        continue


if __name__ == "__main__":
    # 디버깅시 원하는 미션 구역 주석 해제 후 실행
    # stair()
    entrance()
    # danger()
