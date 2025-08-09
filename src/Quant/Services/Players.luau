local Players = game:GetService("Players")
local Initalized = false
local mod = {}

function mod.Init()
    if Initalized then
        return
    end
    Initalized = true
    local Properties = mod.Get("Properties")
    local Events = mod.Get("Events")

    Players.PlayerAdded:Connect(function(plr)
        local Event = Events.GetEvent("Player Joined") or Events.CreateEvent("Player Joined")
        local PlayerProps = Properties.new(plr)
        PlayerProps:Set("Join time", tick())
        PlayerProps:Set("State", "Idle")
        Event:Fire(plr)
    end)

    Players.PlayerRemoving:Connect(function(plr)
        local Event = Events.GetEvent("Player Left") or Events.CreateEvent("Player Left")
        Event:Fire(plr)
    end)
end

return mod