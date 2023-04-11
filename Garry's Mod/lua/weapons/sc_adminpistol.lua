-- Since this script isn't at lua/autorun or lua/autorun/client, I must send this to client
if SERVER then
	AddCSLuaFile() -- Send self
end

-- Things that cannot be in SWEP table
local className = "sc_adminpistol"
local initSecondaryType = 0
--
-- SWEP
SWEP.Category = "SC Weapons"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.PrintName = "Admin Pistol"
SWEP.Purpose = "Yet Another Admin Pistol"
SWEP.Instructions = "Click to shoot, Reload to change bullet type"
SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.AutoSwitchFrom = false
SWEP.AutoSwitchTo = false
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.CSMuzzleFlashes = false
SWEP.UseHands = true
SWEP.HoldType = "pistol"
--
-- SWEP Primary
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true
SWEP.Primary.ClipSize = 1
SWEP.Primary.Damage = 99999999999
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Delay = 0.05
SWEP.Primary.Force = 1000000
SWEP.Primary.Recoil = 0
SWEP.Primary.ShotCount = 75
SWEP.Primary.Sound = "Weapon_M4A1.Silenced"
SWEP.Primary.Spread = 0.25
SWEP.Primary.Volume = 0.75
--
-- SWEP Secondary Common
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = true
SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Recoil = 0
SWEP.Secondary.Volume = 0.75
--
-- SWEP Secondary 1 (Explosion)
SWEP.Secondary.Explosion = {}
SWEP.Secondary.Explosion.Damage = 9999999 -- Damage for explosion
SWEP.Secondary.Explosion.Delay = 0.05 -- Delay for explosion
SWEP.Secondary.Explosion.Magnitude = 175 -- Explosion Magnitude of explosion
SWEP.Secondary.Explosion.Force = 1000000 -- Force of explosion
SWEP.Secondary.Explosion.ShotCount = 1 -- ShotCount for explosion. No need to set it.
SWEP.Secondary.Explosion.Sound = "Weapon_AWP.Single" -- Sound for explosion
SWEP.Secondary.Explosion.Spread = 0.1 -- Spread of explosion
--
-- SWEP Secondary 2 (Airboat Gun)
SWEP.Secondary.Airboat = {}
SWEP.Secondary.Airboat.Damage = 35 -- Damage for airboat gun
SWEP.Secondary.Airboat.Delay = 0.05 -- Delay for airboat gun
SWEP.Secondary.Airboat.Force = 1000000 -- Force of airboat gun
SWEP.Secondary.Airboat.ShotCount = 7 -- ShotCount for airboat gun
SWEP.Secondary.Airboat.Sound = "Airboat.FireGunRevDown" -- Sound for airboat gun
SWEP.Secondary.Airboat.Spread = 0.2 -- Spread of airboat gun
--
-- SWEP Secondary 3 (Combine Ball)
SWEP.Secondary.CombineBall = {}
SWEP.Secondary.CombineBall.Sound1 = "Weapon_AR2.Double"
SWEP.Secondary.CombineBall.Sound2 = "weapons/physcannon/energy_bounce1.wav" -- This doesn't have corresponding soundscript!
SWEP.Secondary.CombineBall.Speed = 5000
SWEP.Secondary.CombineBall.Delay = 0.5

-- Set kill icon
if CLIENT then
	killicon.AddFont(className, "HL2MPTypeDeath", "-", Color(255, 80, 0, 255))
	-- env_explosion is not well match
	killicon.AddFont("env_explosion", "HL2MPTypeDeath", "7", Color(255, 80, 0, 255))
end

--
-- Functions
function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:SetupDataTables()
	self:NetworkVar("Int", 0, "SecondaryType")
	self:NetworkVarNotify("SecondaryType", self.OnSecondaryTypeChanged)
	self:SetSecondaryType(initSecondaryType)
end

--
-- Primary Fire
function SWEP:PrimaryAttack()
	if not self:CanPrimaryAttack() then return end

	local bullet = {
		Damage = self.Primary.Damage,
		Force = self.Primary.Force,
		Num = self.Primary.ShotCount,
		Tracer = 0,
		AmmoType = self.Primary.Ammo,
		Spread = Vector(self.Primary.Spread * 0.1, self.Primary.Spread * 0.1, 0),
		Src = self:GetOwner():GetShootPos(),
		Dir = self:GetOwner():GetAimVector()
	}

	-- Remove RPG Missiles
	self:RemoveMissile()
	-- Fire bullet
	self:ShootEffects()
	self:GetOwner():FireBullets(bullet)
	EmitSound(Sound(self.Primary.Sound), self:GetOwner():GetPos(), self:EntIndex(), CHAN_WEAPON, self.Primary.Volume)

	-- Recoil (Player)
	if not self:GetOwner():IsNPC() and not self:GetOwner():IsNextBot() then
		local r1 = self.Primary.Recoil * -1
		local r2 = self.Primary.Recoil * math.random(-1, 1)
		self:GetOwner():ViewPunch(Angle(r1, r2, r1))
	end

	-- Set delay
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end

