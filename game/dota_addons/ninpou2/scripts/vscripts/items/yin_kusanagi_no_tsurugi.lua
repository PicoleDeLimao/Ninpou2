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
	local manaDrain = ability:GetLevelSpecialValueFor("mana_drain", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			if not target:IsMagicImmune() and not target:GetMana() == 0 then 
				enemy:ReduceMana(manaDrain)
			end 
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", enemy, 2.0)
			Particles:SetControl(particle, 1, enemy:GetAbsOrigin() + Vector(100, 100, 100))
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end