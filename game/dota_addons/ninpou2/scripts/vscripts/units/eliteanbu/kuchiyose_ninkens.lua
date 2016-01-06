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