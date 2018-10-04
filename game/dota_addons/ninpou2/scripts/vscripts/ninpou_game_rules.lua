--[[
	Author: PicoleDeLimao
	Date: 01.13.2016
	This script defines the main rules for game victory/defeat conditions, as well as the actions that must be taken in each one of those case
]]

NinpouGameRules = {}
NinpouGameRules.defeatedTeams = {}
NinpouGameRules.teamScore = {
	[DOTA_TEAM_GOODGUYS] = 0,
	[DOTA_TEAM_BADGUYS] = 0,
	[DOTA_TEAM_CUSTOM_1] = 0,
}
NinpouGameRules.playerScore = {}

-- Get the real name of a team 
function NinpouGameRules:GetRealTeamName(teamNumber)
	if teamNumber == DOTA_TEAM_GOODGUYS then 
		return "Konohagakure"
	elseif teamNumber == DOTA_TEAM_BADGUYS then 
		return "Otogakure"
	elseif teamNumber == DOTA_TEAM_CUSTOM_1 then 
		return "Akatsuki"
	end
end

-- Check if an entity is a team base 
function NinpouGameRules:IsBase(unit)
	return unit:GetUnitName() == "npc_konoha_base_unit" or unit:GetUnitName() == "npc_oto_base_unit" or unit:GetUnitName() == "npc_akatsuki_base_unit"
end

-- Kill the team base, defeating it 
function NinpouGameRules:KillBase(teamNumber)
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _, unit in pairs(units) do 
		-- Kill the team base 
		if NinpouGameRules:IsBase(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:ForceKill(true)
		end
	end
end 
	
-- Check for empty teams and defeat them 
function NinpouGameRules:CheckEmptyTeams()
	local countPlayers = {}
	countPlayers[DOTA_TEAM_GOODGUYS] = 0
	countPlayers[DOTA_TEAM_BADGUYS] = 0 
	countPlayers[DOTA_TEAM_CUSTOM_1] = 0
	for i = 0, DOTA_MAX_TEAM_PLAYERS do 
		if PlayerResource:IsValidPlayerID(i) then 
			local player = PlayerResource:GetPlayer(i)
			countPlayers[player:GetTeamNumber()] = (countPlayers[player:GetTeamNumber()] or 0) + 1
		end
	end
	-- Only remove teams if not on single player mode 
	if countPlayers[DOTA_TEAM_GOODGUYS] + countPlayers[DOTA_TEAM_BADGUYS] + countPlayers[DOTA_TEAM_CUSTOM_1] > 1 then 
		print("[GENERAL] Found " .. tostring(countPlayers[DOTA_TEAM_GOODGUYS]) .. " players for Team #" .. tostring(DOTA_TEAM_GOODGUYS) .. "...")
		print("[GENERAL] Found " .. tostring(countPlayers[DOTA_TEAM_BADGUYS]) .. " players for Team #" .. tostring(DOTA_TEAM_BADGUYS) .. "...")
		print("[GENERAL] Found " .. tostring(countPlayers[DOTA_TEAM_CUSTOM_1]) .. " players for Team #" .. tostring(DOTA_TEAM_CUSTOM_1) .. "...")
		-- Defeat teams from which there is no player 
		for team, numPlayers in pairs(countPlayers) do 
			if numPlayers == 0 then 
				NinpouGameRules:KillBase(team)
			end
		end
	end
end

-- Check victory conditions and return, if true, the base of winner team  
function NinpouGameRules:CheckVictoryConditions()
	local countAliveBases = 0
	local winnerBase = nil
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _, unit in pairs(units) do 
		if Units:IsValidAlive(unit) and NinpouGameRules:IsBase(unit) then 
			countAliveBases = countAliveBases + 1 
			winnerBase = unit
		end
	end
	if countAliveBases == 1 then 
		return winnerBase
	end
end

-- Win actions 
function NinpouGameRules:WinActions(winnerTeamNumber, winnerBase)
	-- Send winning message 
	GameRules:SetCustomVictoryMessage(NinpouGameRules:GetRealTeamName(winnerTeamNumber) .. " victory!")
	GameRules:SendCustomMessage(NinpouGameRules:GetRealTeamName(winnerTeamNumber) .. " won the ninja war.", 0, 0)
	-- Set team as winner 
	GameRules:SetGameWinner(winnerTeamNumber)
end 

-- Remove all units (except heroes) from a team 
function NinpouGameRules:RemoveAllUnits(teamNumber)
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _, unit in pairs(units) do 
		if Units:IsValidAlive(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:RemoveSelf()
		end
	end
	units = Entities:FindAllByClassname("ent_dota_fountain")
	for _, unit in pairs(units) do 
		if Units:IsValidAlive(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:RemoveSelf() 
		end 
	end
end 

-- Disable the players of a team, preventing them interfering the game 
function NinpouGameRules:DisablePlayers(teamNumber)
	local defeatSpot = Entities:FindByName(nil, "defeat_spot"):GetAbsOrigin()
	for i = 0, DOTA_MAX_TEAM_PLAYERS do 
		if PlayerResource:IsValidPlayerID(i) then 
			local player = PlayerResource:GetPlayer(i)
			if player:GetTeamNumber() == teamNumber then 
				local hero = PlayerResource:GetSelectedHeroEntity(i)
				-- Move hero to defeat spot and turn it to command disabled
				if hero ~= nil and IsValidEntity(hero) then 
					hero:RespawnHero(false, false, false) 
					FindClearSpaceForUnit(hero, defeatSpot, true)
					hero:AddAbility("hide_hero")
					local ability = hero:FindAbilityByName("hide_hero")
					ability:UpgradeAbility(true)
					hero:SetAbilityPoints(0)
				end
			end
		end
	end 
end 

-- Defeat a team 
function NinpouGameRules:DefeatTeam(teamNumber)
	if not NinpouGameRules.defeatedTeams[teamNumber] then 
		NinpouGameRules.defeatedTeams[teamNumber] = true
		print("[GENERAL] Team #" .. tostring(teamNumber) .. " was defeated.")
		-- Send defeat message 
		GameRules:SendCustomMessage(NinpouGameRules:GetRealTeamName(teamNumber) .. " was defeated.", 0, 0)
		-- Remove units 
		NinpouGameRules:RemoveAllUnits(teamNumber)
		-- Hide players' heroes
		NinpouGameRules:DisablePlayers(teamNumber)
		-- Check victory conditions 
		local winnerBase = NinpouGameRules:CheckVictoryConditions()
		if winnerBase then 
			local winnerTeamNumber = winnerBase:GetTeamNumber()
			print("[GENERAL] Winner team: " .. tostring(winnerTeamNumber))
			NinpouGameRules:WinActions(winnerTeamNumber, winnerBase)
		end
	end
end

-- Set game settings 
function NinpouGameRules:SetSetting(settings)
	NinpouGameRules.settings = settings
end 

-- Update score 
function NinpouGameRules:UpdateScore(playerID, score) 
	local team = PlayerResource:GetTeam(playerID)
	NinpouGameRules.teamScore[team] = (NinpouGameRules.teamScore[team] or 0) + score 
	NinpouGameRules.playerScore[playerID] = (NinpouGameRules.playerScore[playerID] or 0) + score
	local score_event = {
		team_id = team,
		team_score = NinpouGameRules.teamScore[team],
	}
	DebugPrint("team: " .. team .. " score: " .. score_event.team_score)
	CustomGameEventManager:Send_ServerToAllClients("score_change", score_event)
end 