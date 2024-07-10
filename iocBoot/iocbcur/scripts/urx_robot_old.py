import urx
import time

ROBOT_IP = "164.54.104.148"

def blocking_process(func):
    def wrapper(*args, **kwargs):
        pydev.iointr("ACTION_DONE", 0)
        result = func(*args, **kwargs)
        pydev.iointr("ACTION_DONE", 1)
        return result
    return wrapper

class URXRobot:
    def __init__(self, host):
        self.host = host
        self.robot = None

    def __del__(self):
        self.disconnect()

    def _connection_okay(self):
        if self.robot is not None:
            return True
        return False

    def wait(self):
        t0 = time.monotonic()
        while True:
            elap = time.monotonic() - t0
            if elap >= 5:
                break
            else:
                print(elap)
                time.sleep(0.05)

    def connect(self):
        try:
            print("Connecting...")
            self.robot = urx.Robot(self.host)
        except Exception as e:
            print(f"Failed to connected to robot due to {e}")

    def getj(self):
        return self.robot.getj()

    def disconnect(self):
        if self._connection_okay():
            print("Disconnecting...")
            self.robot.close()

if __name__ == "__main__":
    robot = URXRobot(ROBOT_IP)
    robot.wait()
    #  robot.connect()
    #  print(robot.getj())
    #  robot.disconnect()
