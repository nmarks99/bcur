asyn = require('asyn')

function testing()
    local port_name = "ur_asyn2"
    local addr = 0
    local CLOSE_POPUP_STRING = "CLOSE_POPUP"
    print("\n")
    print("writing param...")
    asyn.writeParam(port_name, addr, CLOSE_POPUP_STRING, 1)
    print("done")
end
