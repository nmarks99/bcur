-- asyn = require("asyn")

-- gets the i'th bit of the number n
function get_bit(n, i)
    if (n & (1 << i)) ~= 0 then
        return 1;
    else
        return 0;
    end
end

-- local DASHBOARD_PORT = "asyn1"
-- local RTDE_PORT = "asyn2"
-- local ADDR = 0
local MOVING_DOUT_BIT = 0 -- digital output bit robot moving flag

function robot_moving()
    local moving_bit = get_bit(A, MOVING_DOUT_BIT)
    print(string.format("bit = %d", moving_bit))
    return moving_bit
end
