--[[
	Author: PicoleDeLimao
	Date: 01.13.2016
	This script defines custom commands to help to debug or perform some trick
]]

CHEAT_CODES = {

}

DEBUG_CODES = {
	["testduel"] = function(playerID, hero)
		local duelInviterPos = Entities:FindByName(nil, "duel_inviter"):GetAbsOrigin()
		local duelReceiverPos = Entities:FindByName(nil, "duel_receiver"):GetAbsOrigin()
		local inviterPlayer = PlayerResource:GetPlayer(playerID)
		local inviterHero = inviterPlayer:GetAssignedHero()
		inviterHero:SetAbsOrigin(duelInviterPos)
		inviterHero:SetForwardVector((duelReceiverPos - duelInviterPos):Normalized())
		local unit = CreateUnitByName("npc_dota_hero_dark_seer", duelReceiverPos, false, nil, nil, DOTA_TEAM_NEUTRALS)
		for i = 1, 50 do 
			unit:HeroLevelUp(false)
		end
		unit:SetForwardVector((duelInviterPos - duelReceiverPos):Normalized())
		unit:SetRespawnsDisabled(true)
	end
}

PLAYER_CODES = {

}

Commands = {}

-- This command increases hero health to infinite
function Commands:GodCommandOn()
  print("[CHEATS] Enabling God Mode")
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 and PlayerResource:GetSelectedHeroEntity(playerID) ~= nil then
	  cmdPlayer.godMode = true 
      Timers:CreateTimer(0.05, function()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		if hero == nil or not cmdPlayer.godMode then 
			return nil 
		end
		hero:SetHealth(hero:GetMaxHealth())
		return 0.05
	  end)
    end
  end
end

-- Disable god mode command 
function Commands:GodCommandOff()
  print("[CHEATS] Disabling God Mode")
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      cmdPlayer.godMode = false
    end
  end
end

-- Defeat the Konohagakure Team
function Commands:DefeatTeamKonohaCommand() 
	print("[CHEATS] Defeating Konohagakure team")
	NinpouGameRules:DefeatTeam(DOTA_TEAM_GOODGUYS)
end

-- Defeat the Otogakure Team
function Commands:DefeatTeamOtoCommand() 
	print("[CHEATS] Defeating Otogakure team")
	NinpouGameRules:DefeatTeam(DOTA_TEAM_BADGUYS)
end

-- Defeat the Akatsuki Team
function Commands:DefeatTeamAkatsukiCommand() 
	print("[CHEATS] Defeating Akatsuki team")
	NinpouGameRules:DefeatTeam(DOTA_TEAM_CUSTOM_1)
end

-- Spawn the Juubi
function Commands:SpawnJuubiCommand()
	print("[CHEATS] Spawning Juubi")
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer then
		local playerID = cmdPlayer:GetPlayerID()
		local hero = PlayerResource:GetSelectedHeroEntity(playerID)
		local juubi = CreateUnitByName('npc_juubi_unit', hero:GetAbsOrigin(), true, hero, hero, hero:GetTeamNumber())
		JuubiAI:Start(juubi)
	end
end

-- Enable debug mode 
function Commands:EnableDebugMode()
	print("[CHEATS] Debug mode enabled")
	Commands.DEBUG = true
end

function Commands:split(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function GameMode:OnPlayerChat(keys)
	local teamonly = keys.teamonly
	local userID = keys.userid
	local playerID = self.vUserIds[userID]:GetPlayerID()
  
	local text = keys.text
  
	if string.sub(text, 1, 1) == '-' then 
		text = string.sub(text, 2, string.len(text))
	end
  
	local input = Commands:split(text, ' ')
	local command = input[1]
	if CHEAT_CODES[command] then 
		if Commands.DEBUG then
			print("[CHEATS] " .. text)
			CHEAT_CODES[command](playerID, input[2])
		end
	elseif DEBUG_CODES[command] then 
		if Commands.DEBUG then
			print("[DEBUG] " .. text)
			DEBUG_CODES[command](playerID, input[2])
		end
	elseif PLAYER_CODES[command] then 
		PLAYER_CODES[command](playerID, input[2])
	end
end