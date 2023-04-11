--[[
Set GodMode to NPC Automatically

Commands:
 - sc_set_god: Set GodMode to the NPC the player is looking at manually
 - sc_unset_god: Unset GodMode to the NPC the player is looking at manually

Requirements:
 - Player must be in 'superadmin' group
--]]

-- Run shared.lua
include("sc_shared.lua")

--[[
	d1_, d2_, d3_, ep1_, ep2_: Half-Life 2 (+EP1, EP2)
	ks_: Mistake Of Pythagoras
	dw_: Dangerous World
]]
local map_prefix = {"d1_", "d2_", "d3_", "ep1_", "ep2_", "ks_", "dw_"}

local npc_list = Set{"npc_alyx", "npc_barney", "npc_eli", "npc_kleiner", "npc_magnusson", "npc_monk", "npc_mossman", "npc_vortigaunt"}

local function FilterMap(map)
	-- Return true if map name starts with map_prefix
	for _, prefix in ipairs(map_prefix) do
		if string.StartWith(map, prefix) then return true end
	end

	return false
end

local function FilterNPC(victim)
	-- Return true if given NPC is in npc_list or is Odessa Cubbage
	local npcClass = victim:GetClass()

	--MsgN(npcClass)
	if npc_list[npcClass] then
		--MsgN(npcClass)
		return true
	elseif npcClass == "npc_citizen" then
		if victim:GetInternalVariable("citizentype") == 4 and victim:GetModel() == "models/odessa.mdl" then return true end --MsgN(npcClass)
	end
	--MsgN("NO NPC")

	return false
end

local function ProcessDamage(victim, dmg)
	if not victim:IsValid() then return true end

	if victim.important == 1 then
		dmg:SetDamage(0)

		return true
	end

	local map_name = game.GetMap()

	if FilterMap(map_name) and FilterNPC(victim) then
		-- Only process target maps!
		-- Victim is NPC
		--MsgN("VICTIM IS NPC")
		if GetConVar("sc_killablenpc"):GetBool() then
			--MsgN("KILLABLE NPC")
			-- NPC is killable
			--MsgN("sc_killablenpc" .. " is set to true. NPC is killable!")
			victim:SetKeyValue("GameEndAlly", 0)
			victim:ClearAllOutputs()
		else
			-- NPC is not killable
			-- Set damage to 0
			--MsgN("NON-KILLABLE NPC")
			--MsgN("sc_killablenpc" .. " is set to false. NPC is not killable!")
			MsgN(victim:GetClass() .. " is invulnerable in this map")
			dmg:SetDamage(0)

			return true
		end
	end
end

local function GetTraceEntity(ply)
	local tr = util.GetPlayerTrace(ply)
	tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
	local trace = util.TraceLine(tr)
	if trace.Hit then return trace.Entity end
end

local function SetImportant(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local ent = GetTraceEntity(ply)
	print("You are looking at " .. ent:GetClass())
	--ent:SetKeyValue("important", 1)
	ent.important = 1
	MsgN("This NPC is now set important")
	print(ent.important)
end

local function UnsetImportant(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local ent = GetTraceEntity(ply)
	ent.important = 0
end

hook.Add("EntityTakeDamage", "ProcessDamage", ProcessDamage)
concommand.Add("sc_set_god", SetImportant, nil, "Set NPC important so that it won't take damage", 0)
concommand.Add("sc_unset_god", UnsetImportant, nil, "Unset NPC important so that it can take damage", 0)
