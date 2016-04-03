--[[
	Author: PicoleDeLimao
	Date: 04.02.2016
	Add yang damage when yang orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local yangDmg = ability:GetLevelSpecialValueFor("yang_damage_bonus", ability:GetLevel() - 1)
	caster.numYangOrbs = (caster.numYangOrbs or 0) + 1
	if caster.numYangOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/econ/items/puck/puck_merry_wanderer/puck_illusory_orb_magic_merry_wanderer.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.yangOrbParticle = particle
		caster.yangDmg = caster.yangDmg + yangDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local yangDmg = ability:GetLevelSpecialValueFor("yang_damage_bonus", ability:GetLevel() - 1)
	if caster.numYangOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.yangOrbParticle, false)
		caster.yangOrbParticle = nil
		caster.yangDmg = caster.yangDmg - yangDmg 
	end
	caster.numYangOrbs = caster.numYangOrbs - 1 
end