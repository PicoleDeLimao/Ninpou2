 --[[
	Author: PicoleDeLimao
	Date: 10.20.2016
	Implement Orochimaru Kuchiyose Kusanagi ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local duration = ability:GetSpecialValueFor("duration")
	
	StartAnimation(caster, {duration=1.0, activity=ACT_DOTA_CAST_ABILITY_5, rate=1.5})
	
	caster.kusanagi_started = true 
	
	local particle = nil
	local affected = { }
	local allAffected = { }
	local count = 0
	
	Timers:CreateTimer(0.03, function()
		count = count + 0.03 
		if count >= duration then 
			if particle ~= nil then
				ParticleManager:DestroyParticle(particle, false)
			end
			caster:RemoveModifierByName("modifier_orochimaru_kusanagi_phase")
			ability:ToggleAbility()
			return nil
		elseif not caster.kusanagi_started then 
			if particle ~= nil then
				ParticleManager:DestroyParticle(particle, false)
			end
			caster:RemoveModifierByName("modifier_orochimaru_kusanagi_phase")
			EndAnimation(caster)
			for _, unit in allAffected do 
				unit.count_kusanagi_hits = 0
			end
			return nil
		elseif count > 0.5 then 
			if particle == nil then 
				particle = ParticleManager:CreateParticle("particles/heroes/orochimaru/kusanagi/kusanagi_no_tsurugi.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				Particles:Attach(particle, caster, "attach_mouth")
				StartAnimation(caster, {duration=duration-0.5, activity=ACT_DOTA_CAST_ABILITY_7, rate=1.0})
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_orochimaru_kusanagi_phase", nil)
			end
			caster:SetAbsOrigin(caster:GetAbsOrigin() + caster:GetForwardVector() * 20)
			affected = Tables:Filter(affected, function(el)
				return (el:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D() < 250
			end)
			Units:FindEnemiesInRange({
				unit = caster,
				point = caster:GetAbsOrigin(),
				radius = 180,
				func = function(enemy) 
					if not Tables:Contains(affected, enemy) and (enemy.count_kusanagi_hits == nil or enemy.count_kusanagi_hits < 3) then 
						local particle = Particles:CreateTimedParticle("particles/econ/items/riki/riki_immortal_ti6/riki_immortal_ti6_blinkstrike_gold_backstab_hit_blood.vpcf", enemy, 2.0)
						Particles:SetControl(particle, 2, Vector(800, 0, 0))
						Units:Damage(caster, enemy, damage, "yin")
						enemy.count_kusanagi_hits = (enemy.count_kusanagi_hits or 0) + 1
						Tables:push(affected, enemy)
					end
					if not Tables:Contains(allAffected, enemy) then 
						Tables:push(allAffected, enemy)
					end
				end
			})
		end
		return 0.03
	end)
end

function SpellStop(event)
	local caster = event.caster 
	local ability = event.ability
	caster.kusanagi_started = false
	FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
end