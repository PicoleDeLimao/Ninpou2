--[[
	Author: PicoleDeLimao
	Date: 02.08.2016
	Attachs sword particle when equiped
]]
function Equip(event)
	local caster = event.caster 
	caster.kusanagiNoTsurugiCount = (caster.kusanagiNoTsurugiCount or 0) + 1
	if caster.kusanagiNoTsurugiCount == 1 then
		local particle = ParticleManager:CreateParticle("particles/items/KusanagiNoTsurugi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.kusanagiNoTsurugiParticle = particle
	end
end

function Unequip(event)
	local caster = event.caster
	if caster.kusanagiNoTsurugiCount == 1 then 
		ParticleManager:DestroyParticle(caster.kusanagiNoTsurugiParticle, false)
		caster.kusanagiNoTsurugiParticle = nil
	end
	caster.kusanagiNoTsurugiCount = caster.kusanagiNoTsurugiCount - 1
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
	if caster.kusanagiNoTsurugiParticle == nill then
		local particle = ParticleManager:CreateParticle("particles/items/KusanagiNoTsurugi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true) 
		caster.kusanagiNoTsurugiParticle = particle
	end
end