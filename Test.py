# Misson Debuging Code
from Core.Misson import MissonEntrance, MissonDanger, MissonStair

def entrance():
    tmp = MissonEntrance()
    while not MissonEntrance.go_robo(tmp):
        print("<ENTRANCE>")
        continue

def danger():
    tmp = MissonDanger()
    while not MissonDanger.go_robo(tmp):
        continue

def stair():
    tmp = MissonStair()
    while not MissonStair.go_robo(tmp):
        continue


if __name__ == "__main__":
    # 디버깅시 원하는 미션 구역 주석 해제 후 실행
    entrance() 
    # danger() 
    # stair() 