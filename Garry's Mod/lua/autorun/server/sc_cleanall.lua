local function CleanAll(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	-- Clean ragdoll
	local ragdoll_maxcount = GetConVar("g_ragdoll_maxcount"):GetInt()

	if ragdoll_maxcount == 0 then
		ragdoll_maxcount = 32
	end

	RunConsoleCommand("g_ragdoll_maxcount", "0")

	timer.Simple(1, function()
		RunConsoleCommand("g_ragdoll_maxcount", tostring(ragdoll_maxcount))
	end)

	-- Clean decal
	for k, v in pairs(player.GetHumans()) do
		v:ConCommand("r_cleardecals")
	end

	local count = 0

	-- Clean debris & gibs & ragdolls
	for k, v in ipairs(ents.GetAll()) do
		-- debris
		if v:GetClass() == "prop_physics" and bit.band(v:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 then
			v:Remove()
			count = count + 1
		end
		-- gibs
		if v:GetClass() == "gib" then
			v:Remove()
			count = count + 1
		end
		-- ragdoll
		if v:GetClass() == "prop_ragdoll" then
			v:Remove()
			count = count + 1
		end
	end

	-- Send result
	net.Start("CleanAllResult")
	net.WriteUInt(count, 20)
	net.Send(ply)
end

local function CleanModels(ply, cmd, args, str)
end

concommand.Add("cleanall", CleanAll, nil, "Clean All", 0)
