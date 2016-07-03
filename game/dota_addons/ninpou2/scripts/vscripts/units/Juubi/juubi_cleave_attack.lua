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
	local radius = ability:GetLevelSpecialValueFor("splash_area", ability:GetLevel() - 1)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do 
		if enemy ~= target then 
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL})
		end
	end
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", PATTACH_ABSORIGIN, target)
end