from epics import caget, caput
import numpy as np
import time

'''
This script demonstrates the basics for interacting with the UR robot
through the provided EPICS PVs using PyEPICS
'''

PREFIX = "bcur:"

## Get some information about the robot:

# Get the current joint positions:
q = caget(f"{PREFIX}Receive:ActualJointPositions")
q = [round(i,2) for i in q]
print(f"Joints = {q} (degrees)")

# Get the current TCP pose:
pose = caget(f"{PREFIX}Receive:ActualTCPPose")
pose = [round(i,2) for i in pose]
print(f"TCP Pose = {pose[0]} mm, {pose[1]} mm, {pose[2]} mm, {pose[3]} deg, {pose[4]} deg, {pose[5]} deg")

# Get the Robotiq gripper state
if caget(f"{PREFIX}RobotiqGripper:IsOpen"):
    print("Gripper: Open")
else:
    print("Gripper: Closed")


###########################


## Move the robot and gripper:

# Move joint 1 by 5 degrees
q = caget(f"{PREFIX}Receive:ActualJointPositions")
caput(f"{PREFIX}Control:J1Cmd", q[0] - 5.0)
caput(f"{PREFIX}Control:moveJ", 1)

# Motion is non-blocking by default
# Wait for motion to start and complete
while True:
    if not caget(f"{PREFIX}Control:Steady"):
        break
while True:
    if caget(f"{PREFIX}Control:Steady"):
        break

# Close the gripper, then open it again
caput(f"{PREFIX}RobotiqGripper:Close", 1)
while True: # wait for gripper to close
    if caget(f"{PREFIX}RobotiqGripper:IsClosed"):
        print("Gripper closed!")
        break
caput(f"{PREFIX}RobotiqGripper:Open", 1)
while True: # wait for gripper to open
    if caget(f"{PREFIX}RobotiqGripper:IsOpen"):
        print("Gripper opened!")
        break

