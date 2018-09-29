--[[
	Author: PicoleDeLimao
	Date: 08.05.2016
	Implement Senbons Launcher
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]
	local radius = ability:GetSpecialValueFor("radius")
	local range = ability:GetCastRange()
	local damage = ability:GetSpecialValueFor("damage_int")
	Particles:CreateTimedParticle("particles/items/senbonslauncher/senbons_launcher.vpcf", target, 3.0, { caster = caster })
	caster:EmitSound("Hero_PhantomAssassin.Dagger.Target")
	Units:FindEnemiesInRange({
		unit = caster,
		point = target,
		radius = radius,
		func = function(enemy)
			Particles:CreateTimedParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_backstab_hit_blood.vpcf", enemy, 3.0)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * caster:GetIntellect(), damage_type = DAMAGE_TYPE_MAGICAL })
		end
	})
end