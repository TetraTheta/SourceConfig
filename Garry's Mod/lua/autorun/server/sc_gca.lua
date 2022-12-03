local function GCA(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local wep = ply:GetActiveWeapon()
	if not wep:IsValid() then return -1 end
	ply:SetAmmo(9999, wep:GetPrimaryAmmoType())
	ply:SetAmmo(9999, wep:GetSecondaryAmmoType())
	ply:SetAmmo(9999, "40MM") --This is for CW 2.0 40MM Grenade
	--surface.PlaySound("/items/ammo_pickup.wav") --This emits error
end

concommand.Add("gca", GCA, nil, "Sets current weapon's ammo to 9999", 0)
