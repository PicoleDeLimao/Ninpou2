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
	local caster = event.caster
	local target = event.target
	if NinpouGameRules:IsBase(caster) then 
		local particle1 = Particles:CreateTimedParticle("particles/base_destruction_fx/gensmoke.vpcf", target, 2.0)
		Particles:SetControl(particle1, 2, 600)
	else
		HUD:SendNotification("#message_building_destroyed")
		local particle = Particles:CreateTimedParticle("particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_generic.vpcf", target, 2.0)
		Particles:SetControl(particle, {1, 3, 8}, target:GetAbsOrigin())
		Particles:SetControl(particle, 7, 300)
	end
	target:EmitSound("Building_DireTower.Destruction")
end