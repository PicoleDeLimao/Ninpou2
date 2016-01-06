--[[
	Author: PicoleDeLimao
	Date: 01.04.2016
	Perform the logic of Demolish ability
]]

-- Deal additional damage to buildings and fire a special effect
function Demolish(event)
    local caster = event.caster
    local target = event.target 
    if target:IsBuilding() then 
        local ability = event.ability
        local damage = caster:GetAverageTrueAttackDamage() * (ability:GetLevelSpecialValueFor("demolish", ability:GetLevel() - 1) - 1)
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/espirit_spawn.vpcf", PATTACH_ABSORIGIN, target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_PHYSICAL
        })
    end
end