#!/bin/bash
# Add this to your bashrc to always run the updated code
# echo 'start_cobot() {
#   curl -fsSL "https://raw.githubusercontent.com/HMI2-Research-Group/mycobot_hand_scripts/master/launch_real_cobot.sh" | bash
# }' >> ~/.bashrc

echo "agx" | sudo -S killall screen
sleep 5
cat << 'EOF'
Let's get it guys!! Final showdown. You are a force to be reckonned with. You are unstoppable. Yoiu are the best and most hard working students of Santa Clara. Muchas Gracias Senor/Seniora! Por Favor! This is your time to shine!!
          |
 \     _____     /
     /       \
    (         )
-   ( ))))))) )   -
     \ \   / /
      \|___|/
  /    |___|    \
       |___| prs
       |___|
EOF
sleep 5
screen -S camera -dm roslaunch astra_camera dabai_u3.launch
echo "Launched Dabai Camera"
sleep 5
screen -S lidar -dm roslaunch limo_bringup limo_start.launch pub_odom_tf:=false 
echo "Launched LIDAR"
sleep 5
screen -S cobot_arm_moveit -dm roslaunch limo_cobot_moveit_config demo.launch
echo "Launched Cobot Arm MoveIt"
sleep 5
screen -S cobot_arm_uart -dm rosrun mycobot_280_moveit sync_plan.py _port:=/dev/ttyACM0 _baud:=115200
echo "Launched Cobot Arm UART plan Syncer"
sleep 2
echo "All processes started"