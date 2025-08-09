local mod = {}
local Initalized = false
mod.__index = mod
local Properties

function mod.Init()
    if Initalized then
        return
    end
    Initalized = true

    Properties = mod.Get("Properties")
end

function mod.SetState(plr, state)
    if not plr or state == nil then
        error("Invalid arguments")
    end

    local plrprops = Properties.new(plr)
    plrprops:Set("State", state)
end

function mod.GetState(plr)
    if not plr then
        error("Invalid arguments")
    end

    local plrprops = Properties.new(plr)
    return plrprops:Get("State")
end

return mod