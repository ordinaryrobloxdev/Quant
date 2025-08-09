local RunService = game:GetService("RunService")
local Initalized = false
local mod = {}
local Events = {}
mod.__index = mod

function mod.Init()
    if Initalized then
        return
    end

    Initalized = true
end

function mod.CreateEvent(Name:string, Type:string)
    if typeof(Name) ~= "string" and typeof(Type) ~= "string" then
        error("Invalid arguments")
    end

    Events[Name] = setmetatable({Event = (Type == "Remote" and Instance.new("RemoteEvent") or Instance.new("BindableEvent")), Type = Type}, mod)
    return Events[Name]
end

function mod.GetEvent(Name:string)
    if typeof(Name) ~= "string" then
        error("Invalid arguments")
    end
    
    return Events[Name]
end

function mod:Connect(Callback)
    if RunService:IsClient() and self.Type == "Remote" then
        return self.Event.OnClientEvent:Connect(Callback)
    elseif RunService:IsServer() and self.Type == "Remote" then
        return self.Event.OnServerEvent:Connect(Callback)
    else
        return self.Event.Event:Connect(Callback)
    end
end

function mod:Fire(...)
    local Data = {...}

    if typeof(Data[1]) == "Instance" and RunService:IsServer() and Data[1]:IsA("Player") and self.Type == "Remote" then
        local plr = Data[1]
        table.remove(Data, 1)
        self.Event:FireClient(plr, unpack(Data))
    elseif RunService:IsServer() and self.Type == "Remote" then
        self.Event:FireAllClients(unpack(Data))
    elseif RunService:IsClient() and self.Type == "Remote" then
        self.Event:FireServer(unpack(Data))
    else
        self.Event:Fire(unpack(Data))
    end
end

return mod