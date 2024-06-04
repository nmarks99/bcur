-- autosave
iocshLoad("$(AUTOSAVE)/iocsh/autosave_settings.iocsh", "PREFIX=$(PREFIX), SAVE_PATH=$(TOP)/iocBoot/$(IOC)")
iocshLoad("$(AUTOSAVE)/iocsh/save_restore.iocsh",      "PREFIX=$(PREFIX), POSITIONS_FILE=auto_positions, SETTINGS_FILE=auto_settings")
iocshLoad("$(AUTOSAVE)/iocsh/autosaveBuild.iocsh",     "PREFIX=$(PREFIX), BUILD_PATH=autosave")
-- -- Note that you can restore a .sav file without also autosaving to it.
-- set_pass0_restoreFile("./autosave_bak/built_settings.sav_240523-110323")
-- set_pass1_restoreFile("./autosave_bak/built_settings.sav_240523-110323")


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
