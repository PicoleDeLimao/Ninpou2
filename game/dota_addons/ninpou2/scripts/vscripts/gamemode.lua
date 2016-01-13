-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false 

if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  -- Set player gold to zero
  hero:SetGold(0, false)
end
                  
-- Spawn creeps for a determined lane
function SpawnCreepsLane(units, unitsCount, offsets, path, team, spawnerName)
	local spawner = Entities:FindByName(nil, spawnerName)
	if Utils:IsValidAlive(spawner) then -- Only spawn units from which spawner is alive
		local forwardVector = (path[2] - path[1]):Normalized()
		for unitKey, unitValue in pairs(units) do 
            for i = 1, unitsCount[unitKey] do 
				Timers:CreateTimer(function()
					-- Create unit at forward vector between origin spot and next spot (in order to spawn them in correct order)
					local unit = CreateUnitByName(unitValue, path[1] + forwardVector * offsets[unitKey], true, nil, nil, team)
					for j = 2, #path do 
						ExecuteOrderFromTable({
							UnitIndex = unit:GetEntityIndex(),
							OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
							Position = path[j],
							Queue = true
						})
					end
				end)
			end
		end
	end
end

-- Spawn creeps for the whole map
function SpawnCreeps(count)
    -- Getting info points 
    local konohaLeftLane     = Entities:FindByName(nil, "spawn_konoha_left_lane"):GetAbsOrigin()
    local konohaRightLane    = Entities:FindByName(nil, "spawn_konoha_right_lane"):GetAbsOrigin()
    local konohaMidLane      = Entities:FindByName(nil, "spawn_konoha_mid_lane"):GetAbsOrigin()
    local otoLeftLane        = Entities:FindByName(nil, "spawn_oto_left_lane"):GetAbsOrigin()
    local otoRightLane       = Entities:FindByName(nil, "spawn_oto_right_lane"):GetAbsOrigin()
    local otoMidLane         = Entities:FindByName(nil, "spawn_oto_mid_lane"):GetAbsOrigin()
    local akatsukiLeftLane   = Entities:FindByName(nil, "spawn_akatsuki_left_lane"):GetAbsOrigin()
    local akatsukiRightLane  = Entities:FindByName(nil, "spawn_akatsuki_right_lane"):GetAbsOrigin()
    local akatsukiMidLane    = Entities:FindByName(nil, "spawn_akatsuki_mid_lane"):GetAbsOrigin()
    local midLane            = Entities:FindByName(nil, "spawn_mid_lane"):GetAbsOrigin()
    -- Define the path for which the units will walk 
    local konohaLeftLanePath    = {konohaLeftLane, otoLeftLane, otoMidLane, otoRightLane, akatsukiRightLane, akatsukiMidLane, akatsukiLeftLane, konohaRightLane, konohaMidLane, konohaLeftLane}
    local konohaRightLanePath   = {konohaRightLane, akatsukiLeftLane, akatsukiMidLane, akatsukiRightLane, otoRightLane, otoMidLane, otoLeftLane, konohaLeftLane, konohaMidLane, konohaRightLane}
    local konohaMidLanePath     = {konohaMidLane, midLane, otoMidLane, otoRightLane, akatsukiRightLane, akatsukiMidLane, akatsukiLeftLane, konohaLeftLane, konohaMidLane}
    local otoLeftLanePath       = {otoLeftLane, konohaLeftLane, konohaMidLane, konohaRightLane, akatsukiLeftLane, akatsukiMidLane, akatsukiRightLane, otoRightLane, otoMidLane, otoLeftLane}
    local otoRightLanePath      = {otoRightLane, akatsukiRightLane, akatsukiMidLane, akatsukiLeftLane, konohaRightLane, konohaMidLane, konohaLeftLane, otoLeftLane, otoMidLane, otoRightLane}
    local otoMidLanePath        = {otoMidLane, midLane, akatsukiMidLane, akatsukiLeftLane, konohaRightLane, konohaMidLane, konohaLeftLane, otoLeftLane, otoMidLane}
    local akatsukiLeftLanePath  = {akatsukiLeftLane, konohaRightLane, konohaMidLane, konohaLeftLane, otoLeftLane, otoMidLane, otoRightLane, akatsukiRightLane, akatsukiMidLane, akatsukiLeftLane}
    local akatsukiRightLanePath = {akatsukiRightLane, otoRightLane, otoMidLane, otoLeftLane, konohaLeftLane, konohaMidLane, konohaRightLane, akatsukiLeftLane, akatsukiMidLane, akatsukiRightLane}
    local akatsukiMidLanePath   = {akatsukiMidLane, midLane, konohaMidLane, konohaLeftLane, otoLeftLane, otoMidLane, otoRightLane, akatsukiRightLane, akatsukiMidLane}
	-- Load units definition from keyvalue file
	local kv = LoadKeyValues("scripts/kv/units_spawn.kv")
	local frequency = kv.Frequency
	local spawnCountSide = kv.SideLaneSpawnCount
	for unitKey, unitValue in pairs(spawnCountSide) do 
		spawnCountSide[unitKey] = math.fmod(count, tonumber(frequency[unitKey])) == 0 and tonumber(spawnCountSide[unitKey]) or 0
	end
	local spawnCountMid = kv.MidLaneSpawnCount
	for unitKey, unitValue in pairs(spawnCountMid) do 
		spawnCountMid[unitKey] = math.fmod(count, tonumber(frequency[unitKey])) == 0 and tonumber(spawnCountMid[unitKey]) or 0 
	end
	-- Spawn creeps 
    SpawnCreepsLane(kv.Konoha, spawnCountSide, kv.Offsets, konohaLeftLanePath, DOTA_TEAM_GOODGUYS, "konoha_academy_left")
    SpawnCreepsLane(kv.Konoha, spawnCountSide, kv.Offsets, konohaRightLanePath, DOTA_TEAM_GOODGUYS, "konoha_academy_right")
    SpawnCreepsLane(kv.Konoha, spawnCountMid, kv.Offsets, konohaMidLanePath, DOTA_TEAM_GOODGUYS, "konoha_base")
    SpawnCreepsLane(kv.Oto, spawnCountSide, kv.Offsets, otoLeftLanePath, DOTA_TEAM_BADGUYS, "oto_academy_left")
    SpawnCreepsLane(kv.Oto, spawnCountSide, kv.Offsets, otoRightLanePath, DOTA_TEAM_BADGUYS, "oto_academy_right")
    SpawnCreepsLane(kv.Oto, spawnCountMid, kv.Offsets, otoMidLanePath, DOTA_TEAM_BADGUYS, "oto_base")
    SpawnCreepsLane(kv.Akatsuki, spawnCountSide, kv.Offsets, akatsukiLeftLanePath, DOTA_TEAM_CUSTOM_1, "akatsuki_academy_left")
    SpawnCreepsLane(kv.Akatsuki, spawnCountSide, kv.Offsets, akatsukiRightLanePath, DOTA_TEAM_CUSTOM_1, "akatsuki_academy_right")
    SpawnCreepsLane(kv.Akatsuki, spawnCountMid, kv.Offsets, akatsukiMidLanePath, DOTA_TEAM_CUSTOM_1, "akatsuki_base")
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  local repeatInterval = 30    -- Return this timer every few seconds in game-time 
  local startAfter     = 0.05  -- Start this timer after few seconds 
  local count          = 0     -- Count how much spawn cycles were ran 
  DebugPrint("[BAREBONES] The game has officially begun")
  Timers:CreateTimer(startAfter, 
    function()
      SpawnCreeps(count)
      count = count + 1
      return repeatInterval 
    end)
