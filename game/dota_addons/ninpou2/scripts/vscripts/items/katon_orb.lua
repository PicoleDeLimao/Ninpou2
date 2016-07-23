--[[
	Author: PicoleDeLimao
	Date: 03.27.2016
	Add katon damage when katon orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local katonDmg = ability:GetLevelSpecialValueFor("katon_damage_bonus", ability:GetLevel() - 1)
	caster.numKatonOrbs = (caster.numKatonOrbs or 0) + 1
	if caster.numKatonOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_apex_exort_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.katonOrbParticle = particle
		caster.katonDmg = caster.katonDmg + katonDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local katonDmg = ability:GetLevelSpecialValueFor("katon_damage_bonus", ability:GetLevel() - 1)
	if caster.numKatonOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.katonOrbParticle, false)
		caster.katonOrbParticle = nil
		caster.katonDmg = caster.katonDmg - katonDmg 
	end
	caster.numKatonOrbs = caster.numKatonOrbs - 1 
end

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
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, Vector(radius, 0, 0))
	Timers:CreateTimer(2.0, function()
		ParticleManager:DestroyParticle(particle, false)
	end)
end