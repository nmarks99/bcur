import time
from robotiq_gripper_driver import RobotiqGripper

ROBOT_IP = "164.54.104.148"
GRIPPER_PORT = 63352

def main():
    pydev.iointr("RUNNING2", 1)

    gripper = RobotiqGripper()
    gripper.connect(ROBOT_IP, GRIPPER_PORT)

    gripper.move_and_wait_for_pos(
        gripper.get_closed_position(),
        gripper._get_var(gripper.SPE),
        gripper._get_var(gripper.FOR)
    )

    gripper.disconnect()

    pydev.iointr("RUNNING2", 0)


if __name__ == "__main__":
    main()