end

-- Initialize AI behavior for pre defined units 
function StartAI() 
  local units = Entities:FindAllByClassname("npc_dota_creature")
  for _, unit in pairs(units) do 
    -- Start AI for Elite Anbus
    if unit:GetUnitName() == "npc_elite_anbu_unit" then 
        EliteAnbuAI:Start(unit)
	elseif unit:GetUnitName() == "npc_elite_anbu_leader_unit" then 
		EliteAnbuLeaderAI:Start(unit)
    end
  end
end

-- This command increases hero health to infinite
function GameMode:GodCommandOn()
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
function GameMode:GodCommandOff()
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
function GameMode:DefeatTeamKonohaCommand() 
	print("[CHEATS] Defeating Konohagakure team")
	NinpouGameRules:DefeatTeam(DOTA_TEAM_GOODGUYS)
end

-- Defeat the Otogakure Team
function GameMode:DefeatTeamOtoCommand() 
	print("[CHEATS] Defeating Otogakure team")
	NinpouGameRules:DefeatTeam(DOTA_TEAM_BADGUYS)
end

-- Defeat the Akatsuki Team
function GameMode:DefeatTeamAkatsukiCommand() 
	print("[CHEATS] Defeating Akatsuki team")
	NinpouGameRules:DefeatTeam(DOTA_TEAM_CUSTOM_1)
end

-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/gamemode to see/modify the exact code
  GameMode:_InitGameMode()

  -- Start AI Behavior for pre defined units
  StartAI()
  
  Timers:CreateTimer(5, function()
	-- Check if there is any empty team 
	NinpouGameRules:CheckEmptyTeams()
  end)
  
  -- Register commands 
  Convars:RegisterCommand("godon", Dynamic_Wrap(GameMode, 'GodCommandOn'), "Increases hero health to infinite", FCVAR_CHEAT)
  Convars:RegisterCommand("godoff", Dynamic_Wrap(GameMode, 'GodCommandOff'), "Disables god mode", FCVAR_CHEAT)
  Convars:RegisterCommand("defeatkonoha", Dynamic_Wrap(GameMode, 'DefeatTeamKonohaCommand'), "Defeat the Konohagakure team", FCVAR_CHEAT)
  Convars:RegisterCommand("defeatoto", Dynamic_Wrap(GameMode, 'DefeatTeamOtoCommand'), "Defeat the Otogakure team", FCVAR_CHEAT)
  Convars:RegisterCommand("defeatakatsuki", Dynamic_Wrap(GameMode, 'DefeatTeamAkatsukiCommand'), "Defeat the Akatsuki team", FCVAR_CHEAT)
end