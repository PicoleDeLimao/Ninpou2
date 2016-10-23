--[[
	Author: PicoleDeLiamo
	Date: 04.01.2016
	Define some units wrapper functions 
]]
LinkLuaModifier("modifier_pause", "modifiers/modifier_pause", LUA_MODIFIER_MOTION_NONE)

if not Units then
	Units = class({})
end

-- Check if unit is valid and alive 
function Units:IsValidAlive(unit)
    return unit ~= nil and IsValidEntity(unit) and unit:IsAlive()
end

-- Check if unit is disabled 
function Units:IsDisabled(unit)
	return unit:IsMuted() or unit:IsSilenced() or unit:IsStunned()
end

-- Check if unit can cast an ability
function Units:CanCast(unit, ability)
	return not Units:IsDisabled(unit) and unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1) and ability:GetCooldownTimeRemaining() == 0
end

-- Check if unit is a hero 
function Units:IsHero(unit)
	return unit:IsHero()
end

-- Check if unit is a building 
function Units:IsBuilding(unit)
	return unit:HasModifier("modifier_is_building")
end

-- Pause an unit 
function Units:Pause(unit)
	unit:AddNewModifier(unit, nil, "modifier_pause", {})
end

-- Unpause an unit 
function Units:Unpause(unit)
	unit:RemoveModifierByName("modifier_pause")
end

-- Damage an unit 
function Units:Damage(damager, damaged, damage, damageType, trueDamageType)
	local trueDamage = nil
	trueDamageType = trueDamageType or DAMAGE_TYPE_MAGICAL
	if damageType == "katon" then
		trueDamage = damage * (100 + (damager.katonDmg or 0) - (damaged.katonDef or 0)) / 100.0
	elseif damageType == "suiton" then
		trueDamage = damage * (100 + (damager.suitonDmg or 0) - (damaged.suitonDef or 0)) / 100.0
	elseif damageType == "doton" then
		trueDamage = damage * (100 + (damager.dotonDmg or 0) - (damaged.dotonDef or 0)) / 100.0
	elseif damageType == "fuuton" then
		trueDamage = damage * (100 + (damager.fuutonDmg or 0) - (damaged.fuutonDef or 0)) / 100.0
	elseif damageType == "raiton" then
		trueDamage = damage * (100 + (damager.raitonDmg or 0) - (damaged.raitonDef or 0)) / 100.0
	elseif damageType == "yin" then
		trueDamage = damage * (100 + (damager.yinDmg or 0) - (damaged.yinDef or 0)) / 100.0
	elseif damageType == "yang" then
		trueDamage = damage * (100 + (damager.yangDmg or 0) - (damaged.yangDef or 0)) / 100.0
	end
	if Units:IsBuilding(damaged) and trueDamageType == DAMAGE_TYPE_MAGICAL then 
		trueDamageType = DAMAGE_TYPE_PHYSICAL
	end
	ApplyDamage({ victim = damaged, attacker = damager, damage = trueDamage, damage_type = trueDamageType})
end

-- Get the nearest hero to an unit inside a group of units 
function Units:GetNearestHero(units, toUnit)
	local nearestHero = nil 
	for _, unit in pairs(units) do 
		if unit ~= nil and unit:IsRealHero() then 
			local distance = toUnit:GetRangeToUnit(unit)
			if nearestHero == nil or distance < nearestHero.distance then 
				nearestHero = {
					['unit'] = unit, 
					['distance'] = distance
				}
			end
		end
	end
	return nearestHero ~= nil and nearestHero.unit or nil
end

-- Create a summon for the unit
function Units:CreateSummon(caster, unitName, position, duration)
	local unit = CreateUnitByName(unitName, position, true, caster, caster, caster:GetTeamNumber())
	unit:SetForwardVector(caster:GetForwardVector())
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:AddNewModifier(caster, nil, "modifier_kill", {duration=duration})
	unit:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})
	unit:AddNewModifier(caster, nil, "modifier_summoned", {})
	return unit
end

