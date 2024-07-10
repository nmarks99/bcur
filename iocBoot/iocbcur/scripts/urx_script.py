import urx
import time

ROBOT_IP = "164.54.104.148"

def main():
    robot = urx.Robot(ROBOT_IP)

    i = 0
    while i < 5:
        print(robot.getj())
        time.sleep(1.0)
        i += 1

    robot.close()

if __name__ == "__main__":
    main()
