--[[
	Author: PicoleDeLimao
	Date: 04.09.2016
	Implement Bijuu Chakra Armor Shield 
]]

function InitializeShield(event)
	local caster = event.caster 
	local ability = event.ability
	caster.bijuuChakraShieldHealth = ability:GetLevelSpecialValueFor("shield_amount", ability:GetLevel() - 1)
	local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin() + Vector(0, 0, 500))
	caster:EmitSound("Hero_Windrunner.Pick")
end

function BlockDamage(event)
	local caster = event.caster
	local ability = event.ability
	local damage = event.Damage 
	local damageBlock = nil
	if damage <= caster.bijuuChakraShieldHealth then 
		caster.bijuuChakraShieldHealth = caster.bijuuChakraShieldHealth - damage 
		caster:SetHealth(caster.oldHealth)
		damageBlock = damage 
	else 
		caster:SetHealth(caster.oldHealth - damage + caster.bijuuChakraShieldHealth)
		caster:RemoveModifierByName("modifier_item_bijuu_chakra_armor_buff")
		damageBlock = caster.bijuuChakraShieldHealth
	end
	SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_BLOCK, caster, damageBlock, nil)
end

-- Keeps track of the caster health
function CasterHealth(event)
	local caster = event.caster
	caster.oldHealth = caster:GetHealth()
end