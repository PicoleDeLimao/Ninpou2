--[[
	Author: PicoleDeLimao
	Date: 02.08.2016
	Attachs sword particle when equiped
]]
function Equip(event)
	local caster = event.caster 
	local particle = ParticleManager:CreateParticle("particles/items/KusanagiNoTsurugi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
	ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
	
	caster.kusanagiNoTsurugiParticle = particle
end

function Unequip(event)
	local caster = event.caster
	if caster.kusanagiNoTsurugiParticle ~= nil then 
		ParticleManager:DestroyParticle(caster.kusanagiNoTsurugiParticle, false)
		caster.kusanagiNoTsurugiParticle = nil
	end
end

function ProjectileStart(event)
	local caster = event.caster
	if caster.kusanagiNoTsurugiParticle ~= nil then 
		ParticleManager:DestroyParticle(caster.kusanagiNoTsurugiParticle, true)
		caster.kusanagiNoTsurugiParticle = nil
	end
end 

function ProjectileEnd(event)
	local caster = event.caster
	local particle = ParticleManager:CreateParticle("particles/items/KusanagiNoTsurugi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
	caster.kusanagiNoTsurugiParticle = particle
end