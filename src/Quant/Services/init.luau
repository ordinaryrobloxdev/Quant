local Services = {}

function Get(Name)
    if Name and script:FindFirstChild(Name) then
        local Rservice = require(script[Name])
        if typeof(Rservice) == "table" then
            Rservice.Get = Get
        end
        if typeof(Rservice) == "table" and typeof(Rservice.Init) == "function" then
            Rservice.Init()
        end
        return Rservice
    end

    for idx, Service:ModuleScript in script:GetChildren() do
        if Service:IsA("ModuleScript") and Service ~= getfenv(2).script then
            local Rservice = require(Service)
            if typeof(Rservice) == "table" then
                Rservice.Get = Get
            end
            Services[Service.Name:lower()] = Rservice
        end
    end

    for name, service in Services do
        if typeof(service) == "table" and typeof(service.Init) == "function" then
            service.Init()
        end
    end

    Services.___ran = true

    return Services
end

return function(Name)
    if (Name and typeof(Name) ~= "string") then
        error("Invalid arguments")
    end

    if Services.___ran then
        if Name and Services[Name:lower()] then
            return Services[Name:lower()]
        else
            return Services
        end
    end

    return Get(Name)
end