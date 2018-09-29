 --[[
	Author: PicoleDeLimao
	Date: 10.24.2016
	Implement Edo Hashirama Jukai Koutan ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local damageFixed = ability:GetLevelSpecialValueFor("dmg_fixed", ability:GetLevel() - 1)
	local damagePerInt = ability:GetLevelSpecialValueFor("dmg_per_int", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1) 
	local orochimaru = PlayerResource:GetSelectedHeroEntity(caster:GetPlayerOwnerID())

	StartAnimation(caster, {duration=0.5, activity=ACT_DOTA_CAST_ABILITY_1, rate=1.0})
	
	Units:Pause(caster)
	Timers:CreateTimer(0.5, function()
		Units:Unpause(caster)
	end)
	
	caster.jukai_koutan_started = true 
	
	local count = 0
	local origin = caster:GetAbsOrigin()
	local trees = { }
	local affected = { }
	
	for i = 1, 5 do
		local dummy = Units:CreateSummon(caster, "npc_dummy_unit", origin + Vector(math.random(-range/2,range/2), math.random(-range/2,range/2), 0), 3.0)
		dummy:EmitSound("Hero_Treant.Death")
	end
	
	Timers:CreateTimer(0.03, function()
		count = count + 0.03 
		if count < 1.0 then 
			for i = 1, 5 do 
				local newOrigin = origin + Vector(math.random(-range/2, range/2), math.random(-range/2, range/2))
				local tree = Units:CreateSummon(caster, "npc_tree_unit", newOrigin, duration)
				tree:SetModelScale(0)
				Timers:CreateTimer(0.1, function()
					tree:SetModelScale(math.random(0.5, 1.5))
				end)
				StartAnimation(tree, {duration=1.0, activity=ACT_IDLE, rate=1.0})
				tree:SetForwardVector(Vector(math.random(), math.random(), 0))
				Particles:CreateTimedParticle("particles/world_destruction_fx/tree_grow_leaves.vpcf", tree, 0.5)
				Particles:CreateTimedParticle("particles/world_destruction_fx/treeleaves_large.vpcf", tree, 0.5)
				Units:FindEnemiesInRange({
					unit = tree,
					point = tree:GetAbsOrigin(),
					radius = 110,
					func = function(enemy)
						if not Tables:Contains(affected, enemy) then 
							Units:Damage(caster, enemy, (damagePerInt * orochimaru:GetIntellect() + damageFixed) / 2, "suiton")
							Units:Damage(caster, enemy, (damagePerInt * orochimaru:GetIntellect() + damageFixed) / 2, "doton")
							Tables:push(affected, enemy)
						end
					end
				})
				Tables:push(trees, tree)
			end
		end
		if not caster.jukai_koutan_started then 
			for i = 1, 5 do
				local dummy = Units:CreateSummon(caster, "npc_dummy_unit", origin + Vector(math.random(-range/2,range/2), math.random(-range/2,range/2), 0), 3.0)
				dummy:EmitSound("Hero_Treant.Death")
			end
			for _, tree in pairs(trees) do 
				tree:ForceKill(false)
				StartAnimation(tree, {duration=1.0, activity=ACT_IDLE, rate=1.0})
				Particles:CreateTimedParticle("particles/world_destruction_fx/tree_grow_leaves.vpcf", tree, 0.5)
				Particles:CreateTimedParticle("particles/world_destruction_fx/treeleaves_large.vpcf", tree, 0.5)
				Timers:CreateTimer(0.05, function()
					if tree:GetAbsOrigin().z > -700 then 
						tree:SetAbsOrigin(tree:GetAbsOrigin() - Vector(0, 0, 30))
						tree:SetModelScale(tree:GetModelScale() - 0.001)
						return 0.05
					end
				end)
			end
			return nil
		end
		return 0.03
	end)
	Timers:CreateTimer(duration, function()
		if caster.jukai_koutan_started then 
			ability:ToggleAbility()
		end
	end)
end

function SpellStop(event)
	local caster = event.caster 
	local ability = event.ability
	caster.jukai_koutan_started = false
end