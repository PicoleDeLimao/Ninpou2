 --[[
	Author: PicoleDeLimao
	Date: 10.24.2016
	Implement Edo Tobirama Kokuangyo no Jutsu ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	Particles:CreateTimedParticle("particles/heroes/orochimaru/kokuangyo/au_darkrift_target_oh_b.vpcf", caster, duration)
	Units:CreateSummon(caster, "npc_kokuangyo_unit", caster:GetAbsOrigin(), duration)
end