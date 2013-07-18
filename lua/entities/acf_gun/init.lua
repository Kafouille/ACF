AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
		
	self.ReloadTime = 1
	self.Ready = true
	self.Firing = nil
	self.Reloading = nil
	self.NextFire = 0
	self.LastSend = 0
	self.Owner = self
	
	self.IsMaster = true
	self.AmmoLink = {}
	self.CurAmmo = 1
	self.Sequence = 1
	
	self.BulletData = {}
		self.BulletData["Type"] = "Empty"
		self.BulletData["PropMass"] = 0
		self.BulletData["ProjMass"] = 0
	
	self.Inaccuracy 	= 1
	
	self.Inputs = Wire_CreateInputs( self, { "Fire", "Unload", "Reload" } )
	self.Outputs = WireLib.CreateSpecialOutputs( self, { "Ready", "AmmoCount", "Entity", "Shots Left", "Fire Rate", "Muzzle Weight", "Muzzle Velocity" }, { "NORMAL" , "NORMAL" , "ENTITY", "NORMAL", "NORMAL", "NORMAL", "NORMAL" } )
	Wire_TriggerOutput(self, "Entity", self)
	self.WireDebugName = "ACF Gun"

end  

function MakeACF_Gun(Owner, Pos, Angle, Id)

	if not Owner:CheckLimit("_acf_gun") then return false end
	
	local Gun = ents.Create("ACF_Gun")
	local List = list.Get("ACFEnts")
	local Classes = list.Get("ACFClasses")
	if not Gun:IsValid() then return false end
	Gun:SetAngles(Angle)
	Gun:SetPos(Pos)
	Gun:Spawn()

	Gun:SetPlayer(Owner)
	Gun.Owner = Owner
	Gun.Id = Id
	Gun.Caliber	= List["Guns"][Id]["caliber"]
	Gun.Model = List["Guns"][Id]["model"]
	Gun.Mass = List["Guns"][Id]["weight"]
	Gun.Class = List["Guns"][Id]["gunclass"]
	-- Custom BS for karbine. Per Gun ROF.
	Gun.PGRoFmod = 1
	if(List["Guns"][Id]["rofmod"]) then
		Gun.PGRoFmod = math.max(0, List["Guns"][Id]["rofmod"])
	end
	-- Custom BS for karbine. Magazine Size, Mag reload Time
	Gun.CurrentShot = 0
	Gun.MagSize = 1
	if(List["Guns"][Id]["magsize"]) then
		Gun.MagSize = math.max(Gun.MagSize, List["Guns"][Id]["magsize"])
	end
	Gun.MagReload = 0
	if(List["Guns"][Id]["magreload"]) then
		Gun.MagReload = math.max(Gun.MagReload, List["Guns"][Id]["magreload"])
	end
	-- self.CurrentShot, self.MagSize, self.MagReload
	
	Gun:SetNWString( "Class" , Gun.Class )
	Gun:SetNWString( "ID" , Gun.Id )
	Gun.Muzzleflash = Classes["GunClass"][Gun.Class]["muzzleflash"]
	Gun.RoFmod = Classes["GunClass"][Gun.Class]["rofmod"]
	Gun.Sound = Classes["GunClass"][Gun.Class]["sound"]
	Gun:SetNWString( "Sound", Gun.Sound )
	Gun.Inaccuracy = Classes["GunClass"][Gun.Class]["spread"]
	Gun:SetModel( Gun.Model )	
	
	Gun:PhysicsInit( SOLID_VPHYSICS )      	
	Gun:SetMoveType( MOVETYPE_VPHYSICS )     	
	Gun:SetSolid( SOLID_VPHYSICS )
	
	local Muzzle = Gun:GetAttachment( Gun:LookupAttachment( "muzzle" ) )
	Gun.Muzzle = Gun:WorldToLocal(Muzzle.Pos)
	
	/*local Height = 30		--Damn you Garry
	local Width = 30
	local length = 105
	local Scale = Gun.Caliber/30
	local VertexFile = file.Read(Gun.Class..".txt", "DATA")
	local PerVertex = string.Explode( "v", VertexFile )
	local Import = {}
	for Key, Value in pairs(PerVertex) do
		local Table = string.Explode( " ", Value )
		local Vec = Vector(tonumber(Table[2],10),tonumber(Table[4],10),tonumber(Table[3],10))
		if Vec != Vector(1,1,1) then
			table.insert(Import, Vertex( Vec*Scale,0,0 ) )
		end
	end
	PrintTable(Import)  
	Gun:SetNWFloat( "Scale" , Scale )
	
	local p1 = Vector(length/-2*Scale,Width/-2*Scale,Height/-2*Scale)
	local p2 = Vector(length/-2*Scale,Width/2*Scale,Height/-2*Scale)
	local p3 = Vector(length/2*Scale,Width/2*Scale,Height/-2*Scale)
	local p4 = Vector(length/2*Scale,Width/-2*Scale,Height/-2*Scale)
	local p5 = Vector(length/-2*Scale,Width/-2*Scale,Height/2*Scale)
	local p6 = Vector(length/-2*Scale,Width/2*Scale,Height/2*Scale)
	local p7 = Vector(length/2*Scale,Width/2*Scale,Height/2*Scale)
	local p8 = Vector(length/2*Scale,Width/-2*Scale,Height/2*Scale)
	
	local Vertices = {}
	table.Add( Vertices, MeshQuad( p5, p6, p7, p8, 0 ) )
	table.Add( Vertices, MeshQuad( p4, p3, p2, p1, 0 ) )
	table.Add( Vertices, MeshQuad( p8, p7, p3, p4, 0 ) )
	table.Add( Vertices, MeshQuad( p6, p5, p1, p2, 0 ) )
	table.Add( Vertices, MeshQuad( p5, p8, p4, p1, 0 ) )
	table.Add( Vertices, MeshQuad( p7, p6, p2, p3, 0 ) )
	
	PrintTable(Vertices) 
	Gun:PhysicsFromMesh( Import )*/

	local phys = Gun:GetPhysicsObject()  	
	if (phys:IsValid()) then 
		phys:SetMass( Gun.Mass ) 
	end 
	
	Owner:AddCount("_acf_gun", Gun)
	Owner:AddCleanup( "acfmenu", Gun )
	ACF_Activate(Gun, 0)
	return Gun
