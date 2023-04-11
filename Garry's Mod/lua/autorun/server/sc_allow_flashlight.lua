--[[
Allow Flashlight to player

Commands:
 - sc_flashlight: Allow Flashlight to player

Requirements:
 - Player must be in 'flashlight' group (or 'superadmin')
--]]

local targetID = 52920028

-- Allow flashlight automatically
local function AllowFlashlightAutomatic(ply)
	if ply:AccountID() == targetID and not ply:CanUseFlashlight() then
		ply:AllowFlashlight(true)
		MsgN("Flashlight is enabled to " .. ply:Nick())
	end
end

-- Allow flashlight
local function AllowFlashlight(ply, cmd, args, str)
	if not ply:IsValid() then return -1 end
	if not ply:IsUserGroup("superadmin") and not ply:IsUserGroup("flashlight") then return -1 end
	ply:AllowFlashlight(true)
	MsgN("Flashlight is enabled to " .. ply:Nick())
end

concommand.Add("sc_flashlight", AllowFlashlight, nil, "Allow flashlight to player")
hook.Add("PlayerSpawn", "AllowFlashlightAutomatic", AllowFlashlightAutomatic)
