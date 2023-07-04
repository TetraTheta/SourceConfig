--[[
Enable 'point_servercommand' output and if it cannot be run, print it to chat
--]]

util.AddNetworkString("SVCMD")

hook.Add("AcceptInput", "EnableSVCMD", function(ent, name, activator, caller, data)
	if name ~= "Command" then return end
	if ent:GetClass() ~= "point_servercommand" then return end
	if not SERVER then return end
	local str
	if string.StartWith(data, "say ") then
		str = string.sub(data, 5)
	else
		str = data
	end
	net.Start("SVCMD")
	net.WriteString(str)
	net.Broadcast()
end)
