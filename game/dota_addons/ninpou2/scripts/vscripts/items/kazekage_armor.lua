--[[
	Author: PicoleDeLimao
	Date: 05.01.2016
	Add fuuton resistance when kazekage armor is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local fuutonDef = ability:GetLevelSpecialValueFor("fuuton_resistance", ability:GetLevel() - 1)
	caster.fuutonDef = caster.fuutonDef + fuutonDef 
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local fuutonDef = ability:GetLevelSpecialValueFor("fuuton_resistance", ability:GetLevel() - 1)
	caster.fuutonDef = caster.fuutonDef - fuutonDef 
end