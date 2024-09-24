from epics import caget, caput
import time

q = caget("bcur:Receive:ActualJointPositions")
print(q)
caput("bcur:Control:J1Cmd", q[0] + 5.0)
input("Press enter to move...")
caput("bcur:Control:moveJ.PROC", 1)
print("Done")
