--[[
	Author: PicoleDeLimao
	Date: 01.11.2016
	Implements blink functionality of Shunshin Shoes active ability
]]

function ShunshinShoes(event)
	local caster = event.caster 
	local ability = event.ability
	local range = ability:GetLevelSpecialValueFor("shunshin_range", ability:GetLevel() - 1)
	local point = event.target_points[1]
	local casterPos = caster:GetAbsOrigin()
	local diff = point - casterPos 
	if diff:Length2D() > range then 
		point = casterPos + (point - casterPos):Normalized() * range 
	end
	Timers:CreateTimer(0.25, function()
		FindClearSpaceForUnit(caster, point, false)
	end)
end