#!/bin/bash
# Add this to your bashrc to always run the updated code
# start_cobot() {
#   curl -fsSL "https://raw.githubusercontent.com/HMI2-Research-Group/mycobot_hand_scripts/master/launch_real_cobot.sh" | bash
# }
echo "agx" | sudo -S killall screen
sleep 5
screen -S base_teleop -dm roslaunch limo_base limo_base.launch
sleep 5
screen -S camera -dm roslaunch astra_camera dabai_u3.launch
sleep 3
screen -S lidar -dm roslaunch limo_bringup limo_start.launch pub_odom_tf:=false 
sleep 3
screen -S cobot_arm_moveit -dm roslaunch limo_cobot_moveit_config demo.launch
sleep 5
screen -S cobot_arm_uart -dm rosrun mycobot_280_moveit sync_plan.py _port:=/dev/ttyACM0 _baud:=115200
echo "All processes started"