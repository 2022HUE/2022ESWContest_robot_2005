# -*- coding: utf-8 -*-
# Misson Debuging Code

from Core.Misson import  MissonStair

def stair():
    while not MissonStair.go_robo():
        continue

if __name__ == "__main__":
    # 디버깅시 원하는 미션 구역 주석 해제 후 실행
    stair()