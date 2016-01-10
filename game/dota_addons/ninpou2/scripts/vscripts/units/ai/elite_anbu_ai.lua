--[[
	Author: PicoleDeLimao
	Date: 01.06.2016
	Define AI behavior for Elite Anbu units 
]]

ELITE_ANBU_AI_THINK_INTERVAL = 2.0 		-- How much time will be elapsed between one action and another?
ELITE_ANBU_AI_IDLE_TIME_LIMIT = 5.0		-- How much time must be elapsed in idle before the Anbu return to its original position?
ELITE_ANBU_AI_KUCHIYOSE_ENEMIES_LIMIT = 7 -- How many enemies are necessary to trigger 'Kuchiyose no Jutsu: Ninkens' ability?

EliteAnbuAI = {}
EliteAnbuAI.__index = EliteAnbuAI

-- This function determines the next action for Elite Anbu unit 
function EliteAnbuAI:Think() 
	-- Find units within acquisition range
	local enemies = FindUnitsInRadius(self.unit:GetTeamNumber(), self.unit:GetAbsOrigin(), nil, self.unit:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	-- If there aren't nearby enemies and unit is not in its original position, increase idle time 
	if #enemies == 0 and (self.unit:GetAbsOrigin() - self.originalPosition):Length2D() > 50 then 
		self.idleTime = self.idleTime + 1
		-- If idle time is above a certain limit, return back to its original position
		if self.idleTime > self.idleTimeLimit then 
			print("[AI] Elite Anbu returning to base...")
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
		local nearestHero = Utils:GetNearestHero(enemies, self.unit)
		-- Check if unit can cast ability 2 (Kuchiyose: Ninkens)
		if (nearestHero ~= nil or #enemies > self.ability2EnemiesLimit) and Utils:CanCast(self.unit, self.ability2) then 
			print("[AI] Elite Anbu casting " .. self.ability2:GetAbilityName() .. "...")
			ExecuteOrderFromTable({
				UnitIndex = self.unit:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self.ability2:GetEntityIndex(),
				Queue = false
			})
		-- Check if unit can cast ability 1 (Fuuma Shuriken)
		elseif nearestHero ~= nil and Utils:CanCast(self.unit, self.ability1) and not nearestHero:HasModifier("modifier_elite_anbu_fuuma_shuriken") then 
			print("[AI] Elite Anbu casting " .. self.ability1:GetAbilityName() .. "...")
			ExecuteOrderFromTable({
				UnitIndex = self.unit:GetEntityIndex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				TargetIndex = nearestHero:GetEntityIndex(),
				AbilityIndex = self.ability1:GetEntityIndex(),
				Queue = false
			})
		end
	end
end

function EliteAnbuAI:GlobalThink() 
	-- Check if unit is still valid 
	if not Utils:IsValidAlive(self.unit) then
		return nil
	end
	self:Think()
	return self.thinkInterval
end

-- This function initializes the Elite ANBU AI for an unit
function EliteAnbuAI:Start(unit)
	local ai = {}
	setmetatable(ai, EliteAnbuAI)
	ai.unit = unit
	ai.thinkInterval = ELITE_ANBU_AI_THINK_INTERVAL
	ai.originalPosition = unit:GetAbsOrigin()
	ai.idleTime = 0
	ai.idleTimeLimit = ELITE_ANBU_AI_IDLE_TIME_LIMIT
	ai.ability1 = unit:GetAbilityByIndex(0)
	ai.ability2 = unit:GetAbilityByIndex(1)
	ai.ability2EnemiesLimit = ELITE_ANBU_AI_KUCHIYOSE_ENEMIES_LIMIT
	-- Start thinking
	Timers:CreateTimer(ai.thinkInterval, function()
		return ai:GlobalThink()
	end)
	return ai
end