end
list.Set( "ACFCvars", "acf_gun" , {"id"} )
duplicator.RegisterEntityClass("acf_gun", MakeACF_Gun, "Pos", "Angle", "Id")

function ENT:Link( Target )

	-- Don't link if it's not an ammo crate
	if not IsValid( Target ) or Target:GetClass() ~= "acf_ammo" then
		return false, "Guns can only be linked to ammo crates!"
	end
	
	-- Don't link if it's not the right ammo type
	if Target.BulletData["Id"] ~= self.Id then
		return false, "Wrong ammo type!"
	end
	
	-- Don't link if it's a refill crate
	if Target.BulletData["RoundType"] == "Refill" then
		return false, "Refill crates cannot be linked!"
	end
	
	-- Don't link if it's already linked
	for k, v in pairs( self.AmmoLink ) do
		if v == Target then
			return false, "That crate is already linked to this gun!"
		end
	end
	
	table.insert( self.AmmoLink, Target )
	table.insert( Target.Master, self )
	
	if self.BulletData["Type"] == "Empty" and Target["Load"] then
		self:UnloadAmmo()
	end
	
	self.ReloadTime = ( ( Target.BulletData["RoundVolume"] / 500 ) ^ 0.60 ) * self.RoFmod * self.PGRoFmod
	self.RateOfFire = 60 / self.ReloadTime
	Wire_TriggerOutput( self, "Fire Rate", self.RateOfFire )
	Wire_TriggerOutput( self, "Muzzle Weight", math.floor( Target.BulletData["ProjMass"] * 1000 ) )
	Wire_TriggerOutput( self, "Muzzle Velocity", math.floor( Target.BulletData["MuzzleVel"] * ACF.VelScale ) )

	return true, "Link successful!"
	
