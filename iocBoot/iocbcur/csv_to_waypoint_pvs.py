import argparse
from epics import caget

parser = argparse.ArgumentParser()
parser.add_argument('filename', type=str, help='The name of the file to process')
parser.add_argument('-type', required=True, type=str)
parser.add_argument('-macro')
args = parser.parse_args()

def remove_many(string, old_list):
    for s in old_list:
        string = string.replace(s, "")
    return string

# macros are given in the same form as caQtDM and MEDM
# -macro P=xxx:,R=a_macro:,M=another:
macros_dict = dict()
if args.macro is not None:
    for m in args.macro.split(","):
        kv = m.replace(" ", "").split("=")
        macros_dict.update({kv[0]:kv[1]})

with open(args.filename, "r") as f:
    if args.type.lower() == "joint":
        print("Joint space waypoints")
    elif args.type.lower() == "cartesian":
        print("Cartesian space waypoints")
    for line in f:
        print(line,end="")
