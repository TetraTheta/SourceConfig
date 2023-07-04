--[[
Set speed of player

Commands:
 - sc_setspeed: Set speed of player

Requirements:
 - Player must be in 'superadmin' group
--]]
local function ResetOther(ply)
	ply:SetDuckSpeed(0.1)
	ply:SetUnDuckSpeed(0.1)
	ply:SetJumpPower(200)
	ply:SetLadderClimbSpeed(200)
	ply:SetRunSpeed(400)
end

local function SetSpeed(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end

	if args[1] == nil or args[2] == nil then return end

	-- Set speed
	local argfunc = {}
	argfunc["all"] = function()
		if args[2]:lower() == "fast" then
			ply:SetCrouchedWalkSpeed(1)
			ply:SetRunSpeed(600)
			ply:SetSlowWalkSpeed(150)
			ply:SetWalkSpeed(300)
		elseif args[2]:lower() == "reset" then
			ply:SetCrouchedWalkSpeed(0.3)
			ply:SetRunSpeed(400)
			ply:SetSlowWalkSpeed(100)
			ply:SetWalkSpeed(200)
		end
	end

	argfunc["duck"] = function(arg)
		if arg == "fast" then
			ply:SetCrouchedWalkSpeed(1)
		elseif arg == "reset" then
			ply:SetCrouchedWalkSpeed(0.3)
		end
	end
	argfunc["run"] = function(arg)
		if arg == "fast" then
			ply:SetRunSpeed(600)
		elseif arg == "reset" then
			ply:SetRunSpeed(400)
		end
	end
	argfunc["slow"] = function(arg)
		if arg == "fast" then
			ply:SetSlowWalkSpeed(150)
		elseif arg == "reset" then
			ply:SetSlowWalkSpeed(100)
		end
	end
	argfunc["walk"] = function(arg)
		if arg == "fast" then
			ply:SetWalkSpeed(300)
		elseif arg == "reset" then
			ply:SetWalkSpeed(200)
		end
	end

	local low1 = args[1]:lower()
	local low2 = args[2]:lower()

	if argfunc[low1] then
		argfunc[low1](low2)
	end

	ResetOther(ply)
end

local function AutoComplete(cmd, args)
	strargs = string.Trim(args:lower())
	local tbl = {}

	-- No argument
	if strargs == nil or strargs == "" then
		table.insert(tbl, "sc_setspeed all")
		table.insert(tbl, "sc_setspeed duck")
		table.insert(tbl, "sc_setspeed run")
		table.insert(tbl, "sc_setspeed slow")
		table.insert(tbl, "sc_setspeed walk")

		return tbl
	end

	-- One argument
	if string.StartWith(strargs, "a") then
		table.insert(tbl, "sc_setspeed all fast")
		table.insert(tbl, "sc_setspeed all reset")
	elseif string.StartWith(strargs, "d") then
		table.insert(tbl, "sc_setspeed duck fast")
		table.insert(tbl, "sc_setspeed duck reset")
	elseif string.StartWith(strargs, "r") then
		table.insert(tbl, "sc_setspeed run fast")
		table.insert(tbl, "sc_setspeed run reset")
	elseif string.StartWith(strargs, "s") then
		table.insert(tbl, "sc_setspeed slow fast")
		table.insert(tbl, "sc_setspeed slow reset")
	elseif string.StartWith(strargs, "w") then
		table.insert(tbl, "sc_setspeed walk fast")
		table.insert(tbl, "sc_setspeed walk reset")
	else
		-- Wrong argument
		table.insert(tbl, "sc_setspeed all")
		table.insert(tbl, "sc_setspeed duck")
		table.insert(tbl, "sc_setspeed run")
		table.insert(tbl, "sc_setspeed slow")
		table.insert(tbl, "sc_setspeed walk")
	end

	return tbl
end

concommand.Add("sc_setspeed", SetSpeed, AutoComplete, "Set player's speed", 0)
--[[
CrouchedWalkSpeed: 0.30000001192093 (duck)
RunSpeed: 400 (run)
SlowWalkSpeed: 100 (slow)
WalkSpeed: 200 (walk)

MaxSpeed: 200

DuckSpeed: 0.10000000149012 (crouch)
UnDuckSpeed: 0.10000000149012
JumpPower: 200
LadderClimbSpeed: 200
--]]
