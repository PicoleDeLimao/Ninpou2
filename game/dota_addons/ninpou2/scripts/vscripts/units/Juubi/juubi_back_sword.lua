--[[
	Author: PicoleDeLimao
	Date: 07.03.2016
	Implement back to sword form skill
]]

function SpellStart(event)
	local caster = event.caster 
	local ability = event.ability
	caster:ForceKill(true)
end