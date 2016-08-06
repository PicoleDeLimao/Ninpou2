--[[
	Author: PicoleDeLimao
	Date: 08.05.2016
	Implement Explosive Kunai Damage
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1] 
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage_str")
	Throwables:CreateThrowable({
		caster = caster,
		effectName = "particles/items/explosivekunai/explosive_kunai.vpcf",
		target = target,
		height = 200,
		speed = 150,
		onEnd = function(dummy)
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare_explosion.vpcf", dummy, 3.0)
			Particles:SetControlEnt(particle, 3, dummy)
			Particles:CreateTimedParticle("particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf", dummy, 3.0)
			dummy:EmitSound("Hero_Clinkz.Death")
			Units:FindEnemiesInRange({
				unit = caster,
				point = dummy:GetAbsOrigin(),
				radius = radius,
				func = function(enemy) 
					ApplyDamage({ victim = enemy, attacker = caster, damage = damage * caster:GetStrength(), damage_type = DAMAGE_TYPE_MAGICAL })
				end
			})
		end
	})
end