--[[
	Author: PicoleDeLimao
	Date: 10.24.2016
	Add modifier_semi_building to dummy buildings
]]

LinkLuaModifier("modifier_semi_building", "modifiers/modifier_semi_building", LUA_MODIFIER_MOTION_NONE)

function OnCreated(event)
	local caster = event.caster 
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_semi_building", {})
end