--
-- Secondary Fire
function SWEP:SecondaryAttack()
	if not self:CanSecondaryAttack() then return end

	if self:GetSecondaryType() == 0 then
		-- SecondaryType is Explosion
		local trace = self:GetOwner():GetEyeTrace()
		self:ShootEffects()

		if SERVER then
			local exp = ents.Create("env_explosion")
			exp:SetPos(trace.HitPos)
			exp:SetKeyValue("spawnflags", "892")
			exp:SetOwner(self:GetOwner())
			exp:Spawn()
			exp:SetKeyValue("iMagnitude", self.Secondary.Explosion.Magnitude)
			exp:Fire("Explode", 0, 0)
			EmitSound(Sound("weapon_AWP.Single"), self:GetOwner():GetPos(), self:EntIndex(), CHAN_WEAPON, 0.25)
			exp:Fire("Kill", 0, 0)
			self:SetNextPrimaryFire(CurTime() + self.Secondary.Explosion.Delay)
			self:SetNextSecondaryFire(CurTime() + self.Secondary.Explosion.Delay)
		end
	elseif self:GetSecondaryType() == 1 then
		-- SecondaryType is Airboat Gun
		local bullet = {
			Callback = function(attacker, trace, dmginfo)
				local g = math.random(1, 2)

				if g == 1 then
					dmginfo:SetDamageType(DMG_AIRBOAT)
				elseif g == 2 then
					dmginfo:SetDamageType(DMG_BLAST)
				end
			end,
			Damage = self.Secondary.Airboat.Damage,
			Force = self.Secondary.Airboat.Force,
			Num = self.Secondary.Airboat.ShotCount,
			Tracer = 1,
			TracerName = "AirboatGunHeavyTracer",
			AmmoType = self.Secondary.Ammo,
			Spread = Vector(self.Secondary.Airboat.Spread * 0.1, self.Secondary.Airboat.Spread * 0.1, 0),
			Src = self:GetOwner():GetShootPos(),
			Dir = self:GetOwner():GetAimVector()
		}

		-- Remove RPG Missiles
		self:RemoveMissile()
		-- Fire bullet
		self:ShootEffects()
		self:GetOwner():FireBullets(bullet)
		EmitSound(Sound(self.Secondary.Airboat.Sound), self:GetOwner():GetPos(), self:EntIndex(), CHAN_WEAPON, self.Secondary.Volume)

		-- Recoil
		if not self:GetOwner():IsNPC() and not self:GetOwner():IsNextBot() then
			local r1 = self.Secondary.Recoil * -1
			local r2 = self.Secondary.Recoil * math.random(-1, 1)
			self:GetOwner():ViewPunch(Angle(r1, r2, r1))
		end

		-- Set delay
		self:SetNextPrimaryFire(CurTime() + self.Secondary.Airboat.Delay)
		self:SetNextSecondaryFire(CurTime() + self.Secondary.Airboat.Delay)
	elseif self:GetSecondaryType() == 2 then
		-- SecondaryType is Combine Ball
		self:ShootEffects()
		EmitSound(Sound(self.Secondary.CombineBall.Sound1), self:GetOwner():GetPos(), self:EntIndex(), CHAN_WEAPON, self.Secondary.Volume)
		EmitSound(Sound(self.Secondary.CombineBall.Sound2), self:GetOwner():GetPos(), self:EntIndex(), CHAN_WEAPON, self.Secondary.Volume)

		if SERVER then
			local cblauncher = ents.Create("point_combine_ball_launcher")
			cblauncher:SetAngles(self:GetOwner():GetAngles())
			cblauncher:SetPos(self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 10)
			cblauncher:SetKeyValue("minspeed", self.Secondary.CombineBall.Speed)
			cblauncher:SetKeyValue("maxspeed", self.Secondary.CombineBall.Speed)
			cblauncher:SetKeyValue("ballradius", 15)
			cblauncher:SetKeyValue("ballcount", 1)
			cblauncher:SetKeyValue("maxballbounces", 7)
			cblauncher:SetKeyValue("launchconenoise", 0)
			cblauncher:SetNotSolid(true)
			cblauncher:SetMoveType(MOVETYPE_NONE)
			cblauncher:Spawn()
			cblauncher:Activate()
			cblauncher:Fire("LaunchBall")
			cblauncher:Fire("Kill", 0, 0)

			timer.Simple(0.01, function()
				if IsValid(self) and IsValid(self:GetOwner()) then
					for k, v in pairs(ents.FindInSphere(self:GetOwner():GetShootPos(), 85)) do
						if IsValid(v) and v:GetClass() == "prop_combine_ball" and not IsValid(v:SetOwner()) then
							v:SetOwner(self:GetOwner())
							v:GetPhysicsObject():AddGameFlag(FVPHYSICS_WAS_THROWN)
							v:Fire("Explode", 0, 5)
						end
					end
				end
			end)

			self:SetNextPrimaryFire(CurTime() + self.Secondary.CombineBall.Delay)
			self:SetNextSecondaryFire(CurTime() + self.Secondary.CombineBall.Delay)
		end
	end
