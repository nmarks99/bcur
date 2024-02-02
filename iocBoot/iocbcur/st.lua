#ENABLE_HASH_COMMENTS

< envPaths

errlogInit(20000)

-- Tell EPICS all about the record types, device-support modules, drivers,
-- etc. in the software we just loaded (bcur.munch)
dbLoadDatabase("../../dbd/iocbcurLinux.dbd")
iocbcurLinux_registerRecordDeviceDriver(pdbbase)

< settings.lua
< common.lua

< urRobot.lua

-- load the sample database and other records needed
dbLoadTemplate("gixs/gixs_sample.substitutions", "P=$(PREFIX), R=")
-- dbLoadRecords("gixs/gixs.db","P=$(PREFIX),R=")
dbLoadRecords("example_task.db","P=$(PREFIX),R=,PORT=$(UR_RTDE_PORT)")

-------------------------------------------------------------------------------
iocInit()
-------------------------------------------------------------------------------

-- write all the PV names to a local file
-- dbl > dbl-all.txt

-- Diagnostic: CA links in all records
dbcar(0,1)

-- print the time our boot was finished
date()
