--[[
Give maximum ammo to player

Commands:
 - gca: Give maximum ammo to player

Requirements:
 - Player must be in 'superadmin' group
--]]
local adminPistolClass = "sc_adminpistol"

-- Give Admin Pistol to player
local function GiveAdminGunWeapon(ply)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:Give(adminPistolClass)
	ply:SendLua("RunConsoleCommand(\"use\", \"sc_adminpistol\")")
	MsgN("AdminPistol is given to " .. ply:Nick())
end

-- Give Admin Pistol, Gravity Gun, Physics Gun to player with command
local function GiveBasicWeapons(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:Give(adminPistolClass)
	ply:Give("weapon_physgun")
	ply:Give("weapon_physcannon")
	ply:SendLua("RunConsoleCommand(\"use\", \"sc_adminpistol\")")
	MsgN("Basic weapons are given to " .. ply:Nick())
end

concommand.Add("sc_gbw", GiveBasicWeapons, nil, "Give Basic weapon to player", 0)
hook.Add("PlayerSpawn", "GiveAdminGunWeapon", GiveAdminGunWeapon)
