net.Receive("SVCMD", function(len, ply)
	local message = net.ReadString()
	chat.AddText(Color(255, 255, 255, 255), ply, message)
end)
