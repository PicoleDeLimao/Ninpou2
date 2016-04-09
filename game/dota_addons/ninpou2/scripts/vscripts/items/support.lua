--[[
	Author: PicoleDeLimao
	Date: 04.09.2016
	Prevent user from picking more than two support items at once
]]

function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	Timers:CreateTimer(0.1, function()
		caster.numSupport = (caster.numSupport or 0) + 1
		if caster.numSupport > 2 then 
			caster:DropItemAtPositionImmediate(ability, caster:GetAbsOrigin())
			SendErrorMessage(caster:GetPlayerOwnerID(), "#error_support")
		end
	end)
end 

function Unequip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numSupport = caster.numSupport - 1
end