
// Variables that are used on both client and server

SWEP.Author			= "Kafouille"
SWEP.Contact		= ""
SWEP.Purpose		= "Making holes in various materials"
SWEP.Instructions	= "ACF AMR"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false

SWEP.ViewModel			= "models/weapons/v_sniper.mdl"
SWEP.WorldModel			= "models/weapons/w_sniper.mdl"

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 25
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "CombineCannon"
SWEP.UserData = {}
	SWEP.UserData["Id"] = "14.5mmMG"
	SWEP.UserData["Type"] = "AP"
	SWEP.UserData["PropLenght"] = 6
	SWEP.UserData["ProjLenght"] = 10
	SWEP.UserData["Data5"] = 0.6
	SWEP.UserData["Data6"] = 0
	SWEP.UserData["Data7"] = 0
	SWEP.UserData["Data8"] = 0
	SWEP.UserData["Data9"] = 0
	SWEP.UserData["Data10"] = 0

SWEP.Inaccuracy				= 5								--Base spray

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ZoomTime				= 0.25
SWEP.IronSightsPos 			= Vector( -5.85 , -7 , 1.2 )		--Lateral, Depth, Vertical
SWEP.IronSightsAng 			= Vector( 0, -1, 0 )			--Pitch, Yaw, Roll
SWEP.NextSecondaryAttack 	= 0

SWEP.IronSightZoom 			= 1.2
SWEP.ScopeZooms				= {2,4,8}
SWEP.UseScope				= true
SWEP.ScopeScale 			= 0.8
SWEP.DrawParabolicSights	= true

function SWEP:Initialize()

	self.ConvertData = ACF.RoundTypes[self.UserData["Type"]]["convert"]		--Call the correct function for this round type to convert user input data into ballistics data
	self.BulletData = self:ConvertData( self.UserData )	--Put the results into the BulletData table
		
	if ( SERVER ) then 
		self:SetWeaponHoldType("ar2")
		self.Owner:GiveAmmo( self.Primary.DefaultClip, self.Primary.Ammo )	
	end
	
	if CLIENT then											--I ripped that off Jaanus wich ripped it of Tera_Bonita wich ripped it of Nigh Eagle, let's contine the big old rippoff chain

		-- We need to get these so we can scale everything to the player's current resolution.
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()
		
		-- The following code is only slightly riped off from Night Eagle
		-- These tables are used to draw things like scopes and crosshairs to the HUD.
		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
				
		self.ParaScopeTable = {}
		self.ParaScopeTable.x = 0.5*iScreenWidth - self.ScopeTable.l
		self.ParaScopeTable.y = 0.5*iScreenHeight - self.ScopeTable.l
		self.ParaScopeTable.w = 2*self.ScopeTable.l
		self.ParaScopeTable.h = 2*self.ScopeTable.l
		
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.CrossHairTable = {}
		self.CrossHairTable.x11 = 0
		self.CrossHairTable.y11 = 0.5*iScreenHeight
		self.CrossHairTable.x12 = iScreenWidth
		self.CrossHairTable.y12 = self.CrossHairTable.y11
		self.CrossHairTable.x21 = 0.5*iScreenWidth
		self.CrossHairTable.y21 = 0
		self.CrossHairTable.x22 = 0.5*iScreenWidth
		self.CrossHairTable.y22 = iScreenHeight
		
	end
	
	self.ScopeZooms 		= self.ScopeZooms or {5}
	if self.UseScope then
		self.CurScopeZoom	= 1 -- Another index, this time for ScopeZooms
	end
	
	self:ResetVars()

end

function SWEP:PrimaryAttack()

	if !self:CanPrimaryAttack() then return end
	
	local PlayerAim = self.Owner:GetAimVector()
	local PlayerPos = self.Owner:GetShootPos()
	self:EmitSound("weapons/AMR/sniper_fire.wav")
	
	local MuzzlePos = PlayerPos
	local MuzzleVec = PlayerAim
	local Speed = ACF_MuzzleVelocity( self.BulletData["PropMass"], self.BulletData["ProjMass"], self.Caliber )
	local Modifiers = self:CalculateModifiers()
	local Recoil = (self.BulletData["ProjMass"] * Speed^2)/1000
	self:ApplyRecoil(math.min(Recoil*Modifiers,50))
	
	if CLIENT then return end
			
	if ( self.RoundType != "Empty" ) then

		local Inaccuracy = VectorRand() / 360 * self.Inaccuracy * Modifiers
		local Flight = (MuzzleVec+Inaccuracy):GetNormalized() * Speed * 39.37
		
		self.BulletData["Pos"] = MuzzlePos
		self.BulletData["Flight"] = (PlayerAim+Inaccuracy):GetNormalized() * Speed * 39.37 + self:GetVelocity()
		self.BulletData["Owner"] = self.Owner
		self.BulletData["Gun"] = self.Owner
		self.CreateShell = ACF.RoundTypes[self.BulletData["Type"]]["create"]
		self:CreateShell( self.BulletData )
		
		self:MuzzleEffect( MuzzlePos , MuzzleVec:Angle() )
		self:TakePrimaryAmmo(1)
	
	end
	
