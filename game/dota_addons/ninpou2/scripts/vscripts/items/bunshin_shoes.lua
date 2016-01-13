--[[
	Author: PicoleDeLimao
	Date: 01.11.2016
	Implements Mirror Image funcionality of Bunshin Shoes 
]]

function KageBunshinNoJutsu(event)
	local caster = event.caster 
	local ability = event.ability 
	local numBunshins = ability:GetLevelSpecialValueFor("bunshin_number", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("bunshin_duration", ability:GetLevel() - 1)
	caster:EmitSound("Jutsu")
	Timers:CreateTimer(0.4, function()
		for i = 1, numBunshins do 
			Utils:CreateBunshin(caster, ability, duration)
		end
	end)
end