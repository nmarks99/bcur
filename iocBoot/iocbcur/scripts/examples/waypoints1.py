from epics import caget, caput

'''
Example 1:
This script demonstrates how to move the robot through
a series of cartesian waypoints by interacting with PVs made
available by the urRobot EPICS support. 

This assumes $(P)WaypointL:1 through $(P)WaypointL:5 are defined.
'''
# -----------------------------------

# the IOC prefix (with trailing ':')
PREFIX = "bcur:"

# To move through a series of cartesian waypoints, we need to do the following,
# For each waypoint...
# 1. caput("WaypointL:N:moveL", 1) # where N is the waypoint number
# 2. Wait for motion to begin
# 3. Wait for motion and waypoint action to complete
# Note: the $(P)Control:AsyncMoveDone PV will be 1 if the motion and waypoint action
# are complete, otherwise it will be zero.

# For convenience, we define a function to accomplish steps 2 and 3
def wait_motion():
    done_pv = f"{PREFIX}Control:AsyncMoveDone"
    # wait until AsyncMoveDone == 0
    while True:
        #  started = 1 if caget(done_pv) == 0 else 0
        started = not caget(done_pv)
        if started:
            break

    # wait until AsyncMoveDone == 1
    while True:
        done = caget(done_pv)
        if done:
            break


# Each waypoint has an associated waypoint action.
# Waypoint actions are automatically executed after the robot reaches a waypoint
# Supported actions (WaypointL:N:ActionOpt)
# Custom = 0
# Open gripper = 1
# Close gripper = 1
# For this demo, we'll set the waypoint action to 1 (open gripper) for all waypoints
for i in range(1,6):
    caput(f"{PREFIX}WaypointL:{i}:ActionOpt", 1)

# Lets create a list of the waypoint PVs we'd like to move through in order
path = [
    f"{PREFIX}WaypointL:1",
    f"{PREFIX}WaypointL:4",
    f"{PREFIX}WaypointL:1",
    f"{PREFIX}WaypointL:2",
    f"{PREFIX}WaypointL:1"
]

# Now we'll move through the waypoints
for wp in path:
    caput(f"{wp}:moveL", 1)
    wait_motion()
