 --[[
	Author: PicoleDeLimao
	Date: 10.25.2016
	Implement Edo Hashirama Adamantine Punch ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	
	Units:Pause(caster)
	StartAnimation(caster, {duration=9999, activity=ACT_DOTA_RUN, rate=3.0})
	Particles:CreateTimedParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact.vpcf", caster, 3.0)
	caster:EmitSound("Hero_Brewmaster.ThunderClap")
	
	Timers:CreateTimer(0.03, function()
		local dist = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
		local forward = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
		if dist > 150 then 
			local newOrigin = caster:GetAbsOrigin() + forward * 30 
			caster:SetAbsOrigin(newOrigin)
			caster:SetForwardVector(forward)
			return 0.03
		else
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue_coreglow02.vpcf", caster, 2.0)
			Particles:Attach(particle, caster, "attach_attack1")
			StartAnimation(caster, {duration=0.4, activity=ACT_DOTA_ATTACK,rate=2.0})
			Timers:CreateTimer(0.25, function()
				Units:Unpause(caster)
				Units:Pause(target)
				Units:Damage(caster, target, damage, "yang")
				StartAnimation(target, {duration=0.5, activity=ACT_DOTA_DIE,rate=1.0})
				Particles:CreateTimedParticle("particles/econ/items/earthshaker/earthshaker_totem_ti6/earthshaker_totem_ti6_leap_impact_d.vpcf", caster, 3.0)
				caster:EmitSound("Hero_EarthSpirit.BoulderSmash.Target")
				Units:Knockback({
					unit = target,
					distance = 300,
					duration = 0.5,
					height = 20,
					forward = forward,
					onFinish = function()
						Units:Unpause(target)
					end
				})
			end)
		end
	end)
end