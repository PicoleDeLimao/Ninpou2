--[[
	Author: PicoleDeLimao
	Date: 03.27.2016
	Add yin damage when yin orb is equipped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability 
	local yinDmg = ability:GetLevelSpecialValueFor("yin_damage_bonus", ability:GetLevel() - 1)
	caster.numYinOrbs = (caster.numYinOrbs or 0) + 1
	if caster.numYinOrbs == 1 then 
		local particle = ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_apex_wex_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.yinOrbParticle = particle
		caster.yinDmg = caster.yinDmg + yinDmg 
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability 
	local yinDmg = ability:GetLevelSpecialValueFor("yin_damage_bonus", ability:GetLevel() - 1)
	if caster.numYinOrbs == 1 then 
		ParticleManager:DestroyParticle(caster.yinOrbParticle, false)
		caster.yinOrbParticle = nil
		caster.yinDmg = caster.yinDmg - yinDmg 
	end
	caster.numYinOrbs = caster.numYinOrbs - 1 
end