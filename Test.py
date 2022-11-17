# Misson Debuging Code
from Core.Misson import MissonEntrance, MissonDanger, MissonStair

def entrance():
    while not MissonEntrance.go_robo():
        print("<ENTRANCE>")
        continue

def danger():
    while not MissonDanger.go_robo():
        print("<DANGER>")
        continue

def stair():
    while not MissonStair.go_robo():
        continue


if __name__ == "__main__":
    # 디버깅시 원하는 미션 구역 주석 해제 후 실행
    # entrance()
    danger()
    # stair() 