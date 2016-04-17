--[[
	Author: PicoleDeLiamo
	Date: 04.10.2016
	Define some players wrapper functions 
]]

if not Players then 
	Players = class({})
end

-- Add gold to a unit
function Players:AddGoldToUnit(unit, amount)
	SendOverheadEventMessage(unit:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, unit, amount, nil)
end
