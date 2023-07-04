--[[
Remove object player is looking at

Commands:
 - sc_remove: Remove object player is looking at
 - sc_remove_all: Remove objects player is looking at, including those ones are connected too
 - sc_remove_constraints: Remove constraints of the object player is looking at

Requirements:
 - Player must be in 'superadmin' group
--]]
local function GetTraceEntity(ply)
	local tr = util.GetPlayerTrace(ply)
	tr.mask = bit.bor(CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX)
	local trace = util.TraceLine(tr)
	if trace.Hit then return trace.Entity end
end

local function RemoveEntity(ent)
	if not IsValid(ent) or ent.IsPlayer() then return false end
	if CLIENT then return true end
	-- Remove all constraints to stop ropes from hanging around
	constraint.RemoveAll(ent)

	-- Remove the entity after 1 second
	timer.Simple(0.1, function()
		if IsValid(ent) then
			ent:Remove()
		end
	end)

	-- Make the entity not solid
	ent:SetNotSolid(true)
	ent:SetMoveType(MOVETYPE_NONE)
	ent:SetNoDraw(true)
	-- Show effect
	local ed = EffectData()
	ed:SetOrigin(ent:GetPos())
	ed:SetEntity(ent)
	util.Effect("entity_remove", ed, true, true)

	return true
end

local function RemoveOne(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local entity = GetTraceEntity(ply)
	if RemoveEntity(entity) then return true end

	return false
end

local function RemoveAllConneted(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local entity = GetTraceEntity(ply)
	if not IsValid(entity) or entity:IsPlayer() then return false end
	if CLIENT then return true end
	local constrainedEntities = constraint.GetAllConstrainedEntities(entity)
	local count = 0

	for _, ent in pairs(constrainedEntities) do
		if RemoveEntity(ent) then
			count = count + 1
		end
	end

	return true
end

local function RemoveConstraints(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	local entity = GetTraceEntity(ply)
	if not IsValid(entity) or entity:IsPlayer() then return false end

	return constraint.RemoveAll(entity)
end

concommand.Add("sc_remove", RemoveOne, nil, "Remove object you are looking at", 0)
concommand.Add("sc_remove_all", RemoveAllConneted, nil, "Remove objects you are looking at, including those ones are connected too", 0)
concommand.Add("sc_remove_constraints", RemoveConstraints, nil, "Remove constraints of the object you are looking at", 0)
