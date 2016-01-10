-- This file contains all barebones-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the GameMode:_Function calls in these events as it will mess with the internal barebones systems.

-- Contains list of models associated to each hero
require('model_list')

-- Cleanup a player when they leave
function GameMode:OnDisconnect(keys)
  DebugPrint('[BAREBONES] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function GameMode:OnGameRulesStateChange(keys)
  DebugPrint("[BAREBONES] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- Remove heroes cosmetics
function RemoveCosmetics(hero) 
  Timers:CreateTimer(0.05, function()
      -- Setup variables
      local model_name = ""

      -- Check if npc is hero
      if not IsValidEntity(hero) or not hero:IsHero() then return end

      -- Getting model name
      if model_lookup[ hero:GetName() ] ~= nil and hero:GetModelName() ~= model_lookup[ hero:GetName() ] then
        model_name = model_lookup[ hero:GetName() ]
      else
        return nil
      end

      -- Check if it's correct format
      if hero:GetModelName() ~= "models/development/invisiblebox.vmdl" then return nil end

      -- Never got changed before
      local toRemove = {}
      local wearable = hero:FirstMoveChild()
      while wearable ~= nil do
        if wearable:GetClassname() == "dota_item_wearable" then
          table.insert( toRemove, wearable )
        end
        wearable = wearable:NextMovePeer()
      end

      -- Remove wearables
      for k, v in pairs( toRemove ) do
        v:SetModel( "models/development/invisiblebox.vmdl" )
        v:RemoveSelf()
      end

      -- Set model
      hero:SetModel( model_name )
      hero:SetOriginalModel( model_name )
      hero:MoveToPosition( hero:GetAbsOrigin() )
	  hero:RespawnHero(false,false,false) 

      return nil
    end
  )
end

-- An NPC has spawned somewhere in game.  This includes heroes
function GameMode:OnNPCSpawned(keys)
  DebugPrint("[BAREBONES] NPC Spawned")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main barebones functions
  GameMode:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
  -- Initialize AI behavior for medical ninjas
  Timers:CreateTimer(0.05, function() 
	  if IsValidEntity(npc) and npc:GetUnitName() == "npc_medical_ninja_unit" then 
		MedicalNinjaAI:Start(npc)
	  end
  end)
  RemoveCosmetics(npc)
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function GameMode:OnEntityHurt(keys)
  --DebugPrint("[BAREBONES] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function GameMode:OnItemPickedUp(keys)
  DebugPrint( '[BAREBONES] OnItemPickedUp' )
  DebugPrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function GameMode:OnPlayerReconnect(keys)
  DebugPrint( '[BAREBONES] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function GameMode:OnItemPurchased( keys )
  DebugPrint( '[BAREBONES] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
function GameMode:OnAbilityUsed(keys)
  DebugPrint('[BAREBONES] AbilityUsed')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function GameMode:OnNonPlayerUsedAbility(keys)
  DebugPrint('[BAREBONES] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
end

-- A player changed their name
function GameMode:OnPlayerChangedName(keys)
  DebugPrint('[BAREBONES] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function GameMode:OnPlayerLearnedAbility( keys)
  DebugPrint('[BAREBONES] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function GameMode:OnAbilityChannelFinished(keys)
  DebugPrint('[BAREBONES] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function GameMode:OnPlayerLevelUp(keys)
  DebugPrint('[BAREBONES] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function GameMode:OnLastHit(keys)
  DebugPrint('[BAREBONES] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function GameMode:OnTreeCut(keys)
  DebugPrint('[BAREBONES] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function GameMode:OnRuneActivated (keys)
  DebugPrint('[BAREBONES] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function GameMode:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[BAREBONES] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  DebugPrint('[BAREBONES] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  DebugPrint('[BAREBONES] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- Get the real name of a team 
function GetRealTeamName(teamNumber)
	if teamNumber == DOTA_TEAM_GOODGUYS then 
		return "Konohagakure"
	elseif teamNumber == DOTA_TEAM_BADGUYS then 
		return "Otogakure"
	elseif teamNumber == DOTA_TEAM_CUSTOM_1 then 
		return "Akatsuki"
	end
end

-- Defeat a team 
function DefeatTeam(teamNumber)
	print("[GENERAL] Team #" .. tostring(teamNumber) .. " was defeated.")
	-- Increment number of defeated teams 
	GameRules.defeatedTeams = GameRules.defeatedTeams and GameRules.defeatedTeams + 1 or 1
	-- Send defeat message 
	GameRules:SendCustomMessage(GetRealTeamName(teamNumber) .. " was defeated.", 0, 0)
	-- Remove units 
	local units = Entities:FindAllByClassname("npc_dota_creature")
	for _, unit in pairs(units) do 
		if Utils:IsValidAlive(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:RemoveSelf()
		end
	end
	units = Entities:FindAllByClassname("npc_dota_tower")
	for _, unit in pairs(units) do 
		if Utils:IsValidAlive(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:ForceKill(true)
		end 
	end
	units = Entities:FindAllByClassname("npc_dota_barracks")
	for _, unit in pairs(units) do 
		if Utils:IsValidAlive(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:ForceKill(true)
		end
	end
	units = Entities:FindAllByClassname("ent_dota_fountain")
	for _, unit in pairs(units) do 
		if Utils:IsValidAlive(unit) and unit:GetTeamNumber() == teamNumber then 
			unit:RemoveSelf() 
		end 
	end
	-- Hide players' heroes
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

-- Check which team is the winner 
function GetWinnerTeamNumber()
	local units = Entities:FindAllByClassname("npc_dota_tower")
	for _, unit in pairs(units) do 
		if Utils:IsValidAlive(unit) then 
			if unit:GetUnitName() == "npc_konoha_base_unit" or unit:GetUnitName() == "npc_oto_base_unit" or unit:GetUnitName() == "npc_akatsuki_base_unit" then 
				return unit:GetTeamNumber()
			end
		end
	end
end

-- An entity died
function GameMode:OnEntityKilled( keys )
	DebugPrint( '[BAREBONES] OnEntityKilled Called' )
	DebugPrintTable( keys )

	GameMode:_OnEntityKilled( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
	killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end

	-- The ability/item used to kill, or nil if not killed by an item/ability
	local killerAbility = nil

	if keys.entindex_inflictor ~= nil then
	killerAbility = EntIndexToHScript( keys.entindex_inflictor )
	end

	local damagebits = keys.damagebits -- This might always be 0 and therefore useless

	-- Put code here to handle when an entity gets killed
	-- A base was destroyed
	if killedUnit:GetUnitName() == "npc_konoha_base_unit" or killedUnit:GetUnitName() == "npc_oto_base_unit" or killedUnit:GetUnitName() == "npc_akatsuki_base_unit" then 
		-- Display destruction particle 
		local particle = ParticleManager:CreateParticle("particles/radiant_fx2/good_ancient001_znight_endcap.vpcf", PATTACH_CUSTOMORIGIN, killedUnit)
		ParticleManager:SetParticleControl(particle, 0, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 2, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 7, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 10, Vector(500, 500, 500))
		Timers:CreateTimer(2.0, function()
			killedUnit:EmitSound("Building_DireTower.Destruction")
			killedUnit:AddNoDraw()
		end)
		-- Defeat team 
		DefeatTeam(killedUnit:GetTeamNumber())
		-- Check victory conditions 
		if GameRules.defeatedTeams == 2 then 
			local winnerTeamNumber = GetWinnerTeamNumber()
			print("[GENERAL] Winner team: " .. tostring(winnerTeamNumber))
			-- Send winning message 
			GameRules:SendCustomMessage(GetRealTeamName(winnerTeamNumber) .. " won the ninja war.", 0, 0)
			-- Set team as winner 
			GameRules:SetGameWinner(winnerTeamNumber)
		end
	end
	-- Show proper death animation for buildings 
	if killedUnit:GetClassname() == "npc_dota_tower" or killedUnit:GetClassname() == "npc_dota_barracks" and killedUnit:GetUnitName() ~= "npc_konoha_base_unit" and killedUnit:GetUnitName() ~= "npc_oto_base_unit" and killedUnit:GetUnitName() ~= "npc_akatsuki_base_unit" then 
		local particle1 = ParticleManager:CreateParticle("particles/siege_fx/siege_good_death_01.vpcf", PATTACH_CUSTOMORIGIN, killedUnit)
		ParticleManager:SetParticleControl(particle1, 0, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControlOrientation(particle1, 1, Vector(100, 0, 0), Vector(0, 0, 0), Vector(0, 0, 100))
		local particle2 = ParticleManager:CreateParticle("particles/radiant_fx/tower_good3_destroy_lvl3.vpcf", PATTACH_CUSTOMORIGIN, killedUnit)
		ParticleManager:SetParticleControl(particle2, 0, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle2, 1, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle2, 3, killedUnit:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle2, 7, Vector(300, 300, 300))
		ParticleManager:SetParticleControl(particle2, 8, killedUnit:GetAbsOrigin())
		killedUnit:EmitSound("Building_DireTower.Destruction")
		killedUnit:AddNoDraw()
	end
	-- Kuchiyoses don't display corpses nor death animation
	if killedUnit.is_kuchiyose then 
		killedUnit:AddNoDraw()
	end
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  DebugPrint('[BAREBONES] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function GameMode:OnConnectFull(keys)
  DebugPrint('[BAREBONES] OnConnectFull')
  DebugPrintTable(keys)

  GameMode:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function GameMode:OnIllusionsCreated(keys)
  DebugPrint('[BAREBONES] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function GameMode:OnItemCombined(keys)
  DebugPrint('[BAREBONES] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function GameMode:OnAbilityCastBegins(keys)
  DebugPrint('[BAREBONES] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function GameMode:OnTowerKill(keys)
  DebugPrint('[BAREBONES] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function GameMode:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[BAREBONES] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function GameMode:OnNPCGoalReached(keys)
  DebugPrint('[BAREBONES] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function GameMode:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = self.vUserIds[userID]:GetPlayerID()

  local text = keys.text
end