-- specify directories in which to search for included request files
-- Note that the vxWorks variables (e.g., 'startup') are from cdCommands
set_requestfile_path("$(ADCORE)/db")
set_requestfile_path("$(AUTOSAVE)/db")
set_requestfile_path("$(BUSY)/db")
set_requestfile_path("$(CALC)/db")
set_requestfile_path("$(CAMAC)/db")
set_requestfile_path("$(CAPUTRECORDER)/db")
set_requestfile_path("$(DAC128V)/db")
set_requestfile_path("$(DELAYGEN)/db")
set_requestfile_path("$(DXP)/db")
set_requestfile_path("$(DXPSITORO)/db")
set_requestfile_path("$(IP)/db")
set_requestfile_path("$(IP330)/db")
set_requestfile_path("$(IPUNIDIG)/db")
set_requestfile_path("$(LABJACK)/db")
set_requestfile_path("$(LOVE)/db")
set_requestfile_path("$(LUA)/db")
set_requestfile_path("$(MCA)/db")
set_requestfile_path("$(MEASCOMP)/db")
set_requestfile_path("$(MODBUS)/db")
set_requestfile_path("$(MOTOR)/db")
set_requestfile_path("$(OPTICS)/db")
set_requestfile_path("$(QUADEM)/db")
set_requestfile_path("$(SCALER)/db")
set_requestfile_path("$(SSCAN)/db")
set_requestfile_path("$(SOFTGLUE)/db")
set_requestfile_path("$(SOFTGLUEZYNQ)/db")
set_requestfile_path("$(STD)/db")
set_requestfile_path("$(VAC)/db")
set_requestfile_path("$(VME)/db")
set_requestfile_path("$(YOKOGAWA_DAS)/db")
set_requestfile_path("$(TOP)/db")

-- debug output level
save_restoreSet_Debug(0)

-- busy record
dbLoadRecords("$(BUSY)/busyApp/Db/busyRecord.db", "P=$(PREFIX),R=mybusy1")
dbLoadRecords("$(BUSY)/busyApp/Db/busyRecord.db", "P=$(PREFIX),R=mybusy2")

-- Load database record for alive heartbeating support.
-- IOCNM is name of IOC, RHOST specifies the remote server accepting hearbeats
dbLoadRecords("$(ALIVE)/aliveApp/Db/alive.db", "P=$(PREFIX),IOCNM=$(IOC),RHOST=164.54.100.11")
dbLoadRecords("$(ALIVE)/aliveApp/Db/aliveMSGCalc.db", "P=$(PREFIX)")