end

function SWEP:MuzzleEffect( )
 
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
end

function SWEP:ApplyRecoil(recoil)

	if self.OwnerIsNPC or (SERVER and not self.Owner:IsListenServerHost()) then return end
	
	local EyeAng = Angle(
	recoil*math.Rand(-4,-0.7), -- Up/Down recoil
	recoil*math.Rand(-0.7,0.7), -- Left/Right recoil
	0)
	
	-- Punch the player's view
	self.Owner:ViewPunch(1.3*EyeAng) -- This smooths out the player's screen movement when recoil is applied
	self.Owner:SetEyeAngles(self.Owner:EyeAngles() + EyeAng)
	
end

-- Acuracy/recoil modifiers
function SWEP:CalculateModifiers()

	local modifier = 1

	if self.Owner:KeyDown(IN_FORWARD | IN_BACK | IN_MOVELEFT | IN_MOVERIGHT) then
		modifier = modifier*10
	end
	
	if not self.Owner:IsOnGround() then
		modifier = modifier*10 --You can't be jumping and crouching at the same time, so return here
	return modifier end
	
	if self.Owner:Crouching() then 
		modifier = modifier*0.3
	end
	
	if self.Weapon:GetNetworkedBool("Ironsights", false) then 
		modifier = modifier*0.2
	end
	
	return modifier

end

---------------------------------------------------------
----FireMode/IronSight Helper Functions----
---------------------------------------------------------

function SWEP:SetIronsights(b,player)

if CLIENT or (not player) or player:IsNPC() then return end

	-- Send the ironsight state to the client, so it can adjust the player's FOV/Viewmodel pos accordingly
	self.Weapon:SetNetworkedBool("Ironsights", b)
	
	if self.UseScope then -- If we have a scope, use that instead of ironsights
		if b then
			--Activate the scope after we raise the rifle
			timer.Simple(self.ZoomTime, self.SetScope, self, true, player)
		else
			self:SetScope(false, player)
		end
	end

end

function SWEP:SetScope(b,player)

	if CLIENT or (!player) or player:IsNPC() then return end

	local PlaySound = b~= self.Weapon:GetNetworkedBool("Scope", not b) -- Only play zoom sounds when chaning in/out of scope mode
	self.CurScopeZoom = 1 -- Just in case...
	self.Weapon:SetNetworkedFloat("ScopeZoom",self.ScopeZooms[self.CurScopeZoom])

	if b then 
		player:DrawViewModel(false)
	else
		player:DrawViewModel(true)
	end
	
	-- Send the scope state to the client, so it can adjust the player's fov/HUD accordingly
	self.Weapon:SetNetworkedBool("Scope", b) 

end

function SWEP:Think()	

	if self.Owner:KeyDown(IN_USE) and !self.Loaded then
		self:CrateReload()
	end
	
	if not self.Owner:IsOnGround() then
		self:ResetVars()
	end
	if self.OwnerIsNPC or (SERVER and not self.Owner:IsListenServerHost()) or not self.Weapon:GetNetworkedBool("Ironsights", false) then return end
	
	local Modifiers = self:CalculateModifiers() * self.CurScopeZoom
	
	local EyeAng = Angle(
	Modifiers*math.Rand(0.1,-0.1), -- Up/Down shake
	Modifiers*math.Rand(0.1,-0.1), -- Left/Right shake
	0)
	
	-- Punch the player's view
	self.Owner:ViewPunch(1.3*EyeAng) -- This smooths out the player's screen movement when recoil is applied
	self.Owner:SetEyeAngles(self.Owner:EyeAngles() + EyeAng)
	
	self:NextThink( CurTime()+0.1 )
	
end

