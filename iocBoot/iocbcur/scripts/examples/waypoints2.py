from epics import caget, caput

'''
If you haven't looked at waypoints1.py yet, look there for a more in-depth
explanation of the below.

Example 1: Move through a path of waypoints with waypoint actions
'''

PREFIX = "bcur:"

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


# Lets create a list of the waypoint PVs we'd like to move through in order
path = [
    f"{PREFIX}WaypointL:1",
    f"{PREFIX}WaypointL:4",
    f"{PREFIX}WaypointL:1",
    f"{PREFIX}WaypointL:2",
    f"{PREFIX}WaypointL:1"
]

# Define the waypoint actions for each waypoint
# Here we will set the action at waypoint 1 to "open gripper(1)"
# and the action and waypoints 2 and 4 to "close gripper(2)"
caput(f"{PREFIX}WaypointL:1:ActionOpt", 1)
caput(f"{PREFIX}WaypointL:2:ActionOpt", 2)
caput(f"{PREFIX}WaypointL:4:ActionOpt", 2)

# move through the waypoints
for wp in path:
    caput(f"{wp}:moveL", 1)
    wait_motion()
