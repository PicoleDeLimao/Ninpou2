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
	if caster.numKatonOrbs > 0 then 
		caster.numKatonOrbs = caster.numKatonOrbs - 1 
	end
end