 --[[
	Author: PicoleDeLimao
	Date: 10.19.2016
	Implement Orochimaru Kuchiyose Rashomon ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	local dmgAbsorbed = ability:GetLevelSpecialValueFor("dmg_absorbed", ability:GetLevel() - 1)
	
	local rashomon = Units:CreateSummon(caster, "npc_rashomon_unit", caster:GetAbsOrigin() + caster:GetForwardVector() * 150, duration)
	rashomon:EmitSound("Hero_EarthShaker.Gravelmaw.Cast")
	
	local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike_eruption.vpcf", rashomon, 2.0)
	local particleInitialPos = rashomon:GetAbsOrigin() + Vectors:rotate2DDeg(rashomon:GetForwardVector(), 90) * 150
	local particleFinalPos = rashomon:GetAbsOrigin() + Vectors:rotate2DDeg(rashomon:GetForwardVector(), -90) * 150
	Particles:SetControl(particle, 0, particleInitialPos)
	Particles:SetControl(particle, 1, particleFinalPos)
	
	local count = 0
	Timers:CreateTimer(0.03, function()
		if count < duration and rashomon:IsAlive() then 
			count = count + 0.03
			return 0.03
		else
			StartAnimation(rashomon, {duration=1.0, activity=ACT_DOTA_DIE, rate=1.0})
			local particle = Particles:CreateTimedParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike_eruption.vpcf", rashomon, 2.0)
			local particleInitialPos = rashomon:GetAbsOrigin() + Vectors:rotate2DDeg(rashomon:GetForwardVector(), 90) * 150
			local particleFinalPos = rashomon:GetAbsOrigin() + Vectors:rotate2DDeg(rashomon:GetForwardVector(), -90) * 150
			Particles:SetControl(particle, 0, particleInitialPos)
			Particles:SetControl(particle, 1, particleFinalPos)
			rashomon:EmitSound("Hero_EarthShaker.Gravelmaw")
			Timers:CreateTimer(1.0, function()
				rashomon:AddNoDraw()
			end)
		end
	end)
end

function DamageTaken(event)
	local rashomon = event.caster 
	local unit = event.unit 
	local damage = event.Damage
	unit:SetHealth(unit:GetHealth() + damage)
	rashomon:SetHealth(rashomon:GetHealth() - damage)
end