end

function ENT:Unlink( Target )

	local Success = false
	for Key,Value in pairs(self.AmmoLink) do
		if Value == Target then
			table.remove(self.AmmoLink,Key)
			Success = true
		end
	end
	
	if Success then
		return true, "Unlink successful!"
	else
		return false, "That entity is not linked to this gun!"
	end
	
end

local WireTable = { "gmod_wire_adv_pod", "gmod_wire_pod", "gmod_wire_keyboard", "gmod_wire_joystick", "gmod_wire_joystick_multi" }

function ENT:GetUser( inp )
	if inp:GetClass() == "gmod_wire_adv_pod" then
		if inp.Pod then
			return inp.Pod:GetDriver()
		end
	elseif inp:GetClass() == "gmod_wire_pod" then
		if inp.Pod then
			return inp.Pod:GetDriver()
		end
	elseif inp:GetClass() == "gmod_wire_keyboard" then
		if inp.ply then
			return inp.ply 
		end
	elseif inp:GetClass() == "gmod_wire_joystick" then
		if inp.Pod then 
			return inp.Pod:GetDriver()
		end
	elseif inp:GetClass() == "gmod_wire_joystick_multi" then
		if inp.Pod then 
			return inp.Pod:GetDriver()
		end
	elseif inp:GetClass() == "gmod_wire_expression2" then
		if inp.Inputs["Fire"] then
			return self:GetUser(inp.Inputs["Fire"].Src) 
		elseif inp.Inputs["Shoot"] then
			return self:GetUser(inp.Inputs["Shoot"].Src) 
		elseif inp.Inputs then
			for _,v in pairs(inp.Inputs) do
				if table.HasValue(WireTable, v.Src:GetClass()) then
					return self:GetUser(v.Src) 
				end
			end
		end
	end
	return inp.Owner or inp:GetOwner()
	
end

function ENT:TriggerInput( iname , value )
	
	if (iname == "Unload" and value > 0) then
		self:UnloadAmmo()
	elseif ( iname == "Fire" and value > 0 and ACF.GunfireEnabled ) then
		if self.NextFire < CurTime() then
			self.User = self:GetUser(self.Inputs["Fire"].Src)
			if not IsValid(self.User) then self.User = self.Owner end
			self:FireShell()
			self:Think()
		end
		self.Firing = true
	elseif ( iname == "Fire" and value <= 0 ) then
		self.Firing = false
	elseif ( iname == "Reload" and value ~= 0 ) then
		self.Reloading = true
	end		
end

function RetDist( enta, entb )
	if not ((enta and enta:IsValid()) or (entb and entb:IsValid())) then return 0 end
	disp = enta:GetPos() - entb:GetPos()
	dist = math.sqrt( disp.x * disp.x + disp.y * disp.y + disp.z * disp.z )
	return dist
end

