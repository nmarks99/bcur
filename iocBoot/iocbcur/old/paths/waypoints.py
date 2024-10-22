#!/usr/bin/env python3
from epics import caget, caput
import argparse
import time

override_opts = {
    "OPEN" : 1,
    "CLOSE" : 2,
    "OPENED" : 1,
    "CLOSED" : 2,
}

class Waypoint:
    def __init__(self, pv_name, done_pv, override=None):
        self.pv_name = pv_name
        self.done_pv = done_pv
        self.override = override
        if "WaypointJ" in pv_name:
            self.move_pv = f"{pv_name}:moveJ.PROC"
        elif "WaypointL" in pv_name:
            self.move_pv = f"{pv_name}:moveL.PROC"

    def _wait(self):
        # wait to start
        while True:
            started = 1 if caget(self.done_pv) == 0 else 0
            if started:
                break
            else:
                time.sleep(0.001)
        # wait to finish
        while True:
            done = caget(self.done_pv)
            if done:
                break
            else:
                time.sleep(0.001)

    def go(self):
        action0 = caget(f"{self.pv_name}:ActionOpt")
        if self.override is not None:
            print(f"caput {self.pv_name}:ActionOpt {self.override}", end="\t")
            caput(f"{self.pv_name}:ActionOpt", self.override)

        # do the move and action and wait for it to complete
        print(f"caput {self.move_pv} 1")
        caput(self.move_pv, 1)
        self._wait()

        # set action back to what it was before
        print(f"caput {self.pv_name}:ActionOpt {action0}")
        caput(f"{self.pv_name}:ActionOpt\n", action0)


def read_path_file(filename, prefix, max_waypoints):
    target_descs = []
    overrides = []
    done_pv = f"{prefix}Control:AsyncMoveDone.RVAL"
    with open(filename,"r") as f:
        for line in f:
            line_split = line.split('"')
            line_split = [i.strip() for i in line_split if len(i)>0]
            assert(len(line_split) > 0 and len(line_split) <= 2), f"Invalid path file, {len(line_split)}"
            target_descs.append(line_split[0])
            if len(line_split) == 2:
                overrides.append(override_opts[line_split[1]])
            else:
                overrides.append(0)

    actual_desc_dict = {}
    pv_base = f"{prefix}WaypointL:$(N)"
    for n in range(1, max_waypoints+1):
        pv = pv_base.replace("$(N)", str(n))
        desc = caget(pv)
        actual_desc_dict[desc] = pv
   
    path = []
    for i in range(len(target_descs)):
        pv_name = actual_desc_dict[target_descs[i]] 
        path.append(Waypoint(pv_name, done_pv, overrides[i]))
        
    return path


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('filename', help='Filepath to waypoints path file')
    args = parser.parse_args()
    
    done = caget("bcur:Control:AsyncMoveDone")
    if not done: 
        print(f"Done = {done}")
        print("Motion in progress...please wait")
        exit()
    
    if caget("bcur:SampleLocation") == "A":
        if "BtoA.path" in args.filename:
            print("Sample already at A")
            exit()

    if caget("bcur:SampleLocation") == "B":
        if "AtoB.path" in args.filename:
            print("Sample already at B")
            exit()

    path = read_path_file(args.filename, "bcur:", max_waypoints=25)

    for waypoint in path:
        waypoint.go() # blocking

    if "AtoB.path" in args.filename:
        caput("bcur:SampleLocation", "B")
    elif "BtoA.path" in args.filename:
        caput("bcur:SampleLocation", "A")


if __name__ == "__main__":
    main()
