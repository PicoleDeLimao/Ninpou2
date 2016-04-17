--[[
	Author: PicoleDeLimao
	Date: 04.10.2016
	Prevent user from picking more than one set at once
]]

function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numSets = caster.numSets or 0
	Timers:CreateTimer(0.1, function()
		caster.numSets = (caster.numSets or 0) + 1
		if caster.numSets > 1 then 
			caster:DropItemAtPositionImmediate(ability, caster:GetAbsOrigin())
			HUD:SendErrorMessage(caster:GetPlayerOwnerID(), "#error_set")
		end
	end)
end 

function Unequip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numSets = caster.numSets - 1
end