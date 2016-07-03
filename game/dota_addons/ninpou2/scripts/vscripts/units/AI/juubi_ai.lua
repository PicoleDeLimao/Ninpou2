--[[
	Author: PicoleDeLimao
	Date: 07.02.2016
	Define AI behavior for Juubi
]]

JUUBI_AI_THINK_INTERVAL = 2.0   -- How much time will be elapsed between one action and another?
JUUBI_AI_BUILDING_WEIGHT = 3.0  -- How likely juubi is to attack a building 
JUUBI_AI_CREEP_WEIGTH = 2.0     -- How likely juubi is to attack a creep    
JUUBI_AI_HERO_WEIGHT = 1.0      -- How likely juubi is to attack a hero 

JuubiAI = {}
JuubiAI.__index = JuubiAI

-- Calculate how likely juubi is to attack this unit 
function JuubiAI:GetScore(enemy)
	if enemy:GetMaxHealth() == 0 then 
		return 0
	end
	local score = 0 
	if enemy:IsBuilding() then 
		score = (1 - enemy:GetHealth() / enemy:GetMaxHealth()) * JUUBI_AI_BUILDING_WEIGHT
	elseif not enemy:IsHero() then
		score = (1 - enemy:GetHealth() / enemy:GetMaxHealth()) * JUUBI_AI_CREEP_WEIGTH
	else 
		score = (1 - enemy:GetHealth() / enemy:GetMaxHealth()) * JUUBI_AI_HERO_WEIGHT
	end
	if enemy:IsAttackingEntity(self.unit) or enemy:IsAttackingEntity(self.unit:GetOwner()) then 
		score = score * 2
	end
	if self.unit:GetOwner():IsAttackingEntity(enemy) then 
		score = score * 4
	end
	return score
end 

-- This function finds the next target which juubi must attack
function JuubiAI:FindNextUnit()
    local maxScore = nil
    local enemies = FindUnitsInRadius(self.unit:GetTeamNumber(), self.unit:GetAbsOrigin(), nil, self.acquisitionRange, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do 
        -- Check if enemy is valid
        if Units:IsValidAlive(enemy) then 
            local score = self:GetScore(enemy)
            if score > 0 and (maxScore == nil or score > maxScore.score) then 
                maxScore = {
                    ['score'] = score,
                    ['unit'] = enemy
                }
            end
        end
    end
    return maxScore ~= nil and maxScore.unit or nil 
end 

-- This function determines the next action for the juubi
function JuubiAI:Think() 
	local enemy = self:FindNextUnit()
	-- Too distant. Come back 
	if Units:IsValidAlive(self.unit:GetOwner()) and (self.unit:GetRangeToUnit(self.unit:GetOwner()) > 2000 or enemy == nil) then 
		ExecuteOrderFromTable({
			UnitIndex = self.unit:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			Position = self.unit:GetOwner():GetAbsOrigin(),
			Queue = false
		})
	-- There's a nearby enemy
	elseif enemy ~= nil then 
		ExecuteOrderFromTable({
			UnitIndex = self.unit:GetEntityIndex(),
			OrderType = DOTA_UNIT_ORDER_ATTACK_TARGET,
			TargetIndex = enemy:GetEntityIndex(),
			Queue = false
		})
	end
end

function JuubiAI:GlobalThink() 
    -- Check if unit is still valid
    if not Units:IsValidAlive(self.unit) then 
        return nil
    end
    self:Think()
    return self.thinkInterval
end 

-- This function initializes the juubi AI 
function JuubiAI:Start(unit) 
    local ai = {}   
    setmetatable(ai, JuubiAI)
    ai.unit = unit 
    ai.thinkInterval = JUUBI_AI_THINK_INTERVAL
    ai.acquisitionRange = unit:GetAcquisitionRange()
    -- Start thinking 
    Timers:CreateTimer(ai.thinkInterval, function() 
        return ai:GlobalThink()
    end)
    return ai
end
