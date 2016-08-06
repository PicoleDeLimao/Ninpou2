--[[
	Author: PicoleDeLimao
	Date: 08.06.2016
	Implement Smoke Bomb
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]  
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	Throwables:CreateThrowable({
		caster = caster,
		effectName = "particles/items/smokebomb/smoke_bomb.vpcf",
		target = target,
		height = 300,
		speed = 300,
		onEnd = function(dummy)
			for i = 1,2 do
				local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_riki/riki_smokebomb.vpcf", target, duration, { caster = caster })
				Particles:SetControl(particle, 1, radius + 100)
			end
			local dummy = CreateUnitByName("npc_smoke_bomb_unit", target, false, caster, caster, caster:GetTeamNumber())
			Timers:CreateTimer(duration, function()
				dummy:ForceKill(false)
			end)
			local count = 0
			Timers:CreateTimer(0.1, function()
				Units:FindAlliesInRange({
					unit = caster,
					point = target,
					radius = radius,
					func = function(ally)
						ability:ApplyDataDrivenModifier(caster, ally, "modifier_invisible", {duration=0.2})
					end
				})
				count = count + 0.1
				if count < duration then 
					return 0.1
				end
			end)
		end
	})
end