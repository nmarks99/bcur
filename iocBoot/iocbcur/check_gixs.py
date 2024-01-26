#!/usr/bin/env python3
from epics import caput
import sys
import time

MAX_BLOCK = int(sys.argv[1])

pvs = [
    "bcur:Sample$(BlockID):InReservoir",
    "bcur:Sample$(BlockID):InGripper",
    "bcur:Sample$(BlockID):InSampleStage",
    "bcur:Sample$(BlockID):Measured",
]

for i in range(1, MAX_BLOCK+1):
    for pv in pvs:
        pv_sub = pv.replace("$(BlockID)", str(i))
        caput(pv_sub, 1)
        time.sleep(1)
        if "InSampleStage" not in pv_sub and "Measured" not in pv_sub:
            caput(pv_sub, 0)
