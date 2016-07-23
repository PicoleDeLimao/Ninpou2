--[[
	Author: PicoleDeLimao
	Date: 03.04.2016
	Deals area critical strike damage
]]
function CriticalStrike(event)
	local caster = event.caster 
	local target = event.target 
	local ability = event.ability
	local damage = caster:GetAverageTrueAttackDamage()
	local bonus = ability:GetLevelSpecialValueFor("crit_bonus", ability:GetLevel() - 1) / 100.0
	local radius = ability:GetLevelSpecialValueFor("crit_area", ability:GetLevel() - 1)
	local slowDuration = ability:GetLevelSpecialValueFor("slow_duration", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_tidehunter/tidehunter_gush.vpcf", enemy, 0.25)
			Particles:SetControlEnt(particle, 0, enemy)
			Particles:SetControlEnt(particle, 1, enemy, { target = enemy:GetAbsOrigin() + Vector(0, 0, 300) })
			Particles:SetControl(particle, 3, 100)
			if not enemy:IsMagicImmune() then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_suiton_orb_slow", {duration = slowDuration})
			end
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end