from epics import caget, caput, PV
import time

PREFIX = "bcur:"


done_pv = f"{PREFIX}Control:AsyncMoveDone"
waypointN = f"{PREFIX}WaypointL:$(N)"

# Lookup waypoint based on description
waypoints_dict = {}
for n in range(1,26):
    pv_name = waypointN.replace("$(N)", str(n))
    pv_val = caget(pv_name)
    if len(pv_val) > 0:
        if pv_val in waypoints_dict.keys():
            raise RuntimeError("Duplicate waypoint names found!")
        else:
            waypoints_dict[pv_val] = pv_name


def wait_process():

    # wait to start
    while True:
        started = 1 if caget(done_pv) == 0 else 0
        if started:
            break
        else:
            time.sleep(0.01)

    # wait to finish
    while True:
        done = caget(done_pv)
        if done:
            break
        else:
            time.sleep(0.01)


OPEN = 1
CLOSE = 2

path = [
    ("HomeL", OPEN),
    ("A standoff", OPEN),
    ("A", CLOSE),
    ("A standoff", CLOSE),
    ("HomeL", CLOSE),
    ("B standoff", CLOSE),
    ("B", OPEN),
    ("B standoff", OPEN),
    ("HomeL", OPEN),
]

for p in path:
    pv = waypoints_dict[p[0]]
    grip = p[1]

    move_pv = f"{pv}:moveL.PROC"
    action_pv = f"{pv}:ActionOpt"

    caput(action_pv, grip)
    caput(move_pv, 1)
    wait_process()
