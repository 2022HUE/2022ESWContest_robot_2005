from Core.Misson import MissonEntrance

def main():
    tmp = MissonEntrance()
    while not MissonEntrance.go_robo(tmp):
        continue


if __name__ == "__main__":
    main()