 --[[
	Author: PicoleDeLimao
	Date: 09.17.2016
	Implement Orochimaru Sen'eijashu ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = ability:GetCastRange()
	local damagePerInt = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local damageType = "yin"
	
	local duration = 0.3
	local tick = 0.03
	local speed = range / (duration / tick) 
	local radius = 150
	local numsnakes = 4
	local angle = 10
	
	--caster:EmitSound("Hero_Medusa.MysticSnake.Cast")
	StartAnimation(caster, {duration=duration*2,activity=ACT_DOTA_CAST_ABILITY_6, rate=1.0})
	Units:Pause(caster)
	-- Create dummies and animations 
	local caster_forward = caster:GetForwardVector()
	local dummies = {}
	local snakes = {}
	for i = 1, numsnakes do 
		local rotation_angle = -angle/2 + angle/numsnakes*i + math.random(-3,3)
		local forward = Vectors:rotate2DDeg(caster_forward, rotation_angle)
		local dummy = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin() + forward * 150, false, caster, caster, caster:GetTeam())
		dummy:SetForwardVector(forward)
		dummy.speed = speed + math.random(-4,4)
		local snakefx = ParticleManager:CreateParticle("particles/heroes/orochimaru/seneijashu/shredder_timberchain.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleAlwaysSimulate(snakefx)
		ParticleManager:SetParticleControlEnt(snakefx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(snakefx, 1, dummy, PATTACH_POINT_FOLLOW, "attach_origin", dummy:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(snakefx, 2, Vector(dummy.speed * 1/tick,0,0))
		dummies[i] = dummy
		snakes[i] = snakefx
	end
	local projectile = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
	projectile:SetForwardVector(caster:GetForwardVector())
	
	-- Chain loop
	local startPulling = function(target, distanceTraveled)
		Timers:CreateTimer(tick, function()
			for i = 1, numsnakes do 
				dummies[i]:SetAbsOrigin(dummies[i]:GetAbsOrigin() - dummies[i]:GetForwardVector() * dummies[i].speed)
			end
			projectile:SetAbsOrigin(projectile:GetAbsOrigin() - projectile:GetForwardVector() * speed)
			if target ~= nil then 
				local vec = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
				target:SetAbsOrigin(target:GetAbsOrigin() - vec * speed)
			end
			distanceTraveled = distanceTraveled - speed
			if distanceTraveled > 0 then 
				return tick 
			else
				if target ~= nil then 
					FindClearSpaceForUnit(target, target:GetAbsOrigin(), true)
					Units:Unpause(target)
				end
				EndAnimation(caster)
				for i = 1, numsnakes do
					dummies[i]:Destroy()
					ParticleManager:DestroyParticle(snakes[i], false)
				end
				projectile:Destroy()
				Units:Unpause(caster)
			end
		end)
	end
	local distanceTraveled = 0
	Timers:CreateTimer(tick, function()
		for i = 1, numsnakes do 
			dummies[i]:SetAbsOrigin(dummies[i]:GetAbsOrigin() + dummies[i]:GetForwardVector() * dummies[i].speed)
		end
		projectile:SetAbsOrigin(projectile:GetAbsOrigin() + projectile:GetForwardVector() * speed)
		-- Find a enemy in range 
		local target = nil
		Units:FindEnemiesInRange({
			unit = caster,
			point = projectile:GetAbsOrigin(),
			radius = radius,
			func = function(enemy)
				if Units:IsHero(enemy) then 
					target = enemy
				elseif target == nil and not Units:IsBuilding(enemy) then 
					target = enemy
				end
			end
		})
		-- Start pulling loop
		if target ~= nil then 
			target:EmitSound("Hero_Medusa.MysticSnake.Target")
			local particle = Particles:CreateTimedParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_backstab_hit_blood.vpcf", target, 2.0)
			Particles:SetControl(particle, 2, Vector(800, 0, 0))
			Units:Damage(caster, target, caster:GetIntellect() * damagePerInt, damageType)
			Units:Pause(target)
			startPulling(target, distanceTraveled)
		else
			distanceTraveled = distanceTraveled + speed 
			if distanceTraveled < range then 
				return tick
			else
				startPulling(nil, distanceTraveled)
			end
		end
	end)
end