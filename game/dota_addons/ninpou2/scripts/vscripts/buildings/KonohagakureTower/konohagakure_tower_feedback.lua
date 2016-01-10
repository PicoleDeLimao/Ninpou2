--[[
	Author: PicoleDeLimao
	Date: 01.09.2016
	Make primary towers drain mana upon hit
]]

-- Drain mana 
function ManaBurn(event)
	local target = event.target 
	local ability = event.ability
	local manaBurn = ability:GetLevelSpecialValueFor("mana_per_hit", ability:GetLevel() - 1)
	if target:IsMagicImmune() or target:GetMana() == 0 then return end 
	target:ReduceMana(manaBurn)
	target:EmitSound("Hero_Antimage.ManaBreak")
	ParticleManager:CreateParticle("particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
end