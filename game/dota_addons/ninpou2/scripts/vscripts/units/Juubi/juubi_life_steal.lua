--[[
	Author: PicoleDeLimao
	Date: 07.02.2016
	Implements Juubi Life Steal
]]

function LifeSteal(event)
	local caster = event.caster 
	local ability = event.ability
	local damage = caster:GetAverageTrueAttackDamage()
	local lifeSteal = ability:GetLevelSpecialValueFor("lifesteal", ability:GetLevel() - 1)
	caster:SetHealth(caster:GetHealth() + damage * lifeSteal)
end