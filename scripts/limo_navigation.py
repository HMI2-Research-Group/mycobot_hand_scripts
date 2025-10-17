#!/usr/bin/env python3
from time import sleep

import rospy
import numpy as np
from cv_bridge import CvBridge
from sensor_msgs.msg import Image
from geometry_msgs.msg import Twist
from sensor_msgs.msg import LaserScan

bridge = CvBridge()


class LimoNav:
    def __init__(self):
        # Image subscribers
        self.color_sub = rospy.Subscriber("/limo/color/image_raw", Image, self.color_cb, queue_size=1)
        self.depth_sub = rospy.Subscriber("/limo/depth/image_raw", Image, self.depth_cb, queue_size=1)

        # LaserScan subscriber
        self.laser_sub = rospy.Subscriber("/limo/scan", LaserScan, self.laser_cb, queue_size=1)
        self.vel_pub = rospy.Publisher("/cmd_vel", Twist, queue_size=1)

        self.color_img = None
        self.depth_img = None

        # Laser scan storage
        self.laser_ranges = None  # np.ndarray [N] float32
        self.laser_angles = None  # np.ndarray [N] float32 (radians)
        self.laser_xy = None  # np.ndarray [N,2] float32 (x,y in meters)
        self.laser_stamp = None
        self.robot_loop()

    def depth_cb(self, msg: Image):
        # preserves 32FC1 as float32
        self.depth_img = bridge.imgmsg_to_cv2(msg, "passthrough")
        rospy.loginfo_throttle(2.0, f"Depth dtype: {self.depth_img.dtype}")  # expect float32

    def color_cb(self, msg: Image):
        # converts to uint8 BGR format
        self.color_img = bridge.imgmsg_to_cv2(msg, "bgr8")
        rospy.loginfo_throttle(2.0, f"Color dtype: {self.color_img.dtype}")  # expect uint8

    def laser_cb(self, msg: LaserScan):
        # Convert to numpy for fast processing
        ranges = np.asarray(msg.ranges, dtype=np.float32)
        n = ranges.size
        angles = msg.angle_min + np.arange(n, dtype=np.float32) * msg.angle_increment

        # Validity mask: finite and within sensor bounds
        valid = np.isfinite(ranges) & (ranges >= msg.range_min) & (ranges <= msg.range_max)
        r = ranges[valid]
        a = angles[valid]

        # Cartesian projection (laser frame): x forward, y left (ROS standard)
        if r.size:
            xy = np.stack((r * np.cos(a), r * np.sin(a)), axis=1).astype(np.float32)
            imin = int(np.argmin(r))
            nearest_r = float(r[imin])
            nearest_a_deg = float(np.degrees(a[imin]))
            rospy.loginfo_throttle(
                1.0, f"LaserScan: {r.size}/{n} valid beams | Nearest: {nearest_r:.2f} m @ {nearest_a_deg:.1f}°"
            )
        else:
            xy = np.empty((0, 2), dtype=np.float32)
            rospy.loginfo_throttle(1.0, "LaserScan: no valid returns")

        # Save to object
        self.laser_ranges = ranges
        self.laser_angles = angles
        self.laser_xy = xy
        self.laser_stamp = msg.header.stamp.to_sec()

    def move_robot(self, linear_x, linear_y, angular_z):
        # Placeholder for robot movement logic
        cmd = Twist()
        cmd.linear.x = linear_x
        cmd.linear.y = linear_y
        cmd.angular.z = angular_z
        # Here you would publish cmd to a cmd_vel topic
        self.vel_pub.publish(cmd)
        sleep(0.05)

    def robot_loop(self):
        pass  # Placeholder for main robot loop logic


if __name__ == "__main__":
    rospy.init_node("depth_probe")
    my_limo_nav = LimoNav()
    rospy.spin()
