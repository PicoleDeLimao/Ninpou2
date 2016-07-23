--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Prevent user from picking more than one ninja weapon at once
]]

function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numNinjaWeapons = caster.numNinjaWeapons or 0
	Timers:CreateTimer(0.1, function()
		caster.numNinjaWeapons = (caster.numNinjaWeapons or 0) + 1
		if caster.numNinjaWeapons > 1 then 
			caster:DropItemAtPositionImmediate(ability, caster:GetAbsOrigin())
			HUD:SendErrorMessage(caster:GetPlayerOwnerID(), "#error_ninja_weapon")
		end
	end)
end 

function Unequip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numNinjaWeapons = caster.numNinjaWeapons - 1
end