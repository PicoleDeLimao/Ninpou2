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
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do 
		ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
		if not target:IsMagicImmune() and not target:GetMana() == 0 then 
			enemy:ReduceMana(manaDrain)
		end 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dazzle/dazzle_shadow_wave.vpcf", PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControlEnt(particle, 0, enemy, PATTACH_ABSORIGIN, "attach_origin", enemy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(particle, 1, enemy:GetAbsOrigin() + Vector(50, 50, 50))
	end
end