# -*- coding: utf-8 -*-
# Main code
# import sys
from Core.Controller import Controller


def main():
    while not Controller.go_robo():
        continue


if __name__ == "__main__":
    # sys.stdout = open('~/minirobot/log.txt','w')
    # for i in range(10):
    #     print(i)
    main()
    # sys.stdout.close()