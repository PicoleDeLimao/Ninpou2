--[[
	Author: PicoleDeLimao
	Date: 05.07.2016
	Implement Akatsuki Armor shadow meld
]]

function ShadowMeldThink(event)
	local caster = event.caster	
	local ability = event.ability
	local fade_time = ability:GetSpecialValueFor("fade_time")
	local inaction_duration = ability:GetSpecialValueFor("inaction_duration")
	-- If idle, passively apply the fade out
	if caster:IsIdle() and not caster:GetAttackTarget() then
		if not caster:HasModifier("modifier_shadow_meld") then
			if not caster.shadow_meld then 
				caster.shadow_meld = 0
			end
			caster.shadow_meld = caster.shadow_meld + 0.5
			if caster.shadow_meld >= fade_time + inaction_duration then 
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_meld", {})
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_invisible", {})
			end
		end
	else
		caster.shadow_meld = 0
		caster:RemoveModifierByName("modifier_shadow_meld")
		caster:RemoveModifierByName("modifier_invisible")
	end
end