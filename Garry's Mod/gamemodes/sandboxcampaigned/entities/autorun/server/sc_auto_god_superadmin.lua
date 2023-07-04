--[[
Set GodMode to Player Automatically

Requirements:
 - Player must be in 'superadmin' group
--]]
local function AutoGodMode(ply)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:GodEnable()
	ply:AllowFlashlight(true) -- Fix flashlight if disabled
	MsgN("God mode enabled for " .. ply:Nick())
end

hook.Add("PlayerSpawn", "AutoGodMode", AutoGodMode)
