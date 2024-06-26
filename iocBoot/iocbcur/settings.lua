-- Shell prompt
epicsEnvSet("IOCSH_PS1", "$(IOC)> ")

-- prefix used for all PVs in this IOC
epicsEnvSet("PREFIX", "bcur:")

-- For devIocStats
epicsEnvSet("ENGINEER", "Nick")
epicsEnvSet("LOCATION", "location")
epicsEnvSet("GROUP", "BCDA")

-- search path for database files
-- epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DEVIOCSTATS)/db")

-- search path for streamDevice protocol files
epicsEnvSet("STREAM_PROTOCOL_PATH", ".")

-- search path for lua scripts
epicsEnvSet("LUA_SCRIPT_PATH", "lua_scripts")

-- Specify largest array CA will transport
-- Note for N doubles, need N*8 bytes+some overhead
epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES", 64010)
