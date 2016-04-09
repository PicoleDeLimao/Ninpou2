--[[
	Author: PicoleDeLimao
	Date: 04.09.2016
	Prevent user from picking more than one armor at once
]]

function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numArmors = caster.numArmors or 0
	Timers:CreateTimer(0.1, function()
		caster.numArmors = (caster.numArmors or 0) + 1
		if caster.numArmors > 1 then 
			caster:DropItemAtPositionImmediate(ability, caster:GetAbsOrigin())
			SendErrorMessage(caster:GetPlayerOwnerID(), "#error_armor")
		end
	end)
end 

function Unequip(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.numArmors = caster.numArmors - 1
end