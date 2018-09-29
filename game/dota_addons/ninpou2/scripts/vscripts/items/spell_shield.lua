--[[
	Author: PicoleDeLimao
	Date: 02.08.2016
	Implements the Spell Shield functionality
]]
function IsSpellBlocked(target)
	if target:HasModifier("modifier_item_susanoo_set") and math.random(0, 100) <= 10 then
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		return true
	elseif target:HasModifier("modifier_item_spell_shield") then
		target:RemoveModifierByName("modifier_item_spell_shield")  --The particle effect is played automatically when this modifier is removed (but the sound isn't).
		target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		target.spellShieldCooldown = target.spellShieldCooldownStarting
		return true
	end
	return false
end

function RemoveSpellShield(event)
	IsSpellBlocked(event.caster)
end

function ApplyModifier(event)
	local caster = event.caster 
	local ability = event.ability
	local target = event.target 
	local modifierName = event.ModifierName
	local durationHero = event.DurationHero
	local durationCreep = event.DurationCreep
	local duration = 0
	if target:IsHero() then 
		duration = durationHero
	else
		duration = durationCreep
	end
	if not IsSpellBlocked(target) then 
		if duration ~= nil and duration ~= 0 then
			ability:ApplyDataDrivenModifier(caster, target, modifierName, {duration = duration})
		else
			ability:ApplyDataDrivenModifier(caster, target, modifierName, {})	
		end
	end
end

function CreateShield(event)
	local caster = event.caster 
	local ability = event.ability
	local cooldown = event.Cooldown
	if not caster:HasModifier("modifier_item_spell_shield") then
		if caster.spellShieldCooldown == nil or caster.spellShieldCooldown <= 0 then 
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_spell_shield", {})
			caster.spellShieldCooldownStarting = cooldown
		else 
			caster.spellShieldCooldown = caster.spellShieldCooldown - 0.03
		end
	end
end