-- Create an illusion of the caster 
function Units:CreateBunshin(caster, ability, duration)
	-- Get a random position around the caster 
	local origin = caster:GetAbsOrigin() + caster:GetForwardVector() * 150
	-- Create a new bunshin 
	local bunshin = CreateUnitByName(caster:GetUnitName(), origin, true, caster, nil, caster:GetTeamNumber())
	bunshin:SetPlayerID(caster:GetPlayerID())
	bunshin:SetControllableByPlayer(caster:GetPlayerID(), true)
	-- Level up bunshin to caster level 
	for j = 1, caster:GetLevel() - 1 do 
		bunshin:HeroLevelUp(false)
	end 
	-- Set the skill points to 0 and learn the skills of the caster 
	bunshin:SetAbilityPoints(0)
	for j = 0, 15 do 
		local casterAbility = caster:GetAbilityByIndex(j)
		if casterAbility ~= nil then 
			local abilityLevel = casterAbility:GetLevel()
			local abilityName = casterAbility:GetAbilityName()
			local bunshinAbility = bunshin:FindAbilityByName(abilityName)
			bunshinAbility:SetLevel(abilityLevel)
		end
	end
	-- Recreate items of the caster 
	for j = 0, 5 do 
		local item = caster:GetItemInSlot(j)
		if item ~= nil then 
			local itemName = item:GetName()
			local newItem = CreateItem(itemName, bunshin, bunshin)
			bunshin:AddItem(newItem)
		end
	end
	-- Set the bunshin as illusion
	bunshin:AddNewModifier(caster, ability, "modifier_illusion", {duration = duration, outgoing_damage = 100, incoming_damage = 10000})
	bunshin:MakeIllusion()
	-- Show smoke effects and sound 
	bunshin:EmitSound("Poof")
	ParticleManager:CreateParticle("particles/econ/items/invoker/invoker_apex/invoker_sun_strike_orange_smoke_immortal1.vpcf", PATTACH_ABSORIGIN, bunshin)
	local lastOrigin = bunshin:GetAbsOrigin()
	Timers:CreateTimer(0.1, function() 
		if not Units:IsValidAlive(bunshin) then 
			local dummy = CreateUnitByName("npc_dummy_unit", lastOrigin, false, caster, nil, caster:GetTeamNumber())
			dummy:EmitSound("Poof")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_sphere_final_explosion_smoke.vpcf", PATTACH_CUSTOMORIGIN, dummy)
			ParticleManager:SetParticleControl(particle, 0, lastOrigin)
			ParticleManager:SetParticleControl(particle, 3, lastOrigin)
			Timers:CreateTimer(2.0, function() 
				if Units:IsValidAlive(dummy) then
					dummy:ForceKill(true)
				end
			end)
			return nil
		end
		lastOrigin = bunshin:GetAbsOrigin()
		if not Units:IsValidAlive(caster) then 
			bunshin:ForceKill(true)
		end
		return 0.1 
	end)
end

-- Find all enemies within range 
function Units:FindEnemiesInRange(params)
	local unit = params.unit 
	local point = params.point or unit:GetAbsOrigin() 
	local radius = params.radius 
	local target_type = params.target_type or DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = params.flags or 0
	local includeBuildings = params.includeBuildings or true
	if includeBuildings then 
		flags = flags + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	end
	local callback = params.func
	local enemies = FindUnitsInRadius(unit:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
	if callback then 
		for _, enemy in pairs(enemies) do 
			callback(enemy)
		end
	end
	return enemies
end

-- Find all allies within range 
function Units:FindAlliesInRange(params)
	local unit = params.unit 
	local point = params.point or unit:GetAbsOrigin() 
	local radius = params.radius 
	local target_type = params.target_type or DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = params.flags or DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
	local callback = params.func
	local allies = FindUnitsInRadius(unit:GetTeamNumber(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
	if callback then 
		for _, enemy in pairs(allies) do 
			callback(enemy)
		end
	end
	return allies
end

-- Spawn creeps for a determined lane
function Units:SpawnCreepsLane(units, unitsCount, offsets, path, team, spawnerName)
	local spawner = Entities:FindByName(nil, spawnerName)
	if Units:IsValidAlive(spawner) then -- Only spawn units from which spawner is alive
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
function Units:SpawnCreeps(count)
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
    Units:SpawnCreepsLane(kv.Konoha, spawnCountSide, kv.Offsets, konohaLeftLanePath, DOTA_TEAM_GOODGUYS, "konoha_academy_left")
    Units:SpawnCreepsLane(kv.Konoha, spawnCountSide, kv.Offsets, konohaRightLanePath, DOTA_TEAM_GOODGUYS, "konoha_academy_right")
    Units:SpawnCreepsLane(kv.Konoha, spawnCountMid, kv.Offsets, konohaMidLanePath, DOTA_TEAM_GOODGUYS, "konoha_base")
    Units:SpawnCreepsLane(kv.Oto, spawnCountSide, kv.Offsets, otoLeftLanePath, DOTA_TEAM_BADGUYS, "oto_academy_left")
    Units:SpawnCreepsLane(kv.Oto, spawnCountSide, kv.Offsets, otoRightLanePath, DOTA_TEAM_BADGUYS, "oto_academy_right")
    Units:SpawnCreepsLane(kv.Oto, spawnCountMid, kv.Offsets, otoMidLanePath, DOTA_TEAM_BADGUYS, "oto_base")
    Units:SpawnCreepsLane(kv.Akatsuki, spawnCountSide, kv.Offsets, akatsukiLeftLanePath, DOTA_TEAM_CUSTOM_1, "akatsuki_academy_left")
    Units:SpawnCreepsLane(kv.Akatsuki, spawnCountSide, kv.Offsets, akatsukiRightLanePath, DOTA_TEAM_CUSTOM_1, "akatsuki_academy_right")
    Units:SpawnCreepsLane(kv.Akatsuki, spawnCountMid, kv.Offsets, akatsukiMidLanePath, DOTA_TEAM_CUSTOM_1, "akatsuki_base")
end
