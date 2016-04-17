--[[
	Author: PicoleDeLimao
	Date: 04.09.2016
	Prevent user from picking more than two support items at once
]]

function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numSupports = caster.numSupports or 0
	Timers:CreateTimer(0.1, function()
		caster.numSupports = (caster.numSupports or 0) + 1
		if caster.numSupports > 2 then 
			caster:DropItemAtPositionImmediate(ability, caster:GetAbsOrigin())
			HUD:SendErrorMessage(caster:GetPlayerOwnerID(), "#error_support")
		end
	end)
end 

function Unequip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numSupports = caster.numSupports - 1
end