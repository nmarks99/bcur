asyn = require("asyn")
RTDE_ASYN_PORT = "asyn2"
ADDR = 0

subtask = -1
function main()
    
    -- really this would be triggered automatically as the 
    -- result of another command but we it manually as an example
    asyn.writeParam(RTDE_ASYN_PORT, ADDR, "SET_STANDARD_DIGITAL_OUT0", 1)

    subtask = subtask + 1
    if (subtask == 0) then
        print("Running first task...")
    elseif (subtask == 1) then
        print("Running second task...")
    elseif (subtask == 2) then
        print("Running third task...")
    elseif (subtask == 3) then
        print("Running fourth task...")
    elseif (subtask == 4) then
        print("Running fifth task...")
    else
        print("Done!")
    end
end
