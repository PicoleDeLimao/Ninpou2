--[[
	Author: PicoleDeLimao
	Date: 05.08.2016
	Implement Akatsuki Set shadow ambush and pathfinder
]]

LinkLuaModifier("modifier_shadow_ambush_buff", "modifiers/modifier_shadow_ambush_buff", LUA_MODIFIER_MOTION_NONE)

function ShadowAmbushThink(event)
	local caster = event.caster	
	local ability = event.ability
	local fade_time = ability:GetSpecialValueFor("fade_time")
	local inaction_duration = ability:GetSpecialValueFor("inaction_duration")
	-- If idle, passively apply the fade out
	ability:CreateVisibilityNode(caster:GetAbsOrigin(), 1000, 5.0)
	if not caster.shadow_ambush then 
		caster.shadow_ambush = 0
	end
	if not caster.shadow_ambush_duration then 
		caster.shadow_ambush_duration = 0
	end
	if caster:IsIdle() and not caster:GetAttackTarget() then
		if not caster:HasModifier("modifier_shadow_ambush") then
			caster.shadow_ambush = caster.shadow_ambush + 0.5
			if caster.shadow_ambush >= fade_time + inaction_duration then 
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_ambush", {})
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisible", {})
			end
		else
			if caster.shadow_ambush_duration < 10 then
				caster.shadow_ambush_duration = caster.shadow_ambush_duration + 0.5
			end
		end
	else
		if caster.shadow_ambush_duration > 0 then 
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_slark/slark_dark_pact_pulses.vpcf", caster, 2.0)
			Particles:SetControlEnt(particle, {1, 3, 4, 5}, caster)
			Particles:SetControl(particle, 2, 300)
			caster.shadow_ambush_bonus = caster.shadow_ambush_duration
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_ambush_buff", {duration=6})
		end
		caster.shadow_ambush = 0
		caster.shadow_ambush_duration = 0
		caster:RemoveModifierByName("modifier_shadow_ambush")
		caster:RemoveModifierByName("modifier_invisible")
	end
end