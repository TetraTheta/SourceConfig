--[[
Give basic weapons to player

Commands:
 - gbw: Give basic weapons to player

Requirements:
 - Player must be in 'superadmin' group
--]]
local adminPistolClass = "sc_adminpistol"
local adminRifleClass = "sc_adminrifle"

-- Give Admin Pistol to player
local function GiveAdminGunWeapon(ply)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:Give(adminPistolClass)
	ply:Give(adminRifleClass)
	ply:SendLua("RunConsoleCommand(\"use\", \"sc_adminpistol\")")
	MsgN("Admin Weapons are given to " .. ply:Nick())
end

-- Give Admin Pistol, Admin Rifle, Gravity Gun, Physics Gun to player with command
local function GiveBasicWeapons(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:Give(adminPistolClass)
	ply:Give(adminRifleClass)
	ply:Give("weapon_physgun")
	ply:Give("weapon_physcannon")
	if engine.ActiveGamemode() == "sandbox" then
		ply:Give("gmod_tool")
	end
	ply:SendLua("RunConsoleCommand(\"use\", \"sc_adminpistol\")")
	MsgN("Basic weapons are given to " .. ply:Nick())
end

concommand.Add("gbw", GiveBasicWeapons, nil, "Give Basic weapon to player", 0)
hook.Add("PlayerSpawn", "GiveAdminGunWeapon", GiveAdminGunWeapon)
