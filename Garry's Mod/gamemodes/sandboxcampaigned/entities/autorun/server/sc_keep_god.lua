--[[
Keep GodMode to player

Commands:
 - sc_keepgod: Keep GodMode to player

Requirements:
 - Player must be in 'superadmin' group
--]]
local function KeepGod(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	if ply.keep_god ~= true then
		MsgN("You are now in KeepGodMode")
		ply.keep_god = true
	else
		MsgN("You are now not in KeepGodMode")
		ply.keep_god = false
	end
end

local function KeepGod_Tick()
	for _, v in ipairs(player.GetHumans()) do
		if v.keep_god == true then
			v:GodEnable()
		end
	end
end

concommand.Add("sc_keepgod", KeepGod, nil, "Keep GodMode to player", 0)
hook.Add("Tick", "KeepGodMode", KeepGod_Tick)
