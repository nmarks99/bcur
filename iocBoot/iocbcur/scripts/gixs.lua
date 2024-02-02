asyn = require("asyn")

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

function load_sample()
    asyn.writeParam(DASHBOARD_PORT, ADDR, "LOAD_URP", "myprogram")
    -- TODO: wait for program to be loaded
    asyn.writeParam(DASHBOARD_PORT, ADDR, "PLAY", 1)
    asyn.writeParam(RTDE_PORT, ADDR, "SET_STANDARD_DIGITAL_OUT0", 1)

    -- wait for robot to start moving before checking that it has stopped
    while true do
        local dout = asyn.readParam(RTDE_PORT, ADDR, "DIGITAL_OUTPUT_BITS")
        local moving = get_bit(dout, MOVING_DOUT_BIT) -- 0'th bit is moving flag
        if (moving == 1) then
            break
        end
    end
    print("Move started!")

    -- wait until robot finishes moving
    print("Waiting for move to finish...")
    while true do
        local dout = asyn.readParam(RTDE_PORT, ADDR, "DIGITAL_OUTPUT_BITS")
        local moving = get_bit(dout, MOVING_DOUT_BIT) -- 0'th bit is moving flag
        if (moving == 0) then
            break
        end
    end

    print("Done!")
end
