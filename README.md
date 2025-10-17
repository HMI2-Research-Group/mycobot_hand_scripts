Run the following commands:
```bash
sudo apt-get install -y ros-noetic-ros-control
sudo apt-get install -y ros-noetic-ros-controllers
sudo apt-get install -y ros-noetic-gazebo-ros
sudo apt-get install -y ros-noetic-gazebo-ros-control
sudo apt-get install -y ros-noetic-joint-state-publisher-gui 
sudo apt-get install -y ros-noetic-rqt-robot-steering 
sudo apt-get install -y ros-noetic-teleop-twist-keyboard 
```
```
cd ~
rm -rf -- catkin_ws_BAK
mkdir -p catkin_ws/src
cd catkin_ws/src
git clone https://github.com/agilexrobotics/ugv_gazebo_sim.git
git clone https://github.com/HMI2-Research-Group/mycobot_hand_scripts.git
cd ..
catkin build
source ~/.bashrc
roslaunch limo_gazebo_sim limo_ackerman.launch world_name:=willowgarage.world
rosrun teleop_twist_keyboard teleop_twist_keyboard.py 
```
rostopic echo /clicked_point
header: 
  seq: 2
  stamp: 
    secs: 950
    nsecs:  60000000
  frame_id: "base_footprint"
point: 
  x: 0.06984806060791016
  y: 0.011325716972351074
  z: 0.16922950744628906

```

Task Reach Target frame
 |py-3.8.10| poincarepoint-Precision-5530 in ~/.../src/mycobot_hand_scripts
± |master ?:1 ✗| → rosrun tf tf_echo odom base_footprint
At time 1238.670
- Translation: [-9.400, -7.610, -0.004]
- Rotation: in Quaternion [-0.001, 0.000, 1.000, 0.004]
            in RPY (radian) [0.001, 0.002, 3.133]
            in RPY (degree) [0.047, 0.139, 179.526]
of X= -9.4, -7.6