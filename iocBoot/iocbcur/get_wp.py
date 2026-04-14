from epics import caget
import sys

PREFIX = "bcur:"

assert(len(sys.argv) > 2)
wp_type = sys.argv[1]
wp_num = sys.argv[2]
pvs = []
if wp_type == "J":
    for x in range(1,7):
        wp = f"Waypoint{wp_type}:{wp_num}:J{x}"
        pvs.append(PREFIX+wp)
elif wp_type == "L":
    for x in ["X","Y","Z","Roll","Pitch","Yaw"]:
        wp = f"Waypoint{wp_type}:{wp_num}:{x}"
        pvs.append(PREFIX+wp)
else:
    print(f"Invalid input")

print(caget(f"{PREFIX}Waypoint{wp_type}:{wp_num}"))
for pv in pvs:
    print(round(caget(pv+".VAL"),4), end=",")
print("")
