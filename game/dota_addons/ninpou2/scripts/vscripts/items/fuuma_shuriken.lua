--[[
	Author: PicoleDeLimao
	Date: 08.05.2016
	Implement Fuuma Shuriken
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	local radius = ability:GetSpecialValueFor("radius")
	local range = ability:GetCastRange()
	local damage = ability:GetSpecialValueFor("damage_agi")
	caster:EmitSound("Hero_BountyHunter.Shuriken")
	Throwables:CreateThrowable({
		caster = caster,
		effectName = "particles/items/fuumashuriken/fuuma_shuriken.vpcf",
		target = caster:GetAbsOrigin() + (target - caster:GetAbsOrigin()):Normalized() * range,
		speed = 100,
		radius = radius,
		onHitEnemy = function(enemy, dummy)
			Particles:CreateTimedParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_backstab_hit_blood.vpcf", enemy, 3.0)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * caster:GetAgility(), damage_type = DAMAGE_TYPE_MAGICAL })
		end
	})
end