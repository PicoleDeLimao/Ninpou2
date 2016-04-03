--[[
	Author: PicoleDeLimao
	Date: 03.27.2016
	Add suiton damage when suiton orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local suitonDmg = ability:GetLevelSpecialValueFor("suiton_damage_bonus", ability:GetLevel() - 1)
	caster.numSuitonOrbs = (caster.numSuitonOrbs or 0) + 1
	if caster.numSuitonOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_apex_quas_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.suitonOrbParticle = particle
		caster.suitonDmg = caster.suitonDmg + suitonDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local suitonDmg = ability:GetLevelSpecialValueFor("suiton_damage_bonus", ability:GetLevel() - 1)
	if caster.numSuitonOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.suitonOrbParticle, false)
		caster.suitonOrbParticle = nil
		caster.suitonDmg = caster.suitonDmg - suitonDmg 
	end
	caster.numSuitonOrbs = caster.numSuitonOrbs - 1 
end