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
dbLoadTemplate("waypoints.substitutions", "P=$(PREFIX)")
dbLoadTemplate("paths.substitutions", "P=$(PREFIX)")

-- doAfterIocInit('dbpf("$(PREFIX)Control:TCPOffset_X.VAL", 2.56)')
-- doAfterIocInit('dbpf("$(PREFIX)Control:TCPOffset_Y.VAL", -1.15)')
-- doAfterIocInit('dbpf("$(PREFIX)Control:TCPOffset_Z.VAL", 150.6)')
-- doAfterIocInit('dbpf("$(PREFIX)Control:TCPOffset_Roll.VAL", -0.0203)')
-- doAfterIocInit('dbpf("$(PREFIX)Control:TCPOffset_Pitch.VAL", -3.0925)')
-- doAfterIocInit('dbpf("$(PREFIX)Control:TCPOffset_Yaw.VAL", 0.0024)')

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
