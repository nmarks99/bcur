asyn = require("asyn")
epics = require("epics")

-- gets the i'th bit of the number n
function get_bit(n, i)
    if (n & (1 << i)) ~= 0 then
        return 1;
    else
        return 0;
    end
end


local DASHBOARD_PORT = "asyn1"
local RTDE_PORT = "asyn2"
local ADDR = 0
local MOVING_DOUT_BIT = 0 -- digital output bit robot moving flag

local URP_PROGRAM_NAME = "blink.urp"

function basic_task()
    -- TODO: timeouts

    -- load program, wait for it to be loaded
    asyn.writeParam(DASHBOARD_PORT, ADDR, "LOAD_URP", URP_PROGRAM_NAME)
    while true do
        local val = asyn.readParam(DASHBOARD_PORT, ADDR, "LOADED_PROGRAM")
        if val:find(URP_PROGRAM_NAME,1, true) then
            print(string.format("%s", val))
            break
        end
    end
    print("program loaded!")
    
    -- play program, wait for it to start playing
    asyn.writeParam(DASHBOARD_PORT, ADDR, "PLAY", 1)
    while true do
        local val = asyn.readParam(RTDE_PORT, ADDR, "RUNTIME_STATE")
        print(string.format("runtime state = %d", val))
        if (val == 2) then
            break
        end
    end
    epics.put("bcur:Busy", 1)
    print("program started!")

    -- wait for program to be finished
    while true do
        local val = asyn.readParam(RTDE_PORT, ADDR, "RUNTIME_STATE")
        if (val == 1) then
            break
        end
    end
    epics.put("bcur:Busy", 0)
    print("Program finished!")
end