function ENT:Think()

	local Time = CurTime()
	if self.LastSend+1 <= Time then
		local Ammo = 0
		for Key,AmmoEnt in pairs(self.AmmoLink) do
			if AmmoEnt and AmmoEnt:IsValid() and AmmoEnt["Load"] then
				if RetDist( self, AmmoEnt ) < 512 then
					Ammo = Ammo + (AmmoEnt.Ammo or 0)
				else
					self:Unlink( AmmoEnt )
					soundstr =  "physics/metal/metal_box_impact_bullet" .. tostring(math.random(1, 3)) .. ".wav"
					self:EmitSound(soundstr,500,100)
				end
			end
		end
		Wire_TriggerOutput(self, "AmmoCount", Ammo)
		if( self.MagSize ) then
			Wire_TriggerOutput(self, "Shots Left", self.MagSize - self.CurrentShot)
		else
			Wire_TriggerOutput(self, "Shots Left", 1)
		end
		
		self:SetNetworkedBeamString("GunType",self.Id)
		self:SetNetworkedBeamInt("Ammo",Ammo)
		self:SetNetworkedBeamString("Type",self.BulletData["Type"])
		self:SetNetworkedBeamInt("Mass",self.BulletData["ProjMass"]*100)
		self:SetNetworkedBeamInt("Propellant",self.BulletData["PropMass"]*1000)
		self:SetNetworkedBeamInt("FireRate",self.RateOfFire)
		
		self.LastSend = Time
	
	end
	
	if self.NextFire <= Time then
		self.Ready = true
		Wire_TriggerOutput(self, "Ready", 1)
		if self.Firing then
			self:FireShell()	
		elseif self.Reloading then
			self:ReloadMag()
		end
	end

	self:NextThink(Time)
	return true
	
end

function ENT:CheckWeight()
	local mass = self:GetPhysicsObject():GetMass()
	local maxmass = GetConVarNumber("bnk_maxweight") * 1000 + 999
	
	local chk = false
	
	local allents = constraint.GetAllConstrainedEntities( self )
	for _, ent in pairs(allents) do
		if (ent and ent:IsValid() and not ent:IsPlayer() and not (ent == self)) then
			local phys = ent:GetPhysicsObject()
			if(phys:IsValid()) then
				mass = mass + phys:GetMass()
			end
		end
	end
	
	if( mass < maxmass ) then
		chk = true
	end
	
	return chk
end

function ENT:ReloadMag()
	if(self.IsUnderWeight == nil) then
		self.IsUnderWeight = true
		if(ISBNK) then
			self.IsUnderWeight = self:CheckWeight()
		end
	end
	if ( (self.CurrentShot > 0) and self.IsUnderWeight and self.Ready and self:GetPhysicsObject():GetMass() >= self.Mass and not self:GetParent():IsValid() ) then
		if ( ACF.RoundTypes[self.BulletData["Type"]] ) then		--Check if the roundtype loaded actually exists
			self:LoadAmmo(self.MagReload, false)	
			self:EmitSound("weapons/357/357_reload4.wav",500,100)
			self.CurrentShot = 0
			Wire_TriggerOutput(self, "Ready", 0)
		else
			self.CurrentShot = 0
			self.Ready = false
			Wire_TriggerOutput(self, "Ready", 0)
			self:LoadAmmo(false, true)	
		end
	end
end

