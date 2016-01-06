--[[
	Author: PicoleDeLimao
	Date: 01.05.2016
	Adjust Kuchiyose no Jutsu: Ninkens ability
]]

-- Get two points facing a distance away from the caster and separated from each other at 30 degrees left and right
function GetSummonPoints(event)
	local caster = event.caster
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	local distance = event.distance 
	local frontPosition = origin + fv * distance 
	local pointLeft = RotatePosition(origin, QAngle(0, 30, 0), frontPosition)
	local pointRight = RotatePosition(origin, QAngle(0, -30, 0), frontPosition)
	local result = {}
	table.insert(result, pointLeft)
	table.insert(result, pointRight)
	return result 
end 

-- Set the units looking at the same point of the caster 
function SetUnitsMoveForward(event)
	local caster = event.caster 
	local target = event.target 
	local fv = caster:GetForwardVector()
	local origin = caster:GetAbsOrigin()
	target:SetForwardVector(fv)
	-- Add target to a table attached to caster handle, to get them on "KillNinkens" function 
	if caster.ninkens == nil then 
		caster.ninkens = {} 
	end
	table.insert(caster.ninkens, target)
	target.is_kuchiyose = true 
end

-- Kill ninkens after modified effect has passed, since they have timed life 
function KillNinkens(event)
	local caster = event.caster
	local targets = caster.ninkens or {} 
	for _, unit in pairs(targets) do 
		if unit and IsValidEntity(unit) then 
			unit:ForceKill(true)
		end
	end
	-- Reset table
	caster.ninkens = {}
end

-- Create a thinker to fire smoke and sound effects
function ShowEffect(event) 
	local target = event.target
	local ability = event.ability
	ability:ApplyDataDrivenThinker(target, target:GetAbsOrigin(), "modifier_kuchiyose_effect", nil)
end

-- Display smoke effect 
function ShowSmoke(event)
	local target = event.target 
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_sphere_final_explosion_smoke.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())
end