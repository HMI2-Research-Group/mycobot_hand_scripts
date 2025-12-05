#!/usr/bin/env python
import time
from math import pi

import numpy as np
from pymycobot.mycobot import MyCobot

PORT = "/dev/ttyACM0"
BAUD = 115200

if __name__ == "__main__":
    mc = MyCobot(PORT, BAUD)
    time.sleep(2.0)  # small delay to make sure serial is ready

    angles = np.array(mc.get_angles())   # returns list of 6 joint angles in degrees
    print("Current Joint Angles (degrees): \n", angles)
    angles_rad = angles * (pi / 180.0)  # convert to radians
    print("Current Joint Angles (radians): \n", angles_rad)
    mc.release_all_servos()  # release the servos after getting angles
    print("Use above Radians only for MoveIt! planning.")

