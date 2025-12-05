from math import pi
from time import sleep

import rospy
import moveit_msgs.msg
import moveit_commander
import geometry_msgs.msg
from pymycobot.mycobot import MyCobot


class MyCobot280Operator:
    def __init__(self) -> None:
        """
        This class is used to control the Franka Emika Panda robot.
        Be sure to activate ROS node and initialize moveit_commander before using this class.
        """
        self.robot = moveit_commander.RobotCommander()
        group_name = "arm_group"
        self.move_group = moveit_commander.MoveGroupCommander(group_name)
        self.move_group.set_planning_time(15.0)

        # Create a publisher for trajectory visualization
        self.display_trajectory_publisher = rospy.Publisher(
            "/move_group/display_planned_path", moveit_msgs.msg.DisplayTrajectory, queue_size=20
        )

        # Gripper Control
        port = "/dev/ttyACM0"  
        baudrate = 115200
        self.mycobot = MyCobot(port, baudrate)
    
    def open_gripper(self):
        # Check initial gripper state
        initial_state = self.mycobot.get_gripper_value(1)
        print(f"Initial gripper state: {initial_state}")
        # Open the gripper
        print("Opening gripper...")
        self.mycobot.set_gripper_state(0, 70)  
        sleep(3)  
    
    def close_gripper(self):
        # Check initial gripper state
        initial_state = self.mycobot.get_gripper_value(1)
        print(f"Initial gripper state: {initial_state}")
        # Close the gripper
        print("Closing gripper...")
        self.mycobot.set_gripper_state(1, 70)  
        sleep(3)

    def display_trajectory(self, plan):
        """
        Display a trajectory in RViz
        :param plan: The trajectory to display
        """
        display_trajectory = moveit_msgs.msg.DisplayTrajectory()
        display_trajectory.trajectory_start = self.robot.get_current_state()
        display_trajectory.trajectory.append(plan)
        self.display_trajectory_publisher.publish(display_trajectory)
        rospy.loginfo("Visualizing the trajectory in RViz")

    def go_to_joint_state(self, target_pose):
        """
        This function is used to move the robot to a specific joint state.
        :param target_pose: A list of joint values (6 for a 6-DOF robot, 12 for a 12-DOF robot).
        :return: True if the execution was successful, False otherwise.
        """
        try:
            # Get current joint values for fallback and debugging
            current_joints = self.move_group.get_current_joint_values()
            # Round the current joints for better logging
            current_joints = [round(j, 3) for j in current_joints]
            rospy.loginfo(f"Current joints: {current_joints}")
            rospy.loginfo(f"Target joints: {target_pose}")

            # Increase planning time for complex movements
            self.move_group.set_planning_time(15.0)

            # Set the joint target
            self.move_group.set_joint_value_target(target_pose)

            # Plan the trajectory - check the return value format
            plan_result = self.move_group.plan()

            # Different MoveIt versions return different formats
            if isinstance(plan_result, tuple):
                # Newer MoveIt versions return (success, trajectory)
                success = plan_result[0]
                trajectory = plan_result[1]
            else:
                # Older versions just return the trajectory
                success = plan_result is not None and len(plan_result.joint_trajectory.points) > 0
                trajectory = plan_result

            if not success or trajectory is None:
                rospy.logwarn("Planning failed! No valid trajectory found.")
                return False

            # Display the planned trajectory in RViz
            display_trajectory = moveit_msgs.msg.DisplayTrajectory()
            display_trajectory.trajectory_start = self.robot.get_current_state()
            display_trajectory.trajectory.append(trajectory)
            self.display_trajectory_publisher.publish(display_trajectory)
            rospy.loginfo("Visualizing planned trajectory in RViz")

            # Execute the planned trajectory
            rospy.loginfo("Executing trajectory...")
            execution_status = self.move_group.execute(trajectory, wait=True)

            if execution_status:
                rospy.loginfo("Execution completed successfully")
            else:
                rospy.logwarn("Execution failed!")

            return execution_status

        except Exception as e:
            rospy.logerr(f"Error in go_to_joint_state: {str(e)}")
            return False

def pick_sock_qr(BOX_PICKUP_POSITION=None, BOX_DROP_POSITION=None):
    """
    Pick up a sock using predefined joint positions.
    Make sure to adjust the BOX_PICKUP_POSITION and BOX_DROP_POSITION for each QR code 
    based on how you will arrive at the sock location.
    """
    operator = MyCobot280Operator()
    # Safe joint positions - adjusted to be within typical myCobot 280 joint limits
    DEFAULT_POSITION = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0] # In radians
    if BOX_PICKUP_POSITION is None and BOX_DROP_POSITION is None:
        raise ValueError("Please provide both BOX_PICKUP_POSITION and BOX_DROP_POSITION or neither.")
        # Example joint positions for references
        # BOX_PICKUP_POSITION = [-2.844, 0.077, 0.833, 2.218, 0.268, 3.073] # In radians
        # BOX_DROP_POSITION = [1.33, -1.99, 1.55, 0.31, 0.26, -0.01] # In radians
    
        
    # Move to initial pose
    operator.open_gripper()
    print("Going to default position")
    if operator.go_to_joint_state(DEFAULT_POSITION):
        print("Successfully moved to initial pose")
    else:
        print("Failed to move to initial pose")
    sleep(2)
    # Move to pick box 1
    print("Moving to pick Jenga")
    if operator.go_to_joint_state(BOX_PICKUP_POSITION):
        print("Successfully moved to box pickup position")
    else:
        print("Failed to move to box pickup position")
    sleep(2)
    operator.close_gripper()
    sleep(2)
    # Move to drop box 1
    print("Moving to drop Jenga")
    if operator.go_to_joint_state(DEFAULT_POSITION):
        print("Successfully moved to initial pose")
    else:
        print("Failed to move to initial pose")
    if operator.go_to_joint_state(BOX_DROP_POSITION):
        print("Successfully moved to box drop position")
    else:
        print("Failed to move to box drop position")
    sleep(2)
    del operator
    

if __name__ == "__main__":
    rospy.init_node("mycobot280_operator", anonymous=True)
    moveit_commander.roscpp_initialize([])
    pick_sock_qr()
    
   
