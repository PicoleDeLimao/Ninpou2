--[[
	Author: PicoleDeLimao
	Date: 05.01.2016
	Add katon resistance when hokage armor is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local katonDef = ability:GetLevelSpecialValueFor("katon_resistance", ability:GetLevel() - 1)
	caster.katonDef = caster.katonDef + katonDef 
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local katonDef = ability:GetLevelSpecialValueFor("katon_resistance", ability:GetLevel() - 1)
	caster.katonDef = caster.katonDef - katonDef 
end