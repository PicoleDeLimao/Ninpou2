MEDICAL_NINJA_AI_THINK_INTERVAL = 2.0   -- How much time will be elapsed between one action and another?

MedicalNinjaAI = {}
MedicalNinjaAI.__index = MedicalNinjaAI

-- Get the score for an ally. The score determines how likely the ally is to be healed by the medical ninja
function MedicalNinjaAI:GetScore(ally)
    -- Don't heal already healed allys
    if ally:HasModifier("modifier_medical_ninja_heal") or ally:GetHealthPercent() == 100 then 
        return 0
    end
    local healthWeight = 0.7
    local distanceWeight = 0.3
    local heroWeight = 0.3
    local health = (100 - ally:GetHealthPercent()) / 100.0
    local distance = (self.aquisitionRange - self.unit:GetRangeToUnit(ally)) / self.aquisitionRange
    local isHero = ally:IsRealHero() and 1 or 0 
    return health * healthWeight + distance * distanceWeight + isHero * heroWeight
end 

-- This function finds a hurt ally with highest score within the aquisition range radius
function MedicalNinjaAI:FindHurtAlly()
    local maxScore = nil
    local allies = FindUnitsInRadius(self.unit:GetTeamNumber(), self.unit:GetAbsOrigin(), nil, self.aquisitionRange, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, ally in pairs(allies) do 
        -- Check if ally is valid
        if Utils:IsValidAlive(ally) then 
            local score = self:GetScore(ally)
            if score > 0 and (maxScore == nil or score > maxScore.score) then 
                maxScore = {
                    ['score'] = score,
                    ['unit'] = ally
                }
            end
        end
    end
    return maxScore ~= nil and maxScore.unit or nil 
end 

-- This function determines the next behavior for a medical ninja unit
function MedicalNinjaAI:Think() 
    -- Will only perform the heal action if mana amount is enough to cast it
    if self.unit:GetMana() > self.minManaAmount then 
        local hurtAlly = self:FindHurtAlly()
        -- Check if there's any nearby hurt unit
        if hurtAlly ~= nil then 
            self.unit:CastAbilityOnTarget(hurtAlly, self.ability, self.unit:GetPlayerOwnerID())
            StartAnimation(self.unit, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.5})
        end
    end
end

function MedicalNinjaAI:GlobalThink() 
    -- Check if unit is still valid
    if not Utils:IsValidAlive(self.unit) then 
        self = nil
        return self
    end
    self:Think()
    return self.thinkInterval
end 

-- This function initializes the medical ninja AI for an unit in order to enable it to autocast heal ability
function MedicalNinjaAI:Start(unit) 
    local ai = {}   
    setmetatable(ai, MedicalNinjaAI)
    ai.unit = unit 
    ai.thinkInterval = MEDICAL_NINJA_AI_THINK_INTERVAL
    ai.ability = unit:GetAbilityByIndex(0)
    ai.aquisitionRange = ai.ability:GetCastRange()
    ai.minManaAmount = ai.ability:GetManaCost(0)
    -- Start thinking 
    Timers:CreateTimer(function() 
        return ai:GlobalThink()
    end)
    return ai
end
