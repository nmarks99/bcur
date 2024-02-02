epicsEnvSet("ROBOT_NAME", "")

-- Set up UR dashboard server
epicsEnvSet("UR_DASH_PORT", "asyn1")
dbLoadRecords("$(URROBOT)/db/dashboard.db", "P=$(PREFIX), R=$(ROBOT_NAME), PORT=$(UR_DASH_PORT), ADDR=0")
URRobotDashboardConfig("$(UR_DASH_PORT)", "164.54.104.148")

-- Set up UR RTDE interface
epicsEnvSet("UR_RTDE_PORT", "asyn2")
dbLoadRecords("$(URROBOT)/db/rtde_receive.db", "P=$(PREFIX), R=$(ROBOT_NAME), PORT=$(UR_RTDE_PORT), ADDR=0")
dbLoadRecords("$(URROBOT)/db/rtde_io.db", "P=$(PREFIX), R=$(ROBOT_NAME), PORT=$(UR_RTDE_PORT), ADDR=0")
URRobotRTDEConfig("$(UR_RTDE_PORT)", "164.54.104.148")
