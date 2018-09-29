modifier_semi_building = class({})


function modifier_semi_building:OnCreated(event)
    self.disable_turning = event.disable_turning == 1 and 1 or 1
    self.magic_immune = event.magic_immune == 1
    self.deniable = event.deniable == 1
end

function modifier_semi_building:GetModifierDisableTurning()
    return self.disable_turning
end

function modifier_semi_building:GetModifierIgnoreCastAngle()
    return self.disable_turning or 1
end

function modifier_semi_building:CheckState() 
    return { [MODIFIER_STATE_MAGIC_IMMUNE] = self.magic_immune or true,
             [MODIFIER_STATE_SPECIALLY_DENIABLE] = self.deniable or true, --add setting in semi_building_settings.kv
             [MODIFIER_STATE_ROOTED] = true,
             [MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
             [MODIFIER_STATE_NO_UNIT_COLLISION] = true, }
end

function modifier_semi_building:DeclareFunctions() 
  return { MODIFIER_PROPERTY_DISABLE_TURNING,
           MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
           MODIFIER_PROPERTY_MOVESPEED_LIMIT, }
end

function modifier_semi_building:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_semi_building:GetModifierMoveSpeed_Limit()
    return 0
end

function modifier_semi_building:IsHidden()
    return true
end

function modifier_semi_building:IsPurgable()
    return false
end