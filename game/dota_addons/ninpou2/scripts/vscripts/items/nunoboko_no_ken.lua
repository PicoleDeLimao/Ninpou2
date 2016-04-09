--[[
	Author: PicoleDeLimao
	Date: 04.09.2016
	Attachs sword particle when equiped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability
	local damageIncrease = ability:GetLevelSpecialValueFor("elemental_damage_bonus", ability:GetLevel() - 1)
	caster.nunobokoNoKenCount = (caster.nunobokoNoKenCount or 0) + 1
	caster.katonDmg = caster.katonDmg + damageIncrease 
	caster.suitonDmg = caster.suitonDmg + damageIncrease 
	caster.dotonDmg = caster.dotonDmg + damageIncrease 
	caster.fuutonDmg = caster.fuutonDmg + damageIncrease 
	caster.raitonDmg = caster.raitonDmg + damageIncrease 
	caster.yinDmg = caster.yinDmg + damageIncrease 
	caster.yangDmg = caster.yangDmg + damageIncrease 
	if caster.nunobokoNoKenCount == 1 then
		local particle = ParticleManager:CreateParticle("particles/items/NunobokoNoKen/nunoboko_no_ken.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.nunobokoNoKenParticle = particle
		caster.nunobokoNoKenParticleName = event.ParticleName
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability
	local damageIncrease = ability:GetLevelSpecialValueFor("elemental_damage_bonus", ability:GetLevel() - 1)
	caster.katonDmg = caster.katonDmg - damageIncrease 
	caster.suitonDmg = caster.suitonDmg - damageIncrease 
	caster.dotonDmg = caster.dotonDmg - damageIncrease 
	caster.fuutonDmg = caster.fuutonDmg - damageIncrease 
	caster.raitonDmg = caster.raitonDmg - damageIncrease 
	caster.yinDmg = caster.yinDmg - damageIncrease 
	caster.yangDmg = caster.yangDmg - damageIncrease 
	if caster.nunobokoNoKenCount == 1 then 
		ParticleManager:DestroyParticle(caster.nunobokoNoKenParticle, false)
		caster.nunobokoNoKenParticle = nil
	end
	caster.nunobokoNoKenCount = caster.nunobokoNoKenCount - 1
end

function CriticalStrike(event)
	local caster = event.caster 
	local target = event.target 
	local ability = event.ability
	local damage = caster:GetAverageTrueAttackDamage()
	local bonus = ability:GetLevelSpecialValueFor("crit_bonus", ability:GetLevel() - 1) / 100.0
	local radius = ability:GetLevelSpecialValueFor("crit_area", ability:GetLevel() - 1)
	local slowDuration = ability:GetLevelSpecialValueFor("slow_duration", ability:GetLevel() - 1)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BUILDING + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do 
		ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_MAGICAL})
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", PATTACH_ABSORIGIN, enemy)
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_nunoboko_no_ken_slow", {duration = slowDuration})
		Timers:CreateTimer(0.25, function()
			ParticleManager:DestroyParticle(particle, false)
		end)
		PopupCriticalDamage(enemy, damage * bonus)
	end
end

function ShapeTheWorld(event)
	local caster = event.caster 
	local target = event.target_points[1]
	local ability = event.ability 
	local radius = ability:GetLevelSpecialValueFor("shape_world_radius", ability:GetLevel() - 1)
	local paralysisDuration = ability:GetLevelSpecialValueFor("shape_world_duration", ability:GetLevel() - 1)
	local damageTakenDuration = ability:GetLevelSpecialValueFor("shape_world_damage_taken_duration", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("shape_world_damage", ability:GetLevel() - 1)
	local particle = ParticleManager:CreateParticle("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, target)
	ParticleManager:SetParticleControl(particle, 1, Vector(radius, 0, 0))
	Timers:CreateTimer(paralysisDuration, function() 
		ParticleManager:DestroyParticle(particle, false)
	end)
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), target, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_nunoboko_no_ken_paralysis", {duration = paralysisDuration})
		ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_nunoboko_no_ken_damage_taken", {duration = damageTakenDuration})
		ApplyDamage({ victim = enemy, attacker = caster, damage = (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * damage, damage_type = DAMAGE_TYPE_MAGICAL})
	end
	caster:EmitSound("Hero_Enigma.BlackHole.Cast.Chasm")
end