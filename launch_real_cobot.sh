#!/bin/bash
# Add this to your bashrc to always run the updated code
# echo 'start_cobot() {
#   curl -fsSL "https://raw.githubusercontent.com/HMI2-Research-Group/mycobot_hand_scripts/master/launch_real_cobot.sh" | bash
# }' >> ~/.bashrc

# Manage temporary directory for multiple executions
TMP_DIR="/tmp/mycobot_scripts"
if [ -d "$TMP_DIR" ]; then
    echo "Removing existing temporary directory..."
    rm -rf "$TMP_DIR"
fi
mkdir -p "$TMP_DIR"
cd "$TMP_DIR"

echo "agx" | sudo -S killall screen
sleep 5
cat << 'EOF'
 ___| |_ __ _ _ __  __      ____ _ _ __ ___ 
 / __| __/ _` | '__| \ \ /\ / / _` | '__/ __|
 \__ \ || (_| | |     \ V  V / (_| | |  \__ \
 |___/\__\__,_|_|      \_/\_/ \__,_|_|  |___/
George Lucas - Jedi - Death Star - R2-D2 - C-3PO - Yoda - Darth Vader

                 _.' :  `._
             .-.'`.  ;   .'`.-.
    __      / : ___\ ;  /___ ; \      __
  ,'_ ""--.:__;".-.";: :".-.":__;.--"" _`,
  :' `.t""--.. '<@.`;_  ',@>` ..--""j.' `;
       `:-.._J '-.-'L__ `-- ' L_..-;'
         "-.__ ;  .-"  "-.  : __.-"
             L ' /.------.\ ' J
              "-.   "--"   .-"
             __.l"-:_JL_;-";.__
          .-j/'.;  ;""""  / .'\"-.
        .' /:`. "-.:     .-" .';  `.
     .-"  / ;  "-. "-..-" .-"  :    "-.
  .+"-.  : :      "-.__.-"      ;-._   \
  ; \  `.; ;                    : : "+. ;
  :  ;   ; ;                    : ;  : \:
 : `."-; ;  ;                  :  ;   ,/;
  ;    -: ;  :                ;  : .-"'  :
  :\     \  : ;             : \.-"      :
   ;`.    \  ; :            ;.'_..--  / ;
   :  "-.  "-:  ;          :/."      .'  :
     \       .-`.\        /t-""  ":-+.   :
      `.  .-"    `l    __/ /`. :  ; ; \  ;
        \   .-" .-"-.-"  .' .'j \  /   ;/
         \ / .-"   /.     .'.' ;_:'    ;
          :-""-.`./-.'     /    `.___.'
                \ `t  ._  /  bug :F_P:
                 "-.t-._:'
  
  I hope all your scripts work fine...
  Remember, the Force will be with you, always.

  .   *   ..  . *  *
*  * @()Ooc()*   o  .
    (Q@*0CG*O()  ___
   |\_________/|/ _ \
   |  |  |  |  | / | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | | | |
   |  |  |  |  | \_| |
   |  |  |  |  |\___/
   |\_|__|__|_/|
    \_________/

So you want to run run the bot?? Darth Vader is asking why? Is it to overthrow the empire? Is it to join the dark side? Answer wisely...
EOF
screen -S base_teleop -dm roslaunch limo_base limo_base.launch
sleep 10
echo "Launched Base Teleop Controller"
sleep 5
screen -S camera -dm roslaunch astra_camera dabai_u3.launch
echo "Launched Dabai Camera"
sleep 3
screen -S lidar -dm roslaunch limo_bringup limo_start.launch pub_odom_tf:=false 
echo "Launched Lidar"
sleep 10
cat << 'EOF'
                                 (*)
  |       |       |       |      |/|      |       |       |       |
 (*)     (*)     (*)     (*)     |/|     (*)     (*)     (*)     (*)
 |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|
 |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|
 |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|
 |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|     |/|
 |/|     |/|     |/|     |/|    (( ))    |/|     |/|     |/|     |/|
 |/|     |/|     |/|     |/|     ( )     |/|     |/|     |/|     |/|
(( ))   (( ))   (( ))   (( ))    ( )    (( ))   (( ))   (( ))   (( ))
 ( )     ( )     ( )     ( )     o.o     ( )     ( )     ( )     ( )
 ( )     ( )     ( )     ( )   __/_\__   ( )     ( )     ( )     ( )
 ( )     ( )     ( )     ( )   \/   \/   ( )     ( )     ( )     ( )
 ( )     ( )     ( )     ( )   /_____\   ( )     ( )     ( )     ( )
  ( )     ( )     ( )    ( )     \./     ( )    ( )     ( )     ( )
    ( )     ( )    ( )    ( )    o o    ( )    ( )    ( )     ( )
      ( )     ( )    ( )    ( ) ((|)) ( )    ( )    ( )     ( )
        ( )     ( )    ( )    ( )(|)( )    ( )    ( )     ( )
           ( )     ( )    ( )   ((|))   ( )    ( )     ( )
               ( )     ( )    ( )(|)( )    ( )     ( )
                    ( )    ( )  ((|))  ( )    ( )
                          ( )   ((|))   ( )
                                ((|))
                                ((|))
                                ((|))
                               ooooooo
                            ooooooooooooo
               Happy      ooooooooooooooooo    Hanukkah!
                         ooooooooooooooooooo

Isn't it Thankgiving Holiday yet? Your robot needs rest!!
EOF
screen -S cobot_arm_moveit -dm roslaunch limo_cobot_moveit_config demo.launch
echo "Launched Cobot Arm MoveIt"
sleep 5
screen -S cobot_arm_uart -dm rosrun mycobot_280_moveit sync_plan.py _port:=/dev/ttyACM0 _baud:=115200
echo "Launched Cobot Arm UART plan Syncer"
sleep 10
echo "All processes started"
cat << 'EOF'
                            __.......___
                    __..od8888888888888888bo.
                _.d888888888888888888888888888b.        _.._
             .d8888888888888888888888888888888888b.  .d888888b.
           .d88888888888888888888888888888888888888bd88888888888b.
         .d888888888888888888888888888888888P'"'  `"48888888888888b.
         888888888888888888888888888888888+'         `48888888888888.
        j888888888888P"'  '   `'  `"'+++"'              `488888888888.
        88888888888P'                                     `48888888888.
        888888888P'                                         `8888888888.
       j8888888P'                                            `8888888888.
      .8888888P                                               l8888888888.
      8888888'                                                 88888888888
     j888888'                                          ____    `8888888888l
     888888f                                  _.ood8888++488b.  `8888888888
    j888888                                 +P'"          `488b._`888888888l
    8888888           ___,,.ooo._         .dP'              `88888b888888888
    8888888      _.d8++"""""'''"4b.      .8'                 `88888888888888
    8888888    .dP"'             `8b.__..88       _.._        88888888888888
    8888888  .d8f                 `88888888.     " 48P`.      88P`  88888888
    l888888 j888'           _...   88f   `88.                 8P    88P'  `4
     888888.d888        _.-'488P   88     `88.              ,jP     8f  db |
     `4888888888.      '           8P      `48._      __..gP'       8   4P |
      ."`488+`48L                .jP         `+888888++""'          '  . ' '
      | _ `"   `48.            _dP'          b.                        :  .
      `'8b       `4b.__   __.odP'            `4.                      .d  |
       \`8         `""+++++""'   ,             `b                     8P  |
        \`                     .d'  ,.    _,o. ,P                     P   |
         \  d.                .P'  .P"Y8""  `'"'                          |
            88               j'        8.                                 |
          ` `4              '          "'                                 '
           .  `                            __                           ,'
                                  _.g8bogo+"""+++,._                   .
            '                  _.o"'              `"'                  |
            .                 j"                                       |
             \                                                         |
              `-.                                                    .d|
                 .                                                 .d8'|
                  .                                             .d888' jb.
            __..od8b.                                      _.od88888' .8888b.
    __..od88888888888b.                            __..oo888888888P' .88888888b
oo888888888888888888888b._            ______...ooo88888888888888P'  .8888888888
88888888888888888888888888b. .ooo8b++++++"""888888888888888888+'  .d88888888888
8888888888888888888888888888              .d888888888888888+'   .d8888888888888
8888888888888888888888888888l            .888888888888888+'   .d888888888888888



Fine 007, here is your robot the MI6 promised you. Take good care of it, it might save your life one day...

     0000             0000        7777777777777777/========___________
   00000000         00000000      7777^^^^^^^7777/ || ||   ___________
  000    000       000    000     777       7777/=========//
 000      000     000      000             7777// ((     //
0000      0000   0000      0000           7777//   \\   //
0000      0000   0000      0000          7777//========//
0000      0000   0000      0000         7777
0000      0000   0000      0000        7777
 000      000     000      000        7777
  000    000       000    000       77777
   00000000         00000000       7777777
     0000             0000        777777777


Please get to working
                              \\\\\\\
                            \\\\\\\\\\\\
                          \\\\\\\\\\\\\\\
  -----------,-|           |C>   // )\\\\|
           ,','|          /    || ,'/////|
---------,','  |         (,    ||   /////
         ||    |          \\  ||||//''''|
         ||    |           |||||||     _|
         ||    |______      `````\____/ \
         ||    |     ,|         _/_____/ \
         ||  ,'    ,' |        /          |
         ||,'    ,'   |       |         \  |
_________|/    ,'     |      /           | |
_____________,'      ,',_____|      |    | |
             |     ,','      |      |    | |
             |   ,','    ____|_____/    /  |
             | ,','  __/ |             /   |
_____________|','   ///_/-------------/   |
              |===========,'
EOF