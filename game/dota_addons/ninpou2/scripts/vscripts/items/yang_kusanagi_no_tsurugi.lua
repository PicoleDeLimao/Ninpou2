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
	local armorDuration = ability:GetLevelSpecialValueFor("armor_duration", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			local damage = caster:GetAverageTrueAttackDamage(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_chen/chen_holy_persuasion_sparks.vpcf", enemy, 0.1)
			Particles:SetControlEnt(particle, 1, enemy)
			if not enemy:IsMagicImmune() then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_yang_orb_debuff", {duration = armorDuration})
			end
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end