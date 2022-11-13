# -*- coding: utf-8 -*-
# Motion code
import platform
import argparse
import cv2 as cv
import serial
import time
import sys
from threading import Thread, Lock
from Setting import setting


# -----------------------------------------------
class Motion:
    def __init__(self, sleep_time=0):
        self.serial_use = 1
        self.serial_port = None
        self.Read_RX = 0
        self.receiving_exit = 1
        self.threading_Time = 0.01
        self.sleep_time = sleep_time
        self.lock = Lock()
        self.distance = 0
        BPS = 4800  # 4800,9600,14400, 19200,28800, 57600, 115200
        # ---------local Serial Port : ttyS0 --------
        # ---------USB Serial Port : ttyAMA0 --------
        self.serial_port = serial.Serial('/dev/ttyS0', BPS, timeout=0.01)
        self.serial_port.flush()  # serial cls
        self.serial_t = Thread(target=self.Receiving, args=(self.serial_port,))
        self.serial_t.daemon = True
        self.serial_t.start()
        time.sleep(0.1)

    # DELAY DECORATOR
    def sleep(self, func):
        def decorated():
            func()
            time.sleep(self.sleep_time)

        return decorated

    def TX_data_py2(self, one_byte):  # one_byte= 0~255
        self.lock.acquire()
        self.serial_port.write(serial.to_bytes([one_byte]))  # python3
        time.sleep(0.02)

    def RX_data(self):
        if self.serial_port.inWaiting() > 0:
            result = self.serial_port.read(1)
            RX = ord(result)
            return RX
        else:
            return 0

    def Receiving(self, ser):
        self.receiving_exit = 1
        while True:
            if self.receiving_exit == 0:
                break
            time.sleep(self.threading_Time)
            while ser.inWaiting() > 0:
                result = ser.read(1)
                RX = ord(result)
                # -----  remocon 16 Code  Exit ------
                if RX == 16:
                    self.receiving_exit = 0
                    break
                elif RX == 200:
                    try:
                        self.lock.release()
                    except:
                        continue
                elif RX != 200:
                    self.distance = RX


    ############################################################
    # 기본자세 (100)
    def basic(self):
        self.TX_data_py2(100)
    
    # 걷기 (101~120)
    def walk(self):
        pass
    
    # 머리 각도 (121~140)
    def set_head(self, dir, angle = 0):
        """ parameter :
        dir: {DOWN, LEFT, RIGHT, UPDOWN_CENTER, LEFTRIGHT_CENTER}
        angle: {DOWN:{20,30,40,50,60,70,80,90,100,110},
        LEFT:{30,45,60,90},
        RIGHT:{30,45,60,90}
        }
        """
        if dir == 'DOWN':
            self.head_angle1 = angle
        elif dir == 'LEFT' or dir == 'RIGHT':
            self.head_angle2 = angle
        elif dir == 'UPDOWN_CENTER':
            self.head_angle1 = dir
        elif dir == 'LEFTRIGHT_CENTER':
            self.head_angle2 = dir
        center_list = {'UPDOWN_CENTER': 140, 'LEFTRIGHT_CENTER': 135}
        dir_list = {
            'DOWN': {
                20 : 121, 30 : 122, 40 : 123, 50: 124, 60 : 125, 70 : 126, 80 : 127, 90 : 128, 100 : 129, 110 : 130
            },
            'LEFT': {
                30: 134, 45: 133, 60: 132, 90: 131
            },
            'RIGHT': {
                30: 136, 45: 137, 60: 138, 90: 139
            }
        }
        if dir in center_list:
            self.TX_data_py2(center_list[dir])
        else:
            self.TX_data_py2(dir_list[dir][angle])
        time.sleep(0.3)

    
    # 돌기 (141~160)
    def turn(self):
        pass
    
    # 옆으로 이동 (161~170)
    def walk_side(self):
        pass
    
    # 계단 오르내리기 (171~174) [Stair]
    def stair(self):
        pass

    # 장애물 치우기 (175~176) [Line/Stair/Danger]
    def kick(self):
        pass
    
    # 집기 (181~186) [Danger]
    def grab(self):
        pass
    
    # 횟수_집고 전진 (187~188) [Danger]
    def grab_walk(self):
        pass
    
    # 집고 옆으로 (189~192) [Danger]
    def grab_sideway(self):
        pass
    
    # 집고 턴 (193~) [Danger]
    def grab_turn(self):
        pass

    #

    #

    #

if __name__ == '__main__':
    motion = Motion()
    motion.basic()