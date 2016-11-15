--[[
	Author: PicoleDeLiamo
	Date: 07.23.2016
	Define some particles wrapper functions 
]]

if not Particles then
	Particles = class({})
end

-- Create a timed particle 
-- @param effectName: Path to the particle 
-- @param target: Target where the particle will be displayed (can be either a unit or vector. if vector, opts.caster must be provided) 
-- @param particleTime: How much time before the particle be erased
-- @param opts: Optional parameters (particleAttach, caster)
-- @return The created particle 
function Particles:CreateTimedParticle(effectName, target, particleTime, opts)
	if type(target) ~= "table" then 
		local target2 = CreateUnitByName("npc_dummy_unit", target, false, opts.caster, opts.caster, opts.caster:GetTeamNumber())
		target = target2
		Timers:CreateTimer(particleTime, function()
			target:ForceKill(false)
		end)
	end
	local particleOpts = opts or {}
	local particleAttach = particleOpts.particleAttach or PATTACH_ABSORIGIN 
	local particle = ParticleManager:CreateParticle(effectName, particleAttach, target)
	Timers:CreateTimer(particleTime, function()
		ParticleManager:DestroyParticle(particle, false)
	end)
	Particles:SetControlEnt(particle, 0, target)
	return particle
end

-- Attach a particle 
-- @param particle: Particle to be attached 
-- @param unit: Unit on which the particle will be attached to 
-- @param attachName: Name of attachment
function Particles:Attach(particle, unit, attachName)
	ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, attachName, unit:GetAbsOrigin(), true) 
end

-- Wrapper to set particle control entity
-- @param particle: An existing particle 
-- @param controlPoint: Control point which will be set (can be either a value or a list of values)
-- @param entity: Entity to which the control point will be set 
-- @param opts: Optional parameters (particleAttachType, particleAttach, target)
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
-- @param particle: An existing particle 
-- @param controlPoint: Control point which will be set (can be either a value or a list of values)
-- @param value: Value to which the control point will be set (can be either a value or a vector. if a value is provided, then it will be converted to a vector.)
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