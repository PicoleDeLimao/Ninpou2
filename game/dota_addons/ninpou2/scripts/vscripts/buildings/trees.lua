--[[
	Author: PicoleDeLimao
	Date: 10.24.2016
	Add modifier_tree to trees
]]

LinkLuaModifier("modifier_tree", "modifiers/modifier_tree", LUA_MODIFIER_MOTION_NONE)

function OnCreated(event)
	local caster = event.caster 
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_tree", {})
end