function ENT:FireShell()
	
	local CanDo = hook.Run("ACF_FireShell", self, self.BulletData )
	if CanDo == false then return end
	if(self.IsUnderWeight == nil) then
		self.IsUnderWeight = true
		if(ISBNK) then
			self.IsUnderWeight = self:CheckWeight()
		end
	end
	
	local bool = true
	if(ISSITP) then
		if(self.sitp_spacetype != "space" and self.sitp_spacetype != "planet") then
			bool = false
		end
		if(self.sitp_core == false) then
			bool = false
		end
	end
	if ( bool and self.IsUnderWeight and self.Ready and self:GetPhysicsObject():GetMass() >= self.Mass and not self:GetParent():IsValid() ) then
		Blacklist = {}
		if not ACF.AmmoBlacklist[self.BulletData["Type"]] then
			Blacklist = {}
		else
			Blacklist = ACF.AmmoBlacklist[self.BulletData["Type"]]	
		end
		if ( ACF.RoundTypes[self.BulletData["Type"]] and !table.HasValue( Blacklist, self.Class ) ) then		--Check if the roundtype loaded actually exists
		
			local MuzzlePos = self:LocalToWorld(self.Muzzle)
			local MuzzleVec = self:GetForward()
			local SpreadScale = ACF.SpreadScale
			local IaccMult = 1
			if (self.ACF.Health and self.ACF.MaxHealth) then
				IaccMult = math.Clamp(((1 - SpreadScale) / (0.5)) * ((self.ACF.Health/self.ACF.MaxHealth) - 1) + 1, 1, SpreadScale)
			end
			local Inaccuracy = (VectorRand() / 360 * self.Inaccuracy) * IaccMult
			
			self:MuzzleEffect( MuzzlePos , MuzzleVec )
			
			self.BulletData["Pos"] = MuzzlePos
			self.BulletData["Flight"] = (MuzzleVec+Inaccuracy):GetNormalized() * self.BulletData["MuzzleVel"] * 39.37 + self:GetVelocity()
			self.BulletData["Owner"] = self.User
			self.BulletData["Gun"] = self
			self.CreateShell = ACF.RoundTypes[self.BulletData["Type"]]["create"]
			self:CreateShell( self.BulletData )
		
			local Gun = self:GetPhysicsObject()  	
			if (Gun:IsValid()) then 	
				Gun:ApplyForceCenter( self:GetForward() * -(self.BulletData["ProjMass"] * self.BulletData["MuzzleVel"] * 39.37 + self.BulletData["PropMass"] * 3000 * 39.37))			
			end
			
			self.Ready = false
			self.CurrentShot = math.min(self.CurrentShot + 1, self.MagSize)
			if((self.CurrentShot >= self.MagSize) and (self.MagSize > 1)) then
				self:LoadAmmo(self.MagReload, false)	
				self:EmitSound("weapons/357/357_reload4.wav",500,100)
				self.CurrentShot = 0
			else
				self:LoadAmmo(false, false)	
			end
			Wire_TriggerOutput(self, "Ready", 0)
		else
			self.CurrentShot = 0
			self.Ready = false
			Wire_TriggerOutput(self, "Ready", 0)
			self:LoadAmmo(false, true)	
		end
	end
	
end

function ENT:CreateShell()
	--You overwrite this with your own function, defined in the ammo definition file
end

function ENT:FindNextCrate()

	local MaxAmmo = table.getn(self.AmmoLink)
	local AmmoEnt = nil
	local i = 0
	
	while i <= MaxAmmo and not (AmmoEnt and AmmoEnt:IsValid() and AmmoEnt.Ammo > 0) do
		
		self.CurAmmo = self.CurAmmo + 1
		if self.CurAmmo > MaxAmmo then self.CurAmmo = 1 end
		
		AmmoEnt = self.AmmoLink[self.CurAmmo]
		if AmmoEnt and AmmoEnt:IsValid() and AmmoEnt.Ammo > 0 and AmmoEnt["Load"] then
			return AmmoEnt
		end
		AmmoEnt = nil
		
		i = i + 1
	end
	
	return false
end

function ENT:LoadAmmo( AddTime, Reload )

	local AmmoEnt = self:FindNextCrate()
	
	if AmmoEnt then
		AmmoEnt.Ammo = AmmoEnt.Ammo - 1
		self.BulletData = AmmoEnt.BulletData
		self.BulletData["Crate"] = AmmoEnt:EntIndex()
		
		self.ReloadTime = ((self.BulletData["RoundVolume"]/500)^0.60)*self.RoFmod*self.PGRoFmod
		Wire_TriggerOutput(self, "Loaded", self.BulletData["Type"])
		
		self.RateOfFire = (60/self.ReloadTime)
		Wire_TriggerOutput(self, "Fire Rate", self.RateOfFire)
		Wire_TriggerOutput(self, "Muzzle Weight", math.floor(self.BulletData["ProjMass"]*1000) )
		Wire_TriggerOutput(self, "Muzzle Velocity", math.floor(self.BulletData["MuzzleVel"]*ACF.VelScale) )
		
		self.NextFire = CurTime() + self.ReloadTime
		if AddTime then
			self.NextFire = CurTime() + self.ReloadTime + AddTime
		end
		if Reload then
			self:ReloadEffect()
		end
		self:Think()
		return true	
	else
		self.BulletData = {}
			self.BulletData["Type"] = "Empty"
			self.BulletData["PropMass"] = 0
			self.BulletData["ProjMass"] = 0
		
		self:EmitSound("weapons/pistol/pistol_empty.wav",500,100)
		Wire_TriggerOutput(self, "Loaded", "Empty")
				
		self.NextFire = CurTime()+0.5
		self:Think()
	end
	return false
	
