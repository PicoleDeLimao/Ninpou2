--[[
	Author: PicoleDeLimao
	Date: 03.27.2016
	Implement Juubi splash damage
]]
function AttackLanded(event)
	local caster = event.caster 
	local target = event.target
	local ability = event.ability 
	local damage = caster:GetAverageTrueAttackDamage()
	local damageBonus = ability:GetLevelSpecialValueFor("damage_bonus", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("splash_area", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * damageBonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			Particles:CreateTimedParticle("particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", enemy, 2.0)
		end
	})
end