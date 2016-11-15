 --[[
	Author: PicoleDeLimao
	Date: 10.23.2016
	Implement Edo Tobirama Suiton Suijinheki ability
]]

function SpellStart(event)
	local caster = event.caster
	local ability = event.ability
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local range = ability:GetLevelSpecialValueFor("range", ability:GetLevel() - 1)
	local duration = ability:GetChannelTime()
	caster.casting_suijinheki = true
	local count = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_edo_tobirama_suiton_suijinheki_invulnerability", {duration=duration})
	Timers:CreateTimer(0.05, function()
		Particles:CreateTimedParticle("particles/heroes/orochimaru/suijinheki/kunkka_spell_torrent_splash_water4.vpcf", caster, 0.5)
		Particles:CreateTimedParticle("particles/heroes/orochimaru/suijinheki/nyx_assassin_burrow_water.vpcf", caster, 1.0)
		count = count + 1 
		caster:EmitSound("Ability.pre.Torrent")
		Units:FindEnemiesInRange({
			unit = caster,
			point = caster:GetAbsOrigin(),
			radius = range,
			func = function(enemy)
				Units:Damage(caster, enemy, damage / (duration / 0.05), "suiton")
				if count % 10 == 0 and enemy:IsAlive() then
					ability:ApplyDataDrivenModifier(caster, enemy, "modifier_edo_tobirama_suiton_suijinheki_stun", {duration=0.3})
				end
			end
		})
		if caster.casting_suijinheki then 
			return 0.05 
		end
	end)
end

function SpellStop(event)
	local caster = event.caster 
	local ability = event.ability 
	caster.casting_suijinheki = false
	caster:RemoveModifierByName("modifier_edo_tobirama_suiton_suijinheki_invulnerability")
end