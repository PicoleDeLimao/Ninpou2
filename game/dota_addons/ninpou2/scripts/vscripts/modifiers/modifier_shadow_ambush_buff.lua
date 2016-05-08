modifier_shadow_ambush_buff = class({})

function modifier_shadow_ambush_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_shadow_ambush_buff:OnCreated()
	local caster = self:GetCaster()
	if caster.shadow_ambush_bonus then
		self.move_bonus = caster.shadow_ambush_bonus * 10.0
		self.attack_bonus = caster.shadow_ambush_bonus * caster:GetAverageTrueAttackDamage() / 10.0
		self.particle = ParticleManager:CreateParticle("particles/econ/items/templar_assassin/templar_assassin_focal/templar_assassin_meld_focal.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(self.particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(self.particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end
end

function modifier_shadow_ambush_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_bonus
end

function modifier_shadow_ambush_buff:GetModifierBaseAttack_BonusDamage()
	return self.attack_bonus
end

function modifier_shadow_ambush_buff:OnDestroy()
	if self.particle then
		ParticleManager:DestroyParticle(self.particle, true)
	end
end

function modifier_shadow_ambush_buff:IsBuff()
	return true 
end

function modifier_shadow_ambush_buff:IsPurgable()
	return true 
end