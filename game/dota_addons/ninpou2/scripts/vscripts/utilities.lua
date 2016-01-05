Utils = {}

function Utils:IsValidAlive(unit)
    return unit ~= nil and IsValidEntity(unit) and unit:IsAlive()
end