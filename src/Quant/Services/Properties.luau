local Initalized = false
local mod = {}
mod.__index = mod
local Events

function mod.Init()
    if Initalized then
        return
    end
    Initalized = true

    Events = mod.Get("Events")
end

function mod.new(obj:Instance, Type:string)
    if not obj:IsA("Instance") or (Type and typeof(Type) ~= "string") then
        error("Invalid Arguments")
    end

    return setmetatable({obj = obj, Type = Type or "attribute"}, mod)
end

function mod:Get(property:string)
    if property then
        if typeof(property) ~= "string" then
            error("Property name is not a string.")
        end

        if self.Type:lower() == "attribute" then
            return self.obj:GetAttribute(property)
        elseif self.Type == "Value" then
            local objvalue = self.obj:FindFirstChild(property)

            if objvalue and objvalue:IsA("ValueBase") then
                return objvalue.Value
            end
        end
    else
        if self.Type:lower() == "attribute" then
            return self.obj:GetAttributes()
        else
            local ToRet = {}

            for idx, objvalue:ValueBase in self.obj:GetChildren() do
                if objvalue:IsA("ValueBase") then
                    ToRet[objvalue.Name] = objvalue.Value
                end
            end

            return ToRet
        end
    end
end

function mod:Set(property:string, value:any)
    if typeof(property) ~= "string" or value == nil then
        error("Invalid arguments")
    end
    
    local Event = Events.GetEvent("Property Changed") or Events.CreateEvent("Property Changed")

    if self.Type:lower() == "attribute" then
        self.obj:SetAttribute(property, value)
    else
        local objvalue
        if self.obj:FindFirstChild(property) then
            if self.obj[property]:IsA("ValueBase") then
                objvalue = self.obj[property]
            end
        end
        objvalue = objvalue or Instance.new(typeof(value).."Value", self.obj)
        objvalue.Name = property
        objvalue.Value = value
    end

    Event:Fire(self.obj, property, value)
end

function mod:Remove(property)
    if typeof(property) ~= "string" then
        error("Property name is not a string")
    end

    if self.Type:lower() == "attribute" then
        self.obj:SetAttribute(property, nil)
    else
        if self.obj:FindFirstChild(property) then
            if self.obj[property]:IsA("ValueBase") then
                self.obj[property]:Destroy()
            end
        end
    end
end

return mod