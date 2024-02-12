asyn = require("asyn")
epics = require("epics")
Status = {OKAY=0 , ERROR=1}

----------------------------------------------------------------
-- port names must match asyn port names created in urRobot.cmd
local DASHBOARD_PORT = "asyn_dash"
local RTDE_PORT = "asyn_rtde"
local ADDR = 0
----------------------------------------------------------------


SafetyStatus = {
    IS_NORMAL_MODE = 0,
    IS_REDUCED_MODE = 1,
    IS_PROTECTIVE_STOPPED = 2,
    IS_RECOVERY_MODE = 3,
    IS_SAFEGUARD_STOPPED = 4,
    IS_SYSTEM_EMERGENCY_STOPPED = 5,
    IS_ROBOT_EMERGENCY_STOPPED = 6,
    IS_EMERGENCY_STOPPED = 7,
    IS_VIOLATION = 8,
    IS_FAULT = 9,
    IS_STOPPED_DUE_TO_SAFETY = 10
}

RuntimeState = {
    STOPPING = 0,
    STOPPED = 1,
    PLAYING = 2,
    PAUSING = 3,
    PAUSED = 4,
    RESUMING = 5
}

RobotMode = {
    ROBOT_MODE_NO_CONTROLLER = -1,
    ROBOT_MODE_DISCONNECTED = 0,
    ROBOT_MODE_CONFIRM_SAFETY = 1,
    ROBOT_MODE_BOOTING = 2,
    ROBOT_MODE_POWER_OFF = 3,
    ROBOT_MODE_POWER_ON = 4,
    ROBOT_MODE_IDLE = 5,
    ROBOT_MODE_BACKDRIVE = 6,
    ROBOT_MODE_RUNNING = 7,
    ROBOT_MODE_UPDATING_FIRMWARE = 8
}


-- returns the i'th bit of the number n
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
        local val = asyn.readParam(asyn_port, ADDR, asyn_param)
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

-- returns true is robot stopped and in normal mode, otherwise false
local function ready()
    local safety_status_bits = asyn.readParam(RTDE_PORT, ADDR, "SAFETY_STATUS_BITS")
    local normal_bit = get_bit(safety_status_bits, SafetyStatus.IS_NORMAL_MODE)
    if (normal_bit ~= 1) then
        print("Not in normal mode, check safety status")
        return false
    end
    local runtime_state = asyn.readParam(RTDE_PORT, ADDR, "RUNTIME_STATE")
    if (runtime_state ~= RuntimeState.STOPPED) then
        print("Ensure robot is stopped before running another program")
        return false
    end
    return true
end


function load_sample(args)
    if args.program == nil then
        print("No URP program given")
        return Status.ERROR
    end
    if args.P == nil then
        print("No IOC prefix given")
        return Status.ERROR
    end

    args.R = args.R ~= nil and args.R or ""
    local busy_pv = string.format("%s%sBusy", args.P, args.R)
    local blockid_pv = string.format("%s%sBlockID",args.P, args.R)

    -- checks that robot is stopped and in normal mode before continuing
    if ready() == false then
        return Status.ERROR
    end

    -- set robot as busy for duration of task
    epics.put(busy_pv, 1)

    -- sets BlockID
    print(string.format("Starting program %s with BlockID %d", args.program, A))
    epics.put(blockid_pv, A)

    -- load URP program and wait for it to be loaded
    asyn.writeParam(DASHBOARD_PORT, ADDR, "LOAD_URP", args.program)
    wait_asyn_param(DASHBOARD_PORT, "LOADED_PROGRAM", args.program)
    print("Program loaded!")
    
    -- play program, wait for it to start playing
    asyn.writeParam(DASHBOARD_PORT, ADDR, "PLAY", 1)
    wait_asyn_param(RTDE_PORT, "RUNTIME_STATE", RuntimeState.PLAYING)
    print("Program started!")

    -- wait for the program to be finished
    wait_asyn_param(RTDE_PORT, "RUNTIME_STATE", RuntimeState.STOPPED)
    print("Program finished!")
    
    -- robot is no longer busy
    epics.put(busy_pv, 0)

    return Status.OKAY
end
