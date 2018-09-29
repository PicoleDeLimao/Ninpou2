--[[
	Author: PicoleDeLimao
	Date: 05.01.2016
	Add suiton resistance when mizukage armor is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local suitonDef = ability:GetLevelSpecialValueFor("suiton_resistance", ability:GetLevel() - 1)
	caster.suitonDef = caster.suitonDef + suitonDef 
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local suitonDef = ability:GetLevelSpecialValueFor("suiton_resistance", ability:GetLevel() - 1)
	caster.suitonDef = caster.suitonDef - suitonDef 
end