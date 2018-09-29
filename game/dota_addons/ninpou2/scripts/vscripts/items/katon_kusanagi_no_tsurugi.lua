--[[
	Author: PicoleDeLimao
	Date: 02.08.2016
	Deals area critical strike damage
]]
function CriticalStrike(event)
	local caster = event.caster 
	local target = event.target 
	local ability = event.ability
	local bonus = ability:GetLevelSpecialValueFor("crit_bonus", ability:GetLevel() - 1) / 100.0
	local radius = ability:GetLevelSpecialValueFor("crit_area", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			local damage = caster:GetAverageTrueAttackDamage(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			Particles:CreateTimedParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", enemy, 2.0)
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end