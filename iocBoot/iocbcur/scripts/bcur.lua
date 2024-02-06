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


-- waits for the 'asyn_param' on 'asyn_port' to
-- equal the value of 'match'
function await_asyn_param(asyn_port, asyn_param, match)
    -- TODO: add timeout
    if type(match) == "string" then
        while true do
            local val = asyn.readParam(asyn_port, 0, asyn_param) 
            if val:find(match, 1, true) then
                break
            end
        end
    else
        while true do
            local val = asyn.readParam(asyn_port, 0, asyn_param)
            if (val == match) then
                break
            end
        end
    end
end

local DASHBOARD_PORT = "asyn1"
local RTDE_PORT = "asyn2"
local ADDR = 0
local MOVING_DOUT_BIT = 0 -- digital output bit robot moving flag

local urp_program = "blink.urp"
function basic_task()
    -- set robot as busy for duration of function
    epics.put("bcur:Busy", 1)

    -- load URP program and wait for it to be loaded
    asyn.writeParam(DASHBOARD_PORT, ADDR, "LOAD_URP", urp_program)
    await_asyn_param(DASHBOARD_PORT, "LOADED_PROGRAM", urp_program)
    print("program loaded!")
    
    -- play program, wait for it to start playing
    asyn.writeParam(DASHBOARD_PORT, ADDR, "PLAY", 1)
    await_asyn_param(RTDE_PORT, "RUNTIME_STATE", 2)
    print("program started!")

    -- wait for the program to be finished
    await_asyn_param(RTDE_PORT, "RUNTIME_STATE", 1)
    print("Program finished!")
    
    -- robot is no longer busy
    epics.put("bcur:Busy", 0)
end
