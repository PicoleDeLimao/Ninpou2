--[[
	Author: PicoleDeLiamo
	Date: 07.23.2016
	Define some particles wrapper functions 
]]

if not Particles then
	Particles = class({})
end

-- Create a timed particle 
function Particles:CreateTimedParticle(effectName, target, particleTime, opts)
	local particleOpts = opts or {}
	local particleAttach = particleOpts.particleAttach or PATTACH_ABSORIGIN 
	local particle = ParticleManager:CreateParticle(effectName, particleAttach, target)
	Timers:CreateTimer(particleTime, function()
		ParticleManager:DestroyParticle(particle, false)
	end)
	Particles:SetControlEnt(particle, 0, target)
	return particle
end

-- Wrapper to set particle control entity
function Particles:SetControlEnt(particle, controlPoint, entity, opts)
	local particleOpts = opts or {}
	local particleAttachType = particleOpts.particleAttachType or PATTACH_ABSORIGIN
	local particleAttach = particleOpts.particleAttach or "attach_origin"
	local particleTarget = particleOpts.target or entity:GetAbsOrigin()
	if type(controlPoint) == "table" then 
		for _, cp in pairs(controlPoint) do 
			ParticleManager:SetParticleControlEnt(particle, cp, entity, particleAttachType, particleAttach, particleTarget, true)
		end
	else
		ParticleManager:SetParticleControlEnt(particle, controlPoint, entity, particleAttachType, particleAttach, particleTarget, true)
	end
end

-- Wrapper to set particle control 
function Particles:SetControl(particle, controlPoint, value)
	local controlPointValue = 0
	if type(value) == "number" then 
		controlPointValue = Vector(value, value, value)
	else 
		controlPointValue = value
	end
	if type(controlPoint) == "table" then 
		for _, cp in pairs(controlPoint) do 
			ParticleManager:SetParticleControl(particle, cp, controlPointValue)
		end
	else 
		ParticleManager:SetParticleControl(particle, controlPoint, controlPointValue)
	end
end