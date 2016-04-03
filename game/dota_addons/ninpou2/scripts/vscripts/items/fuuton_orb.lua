--[[
	Author: PicoleDeLimao
	Date: 04.02.2016
	Add fuuton damage when fuuton orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local fuutonDmg = ability:GetLevelSpecialValueFor("fuuton_damage_bonus", ability:GetLevel() - 1)
	caster.numFuutonOrbs = (caster.numFuutonOrbs or 0) + 1
	if caster.numFuutonOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_cyclone_swirl.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 5, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.fuutonOrbParticle = particle
		caster.fuutonDmg = caster.fuutonDmg + fuutonDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local fuutonDmg = ability:GetLevelSpecialValueFor("fuuton_damage_bonus", ability:GetLevel() - 1)
	if caster.numFuutonOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.fuutonOrbParticle, false)
		caster.fuutonOrbParticle = nil
		caster.fuutonDmg = caster.fuutonDmg - fuutonDmg 
	end
	if caster.numFuutonOrbs > 0 then 
		caster.numFuutonOrbs = caster.numFuutonOrbs - 1 
	end
end