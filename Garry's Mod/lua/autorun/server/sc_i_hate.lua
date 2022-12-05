local function CrouchSpeed(ply, cmd, args, str)
	if not ply:IsValid() or not ply:IsUserGroup("superadmin") then return -1 end
	ply:SetCrouchedWalkSpeed(1)
end

concommand.Add("i_hate_crouching", CrouchSpeed, nil, "Increase Crouch Walking Speed", 0)
