--[[
	Author: PicoleDeLimao
	Date: 01.11.2016
	Implements Yasakani no Magatama's Rinnegan jutsu invulnerability
]]
function CheckHealth(event)
	local caster = event.caster
	local ability = event.ability 
	local duration = ability:GetLevelSpecialValueFor("rinnegan_invulnerability_duration", ability:GetLevel() - 1)
	local cooldown = ability:GetLevelSpecialValueFor("rinnegan_invulnerability_cooldown", ability:GetLevel() - 1)
	local thinkInterval = ability:GetLevelSpecialValueFor("think_interval", ability:GetLevel() - 1)
	if caster.cooldown == nil then 
		caster.cooldown = 0 
	end
	if caster.cooldown > 0 then 
		caster.cooldown = caster.cooldown - thinkInterval
	elseif caster:GetHealthPercent() <= 30 then  
		caster.cooldown = cooldown 
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_yasakani_no_magatama_rinnegan", {})
	end 
end