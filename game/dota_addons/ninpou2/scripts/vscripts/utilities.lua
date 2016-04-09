--[[
	Author: PicoleDeLiamo
	Date: 04.01.2016
	Define many utilitary functions 
]]

Utils = {}

-- Check if unit is valid and alive 
function Utils:IsValidAlive(unit)
    return unit ~= nil and IsValidEntity(unit) and unit:IsAlive()
end

-- Check if unit is disabled 
function Utils:IsDisabled(unit)
	return unit:IsMuted() or unit:IsSilenced() or unit:IsStunned()
end

-- Check if unit can cast an ability
function Utils:CanCast(unit, ability)
	return not Utils:IsDisabled(unit) and unit:GetMana() > ability:GetManaCost(ability:GetLevel() - 1) and ability:GetCooldownTimeRemaining() == 0
end

-- Get the nearest hero to an unit inside a group of units 
function Utils:GetNearestHero(units, toUnit)
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

-- Create an illusion of the caster 
function Utils:CreateBunshin(caster, ability, duration)
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
		if not Utils:IsValidAlive(bunshin) then 
			local dummy = CreateUnitByName("npc_dummy_unit", lastOrigin, false, caster, nil, caster:GetTeamNumber())
			dummy:EmitSound("Poof")
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_ice_blast_sphere_final_explosion_smoke.vpcf", PATTACH_CUSTOMORIGIN, dummy)
			ParticleManager:SetParticleControl(particle, 0, lastOrigin)
			ParticleManager:SetParticleControl(particle, 3, lastOrigin)
			Timers:CreateTimer(2.0, function() 
				if Utils:IsValidAlive(dummy) then
					dummy:ForceKill(true)
				end
			end)
			return nil
		end
		lastOrigin = bunshin:GetAbsOrigin()
		if not Utils:IsValidAlive(caster) then 
			bunshin:ForceKill(true)
		end
		return 0.1 
	end)
end