-- Secondary attack is used to set ironsights/change firemodes
-- TODO: clean this function up
function SWEP:SecondaryAttack()

	if self.NextSecondaryAttack > CurTime() or self.OwnerIsNPC then return end
	self.NextSecondaryAttack = CurTime() + 0.3
	
	if self.Owner:KeyDown(IN_USE) then
	
	local NumberOfFireModes = table.getn(self.AvailableFireModes)
	if NumberOfFireModes < 2 then return end -- We need at least 2 firemodes to change firemodes!
	
		self:RevertFireMode()
		self.CurFireMode = math.fmod(self.CurFireMode, NumberOfFireModes) + 1 -- This just cycles through all available fire modes
		self:SetFireMode()
		
		self.Weapon:EmitSound(sndCycleFireMode)
	-- All of this is more complicated than it needs to be. Oh well.
	elseif self.IronSightsPos then
	
		local NumberOfScopeZooms = table.getn(self.ScopeZooms)

		if self.UseScope and self.Weapon:GetNetworkedBool("Scope", false) then
		
			self.CurScopeZoom = self.CurScopeZoom + 1
			if self.CurScopeZoom <= NumberOfScopeZooms then	
				self.Weapon:SetNetworkedFloat("ScopeZoom",self.ScopeZooms[self.CurScopeZoom])					
			else
				self:SetIronsights(false,self.Owner)
				self.CurScopeZoom = 1
			end		
		else
			local bIronsights = not self.Weapon:GetNetworkedBool("Ironsights", false)
			self:SetIronsights(bIronsights,self.Owner)	
		end	
	end	
end

function SWEP:Reload()
	
	if  ( self.Weapon:Clip1() < self.Primary.ClipSize && self.Owner:GetAmmoCount( self.Primary.Ammo ) > 0 ) then
	
		self.Weapon:EmitSound("weapons/AMR/sniper_reload.wav",350,110)
		self.Weapon:DefaultReload(ACT_VM_RELOAD)	
		self:SetIronsights(false,self.Owner)
		
	end
	
end

function SWEP:CrateReload()

	local ViewTr = { }
		ViewTr.start = self.Owner:GetShootPos()
		ViewTr.endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector()*128
		ViewTr.filter = {self.Owner, self.Weapon}
	local ViewRes = util.TraceLine(ViewTr)					--Trace to see if it will hit anything
	
	if SERVER then	
		local AmmoEnt = ViewRes.Entity
		if AmmoEnt and AmmoEnt:IsValid() and AmmoEnt.Ammo > 0 and AmmoEnt.RoundId == "14.5mmMG" then
			local CurAmmo = self.Owner:GetAmmoCount( self.Primary.Ammo )
			local Transfert = math.min(AmmoEnt.Ammo, self.Primary.DefaultClip-CurAmmo)
			AmmoEnt.Ammo = AmmoEnt.Ammo - Transfert
			self.Owner:GiveAmmo( Transfert, self.Primary.Ammo )
			
			self.BulletData = AmmoEnt.BulletData
			
			return true	
		end
	end
	
end

/*---------------------------------------------------------
   Name: ShouldDropOnDie
   Desc: Should this weapon be dropped when its owner dies?
---------------------------------------------------------*/
function SWEP:ShouldDropOnDie()
	return true
end

function SWEP:ResetVars()

	self.NextSecondaryAttack = 0
	
	self.bLastIron = false
	self.Weapon:SetNetworkedBool("Ironsights", false)
	
	if self.UseScope then
		self.CurScopeZoom = 1
		self.fLastScopeZoom = 1
		self.bLastScope = false
		self.Weapon:SetNetworkedBool("Scope", false)
		self.Weapon:SetNetworkedBool("ScopeZoom", self.ScopeZooms[1])
	end
	
	if self.Owner then
		self.OwnerIsNPC = self.Owner:IsNPC() -- This ought to be better than getting it every time we fire
		self:SetIronsights(false,self.Owner)
		self:SetScope(false,self.Owner)
	end
	
end

-- We need to call ResetVars() on these functions so we don't whip out a weapon with scope mode or insane recoil right of the bat or whatnot
function SWEP:Holster(wep) 		self:ResetVars() return true end
function SWEP:Equip(NewOwner) 	self:ResetVars() return true end
function SWEP:OnRemove() 		self:ResetVars() return true end
function SWEP:OnDrop() 			self:ResetVars() return true end
function SWEP:OwnerChanged() 	self:ResetVars() return true end
function SWEP:OnRestore() 		self:ResetVars() return true end
