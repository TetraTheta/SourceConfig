local function CrouchSpeed(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:SetCrouchedWalkSpeed(1)
end

local function DroppedWeapon(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	-- List of HL2 Weapons & Ammo
	local wl = {}
	local count = 0
	-- Weapon
	wl.grenade_ar2 = true
	wl.weapon_357 = true
	wl.weapon_ar2 = true
	wl.weapon_bugbait = true
	wl.weapon_crossbow = true
	wl.weapon_crowbar = true
	wl.weapon_frag = true
	wl.weapon_pistol = true
	wl.weapon_rpg = true
	wl.weapon_shotgun = true
	wl.weapon_slam = true
	wl.weapon_smg1 = true
	wl.weapon_stunstick = true
	-- Ammo
	wl.item_ammo_357 = true
	wl.item_ammo_357_large = true
	wl.item_ammo_ar2 = true
	wl.item_ammo_ar2_altfire = true
	wl.item_ammo_ar2_large = true
	wl.item_ammo_crossbow = true
	wl.item_ammo_pistol = true
	wl.item_ammo_pistol_large = true
	wl.item_ammo_smg1 = true
	wl.item_ammo_smg1_grenade = true
	wl.item_ammo_smg1_large = true
	wl.item_box_buckshot = true
	wl.item_rpg_round = true

	for k, v in ipairs(ents.GetAll()) do
		if not IsValid(v:GetPhysicsObject()) then continue end
		local c = v:GetClass()

		if wl[c] then
			v:Remove()
			count = count + 1
		end
	end

	-- Send result
	net.Start("IHateWPNResult")
	net.WriteUInt(count, 20)
	net.Send(ply)
end

local function BatteryAndKit(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local count = 0

	for k, v in ipairs(ents.GetAll()) do
		local c = v:GetClass()

		if c == "item_healthkit" or c == "item_healthvial" or c == "item_battery" then
			v:Remove()
			count = count + 1
		end
	end

	-- Send result
	net.Start("IHateBHResult")
	net.WriteUInt(count, 20)
	net.Send(ply)
end

concommand.Add("i_hate_crouching", CrouchSpeed, nil, "Increase crouch walking speed", 0)
concommand.Add("i_hate_dropped_weapons", DroppedWeapon, nil, "Clear dropped weapons", 0)
concommand.Add("i_hate_battery_and_healthkit", BatteryAndKit, nil, "Clear battery and health kit", 0)
