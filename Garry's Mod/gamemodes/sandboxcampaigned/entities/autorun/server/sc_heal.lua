--[[
Heals player

Commands:
 - heal: Heals player

Requirements:
 - Player must be in 'superadmin' group
--]]
local function Heal(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:SetHealth(100)
	ply:SetArmor(500)
end

concommand.Add("heal", Heal, nil, "Heals player", 0)
