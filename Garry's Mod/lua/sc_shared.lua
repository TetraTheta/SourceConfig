-- For both Server and Client
-- ConVar
if not ConVarExists("sc_killablenpc") then
	local flags = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY}

	CreateConVar("sc_killablenpc", "0", flags, "Is Essentials NPC killable? (OnDeath removed?)")
end

if not ConVarExists("sc_zinv") then
	local flags = {FCVAR_ARCHIVE, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY}

	CreateConVar("sc_zinv", "0", flags, "Toggle NPC Invasion (0 = disable, 1 = enable)")
end

-- Set
function Set(tbl)
	local result = {}

	for _, v in ipairs(tbl) do
		result[v] = true
	end

	return result
end

if not SERVER then return end

-- Server only
net.Receive("sc_changecvar", function(len, ply)
	if not (ply:IsValid() and ply:IsPlayer() and ply:IsSuperAdmin()) then return end
	command = net.ReadString()

	if command == "sc_killablenpc" then
		RunConsoleCommand("sc_killablenpc", net.ReadFloat())
	elseif command == "sc_zinv" then
		RunConsoleCommand("sc_zinv", net.ReadFloat())
	end
end)
