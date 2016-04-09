--[[
	Author: PicoleDeLiamo
	Date: 04.09.2016
	Define some global functions 
]]

-- Send an error message to a player 
function SendErrorMessage(pID, message)
	Notifications:ClearBottom(pID)
	Notifications:Bottom(pID, {text=message, style={color='#E62020'}, duration=5})
	EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end