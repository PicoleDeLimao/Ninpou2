--[[
	Author: PicoleDeLimao
	Date: 03.04.2016
	Deals area critical strike damage
]]
function CriticalStrike(event)
	local caster = event.caster 
	local target = event.target 
	local ability = event.ability
	local bonus = ability:GetLevelSpecialValueFor("crit_bonus", ability:GetLevel() - 1) / 100.0
	local radius = ability:GetLevelSpecialValueFor("crit_area", ability:GetLevel() - 1)
	local moveSpeedDuration = ability:GetLevelSpecialValueFor("movespeed_duration", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			local damage = caster:GetAverageTrueAttackDamage(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion.vpcf", enemy, 2.0)
			Particles:SetControlEnt(particle, {1, 3}, enemy)
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end