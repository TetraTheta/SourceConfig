local targetID = 52920028

-- Set GodMode to player
local function AutoGodMode(player)
	if player:AccountID() == targetID then
		player:GodEnable()
		player:AllowFlashlight(true) -- Fix flashlight if disabled
		MsgN("God mode enabled for " .. player:Nick())
	end
end

hook.Add("PlayerSpawn", "AutoGodMode", AutoGodMode)
