--[[
	Author: PicoleDeLimao
	Date: 04.02.2016
	Add doton damage when doton orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local dotonDmg = ability:GetLevelSpecialValueFor("doton_damage_bonus", ability:GetLevel() - 1)
	caster.numDotonOrbs = (caster.numDotonOrbs or 0) + 1
	if caster.numDotonOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/items/dotonorb/espirit_rollingboulder.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 5, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.dotonOrbParticle = particle
		caster.dotonDmg = caster.dotonDmg + dotonDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local dotonDmg = ability:GetLevelSpecialValueFor("doton_damage_bonus", ability:GetLevel() - 1)
	if caster.numDotonOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.dotonOrbParticle, false)
		caster.dotonOrbParticle = nil
		caster.dotonDmg = caster.dotonDmg - dotonDmg 
	end
	if caster.numDotonOrbs > 0 then 
		caster.numDotonOrbs = caster.numDotonOrbs - 1 
	end
end