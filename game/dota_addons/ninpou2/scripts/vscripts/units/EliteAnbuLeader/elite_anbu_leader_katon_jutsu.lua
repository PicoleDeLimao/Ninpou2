--[[
	Author: PicoleDeLimao
	Date: 01.06.2016
	Show launch and impact effects for Katon Jutsu skill
]]

-- Display effect on spell start
function ShowLaunchEffect(event)
	local caster = event.caster
	local target = event.target
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_base_attack_fire_launch.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin() + caster:GetForwardVector() * 2)
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 9, caster:GetAbsOrigin())
end 

-- Display effect when projectile hit unit
function ShowImpactEffect(event)
	local caster = event.caster
	local target = event.target 
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_hit_fire.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
end