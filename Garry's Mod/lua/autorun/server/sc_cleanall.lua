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

	-- Clean debris & gibs
	for k, v in ipairs(ents.GetAll()) do
		-- debris
		if v:GetClass() == "prop_physics" and bit.band(v:GetSpawnFlags(), SF_PHYSPROP_IS_GIB) > 0 then
			v:Remove()
		end
		-- gibs
		if v:GetClass() == "gib" then
			v:Remove()
		end
	end
end

concommand.Add("cleanall", CleanAll, nil, "Clean All", 0)
