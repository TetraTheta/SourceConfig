local targetID = 52920028
local adminPistolClass = "sc_adminpistol"

-- Give Admin Pistol to player
local function GiveAdminGunWeapon(player)
	if player:AccountID() == targetID then
		player:Give(adminPistolClass)
		player:SendLua("RunConsoleCommand(\"use\", \"sc_adminpistol\")")
		MsgN("AdminPistol is given to " .. player:Nick())
	end
end

-- Give Admin Pistol, Gravity Gun, Physics Gun to player with command
local function GiveBasicWeapons(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	if ply:AccountID() == targetID then
		ply:Give(adminPistolClass)
		ply:Give("weapon_physgun")
		ply:Give("weapon_physcannon")
		ply:SendLua("RunConsoleCommand(\"use\", \"sc_adminpistol\")")
		MsgN("Basic weapons are given to " .. ply:Nick())
	end
end

concommand.Add("sc_gbw", GiveBasicWeapons, nil, "Give Basic weapon to player", 0)
hook.Add("PlayerSpawn", "GiveAdminGunWeapon", GiveAdminGunWeapon)
