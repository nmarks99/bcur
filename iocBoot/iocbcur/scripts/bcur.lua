asyn = require("asyn")
epics = require("epics")

-- must match asyn port names created in urRobot.cmd
local DASHBOARD_PORT = "asyn_dash"
local RTDE_PORT = "asyn_rtde"
local ADDR = 0

-- gets the i'th bit of the number n
local function get_bit(n, i)
    if (n & (1 << i)) ~= 0 then
        return 1;
    else
        return 0;
    end
end


-- waits for the 'asyn_param' on 'asyn_port' to equal the value of 'match'
-- if timeout is not specified, will not check for timeout
local function wait_asyn_param(asyn_port, asyn_param, match, timeout)
    local function string_match(val, match)
        return val:find(match, 1, true)
    end
    local function num_match(val, match)
        return val == match
    end
    local match_func = type(match) == "string" and string_match or num_match
    
    local t0 = os.time()
    while true do
        local val = asyn.readParam(asyn_port, 0, asyn_param)
        if match_func(val, match) then
            break
        end
        if timeout ~= nil then
            local elap = (os.time() - t0)
            if (elap >= timeout) then
                print("timeout reached")
                break
            end
        end
    end
end


local urp_program = "blink.urp"
function blink_task()
    -- set robot as busy for duration of function
    epics.put("bcur:Busy", 1)

    -- load URP program and wait for it to be loaded
    asyn.writeParam(DASHBOARD_PORT, ADDR, "LOAD_URP", urp_program)
    wait_asyn_param(DASHBOARD_PORT, "LOADED_PROGRAM", urp_program)
    print("program loaded!")
    
    -- play program, wait for it to start playing
    asyn.writeParam(DASHBOARD_PORT, ADDR, "PLAY", 1)
    wait_asyn_param(RTDE_PORT, "RUNTIME_STATE", 2)
    print("program started!")

    -- wait for the program to be finished
    wait_asyn_param(RTDE_PORT, "RUNTIME_STATE", 1)
    print("Program finished!")
    
    -- robot is no longer busy
    epics.put("bcur:Busy", 0)
end
