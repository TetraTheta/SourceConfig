--[[
Clean objects that hurts eye or server performance

Commands:
 - sc_clean: Clean objects that hurts eye or server performance

Requirements:
 - Player must be in 'superadmin' group
--]]
util.AddNetworkString("CleanResult")

local function CleanBatteryHealthkit()
	local cleanResultBatteryHealthkit = 0

	for k, v in ipairs(ents.GetAll()) do
		local c = v:GetClass()

		if c == "item_healthkit" or c == "item_healthvial" or c == "item_battery" then
			v:Remove()
			cleanResultBatteryHealthkit = cleanResultBatteryHealthkit + 1
		end
	end

	return cleanResultBatteryHealthkit
end

local function CleanDecals()
	for k, v in pairs(player.GetHumans()) do
		v:ConCommand("r_cleardecals")
	end
end

local function CleanDebris()
	local cleanResultDebris = 0

	for k, v in ipairs(ents.GetAll()) do
		-- debris
		if v:GetClass() == "prop_physics" and bit.band(v:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 then
			v:Remove()
			cleanResultDebris = cleanResultDebris + 1
		end
	end

	return cleanResultDebris
end

local function CleanDroppedAmmo()
	local ammoList = {}
	local cleanResultDroppedAmmo = 0
	-- Ammo
	ammoList.item_ammo_357 = true
	ammoList.item_ammo_357_large = true
	ammoList.item_ammo_ar2 = true
	ammoList.item_ammo_ar2_altfire = true
	ammoList.item_ammo_ar2_large = true
	ammoList.item_ammo_crossbow = true
	ammoList.item_ammo_pistol = true
	ammoList.item_ammo_pistol_large = true
	ammoList.item_ammo_smg1 = true
	ammoList.item_ammo_smg1_grenade = true
	ammoList.item_ammo_smg1_large = true
	ammoList.item_box_buckshot = true
	ammoList.item_rpg_round = true

	for k, v in ipairs(ents.GetAll()) do
		if not IsValid(v:GetPhysicsObject()) then continue end
		local c = v:GetClass()

		if ammoList[c] then
			v:Remove()
			cleanResultDroppedAmmo = cleanResultDroppedAmmo + 1
		end
	end

	return cleanResultDroppedAmmo
end

local function CleanDroppedWeapons()
	local weaponList = {}
	local cleanResultDroppedWeapons = 0
	-- Weapon
	weaponList.grenade_ar2 = true
	weaponList.weapon_357 = true
	weaponList.weapon_ar2 = true
	weaponList.weapon_bugbait = true
	weaponList.weapon_crossbow = true
	weaponList.weapon_crowbar = true
	weaponList.weapon_frag = true
	weaponList.weapon_pistol = true
	weaponList.weapon_rpg = true
	weaponList.weapon_shotgun = true
	weaponList.weapon_slam = true
	weaponList.weapon_smg1 = true
	weaponList.weapon_stunstick = true
	-- Ammo
	weaponList.item_ammo_357 = true
	weaponList.item_ammo_357_large = true
	weaponList.item_ammo_ar2 = true
	weaponList.item_ammo_ar2_altfire = true
	weaponList.item_ammo_ar2_large = true
	weaponList.item_ammo_crossbow = true
	weaponList.item_ammo_pistol = true
	weaponList.item_ammo_pistol_large = true
	weaponList.item_ammo_smg1 = true
	weaponList.item_ammo_smg1_grenade = true
	weaponList.item_ammo_smg1_large = true
	weaponList.item_box_buckshot = true
	weaponList.item_rpg_round = true

	for k, v in ipairs(ents.GetAll()) do
		if not IsValid(v:GetPhysicsObject()) then continue end
		local c = v:GetClass()

		if weaponList[c] then
			v:Remove()
			cleanResultDroppedWeapons = cleanResultDroppedWeapons + 1
		end
	end

	return cleanResultDroppedWeapons
end

local function CleanGibs()
	local cleanResultGibs = 0

	for k, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "gib" then
			v:Remove()
			cleanResultGibs = cleanResultGibs + 1
		end
	end

	return cleanResultGibs
end

local function CleanRagdoll()
	local cleanResultRagdoll = 0

	for k, v in ipairs(ents.GetAll()) do
		if v:GetClass() == "prop_ragdoll" then
			v:Remove()
			cleanResultRagdoll = cleanResultRagdoll + 1
		end
	end

	--[[
	local ragdollMaxCount = GetConVar("g_ragdoll_maxcount"):GetInt()

	if ragdollMaxCount == 0 then
		ragdollMaxCount = 32 -- Default value
	end

	RunConsoleCommand("g_ragdoll_maxcount", "0")

	timer.Simple(1, function()
		RunConsoleCommand("g_ragdoll_maxcount", tostring(ragdoll_maxcount))
	end)
	--]]
	-- Instead of restoring value, just set it to default because it doesn't work
	RunConsoleCommand("g_ragdoll_maxcount", "0")

	timer.Simple(0.1, function()
		RunConsoleCommand("g_ragdoll_maxcount", "32")
	end)

	return cleanResultRagdoll
end

local function CleanSmallObjects()
	local cleanResultSmallObjects = 0
	print("This is placeholder: " .. cleanResultSmallObjects)

	return cleanResultSmallObjects
end

local function Clean(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local countAmmo = 0
	local countBatteryHealthkit = 0
	local countDebris = 0
	local countGibs = 0
	local countRagdoll = 0
	local countSmall = 0
	local countWeapon = 0
	if args[1] == nil then return end
	-- Parse arguments
	local argfunc = {}

	argfunc["all"] = function()
		countAmmo = CleanDroppedAmmo()
		countBatteryHealthkit = CleanBatteryHealthkit()
		countDebris = CleanDebris()
		countGibs = CleanGibs()
		countRagdoll = CleanRagdoll()
		countSmall = CleanSmallObjects()
		countWeapon = CleanDroppedWeapons()
		CleanDecals()
	end

	argfunc["ammo"] = function()
		countAmmo = CleanDroppedAmmo()
	end

	argfunc["debris"] = function()
		countDebris = CleanDebris()
	end

	argfunc["gibs"] = function()
		countGibs = CleanGibs()
	end

	argfunc["ragdoll"] = function()
		countRagdoll = CleanRagdoll()
	end

	argfunc["small"] = function()
		countSmall = CleanSmallObjects()
	end

	argfunc["vitality"] = function()
		countBatteryHealthkit = CleanBatteryHealthkit()
	end

	argfunc["weapon"] = function()
		countWeapon = CleanDroppedWeapons()
	end

	local low = args[1]:lower()

	if argfunc[low] then
		argfunc[low]()
	end

	-- Construct result table
	local resultTable = {}

	if countAmmo > 0 then
		resultTable.ammo = countAmmo
	end

	if countBatteryHealthkit > 0 then
		resultTable.vitality = countBatteryHealthkit
	end

	if countDebris > 0 then
		resultTable.debris = countDebris
	end

	if args[1]:lower() == "all" or args[1]:lower() == "decal" then
		resultTable.decal = true
	end

	if countGibs > 0 then
		resultTable.gibs = countGibs
	end

	if countRagdoll > 0 then
		resultTable.ragdoll = countRagdoll
	end

	if countSmall > 0 then
		resultTable.small = countSmall
	end

	if countWeapon > 0 then
		resultTable.weapon = countWeapon
	end

	-- Convert table to JSON (Compressed)
	local resultJsonComp = util.Compress(util.TableToJSON(resultTable))
	net.Start("CleanResult")
	net.WriteUInt(#resultJsonComp, 16)
	net.WriteData(resultJsonComp)
	net.Send(ply)
end

local function AutoComplete(cmd, args)
	strargs = string.Trim(args:lower())
	local tbl = {}

	-- No argument
	if strargs == nil or strargs == "" then
		table.insert(tbl, "sc_clean all")
		table.insert(tbl, "sc_clean ammo")
		table.insert(tbl, "sc_clean debris")
		table.insert(tbl, "sc_clean decal")
		table.insert(tbl, "sc_clean gibs")
		table.insert(tbl, "sc_clean ragdoll")
		table.insert(tbl, "sc_clean small")
		table.insert(tbl, "sc_clean vitality")
		table.insert(tbl, "sc_clean weapon")

		return tbl
	end

	-- One argument
	if string.StartWith(strargs, "a") then
		table.insert(tbl, "sc_clean all")
		table.insert(tbl, "sc_clean ammo")
	elseif string.StartWith(strargs, "d") then
		table.insert(tbl, "sc_clean debris")
		table.insert(tbl, "sc_clean decals")
	elseif string.StartWith(strargs, "g") then
		table.insert(tbl, "sc_clean gibs")
	elseif string.StartWith(strargs, "r") then
		table.insert(tbl, "sc_clean ragdoll")
	elseif string.StartWith(strargs, "s") then
		table.insert(tbl, "sc_clean small")
	elseif string.StartWith(strargs, "v") then
		table.insert(tbl, "sc_clean vitality")
	elseif string.StartWith(strargs, "w") then
		table.insert(tbl, "sc_clean weapon")
	else
		-- Wrong argument
		table.insert(tbl, "sc_clean all")
		table.insert(tbl, "sc_clean ammo")
		table.insert(tbl, "sc_clean debris")
		table.insert(tbl, "sc_clean decal")
		table.insert(tbl, "sc_clean gibs")
		table.insert(tbl, "sc_clean ragdoll")
		table.insert(tbl, "sc_clean small")
		table.insert(tbl, "sc_clean vitality")
		table.insert(tbl, "sc_clean weapon")
	end

	return tbl
end

concommand.Add("sc_clean", Clean, AutoComplete, "Clean Objects", 0)
