#ENABLE_HASH_COMMENTS

< envPaths

-- Search path for PyDevice python scripts
epicsEnvSet("PYTHONPATH","$(TOP)/iocBoot/iocbcur/scripts/")

errlogInit(20000)

-- Tell EPICS all about the record types, device-support modules, drivers,
-- etc. in the software we just loaded (bcur.munch)
dbLoadDatabase("../../dbd/iocbcurLinux.dbd")
iocbcurLinux_registerRecordDeviceDriver(pdbbase)

< settings.lua
< common.lua

iocshLoad("urRobot.iocsh", "PREFIX=$(PREFIX), IP=164.54.104.148")
dbLoadTemplate("waypoints.substitutions", "P=$(PREFIX)")

-- PyDevice PVs for interating with the robot via python
-- dbLoadRecords("py_robot.db", "P=$(PREFIX), IP=164.54.104.148, SCRIPT=urx_robot, CLASS=PyRobot, INSTANCE=robot")

-------------------------------------------------------------------------------
iocInit()
-------------------------------------------------------------------------------

iocshCmd("dbl > dbl_all.txt")

-- Diagnostic: CA links in all records
dbcar(0,1)

-- print the time our boot was finished
date()
