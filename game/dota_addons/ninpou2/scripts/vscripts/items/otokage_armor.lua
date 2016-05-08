--[[
	Author: PicoleDeLimao
	Date: 05.01.2016
	Add yin and yang resistance when otokage armor is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local yinDef = ability:GetLevelSpecialValueFor("yin_resistance", ability:GetLevel() - 1)
	local yangDef = ability:GetLevelSpecialValueFor("yang_resistance", ability:GetLevel() - 1)
	caster.yinDef = caster.yinDef + yinDef 
	caster.yangDef = caster.yangDef + yangDef 
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local yinDef = ability:GetLevelSpecialValueFor("yin_resistance", ability:GetLevel() - 1)
	local yangDef = ability:GetLevelSpecialValueFor("yang_resistance", ability:GetLevel() - 1)
	caster.yinDef = caster.yinDef - yinDef 
	caster.yangDef = caster.yangDef - yinDef 
end