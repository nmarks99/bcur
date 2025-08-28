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

-- Many waypoints fetching action descs causes ring buffer overflow warning...
-- Increasing setOnce queue fixes this.
scanOnceSetQueueSize(2000)

-- Load robot support with waypoint and path support
iocshLoad("urRobot.iocsh", "PREFIX=$(PREFIX), IP=164.54.104.148")
dbLoadTemplate("substitutions/waypoints.substitutions", "P=$(PREFIX)")
dbLoadTemplate("substitutions/paths.substitutions", "P=$(PREFIX)")

-- Load softMotors for controlling the robot
dbLoadTemplate("$(URROBOT)/db/ur_soft_motors.substitutions", "P=$(PREFIX)")

-- General purpose python scripts through PyDevice
dbLoadRecords("user_python_scripts10.db", "P=$(PREFIX)")
doAfterIocInit('dbpf("$(PREFIX)PythonScript1.PROC", 1)')
doAfterIocInit('dbpf("$(PREFIX)PythonScript2.PROC", 1)')
doAfterIocInit('dbpf("$(PREFIX)PythonScript3.PROC", 1)')
doAfterIocInit('dbpf("$(PREFIX)PythonScript4.PROC", 1)')
doAfterIocInit('dbpf("$(PREFIX)PythonScript5.PROC", 1)')

-- devIocStats
dbLoadRecords("$(DEVIOCSTATS)/db/iocAdminSoft.db","IOC=$(PREFIX)")
-- PV aliases change :: into :
dbLoadRecords("$(TOP)/bcurApp/Db/iocAdminSoft_aliases.db","P=$(PREFIX)")

-------------------------------------------------------------------------------
iocInit()
-------------------------------------------------------------------------------

iocshCmd("dbl > dbl-all.txt")

-- Diagnostic: CA links in all records
dbcar(0,1)

-- print the time our boot was finished
date()
