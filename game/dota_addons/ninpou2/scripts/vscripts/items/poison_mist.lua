--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Implement poison mist damage
]]

function SpellStart(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target_points[1]   
	local radius = ability:GetSpecialValueFor("radius")
	local duration = ability:GetSpecialValueFor("duration")
	caster:EmitSound("Hero_Alchemist.UnstableConcoction.Throw")
	Throwables:CreateThrowable({
		caster = caster,
		effectName = "particles/items/poisonmist/batrider_flamebreak.vpcf",
		target = target,
		height = 300,
		speed = 300,
		onEnd = function(dummy)
			local count = 0
			local particle = Particles:CreateTimedParticle("particles/items/poisonmist/pudge_rot.vpcf", target, duration, { caster = caster })
			Particles:SetControl(particle, 1, radius)
			Timers:CreateTimer(1.0, function()
				Units:FindEnemiesInRange({
					unit = caster,
					point = target,
					radius = radius,
					func = function(enemy)
						if not enemy:HasModifier("modifier_item_poison_mist_poison") and not enemy:IsMagicImmune() then
							ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_poison_mist_poison", {duration = duration})
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