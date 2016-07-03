--[[
	Author: PicoleDeLimao
	Date: 01.13.2016
	This script defines custom commands to help to debug or perform some trick
]]

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