end

function SWEP:Reload()
	if not IsFirstTimePredicted() or not self:GetOwner():KeyPressed(IN_RELOAD) or self:GetNextPrimaryFire() > CurTime() then return end
	local val = self:GetSecondaryType()
	val = val + 1

	if val == 3 then
		val = 0
	end

	self:SetSecondaryType(val)
end

function SWEP:RemoveMissile()
	local owner = self:GetOwner()
	local missiles = ents.FindInCone(owner:GetPos(), owner:GetAimVector(), 8000, math.cos(math.rad(2.2)))
	local d = DamageInfo()
	d:SetDamage(999)
	d:SetDamageType(DMG_MISSILEDEFENSE)
	d:SetAttacker(owner)
	d:SetInflictor(self)

	for k, v in pairs(missiles) do
		if v:GetClass():match("_missile") then
			v:TakeDamageInfo(d)
		end
	end
end

function SWEP:OnSecondaryTypeChanged(name, old, new)
	if new == 0 and CLIENT then
		notification.AddLegacy("Explosion Mode", NOTIFY_UNDO, 2)
		surface.PlaySound("buttons/button15.wav")
	elseif new == 1 and CLIENT then
		notification.AddLegacy("Airboat Gun Mode", NOTIFY_UNDO, 2)
		surface.PlaySound("buttons/button15.wav")
	elseif new == 2 and CLIENT then
		notification.AddLegacy("Combineball Mode", NOTIFY_UNDO, 2)
		surface.PlaySound("buttons/button15.wav")
	end
end

function SWEP:FireAnimationEvent(pos, ang, event, options)
	-- Disable Brass Shell Ejection
	if event == 6001 then return true end
end

--
-- Save SWEP Secondary Type and Load it after level transition
--
-- 1. saverestore
-- Only care about actual players because NPC doesn't do secondary fire I guess
--[[
saverestore.AddSaveHook("SCAdminPistolState", function(save)
	if CLIENT then return end
	tbl = {}
	for k, v in ipairs(player.GetHumans()) do
		if IsValid(v:GetWeapon(className)) then
			tbl[v:AccountID()] = v:GetWeapon(className):GetSecondaryType()
		end
	end
	print("saverestore savehook")
	PrintTable(tbl)
	saverestore.WriteTable(tbl, save)
end)
function SWEP:OnRestore()
	saverestore.AddRestoreHook("SCAdminPistolState", function(save)
		if CLIENT then return end
		tbl = saverestore.ReadTable(save)
		print("onrestore saverestore restorehook")
		PrintTable(tbl)
		for k, v in pairs(tbl) do
			for _, ply in ipairs(player.GetHumans()) do
				local wpn = vv:GetWeapon(className)
				if IsValid(wpn) then
					wpn:SetSecondaryType(v)
				end
			end
		end
	end)
end
saverestore.AddRestoreHook("SCAdminPistolState", function(save)
	if CLIENT then return end
	tbl = saverestore.ReadTable(save)
	print("saverestore restorehook")
	PrintTable(tbl)
	for k, v in pairs(tbl) do
		for _, ply in ipairs(player.GetHumans()) do
			local wpn = vv:GetWeapon(className)
			if IsValid(wpn) then
				wpn:SetSecondaryType(v)
			end
		end
	end
end)
]]
-- 2. Shutdown & PlayerInitialSpawn
--[[
hook.Add("ShutDown", "SCAdminPistolState_SD", function()
	tbl = {}
	for k, v in ipairs(player.GetHumans()) do
		if IsValid(v:GetWeapon(className)) then
			tbl[v:AccountID()] = v:GetWeapon(className):GetSecondaryType()
		end
	end
	print("shutdown")
	PrintTable(tbl)
	tblString = util.TableToKeyValues(tbl, "ap")
	file.Write("scdata.txt", tblString)
end)
hook.Add("PlayerInitialSpawn", "SCAdminPistolState_PIS", function(ply, transition)
	if not transition then return end
	tblString = file.Read("scdata.txt")
end)
]]--
