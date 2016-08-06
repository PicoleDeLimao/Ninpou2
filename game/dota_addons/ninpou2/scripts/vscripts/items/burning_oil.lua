--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Implement burning oil damage
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]  
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	local damage = ability:GetSpecialValueFor("damage_per_second")
	caster:EmitSound("Hero_Batrider.Firefly.Cast")
	Throwables:CreateThrowable({
		caster = caster,
		effectName = "particles/items/burningoil/batrider_flamebreak.vpcf",
		target = target,
		height = 300,
		speed = 300,
		onEnd = function(dummy)
			local count = 0
			local particle = Particles:CreateTimedParticle("particles/items/burningoil/batrider_firefly.vpcf", target, duration, { caster = caster })
			Particles:SetControl(particle, 11, radius + 200)
			particle = Particles:CreateTimedParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", dummy, 3.0)
			Particles:SetControlEnt(particle, 3, dummy)
			dummy:EmitSound("Hero_Clinkz.Death")
			Timers:CreateTimer(1.0, function()
				Particles:CreateTimedParticle("particles/econ/items/shadow_fiend/sf_fire_arcana/sf_fire_arcana_loadout.vpcf", target, 1.0, { caster = caster })
				Units:FindEnemiesInRange({
					unit = caster,
					point = target,
					radius = radius,
					func = function(enemy)
						if not enemy:IsMagicImmune() then
							Particles:CreateTimedParticle("particles/units/heroes/hero_batrider/batrider_firefly_head.vpcf", enemy, 1.0)
							ApplyDamage({ victim = enemy, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_PHYSICAL })
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_burning_oil_burning", {duration = 2.0})
						end
					end
				})
				count = count + 1.0
				if count < duration then
					return 1.0
				end
			end)
		end
	})
end