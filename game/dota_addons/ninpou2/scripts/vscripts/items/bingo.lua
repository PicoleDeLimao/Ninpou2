--[[
	Author: PicoleDeLimao
	Date: 04.10.2016
	Initialize bing book reward amount 
]]
function Initialize(event)
	local caster = event.caster
	local reward = event.GoldReward 
	caster.bingoReward = reward 
end