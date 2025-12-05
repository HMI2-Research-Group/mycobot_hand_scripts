#!/usr/bin/env python
import time

from pymycobot.mycobot import MyCobot

PORT = "/dev/ttyACM0"
BAUD = 115200

if __name__ == "__main__":
    mc = MyCobot(PORT, BAUD)
    time.sleep(2.0)  # small delay to make sure serial is ready

    angles = mc.get_angles()   # returns list of 6 joint angles in degrees
    print("Current joint angles (radians): \n", angles)