end

function ENT:UnloadAmmo()
	if not self.BulletData or not self.BulletData["Crate"] then return end -- Explanation: http://www.youtube.com/watch?v=dwjrui9oCVQ
	local Crate = Entity( self.BulletData["Crate"] )
	if Crate and Crate:IsValid() and self.BulletData["Type"] == Crate.BulletData["Type"] then
		Crate.Ammo = Crate.Ammo+1
	end
	
	self.Ready = false
	Wire_TriggerOutput(self, "Ready", 0)
	self:LoadAmmo( math.min(self.ReloadTime,math.max(self.ReloadTime - (self.NextFire - CurTime()),0) )	, true )
	self:EmitSound("weapons/357/357_reload4.wav",500,100)

end

function ENT:MuzzleEffect()
	
	local Effect = EffectData()
		Effect:SetEntity( self )
		Effect:SetScale( self.BulletData["PropMass"] )
		Effect:SetMagnitude( self.ReloadTime )
		Effect:SetSurfaceProp( ACF.RoundTypes[self.BulletData["Type"]]["netid"]  )	--Encoding the ammo type into a table index
	util.Effect( "ACF_MuzzleFlash", Effect, true, true )

end

function ENT:ReloadEffect()

	local Effect = EffectData()
		Effect:SetEntity( self )
		Effect:SetScale( 0 )
		Effect:SetMagnitude( self.ReloadTime )
		Effect:SetSurfaceProp( ACF.RoundTypes[self.BulletData["Type"]]["netid"]  )	--Encoding the ammo type into a table index
	util.Effect( "ACF_MuzzleFlash", Effect, true, true )
	
end

function ENT:PreEntityCopy()

	local info = {}
	local entids = {}
	for Key, Value in pairs(self.AmmoLink) do					--First clean the table of any invalid entities
		if not Value:IsValid() then
			table.remove(self.AmmoLink, Value)
		end
	end
	for Key, Value in pairs(self.AmmoLink) do					--Then save it
		table.insert(entids, Value:EntIndex())
	end
	info.entities = entids
	if info.entities then
		duplicator.StoreEntityModifier( self, "ACFAmmoLink", info )
	end
	
	//Wire dupe info
	local DupeInfo = WireLib.BuildDupeInfo(self)
	if(DupeInfo) then
		duplicator.StoreEntityModifier(self,"WireDupeInfo",DupeInfo)
	end
	
end

function ENT:PostEntityPaste( Player, Ent, CreatedEntities )

	if (Ent.EntityMods) and (Ent.EntityMods.ACFAmmoLink) and (Ent.EntityMods.ACFAmmoLink.entities) then
		local AmmoLink = Ent.EntityMods.ACFAmmoLink
		if AmmoLink.entities and table.Count(AmmoLink.entities) > 0 then
			for _,AmmoID in pairs(AmmoLink.entities) do
				local Ammo = CreatedEntities[ AmmoID ]
				if Ammo and Ammo:IsValid() and Ammo:GetClass() == "acf_ammo" then
					self:Link( Ammo )
				end
			end
		end
		Ent.EntityMods.ACFAmmoLink = nil
	end
	
	//Wire dupe info
	if(Ent.EntityMods and Ent.EntityMods.WireDupeInfo) then
		WireLib.ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
	end

end

function ENT:OnRemove()
	Wire_Remove(self)
end

function ENT:OnRestore()
    Wire_Restored(self)
end
