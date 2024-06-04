#!/usr/bin/env python3
'''
Generates a CSV file of waypoints from Waypoint PVs given in a text file.
'''
import argparse
from epics import caget

parser = argparse.ArgumentParser()
parser.add_argument("filename", type=str, help="The name of the file to process")
parser.add_argument("-macro")
parser.add_argument("-out")
args = parser.parse_args()

# macros are given in the same form as caQtDM and MEDM
# -macro P=xxx:,R=a_macro:,M=another:
macros_dict = dict()
if args.macro is not None:
    for m in args.macro.split(","):
        kv = m.replace(" ", "").split("=")
        macros_dict.update({kv[0]:kv[1]})

def macro_sub(macros: dict, pv: str) -> str:
    for k,v in macros_dict.items():
        pv = pv.replace(f"$({k})",v)
    return pv

def remove_many(string, old_list: list) -> str:
    for s in old_list:
        string = string.replace(s, "")
    return string

def string_contains(string, values: list) -> bool:
    for v in values:
        if v in string:
            return True
    return False

# get the pv names on each line
pv_names_root = []
gripper_overrides = []
with open(args.filename, "r") as f:
    all = f.read()
    if "WaypointL" in all:
        assert("WaypointJ" not in all), "Conversion to CSV with mix of WaypointJ and WaypointL not supported"
        waypoint_type = "cartesian"
    if "WaypointJ" in all:
        assert("WaypointL" not in all), "Conversion to CSV with mix of WaypointJ and WaypointL not supported"
        waypoint_type = "joint"
    f.seek(0)
    
    for line in f:
        if string_contains(line, ["OPEN", "OPENED"]):
            gripper_overrides.append(0)
        elif string_contains(line, ["CLOSE", "CLOSED"]):
            gripper_overrides.append(1)
        else:
            gripper_overrides.append(None)
        pv_name = remove_many(line, [":moveJ", ":moveL", "OPEN", "CLOSE", "OPENED", "CLOSED"])
        pv_name = macro_sub(macros_dict, pv_name)
        pv_names_root.append(pv_name.rstrip())

# get the pv values with caget and format them properly:
# j1,j2,j3,j4,j5,j6,speed,accel,blend,gripper
# x,y,z,roll,pitch,yaw,speed,accel,blend,gripper
out_lines = []
grip_iter = iter(gripper_overrides)
for p in pv_names_root:
    csv_line = ""
    if "WaypointJ" in p:
        for i in range(1,7):
            v = caget(f"{p}:J{i}")
            csv_line = "".join((csv_line, f"{round(v,4)},"))
    elif "WaypointL" in p:
        for i in ("X","Y","Z","Roll","Pitch","Yaw"):
            v = caget(f"{p}:{i}")
            if v is not None:
                csv_line = "".join((csv_line, f"{round(v,4)},"))
            else:
                raise RuntimeError("caget failed")
    speed = caget(f"{p}:Speed")
    accel = caget(f"{p}:Acceleration")
    blend = caget(f"{p}:Blend")
    gripper = next(grip_iter, None)
    if gripper is None:
        print("Gripper override none, using current PV value")
        gripper = int(caget(f"{p}:Gripper.RVAL"))
    csv_line = f"{csv_line}{speed},{accel},{blend},{gripper}"
    out_lines.append(csv_line)


if args.out:
    with open(args.out, "w") as f:
        for line in out_lines:
            f.write(line+"\n")

    if waypoint_type == "cartesian":
        print(f"Cartesian waypoints saved to {args.out}")
    elif waypoint_type == "joint":
        print(f"Joint waypoints saved to {args.out}")

else:
    if waypoint_type == "cartesian":
        print("Cartesian Waypoints:")
        print("X,Y,Z,Roll,Pitch,Yaw,Speed,Acceleration,Blend,Gripper\n")
    elif waypoint_type == "joint":
        print("Joint Waypoints:")
        print("J1,J2,J3,J4,J5,J6,Speed,Acceleration,Blend,Gripper\n")
    for line in out_lines:
        print(line)

