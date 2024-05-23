import argparse
from epics import caget

parser = argparse.ArgumentParser()
parser.add_argument('filename', type=str, help='The name of the file to process')
parser.add_argument('-macro')
args = parser.parse_args()

# macros are given in the same form as caQtDM and MEDM
# -macro P=xxx:,R=a_macro:,M=another:
macros_dict = dict()
if args.macro is not None:
    for m in args.macro.split(","):
        kv = m.replace(" ", "").split("=")
        macros_dict.update({kv[0]:kv[1]})


# get the pv names on each line
pv_names_root = []
with open(args.filename, "r") as f:

    all = f.read()
    if "WaypointL" in all:
        assert("WaypointJ" not in all), "Conversion to CSV with mix of WaypointJ and WaypointL not supported"
    if "WaypointJ" in all:
        assert("WaypointL" not in all), "Conversion to CSV with mix of WaypointJ and WaypointL not supported"

    for line in f:
        pv_name = line
        for k,v in macros_dict.items():
            pv_name = pv_name.replace(f"$({k})",v)
        pv_name = pv_name.replace(":moveJ","")
        pv_name = pv_name.replace(":moveL","")
        pv_names_root.append(pv_name.rstrip())


# get the pv values with caget and format them properly:
# j1,j2,j3,j4,j5,j6,speed,accel,blend,gripper
# x,y,z,roll,pitch,yaw,speed,accel,blend,gripper
for p in pv_names_root:
    csv_line = ""
    if "WaypointJ" in p:
        for i in range(1,7):
            v = caget(f"{p}:J{i}")
            csv_line = "".join((csv_line, f"{round(v,4)},"))
    elif "WaypointL" in p:
        for i in ("X","Y","Z","Roll","Pitch","Yaw"):
            v = caget(f"{p}:{i}")
            csv_line = "".join((csv_line, f"{round(v,4)},"))
    speed = caget(f"{p}:Speed")
    accel = caget(f"{p}:Acceleration")
    blend = caget(f"{p}:Blend")
    gripper = int(caget(f"{p}:Gripper.RVAL"))
    csv_line = f"{csv_line}{speed},{accel},{blend},{gripper}"
    print(csv_line)

