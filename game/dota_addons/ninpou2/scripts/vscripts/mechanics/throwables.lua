--[[
	Author: PicoleDeLiamo
	Date: 07.23.2016
	Define a projectile with parabolic movement
]]

require('mechanics/Vectors')

THROWABLE_FREQUENCY = 0.03   -- How often the throwable movement will be updated per sec?
THROWABLE_MIN_HEIGHT = 128

if not Throwables then
	Throwables = class({})
end

-- Create a throwable
function Throwables:CreateThrowable(params)
	local effectName = params.effectName 
	local caster = params.caster
	local target = params.target 
	local height = params.height or 0 
	local speed = params.speed or 800
	local endCallback = params.onEnd
	local radius = params.radius
	local enemyCallback = params.onHitEnemy
	local hitEnemyOnce = params.hitEnemyOnce or true
	local tickCallback = params.onTick
	local step = 1 / THROWABLE_FREQUENCY
	
	local origin = caster:GetAbsOrigin()
	if height > 0 then
		origin.z = THROWABLE_MIN_HEIGHT
	end
	local maxDistance = (origin - target):Length2D()
	local current = origin
	local dummy = CreateUnitByName("npc_dummy_unit", origin, false, caster, caster, caster:GetTeamNumber())
	local particle = ParticleManager:CreateParticle(effectName, PATTACH_ABSORIGIN_FOLLOW, dummy)
	ParticleManager:SetParticleControl(particle, 1, (target - origin):Normalized())
	local affected = { }
	local countAffected = 0
	Timers:CreateTimer(THROWABLE_FREQUENCY, function()
		local diffVector = target - current
		local currentDistance = diffVector:Length2D()
		if enemyCallback then 
			Units:FindEnemiesInRange({
				unit = caster,
				point = dummy:GetAbsOrigin(),
				radius = radius,
				func = function(enemy) 
					if hitEnemyOnce then 
						if not Throwables:_wasAffected(enemy, affected) then 
							affected[countAffected] = enemy 
							countAffected = countAffected + 1
							enemyCallback(enemy, dummy)
						end
					else
						enemyCallback(enemy, dummy)
					end
				end
			})
		end
		if currentDistance < step then
			if endCallback then
				endCallback(dummy)
			end
			ParticleManager:DestroyParticle(particle, false)
			dummy:ForceKill(false)
		else 
			current = current + diffVector:Normalized() * step
			if height > 0 then
				current.z = Vectors:GetFlyHeight(height, maxDistance, currentDistance)
			end
			dummy:SetAbsOrigin(current)
			if tickCallback then 
				tickCallback(dummy)
			end
			return THROWABLE_FREQUENCY
		end
	end)
end

function Throwables:_wasAffected(enemy, affected)
	for _, unit in pairs(affected) do 
		if unit == enemy then 
			return true 
		end
	end
	return false
end
