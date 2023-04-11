-- sc_clean
net.Receive("CleanResult", function(len, ply)
	local resultJsonCompLen = net.ReadUInt(16)
	local resultJsonComp = net.ReadData(resultJsonCompLen)
	local resultTable = util.JSONToTable(util.Decompress(resultJsonComp))
	local playSound = false

	if resultTable.ammo and math.floor(resultTable.ammo) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.ammo .. " Ammos", NOTIFY_GENERIC, 2)
		playSound = true
	end

	if resultTable.vitality and math.floor(resultTable.vitality) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.vitality .. " Batteries and Healthkits", NOTIFY_GENERIC, 2)
		playSound = true
	end

	if resultTable.debris and math.floor(resultTable.debris) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.debris .. " Debris", NOTIFY_GENERIC, 2)
		playSound = true
	end

	if resultTable.gibs and math.floor(resultTable.gibs) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.gibs .. " Gibs", NOTIFY_GENERIC, 2)
		playSound = true
	end

	if resultTable.ragdoll and math.floor(resultTable.ragdoll) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.ragdoll .. " Ragdolls", NOTIFY_GENERIC, 2)
		playSound = true
	end

	if resultTable.small and math.floor(resultTable.small) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.small .. " Small objects", NOTIFY_GENERIC, 2)
		playSound = true
	end

	if resultTable.weapon and math.floor(resultTable.weapon) > 0 then
		notification.AddLegacy("Cleaned " .. resultTable.weapon .. " Weapons", NOTIFY_GENERIC, 2)
		playSound = true
	end

	-- Check decal last because I don't want to be spammed with 'Cleaned Decals' only
	if playSound == true and resultTable.decal and resultTable.decal == true then
		notification.AddLegacy("Cleaned Decals", NOTIFY_GENERIC, 2)
	end

	if playSound then
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
end)
