-- sc_cleanall
net.Receive("CleanAllResult", function(len, ply)
	local count = net.ReadUInt(20)
	if count ~= 0 then
		notification.AddLegacy("Cleaned " .. count .. " objects", NOTIFY_GENERIC, 2)
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
end)

-- sc_i_hate (Weapon)
net.Receive("IHateWPNResult", function(len, ply)
	local count = net.ReadUInt(20)
	if count ~= 0 then
		notification.AddLegacy("Cleaned " .. count .. " weapons", NOTIFY_GENERIC, 2)
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
end)

-- sc_i_hate (Healthkit + Battery)
net.Receive("IHateBHResult", function(len, ply)
	local count = net.ReadUInt(20)
	if count ~= 0 then
		notification.AddLegacy("Cleaned " .. count .. " healthkits", NOTIFY_GENERIC, 2)
		surface.PlaySound("garrysmod/ui_hover.wav")
	end
end)
