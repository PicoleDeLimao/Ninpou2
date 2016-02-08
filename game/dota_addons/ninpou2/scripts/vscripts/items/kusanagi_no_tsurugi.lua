--[[
	Author: PicoleDeLimao
	Date: 02.08.2016
	Attachs sword particle when equiped
]]
function Equip(event)
	local caster = event.caster 
	local particle = ParticleManager:CreateParticle("particles/items/KusanagiNoTsurugi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
	caster.kusanagi_no_tsurugi_particle = particle
end

function Unequip(event)
	local caster = event.caster
	if caster.kusanagi_no_tsurugi_particle ~= nil then 
		ParticleManager:DestroyParticle(caster.kusanagi_no_tsurugi_particle, false)
		caster.kusanagi_no_tsurugi_particle = nil
	end
end

function ProjectileStart(event)
	local caster = event.caster
	if caster.kusanagi_no_tsurugi_particle ~= nil then 
		ParticleManager:DestroyParticle(caster.kusanagi_no_tsurugi_particle, true)
		caster.kusanagi_no_tsurugi_particle = nil
	end
end 

function ProjectileEnd(event)
	local caster = event.caster
	local particle = ParticleManager:CreateParticle("particles/items/KusanagiNoTsurugi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
	caster.kusanagi_no_tsurugi_particle = particle
end