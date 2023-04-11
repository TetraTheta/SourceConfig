net.Receive("GCA", function(len, ply)
	if net.ReadBool() then
		surface.PlaySound("/items/ammo_pickup.wav")
	end
end)
