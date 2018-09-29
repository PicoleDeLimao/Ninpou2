 --[[
	Author: PicoleDeLimao
	Date: 10.23.2016
	Implement Orochimaru Kuchiyose Edo Tensei ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	local r1 = Vectors:rotate2DDeg(caster:GetForwardVector(), 90)
	local r2 = Vectors:rotate2DDeg(caster:GetForwardVector(), -90)
	local v1 = caster:GetAbsOrigin() + caster:GetForwardVector() * 150 + r1 * 100
	local v2 = caster:GetAbsOrigin() + caster:GetForwardVector() * 150 + r2 * 100
	
	local edotensei1 = Units:CreateSummon(caster, "npc_edo_tensei_unit", v1, 4.0)
	local edotensei2 = Units:CreateSummon(caster, "npc_edo_tensei_unit", v2, 4.0)
	
	Particles:CreateTimedParticle("particles/heroes/orochimaru/edotensei/courier_greevil_purple_ambient_3_e.vpcf", edotensei1, 4.0)
	Particles:CreateTimedParticle("particles/heroes/orochimaru/edotensei/courier_greevil_purple_ambient_3_e.vpcf", edotensei2, 4.0)
	
	Notifications:BottomToAll({image="file://{images}/heroes/orochimaru.png", duration=5.0})
	Notifications:BottomToAll({text="#orochimaru_ultimate", continue=true})
	
	Timers:CreateTimer(1.5, function()
		local hashirama = Units:CreateSummon(caster, "npc_edo_hashirama_unit", v1, duration)
		local tobirama = Units:CreateSummon(caster, "npc_edo_tobirama_unit", v2, duration)
		hashirama:SetRenderColor(223, 191, 191)
		tobirama:SetRenderColor(223, 191, 191)
		hashirama:SetForwardVector(edotensei1:GetForwardVector())
		tobirama:SetForwardVector(edotensei2:GetForwardVector())
		Units:Pause(hashirama)
		Units:Pause(tobirama)
		Timers:CreateTimer(1.0, function()
			Units:Unpause(hashirama)
			Units:Unpause(tobirama)
		end)
		Units:AddDeathEffect(hashirama, "particles/heroes/orochimaru/edotensei/greevil_transformation_dust.vpcf")
		Units:AddDeathEffect(tobirama, "particles/heroes/orochimaru/edotensei/greevil_transformation_dust.vpcf")
	end)
end