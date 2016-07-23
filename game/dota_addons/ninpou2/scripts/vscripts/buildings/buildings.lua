--[[
	Author: PicoleDeLimao
	Date: 07.23.2016
	Add modifier_building to buildings
]]

function OnCreated(event)
	local caster = event.caster 
	local ability = event.ability
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_building", {})
	caster.hp = caster:GetHealth()
end

function KeepHealth(event)
	local caster = event.caster 
	if caster:GetHealth() > caster.hp then 
		caster:SetHealth(caster.hp)
	end
	caster.hp = caster:GetHealth()
end

function OnDeath(event)
	local caster = event.caster 
	local ability = event.ability
	caster:AddNoDraw()
end

function ShowDeathAnimation(event)
	local target = event.target
	local particle1 = Particles:CreateTimedParticle("particles/siege_fx/siege_good_death_01.vpcf", target, 2.0)
	ParticleManager:SetParticleControlOrientation(particle1, 1, Vector(100, 0, 0), Vector(0, 0, 0), Vector(0, 0, 100))
	local particle2 = Particles:CreateTimedParticle("particles/radiant_fx/tower_good3_destroy_lvl3.vpcf", target, 2.0)
	Particles:SetControl(particle2, {1, 3, 8}, target:GetAbsOrigin())
	Particles:SetControl(particle2, 7, 300)
	target:EmitSound("Building_DireTower.Destruction")
end