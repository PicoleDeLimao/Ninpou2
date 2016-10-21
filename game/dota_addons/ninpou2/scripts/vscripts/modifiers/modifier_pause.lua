modifier_pause = class({})

function modifier_pause:DeclareFunctions()
	return {
	}
end

function modifier_pause:CheckState() 
	return { [MODIFIER_STATE_STUNNED] = true, }
end

function modifier_pause:GetAttributes()
  return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_pause:OnCreated()
end

function modifier_pause:OnDestroy()
end

function modifier_pause:IsBuff()
	return false 
end

function modifier_pause:IsPurgable()
	return false 
end

function modifier_pause:IsHidden()
	return true
end