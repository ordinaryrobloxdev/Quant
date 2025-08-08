local Modules = {}

function Get(Name)
    if Name and script:FindFirstChild(Name) then
        local Rmodule = require(script[Name])
        if typeof(Rmodule) == "table" then
            Rmodule.Get = Get
        end
        return Rmodule
    end

    for idx, Module:ModuleScript in script:GetChildren() do
        if Module:IsA("ModuleScript") and Module ~= getfenv(2).script then
            local Rmodule = require(Module)
            if typeof(Rmodule) == "table" then
                Rmodule.Get = Get
            end
            Modules[Module.Name:lower()] = Rmodule
        end
    end

    for name, Module in Modules do
        if typeof(Module) == "table" and typeof(Module.Init) == "function" then
            Module.Init()
        end
    end

    Modules.___ran = true

    return Modules
end

return function(Name)
    if (Name and typeof(Name) ~= "string") then
        error("Invalid arguments")
    end

    if Modules.___ran then
        if Name and Modules[Name:lower()] then
            return Modules[Name:lower()]
        else
            return Modules
        end
    end

    return Get(Name)
end