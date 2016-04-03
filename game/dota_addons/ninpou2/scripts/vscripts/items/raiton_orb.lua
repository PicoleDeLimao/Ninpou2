--[[
	Author: PicoleDeLimao
	Date: 03.27.2016
	Add raiton damage when raiton orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local raitonDmg = ability:GetLevelSpecialValueFor("raiton_damage_bonus", ability:GetLevel() - 1)
	caster.numRaitonOrbs = (caster.numRaitonOrbs or 0) + 1
	if caster.numRaitonOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/items/raitonorb/invoker_apex_wex_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.raitonOrbParticle = particle
		caster.raitonDmg = caster.raitonDmg + raitonDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local raitonDmg = ability:GetLevelSpecialValueFor("raiton_damage_bonus", ability:GetLevel() - 1)
	if caster.numRaitonOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.raitonOrbParticle, false)
		caster.raitonOrbParticle = nil
		caster.raitonDmg = caster.raitonDmg - raitonDmg 
	end
	if caster.numRaitonOrbs > 0 then 
		caster.numRaitonOrbs = caster.numRaitonOrbs - 1 
	end
end