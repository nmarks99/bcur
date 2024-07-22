import time
from robotiq_gripper_driver import RobotiqGripper
import urx

def blocking_process(func):
    def wrapper(*args, **kwargs):
        pydev.iointr("ACTION_DONE", 0)
        result = func(*args, **kwargs)
        pydev.iointr("ACTION_DONE", 1)
        return result
    return wrapper

ROBOT_IP = "164.54.104.148"
GRIPPER_PORT = 63352

class PyRobot:

    def __init__(self):
        self.robot = urx.Robot(ROBOT_IP)
        self.gripper = RobotiqGripper()
        self.gripper.connect(ROBOT_IP, GRIPPER_PORT)

    def disconnect(self):
        self.gripper.disconnect()
        self.robot.close()

    @blocking_process
    def auto_calibrate(self):
        self.gripper.auto_calibrate()

    @blocking_process
    def open_gripper(self):
        self.gripper.move_and_wait_for_pos(
            self.gripper.get_open_position(),
            self.gripper._get_var(self.gripper.SPE),
            self.gripper._get_var(self.gripper.FOR)
        )

    @blocking_process
    def close_gripper(self):
        self.gripper.move_and_wait_for_pos(
            self.gripper.get_closed_position(),
            self.gripper._get_var(self.gripper.SPE),
            self.gripper._get_var(self.gripper.FOR)
        )

    @blocking_process
    def example_process(self):
        t0 = time.monotonic()
        while True:
            elap = time.monotonic() - t0
            print(round(elap,3))
            if elap >= 5:
                break
            else:
                time.sleep(0.1)

#  if __name__ == "__main__":
    #  class pydev(object):
        #  @staticmethod
        #  def iointr(param, value=None):
            #  pass
#
    #  robot = PyRobot()
    #  robot.example_process()
