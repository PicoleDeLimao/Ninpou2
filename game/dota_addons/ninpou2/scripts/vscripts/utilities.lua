--[[
	Author: PicoleDeLiamo
	Date: 04.01.2016
	Define many utilitary functions 
]]

Utils = {}

-- Check if unit is valid and alive 
function Utils:IsValidAlive(unit)
    return unit ~= nil and IsValidEntity(unit) and unit:IsAlive()
end

-- Check if unit can cast an ability
function Utils:CanCast(unit, ability)
	return not unit:IsMuted() and not unit:IsSilenced() and not unit:IsStunned() and unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1) and ability:GetCooldownTimeRemaining() == 0
end

-- Get the nearest hero to an unit inside a group of units 
function Utils:GetNearestHero(units, toUnit)
	local nearestHero = nil 
	for _, unit in pairs(units) do 
		if unit:IsRealHero() then 
			local distance = toUnit:GetRangeToUnit(unit)
			if nearestHero == nil or distance < nearestHero.distance then 
				nearestHero = {
					['unit'] = unit, 
					['distance'] = distance
				}
			end
		end
	end
	return nearestHero ~= nil and nearestHero.unit or nil
end