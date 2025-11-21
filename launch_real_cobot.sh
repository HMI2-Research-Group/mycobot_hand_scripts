#!/bin/bash
# Add this to your bashrc to always run the updated code
# echo 'start_cobot() {
#   curl -fsSL "https://raw.githubusercontent.com/HMI2-Research-Group/mycobot_hand_scripts/master/launch_real_cobot.sh" | bash
# }' >> ~/.bashrc

echo "agx" | sudo -S killall screen
sleep 5
cat << 'EOF'
 _______________
|,----------.  |\
||           |=| |
||          || | |
||       . _o| | | __
|`-----------' |/ /~/
 ~~~~~~~~~~~~~~~ / /
                 ~~

You want to start robot? Drama incoming...
EOF
# screen -S base_teleop -dm roslaunch limo_base limo_base.launch
# sleep 10
# echo "Launched Base Teleop Controller"
sleep 5
screen -S camera -dm roslaunch astra_camera dabai_u3.launch
echo "Launched Dabai Camera"
sleep 3
screen -S lidar -dm roslaunch limo_bringup limo_start.launch pub_odom_tf:=false 
echo "Launched Lidar"
sleep 10
cat << 'EOF'
| ________ |
||12345678||
|""""""""""|
|[M|#|C][-]|
|[7|8|9][+]|
|[4|5|6][x]|
|[1|2|3][%]|
|[.|O|:][=]|
"----------"  hjw

Here is the calculator!! To calculate your robot's next move!
EOF
screen -S cobot_arm_moveit -dm roslaunch limo_cobot_moveit_config demo.launch
echo "Launched Cobot Arm MoveIt"
sleep 5
screen -S cobot_arm_uart -dm rosrun mycobot_280_moveit sync_plan.py _port:=/dev/ttyACM0 _baud:=115200
echo "Launched Cobot Arm UART plan Syncer"
sleep 10
echo "All processes started"
cat << 'EOF'
            .==============.
   __________||_/########\_||__________
  |(O)____ : [FM 103.7] ooooo : ____(O)|      Deep down in L'usiana
  |  /::::\:  _________  +|+  :/::::\  | -=<  close to New Orleans
  |  \;;;;/: |    |    | |+|  :\;;;;/  |      Way Back up in the woods
  |________:_ooooo+==ooo______:________|nad   Among the evergreens...

  Uhh ohh you just hit the wall. -5 points!
EOF