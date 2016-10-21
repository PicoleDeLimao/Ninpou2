--[[
	Author: PicoleDeLimao
	Date: 07.03.2016
	Attachs sword particle when equiped
]]
function Equip(event)
	local caster = event.caster 
	local ability = event.ability
	local damageIncrease = ability:GetLevelSpecialValueFor("elemental_damage_bonus", ability:GetLevel() - 1)
	caster.rikuudouSenninSetCount = (caster.rikuudouSenninSetCount or 0) + 1
	caster.katonDmg = caster.katonDmg + damageIncrease 
	caster.suitonDmg = caster.suitonDmg + damageIncrease 
	caster.dotonDmg = caster.dotonDmg + damageIncrease 
	caster.fuutonDmg = caster.fuutonDmg + damageIncrease 
	caster.raitonDmg = caster.raitonDmg + damageIncrease 
	caster.yinDmg = caster.yinDmg + damageIncrease 
	caster.yangDmg = caster.yangDmg + damageIncrease 
	if caster.rikuudouSenninSetCount == 1 then
		local particle = ParticleManager:CreateParticle("particles/items/RikuudouSenninSet/witchdoctor_ribbitar_ward_skull_lv.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true) 
		caster.rikuudouSenninSetParticle = particle
		caster.rikuudouSenninSetParticleName = event.ParticleName
	end
end

function Unequip(event)
	local caster = event.caster
	local ability = event.ability
	local damageIncrease = ability:GetLevelSpecialValueFor("elemental_damage_bonus", ability:GetLevel() - 1)
	caster.katonDmg = caster.katonDmg - damageIncrease 
	caster.suitonDmg = caster.suitonDmg - damageIncrease 
	caster.dotonDmg = caster.dotonDmg - damageIncrease 
	caster.fuutonDmg = caster.fuutonDmg - damageIncrease 
	caster.raitonDmg = caster.raitonDmg - damageIncrease 
	caster.yinDmg = caster.yinDmg - damageIncrease 
	caster.yangDmg = caster.yangDmg - damageIncrease 
	if caster.rikuudouSenninSetCount == 1 then 
		ParticleManager:DestroyParticle(caster.rikuudouSenninSetParticle, false)
		caster.rikuudouSenninSetParticle = nil
	end
	caster.rikuudouSenninSetCount = caster.rikuudouSenninSetCount - 1
end

function CriticalStrike(event)
	local caster = event.caster 
	local target = event.target 
	local ability = event.ability
	local bonus = ability:GetLevelSpecialValueFor("crit_bonus", ability:GetLevel() - 1) / 100.0
	local radius = ability:GetLevelSpecialValueFor("crit_area", ability:GetLevel() - 1)
	local slowDuration = ability:GetLevelSpecialValueFor("slow_duration", ability:GetLevel() - 1)
	Units:FindEnemiesInRange({
		unit = caster,
		point = target:GetAbsOrigin(),
		radius = radius,
		func = function(enemy)
			local damage = caster:GetAverageTrueAttackDamage(enemy)
			ApplyDamage({ victim = enemy, attacker = caster, damage = damage * bonus, damage_type = DAMAGE_TYPE_PHYSICAL})
			Particles:CreateTimedParticle("particles/units/heroes/hero_nevermore/nevermore_shadowraze.vpcf", enemy, 0.25)
			if not enemy:IsMagicImmune() then
				ability:ApplyDataDrivenModifier(caster, enemy, "modifier_item_rikuudou_sennin_set_slow", {duration = slowDuration})
			end
			PopupCriticalDamage(enemy, damage * bonus)
		end
	})
end

-- Display special effects when juubi is summoned
function SummonJuubi(event)
	local caster = event.caster 
	local ability = event.ability
	local juubi = nil 
	local units = Entities:FindAllByNameWithin("npc_dota_creature", caster:GetAbsOrigin(), 600)
	caster:RemoveItem(ability)
	for _, unit in pairs(units) do 
		if unit:GetUnitName() == "npc_juubi_unit" and unit:GetOwner() == caster then 
			local juubi = unit 
			StartAnimation(juubi, {duration=2.5, activity=ACT_DOTA_SPAWN, rate=1.0})
			for count = 1,15 do
				Timers:CreateTimer(0.5+count/10.0, function()
					local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_earthshaker/earthshaker_echoslam_start_fallback_mid.vpcf", juubi, 2.0)
					ParticleManager:SetParticleControl(particle, 1, juubi:GetAbsOrigin())
				end)
			end
		end
	end
end