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
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			local damage = caster:GetAverageTrueAttackDamage(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_invoker/invoker_tornado.vpcf", enemy, 0.1)
			Particles:SetControlEnt(particle, 3, enemy)
			Particles:SetControlEnt(particle, 6, enemy, { target = enemy:GetAbsOrigin() + Vector(0, 0, 200) })
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end