--[[
	Author: PicoleDeLimao
	Date: 01.09.2016
	Define AI behavior for Elite Anbu Leader units 
]]

ELITE_ANBU_LEADER_AI_THINK_INTERVAL = 2.0				-- How much time will be elapsed between one action and another?
ELITE_ANBU_LEADER_AI_IDLE_TIME_LIMIT = 5.0				-- How much time must be elapsed before the Elite Anbu Leader return to its original position?

EliteAnbuLeaderAI = {}
EliteAnbuLeaderAI.__index = EliteAnbuLeaderAI

-- This function determines the next action for an Elite Anbu Leader unit 
function EliteAnbuLeaderAI:Think() 
	-- Find units within acquisition range
	local enemies = FindUnitsInRadius(self.unit:GetTeamNumber(), self.unit:GetAbsOrigin(), nil, self.unit:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- If there aren't nearby enemies and unit is not in its original position, increase idle time 
	if #enemies == 0 and (self.unit:GetAbsOrigin() - self.originalPosition):Length2D() > 50 then 
		self.idleTime = self.idleTime + 1
		-- If idle time is above a certain limit, return back to its original position
		if self.idleTime > self.idleTimeLimit then 
			print("[AI] Elite Anbu Leader returning to base...")
			ExecuteOrderFromTable({
				UnitIndex = self.unit:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				Position = self.originalPosition,
				Queue = false
			})
			self.idleTime = 0
		end
	-- If there are nearby enemies
	elseif #enemies > 0 then 
		-- Check which abilities the anbu can cast
		local casteableAbilities = {}
		for i = 1, #self.abilities do 
			if Utils:CanCast(self.unit, self.abilities[i]) then 
				table.insert(casteableAbilities, self.abilities[i])
			end
		end
		-- Check if anbu can cast an ability (he only can cast one ability at a time, and must wait the cooldown of one before casting another ability)
		if #casteableAbilities == #self.abilities then 
			for _, enemy in pairs(enemies) do 
				-- If there's a nearby hero which is not yet disabled
				if enemy ~= nil and enemy:IsRealHero() and not Utils:IsDisabled(enemy) then 
					local abilityIndex = math.random(1, #casteableAbilities)
					local ability = casteableAbilities[abilityIndex]
					print("[AI] Elite Anbu casting " .. ability:GetAbilityName() .. "...")
					ExecuteOrderFromTable({
						UnitIndex = self.unit:GetEntityIndex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						TargetIndex = enemy:GetEntityIndex(),
						AbilityIndex = ability:GetEntityIndex(),
						Queue = false
					})
					break
				end
			end
		end
	end
end

function EliteAnbuLeaderAI:GlobalThink() 
	-- Check if unit is still valid 
	if not Utils:IsValidAlive(self.unit) then 
		return nil 
	end
	self:Think()
	return self.thinkInterval
end

-- This function initializes the Elite Anbu Leader AI for an unit
function EliteAnbuLeaderAI:Start(unit)
	local ai = {}
	setmetatable(ai, EliteAnbuLeaderAI)
	ai.unit = unit 
	ai.originalPosition = unit:GetAbsOrigin()
	ai.thinkInterval = ELITE_ANBU_LEADER_AI_THINK_INTERVAL
	ai.idleTime = 0
	ai.idleTimeLimit = ELITE_ANBU_LEADER_AI_IDLE_TIME_LIMIT	
	ai.abilities = {}
	for i = 0, 2 do 
		table.insert(ai.abilities, unit:GetAbilityByIndex(i))
	end
	-- Start thinking 
	Timers:CreateTimer(ai.thinkInterval, function()
		return ai:GlobalThink()
	end)
	return ai
end