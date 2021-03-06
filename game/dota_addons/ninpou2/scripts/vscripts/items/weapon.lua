--[[
	Author: PicoleDeLimao
	Date: 04.09.2016
	Prevent user from picking more than one weapon at once
]]

function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numWeapons = caster.numWeapons or 0
	Timers:CreateTimer(0.1, function()
		caster.numWeapons = (caster.numWeapons or 0) + 1
		if caster.numWeapons > 1 then 
			caster:DropItemAtPositionImmediate(ability, caster:GetAbsOrigin())
			HUD:SendErrorMessage(caster:GetPlayerOwnerID(), "#error_weapon")
		end
	end)
end 

function Unequip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numWeapons = caster.numWeapons - 1
end