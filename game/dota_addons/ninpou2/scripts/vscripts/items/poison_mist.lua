--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Implement poison mist damage
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target 
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	local count = 0
	local particle = ParticleManager:CreateParticle("particles/items/poisonmist/pudge_rot.vpcf", PATTACH_ABSORIGIN, target)
	Particles:SetControl(particle, 1, radius)
	Timers:CreateTimer(1.0, function()
		Units:FindEnemiesInRange({
			unit = caster,
			point = target:GetAbsOrigin(),
			radius = radius,
			func = function(enemy)
				if not enemy:HasModifier("modifier_item_poison_mist_poison") then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_poison_mist_poison", {duration = duration})
				end
			end
		})
		count = count + 1.0
		if count < duration then
			return 1.0
		else
			ParticleManager:DestroyParticle(particle, false)
		end
	end)
end

function Poison(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target 
	local damage = ability:GetSpecialValueFor("damage_per_second")
	if target:GetHealth() > damage then 
		ApplyDamage({ victim = target, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PURE })
	else
		target:SetHealth(1)
	end
end