 --[[
	Author: PicoleDeLimao
	Date: 10.24.2016
	Implement Edo Tobirama Suiton Suishoha ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target_points[1]
	local range = ability:GetCastRange()
	local damagePerInt = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local damageFixed = ability:GetLevelSpecialValueFor("dmg_fixed", ability:GetLevel() - 1)
	local orochimaru = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())
	
	local origin = caster:GetAbsOrigin()
	local forward = (target - caster:GetAbsOrigin()):Normalized()
	local count = 0
	local affected = { }
	
	for i = 1, 10 do 
		local newOriginForward = Vectors:rotate2DDeg(forward, -90)
		local newOrigin = origin + newOriginForward * (-300 + 60 * i)
		local newForward = (target - newOrigin):Normalized()
		local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_morphling/morphling_waveform.vpcf", caster, 1.0)
		Particles:SetControl(particle, 0, origin)
		Particles:SetControl(particle, 1, newForward * range)
		local dummy = CreateUnitByName("npc_dummy_unit", origin, false, caster, caster, caster:GetTeam())
		dummy:SetForwardVector(newForward)
		dummy.distanceTravelled = 0
		dummy:EmitSound("Hero_Morphling.Waveform")
		Timers:CreateTimer(0.05, function()
			if dummy.distanceTravelled < range then 
				local step = range / (1 / 0.05)
				dummy:SetAbsOrigin(dummy:GetAbsOrigin() + dummy:GetForwardVector() * step)
				dummy.distanceTravelled = dummy.distanceTravelled + step
				Units:FindEnemiesInRange({
					unit = dummy,
					point = dummy:GetAbsOrigin(),
					radius = 110,
					func = function(enemy)
						if not Tables:Contains(affected, enemy) then 
							Units:Damage(caster, enemy, damagePerInt * orochimaru:GetIntellect() + damageFixed, "suiton")
							print(damagePerInt * orochimaru:GetIntellect() + damageFixed)
							Tables:push(affected, enemy)
						end
					end
				})
				return 0.05
			end
		end)
	end
	
end