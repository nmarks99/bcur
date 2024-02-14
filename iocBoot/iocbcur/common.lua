-- Setup search path for .req files. Include the db folders of every module specified in RELEASE
luaCmd("modules=require('modules'); for mod,path in pairs(modules) do set_requestfile_path(path .. '/db') end")

-- Debug-output level
save_restoreSet_Debug(0)

-- caputRecorder
iocshLoad("$(CAPUTRECORDER)/iocsh/caputRecorder.iocsh", "PREFIX=$(PREFIX)")

-- Load 20 userScripts
dbLoadRecords("$(LUA)/luaApp/Db/luascripts10.db", "P=$(PREFIX), R=set1:")
dbLoadRecords("$(LUA)/luaApp/Db/luascripts10.db", "P=$(PREFIX), R=set2:")

-- busy record
dbLoadRecords("$(BUSY)/busyApp/Db/busyRecord.db", "P=$(PREFIX),R=mybusy1")
dbLoadRecords("$(BUSY)/busyApp/Db/busyRecord.db", "P=$(PREFIX),R=mybusy2")

-- Load database record for alive heartbeating support.
-- IOCNM is name of IOC, RHOST specifies the remote server accepting hearbeats
dbLoadRecords("$(ALIVE)/aliveApp/Db/alive.db", "P=$(PREFIX),IOCNM=$(IOC),RHOST=164.54.100.11")
dbLoadRecords("$(ALIVE)/aliveApp/Db/aliveMSGCalc.db", "P=$(PREFIX)")
