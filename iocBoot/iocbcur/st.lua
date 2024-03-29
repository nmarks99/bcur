#ENABLE_HASH_COMMENTS

< envPaths

errlogInit(20000)

-- Tell EPICS all about the record types, device-support modules, drivers,
-- etc. in the software we just loaded (bcur.munch)
dbLoadDatabase("../../dbd/iocbcurLinux.dbd")
iocbcurLinux_registerRecordDeviceDriver(pdbbase)

< settings.lua
< common.lua

-- Setup urRobot using urRobot.iocsh example
iocshLoad("$(URROBOT)/iocsh/urRobot.iocsh", "PREFIX=$(PREFIX), IP=164.54.104.148")
-- iocshLoad("./urRobot.iocsh", "PREFIX=$(PREFIX), IP=164.54.104.148")

-------------------------------------------------------------------------------
iocInit()
-------------------------------------------------------------------------------

-- write all the PV names to a local file
-- dbl > dbl-all.txt

-- Diagnostic: CA links in all records
dbcar(0,1)

-- print the time our boot was finished
date()
