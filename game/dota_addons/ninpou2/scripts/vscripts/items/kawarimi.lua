--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Implement Kawarimi
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local duration = ability:GetSpecialValueFor("invul_duration")
	caster:EmitSound("Poof")
	caster:Purge(true, true, false, false, false)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_kawarimi_invul", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisible", {duration = duration})
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_sphere_final_explosion_smoke.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
	local dummy = CreateUnitByName("npc_kawarimi_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber())
	Timers:CreateTimer(2.0, function()
		dummy:ForceKill(false)
	end)
	local x = (50 + math.random() * 150) * (math.random() > 0.5 and 1 or -1)
	local y = (50 + math.random() * 150) * (math.random() > 0.5 and 1 or -1)
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin() + Vector(x, y, 0), false)
end