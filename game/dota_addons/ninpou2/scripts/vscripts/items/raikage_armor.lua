--[[
	Author: PicoleDeLimao
	Date: 05.01.2016
	Add raiton resistance when raikage armor is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local raitonDef = ability:GetLevelSpecialValueFor("raiton_resistance", ability:GetLevel() - 1)
	caster.raitonDef = caster.raitonDef + raitonDef 
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local raitonDef = ability:GetLevelSpecialValueFor("raiton_resistance", ability:GetLevel() - 1)
	caster.raitonDef = caster.raitonDef - raitonDef 
end