--[[
	Author: PicoleDeLimao
	Date: 05.01.2016
	Add doton resistance when tsuchikage armor is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local dotonDef = ability:GetLevelSpecialValueFor("doton_resistance", ability:GetLevel() - 1)
	caster.dotonDef = caster.dotonDef + dotonDef 
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local dotonDef = ability:GetLevelSpecialValueFor("doton_resistance", ability:GetLevel() - 1)
	caster.dotonDef = caster.dotonDef - dotonDef 
end