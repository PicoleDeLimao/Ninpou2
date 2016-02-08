--[[
	Author: PicoleDeLimao
	Date: 02.08.2016
	Implements Absorbing Stone Chakra Leech Ability
]]
function ChakraLeechStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local pID = caster:GetPlayerID()
	local particleName = "particles/units/heroes/hero_lion/lion_spell_mana_drain.vpcf"
	
	-- Particle from target to caster
	caster.manaDrainParticle = ParticleManager:CreateParticle(particleName, PATTACH_POINT_FOLLOW, caster)
	ParticleManager:SetParticleControlEnt(caster.manaDrainParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(caster.manaDrainParticle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
end

--[[
	Kills illusions, if its not an illusion then it moves the caster direction,
	checks the leash distance and drains mana from the target
]]
function ChakraLeech( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- If its an illusion then kill it
	if target:IsIllusion() then
		target:ForceKill(true)
	else
		-- Location variables
		local caster_location = caster:GetAbsOrigin()
		local target_location = target:GetAbsOrigin()

		-- Distance variables
		local distance = (target_location - caster_location):Length2D()
		local break_distance = ability:GetLevelSpecialValueFor("break_distance", (ability:GetLevel() - 1))
		local direction = (target_location - caster_location):Normalized()

		-- If the leash is broken then stop the channel
		if distance >= break_distance then
			ability:OnChannelFinish(false)
			caster:Stop()
			return
		end

		-- Make sure that the caster always faces the target
		caster:SetForwardVector(direction)

		-- Mana calculation
		local mana_per_second = ability:GetLevelSpecialValueFor("mana_per_second", (ability:GetLevel() - 1))
		local tick_interval = ability:GetLevelSpecialValueFor("tick_interval", (ability:GetLevel() - 1))
		local mana_drain = mana_per_second / (1/tick_interval)

		local target_mana = target:GetMana()
		local caster_mana = caster:GetMana()
		local caster_max_mana = caster:GetMaxMana()

		if target_mana <= 1 then 
			ability:OnChannelFinish(false)
			caster:Stop()
			return
		end
		
		-- Mana drain part
		-- If the target has enough mana then drain the maximum amount
		-- otherwise drain whatever is left
		caster.chakra_leech_tick_count = caster.chakra_leech_tick_count and caster.chakra_leech_tick_count + 1 or 1
		if target_mana >= mana_drain then
			target:ReduceMana(mana_drain)
			-- Mana gained can go over the max mana
			if caster_mana + mana_drain > caster_max_mana then
				caster:GiveMana(mana_drain)
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_absorbing_stone_mana_extra", nil)
			else
				caster:GiveMana(mana_drain)
			end
		else
			target:ReduceMana(target_mana)
			caster:GiveMana(target_mana)
		end
	end
end

-- Stops the particle and sound from looping
function ChakraLeechEnd(event)
	local target = event.target
	local caster = event.caster
	local sound = event.sound
	local item = event.ability
	StopSoundEvent(sound, target)
	ParticleManager:DestroyParticle(caster.manaDrainParticle, false) 
	if caster.chakra_leech_tick_count ~= nil and caster.chakra_leech_tick_count >= 2 then 
		caster:RemoveItem(item)
		caster:AddItemByName("item_charged_absorbing_stone")
	end
end