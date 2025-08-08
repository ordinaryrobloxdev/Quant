local Players = game:GetService("Players")
local Initalized = false
local mod = {}
mod.PlayerJoin = Players.PlayerAdded
mod.PlayerLeave = Players.PlayerRemoving
local Properties

function mod.Init()
    if Initalized then
        return
    end
    Initalized = true
    Properties = mod.Get("Properties")

    mod.PlayerJoin:Connect(function(player)
        local PlayerProps = Properties.new(player)
        PlayerProps:Set("Join time", tick())
    end)
end

return mod