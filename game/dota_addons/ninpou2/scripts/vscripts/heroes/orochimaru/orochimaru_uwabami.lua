 --[[
	Author: PicoleDeLimao
	Date: 10.22.2016
	Implement Orochimaru Uwabami ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = ability:GetCastRange()
	local damagePerInt = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local damageFixed = ability:GetLevelSpecialValueFor("dmg", ability:GetLevel() - 1)
	local ensnareDuration = ability:GetLevelSpecialValueFor("ensnare_duration", ability:GetLevel() - 1)
	local damageType = "yin"
	
	local snakes = { }
	local affected = { }
	local count = 0
	local countSnakes = 0
	local angle = 15
	local casterForward = caster:GetForwardVector()
	local casterOrigin = caster:GetAbsOrigin()
	Timers:CreateTimer(0.03, function()
		count = count + 0.03 
		if count < 1.0 then 
			local rotationAngle = math.random(-angle/2, angle/2)
			local rotatedForward = Vectors:rotate2DDeg(casterForward, rotationAngle)
			local snake = CreateUnitByName("npc_manda_unit", casterOrigin + casterForward * math.random(150, 200), false, caster, caster, caster:GetTeam())
			snake:SetForwardVector(rotatedForward)
			snake:SetModelScale(snake:GetModelScale() + math.random(-0.001, 0.003))
			snake.speed = math.random(10, 20)
			snake.distance = 0
			StartAnimation(snake, {duration=5.0, activity=ACT_DOTA_RUN, rate=math.random(3, 5)})
			countSnakes = countSnakes + 1 
			snakes[countSnakes] = snake
		end
		for index, snake in pairs(snakes) do 
			local z = GetGroundHeight(snake:GetAbsOrigin(), snake)
			local newPos = snake:GetAbsOrigin() + snake:GetForwardVector() * snake.speed
			newPos.z = z + 5
			snake:SetAbsOrigin(newPos)
			snake.distance = snake.distance + snake.speed 
			snake.speed = snake.speed + 1
			Units:FindEnemiesInRange({
				unit = snake,
				point = snake:GetAbsOrigin(),
				radius = 110,
				func = function(enemy) 
					if not Tables:Contains(affected, enemy) then 
						local particle = Particles:CreateTimedParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_backstab_hit_blood.vpcf", enemy, 2.0)
						Particles:SetControl(particle, 2, Vector(800, 0, 0))
						Units:Damage(caster, enemy, damagePerInt * caster:GetIntellect() + damageFixed, damageType)
						if not Units:IsBuilding(enemy) and enemy:IsAlive() then 
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_orochimaru_uwabami_esnare", {duration=ensnareDuration})
							local snakeDebuff = CreateUnitByName("npc_manda_unit", enemy:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
							snakeDebuff:SetAbsOrigin(snakeDebuff:GetAbsOrigin() + Vector(0, 0, 50))
							StartAnimation(snakeDebuff, {duration=ensnareDuration, activity=ACT_DOTA_DIE, rate=1.0})
							local snakeDebuffCount = 0
							Timers:CreateTimer(0.05, function()
								snakeDebuff:SetAbsOrigin(enemy:GetAbsOrigin() + Vector(0, 0, 50))
								snakeDebuffCount = snakeDebuffCount + 0.05
								if snakeDebuffCount >= ensnareDuration or not enemy:IsAlive() then 
									snakeDebuff:Destroy()
								else
									return 0.05
								end
							end)
						end
						Tables:push(affected, enemy)
					end
				end
			})
			if snake.distance >= range then 
				snake:Destroy()
				snakes[index] = nil
			end
		end
		if not Tables:IsEmpty(snakes) then 
			return 0.03 
		end
	end)
end