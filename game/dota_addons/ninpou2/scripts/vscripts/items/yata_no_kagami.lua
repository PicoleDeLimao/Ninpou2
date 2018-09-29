--[[
	Author: PicoleDeLimao
	Date: 06.30.2016
	Implements Yata no Kagami effect
]]
function SpellStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf"
	
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN, "attach_origin", caster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(particle, 1, Vector(200, 0, 0))
	ParticleManager:SetParticleControl(particle, 3, caster:GetAbsOrigin() + Vector(0, 0, 400))
	caster:EmitSound("Hero_OgreMagi.Fireblast.Target")
	print("hmmmmok")
end