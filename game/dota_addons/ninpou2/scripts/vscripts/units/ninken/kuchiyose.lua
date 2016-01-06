--[[
	Author: PicoleDeLimao
	Date: 01.06.2016
	Display a smoke and sound file when a kuchiyose dissapear
]]

-- Create a thinker to fire smoke and sound effects
function ShowEffect(event) 
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenThinker(target, target:GetAbsOrigin(), "modifier_kuchiyose_effect", nil)
end

-- Display smoke effect 
function ShowSmoke(event)
	local target = event.target 
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_sphere_final_explosion_smoke.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
end