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
	local bashDuration = ability:GetLevelSpecialValueFor("bash_duration", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			local damage = caster:GetAverageTrueAttackDamage(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", enemy, 2.0)
			Particles:SetControl(particle, {1, 2}, 100)
			if not enemy:IsMagicImmune() then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_doton_orb_stun", {duration = bashDuration})
			end
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end