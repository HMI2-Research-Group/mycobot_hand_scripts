#!/bin/bash
# Add this to your bashrc to always run the updated code
# echo 'start_cobot() {
#   curl -fsSL "https://raw.githubusercontent.com/HMI2-Research-Group/mycobot_hand_scripts/master/launch_real_cobot.sh" | bash
# }' >> ~/.bashrc

echo "agx" | sudo -S killall screen
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
cat << 'EOF'
Dear User, your robot is ready to fly (No it's not). 
      .---.        .-----------
     /     \  __  /    ------
    / /     \(  )/    -----
   //////   ' \/ `   ---
  //// / // :    : ---
 // /   /  /`    '--
//          //..\\
       ====UU====UU====
           '//||\\`
             ''``
EOF
echo "If something malfunctions try debugging yourself 😝👊"