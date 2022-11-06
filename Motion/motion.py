# -*- coding: utf-8 -*-
import platform
import argparse
import cv2
import serial
import time
import sys
from threading import Thread, Lock
#from Constant import const 


# -----------------------------------------------
class Motion:
    head_angle1 = 'UPDOWN_CENTER'
    head_angle2 = 'LEFTRIGHT_CENTER'

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
            # 수신받은 데이터의 수가 0보다 크면 데이터를 읽고 출력
            while ser.inWaiting() > 0:
                # Rx, 수신
                result = ser.read(1)
                RX = ord(result)
                # print ("RX=" + str(RX))
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

    def test(self):
        print('test_motion')
        self.TX_data_py2(32)
        time.sleep(1)
    
    def test_arrow(self, arrow):
        print('test_arrow', arrow)
        if arrow == 'LEFT':
            self.TX_data_py2(15)
            time.sleep(0.3)
        else: 
            self.TX_data_py2(20)
            time.sleep(0.3)
    
    def test_text(self, text):
        print('test_arrow', text)
        if text == 'E':
            self.TX_data_py2(32) # 양팔 벌리기
        elif text == 'W':
            self.TX_data_py2(32) # 양팔 벌리기
        elif text == 'S':
            self.TX_data_py2(32) # 양팔 벌리기
        elif text == 'N':
            self.TX_data_py2(32) # 양팔 벌리기
        time.sleep(0.3)
        
#######################################################
if __name__ == '__main__':
    motion = Motion()
    count = 0
    #motion.TX_data_py2(9)
    #motion.open_door_turn(dir='LEFT', loop=6)
    #motion.walk(dir='FORWARD')
    #motion.open_door(dir='LEFT', loop=15)
    #motion.notice_direction('S')
    
    # start code
    # motion.test()
    
    # for i in range(3):
    #    count += 1
    #    motion.walk("LEFT")
    #    time.sleep(1)
    #    motion.walk("RIGHT")
    #    time.sleep(1)
    #    time.sleep(1)ddd
