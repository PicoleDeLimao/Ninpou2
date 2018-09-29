--[[
	Author: PicoleDeLiamo
	Date: 04.09.2016
	Define some HUD wrapper functions 
]]

if not HUD then 
	HUD = class({})
end 

-- Send an error message to a player 
function HUD:SendErrorMessage(pID, message)
	Notifications:ClearBottom(pID)
	Notifications:Bottom(pID, {text=message, style={color='#E62020'}, duration=5})
	EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end

-- Send a notification message to players
function HUD:SendNotification(message)
	Notifications:BottomToAll({text=message, class="NotificationMessage", duration=5})
end
