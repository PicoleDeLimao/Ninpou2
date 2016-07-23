--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Implement burning oil damage
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target 
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage_per_second")
	local count = 0
	local particle = ParticleManager:CreateParticle("particles/items/burningoil/batrider_firefly.vpcf", PATTACH_ABSORIGIN, target)
	Particles:SetControl(particle, {1, 11}, radius + 200)
	Timers:CreateTimer(1.0, function()
		Particles:CreateTimedParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout.vpcf", target, 1.0)
		Units:FindEnemiesInRange({
			unit = caster,
			point = target:GetAbsOrigin(),
			radius = radius,
			func = function(enemy)
				Particles:CreateTimedParticle("particles/units/heroes/hero_batrider/batrider_firefly_head.vpcf", enemy, 1.0)
				ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
				if not enemy:IsMagicImmune() then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_burning_oil_burning", {duration = 2.0})
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