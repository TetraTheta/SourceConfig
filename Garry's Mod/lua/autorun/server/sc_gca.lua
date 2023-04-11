--[[
Give maximum ammo to player

Commands:
 - gca: Give maximum ammo to player

Requirements:
 - Player must be in 'superadmin' group
--]]
util.AddNetworkString("GCA")

local function GiveCurrentAmmo(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() then return -1 end
	ply:SetAmmo(9999, wep:GetPrimaryAmmoType())
	ply:SetAmmo(9999, wep:GetSecondaryAmmoType())
	ply:SetAmmo(9999, "40MM") --This is for CW 2.0 40MM Grenade
	-- Send message for sound
	net.Start("GCA")
	net.WriteBool(true)
	net.Send(ply)
end

concommand.Add("gca", GiveCurrentAmmo, nil, "Sets current weapon's ammo to 9999", 0)
