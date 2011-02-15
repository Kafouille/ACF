AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
	
	self.KillAction = true
	self.DamageAction = true
	self.IsExplosive = true
	self.Exploding = false
	self.Damaged = false
	self.CanUpdate = true
	
	self.Master = {}
	self.Sequence = 0
	
	self.WireDebugName = "Ammo Crate"
	--self.Inputs = Wire_CreateInputs( self.Entity, { "Sequence"} )
	self.Outputs = Wire_CreateOutputs( self.Entity, { "Munitions" , "On Fire" } )
		
	self.NextThink = CurTime() +  1
	
end

function MakeACF_Ammo(Owner, Pos, Angle, Id, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10)

	if not Owner:CheckLimit("_acf_ammo") then return false end
	
	local Ammo = ents.Create("ACF_Ammo")
	if not Ammo:IsValid() then return false end
	Ammo:SetAngles(Angle)
	Ammo:SetPos(Pos)
	Ammo:Spawn()
	Ammo:SetPlayer(Owner)
	Ammo.Owner = Owner
	
	Ammo.Model = ACF.Weapons["Ammo"][Id]["model"]
	Ammo:SetModel( Ammo.Model )	
	
	Ammo:PhysicsInit( SOLID_VPHYSICS )      	
	Ammo:SetMoveType( MOVETYPE_VPHYSICS )     	
	Ammo:SetSolid( SOLID_VPHYSICS )
	
	Ammo.Id = Id
	Ammo:CreateAmmo(Id, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10)
	
	Ammo.Ammo = Ammo.Capacity
	Ammo.EmptyMass = ACF.Weapons["Ammo"][Ammo.Id]["weight"]
	Ammo.Mass = Ammo.EmptyMass + math.floor( (Ammo.BulletData["ProjMass"] + Ammo.BulletData["PropMass"]) * Ammo.Ammo * 2 )
	
	local phys = Ammo:GetPhysicsObject()  	
	if (phys:IsValid()) then 
		phys:SetMass( Ammo.Mass ) 
	end 
	
	undo.Create("ACF Ammo")
		undo.AddEntity( Ammo )
		undo.SetPlayer( Owner )
	undo.Finish()
	
	Owner:AddCount( "_acf_ammo", Ammo )
	Owner:AddCleanup( "acfmenu", Ammo )
	
	return Ammo
end
list.Set( "ACFCvars", "acf_ammo" , {"id", "data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10"} )
duplicator.RegisterEntityClass("acf_ammo", MakeACF_Ammo, "Pos", "Angle", "Id", "RoundId", "RoundType", "RoundPropellant", "RoundProjectile", "RoundData5", "RoundData6", "RoundData7", "RoundData8", "RoundData9", "RoundData10" )

function ENT:Update( ArgsTable )	--That table is the player data, as sorted in the ACFCvars above, with player who shot, and pos and angle of the tool trace inserted at the start

	if ( ArgsTable[1] != self.Owner ) then --Argtable[1] is the player that shot the tool
		ArgsTable[1]:SendLua( "GAMEMODE:AddNotify('You don't own that ammo crate !', NOTIFY_GENERIC, 7);" )
	return end
	
	if ( ArgsTable[6] == "Refill" ) then --Argtable[6] is the round type. If it's refill it shouldn't be loaded into guns, so we refuse to change to it
		ArgsTable[1]:SendLua( "GAMEMODE:AddNotify('Refill ammo type is only avaliable for new crates', NOTIFY_GENERIC, 7);" )
	return end
	
	if ( ArgsTable[5] != self.RoundId ) then --Argtable[5] is the weapon ID the new ammo loads into
		for Key, Gun in pairs( self.Master ) do
			if Gun:IsValid() then
				Gun:Unlink( self.Entity )
			end
		end
		ArgsTable[1]:SendLua( "GAMEMODE:AddNotify('New ammo type, crate unlinked', NOTIFY_GENERIC, 7);" )
	end
	
	
	local AmmoPercent = self.Ammo/self.Capacity
	
	self:CreateAmmo(ArgsTable[4], ArgsTable[5], ArgsTable[6], ArgsTable[7], ArgsTable[8], ArgsTable[9], ArgsTable[10], ArgsTable[11], ArgsTable[12], ArgsTable[13], ArgsTable[14])
	
	self.Ammo = math.floor(self.Capacity*AmmoPercent)
	self.Mass = self.EmptyMass + math.floor( (self.BulletData["ProjMass"] + self.BulletData["PropMass"]) * self.Ammo * 2 )
	
	ArgsTable[1]:SendLua( "GAMEMODE:AddNotify('Crate updated', NOTIFY_GENERIC, 7);" )
	
end

function ENT:CreateAmmo(Id, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10)

	--Data 1 to 4 are should always be Round ID, Round Type, Propellant lenght, Projectile lenght
	self.RoundId = Data1		--Weapon this round loads into, ie 140mmC, 105mmH ...
	self.RoundType = Data2		--Type of round, IE AP, HE, HEAT ...
	self.RoundPropellant = Data3--Lenght of propellant
	self.RoundProjectile = Data4--Lenght of the projectile
	self.RoundData5 = ( Data5 or 0 )
	self.RoundData6 = ( Data6 or 0 )
	self.RoundData7 = ( Data7 or 0 )
	self.RoundData8 = ( Data8 or 0 )
	self.RoundData9 = ( Data9 or 0 )
	self.RoundData10 = ( Data10 or 0 )
	
	local PlayerData = {}
		PlayerData["Id"] = self.RoundId
		PlayerData["Type"] = self.RoundType
		PlayerData["PropLength"] = self.RoundPropellant
		PlayerData["ProjLength"] = self.RoundProjectile
		PlayerData["Data5"] = self.RoundData5
		PlayerData["Data6"] = self.RoundData6
		PlayerData["Data7"] = self.RoundData7
		PlayerData["Data8"] = self.RoundData8
		PlayerData["Data9"] = self.RoundData9
		PlayerData["Data10"] = self.RoundData10
	self.ConvertData = ACF.RoundTypes[self.RoundType]["convert"]
	self.BulletData = self:ConvertData( PlayerData )
		
	local Size = (self:OBBMaxs() - self:OBBMins())
	local Efficiency = 0.07			--This is the part of space that's actually useful, the rest is wasted on interround gaps, loading systems ..
	self.Volume = math.floor(Size.x * Size.y * Size.z)*Efficiency
	self.Capacity = math.floor(self.Volume*16.38/self.BulletData["RoundVolume"])
	
	self:SetNetworkedString("AmmoID",self.BulletData["Id"])		--Set all the networked variables so the client knows what that crate is shooting.
	self:SetNetworkedString("AmmoType",self.RoundType)
	self:SetNetworkedString("Ammo",self.Ammo)
	self:SetNetworkedInt("Caliber",self.BulletData["Caliber"])	
	self:SetNetworkedInt("ProjMass",self.BulletData["ProjMass"])
	self:SetNetworkedInt("FillerMass",self.BulletData["FillerMass"])
	self:SetNetworkedInt("PropMass",self.BulletData["PropMass"])
	self:SetNetworkedInt("DragCoef",self.BulletData["DragCoef"])
	self:SetNetworkedInt("MuzzleVel",self.BulletData["MuzzleVel"])
	self:SetNetworkedInt("Tracer",self.BulletData["Tracer"])

end

function ENT:TriggerInput( iname , value )

	if (iname == "Sequence") then
		self.Sequence = value
	end		

end

function ENT:Think()
	
	self.Mass = self.EmptyMass + math.floor( (self.BulletData["ProjMass"] + self.BulletData["PropMass"]) * self.Ammo * 2 )
	self.Entity:GetPhysicsObject():SetMass(self.Mass) 
	
	self:SetNetworkedString("Ammo",self.Ammo)
	self:SetNetworkedVector("TracerColour",self.Entity:GetColor())	
		
	self.Entity:NextThink( CurTime() +  1 )
	
	if self.Damaged then
		if self.Damaged < CurTime() then
			ACF_AmmoExplosion( self.Entity , self.Entity:GetPos() )
		else
			if math.Rand(0,150) > self.BulletData["RoundVolume"]^0.5 and math.Rand(0,1) < self.Ammo/self.Capacity and ACF.RoundTypes[self.BulletData["Type"]] then
				self.Entity:EmitSound( "ambient/explosions/explode_4.wav" , 350 , math.max(255 - self.BulletData["PropMass"]*100,60)  )	
				local MuzzlePos = self.Entity:GetPos()
				local MuzzleVec = VectorRand()
				local Speed = ACF_MuzzleVelocity( self.BulletData["PropMass"], self.BulletData["ProjMass"]/2, self.Caliber )
				
				self.BulletData["Pos"] = MuzzlePos
				self.BulletData["Flight"] = (MuzzleVec):GetNormalized() * Speed * 39.37 + self:GetVelocity()
				self.BulletData["Owner"] = self.Owner
				self.BulletData["Gun"] = self.Entity
				self.BulletData["Crate"] = self.Entity:EntIndex()
				self.CreateShell = ACF.RoundTypes[self.BulletData["Type"]]["create"]
				self:CreateShell( self.BulletData )
				
				self.Ammo = self.Ammo - 1
				
			end
			self.Entity:NextThink( CurTime() + 0.01 + self.BulletData["RoundVolume"]^0.5/100 )
		end
	end
	
	Wire_TriggerOutput(self.Entity, "Munitions", self.Ammo)
	return true

end

function ENT:ConvertData()
	--You overwrite this with your own function, defined in the ammo definition file
end

function ENT:Touch( Supplier )
	
	if ( Supplier:GetClass() == "acf_ammo" ) then

		if ( Supplier.RoundType == "Refill" ) then
		
			local Supply = math.floor(Supplier.Ammo/self.BulletData["RoundVolume"])
			
			if self.Capacity > self.Ammo then	
			
				local Transfert = math.min(Supply , self.Capacity - self.Ammo)
				--Msg("Reicever Ok " ..Transfert.. "\n")
				self.Ammo = self.Ammo + Transfert
				Supplier.Ammo = Supplier.Ammo - math.floor(Transfert*self.BulletData["RoundVolume"])
				
				self.Supplied = true
				self.Entity:EmitSound( "items/ammo_pickup.wav" , 500, 80 )
				
				if Transfer == Supply then			
					Supplier:Remove()
				end
				
			end
			
		end
		
	end
	
end

function ENT:IsKilled( Inflictor )

	if self.Exploding or not self.IsExplosive then return end
	
	self.Exploding = true
	if self.Ammo > 1 then
		ACF_AmmoExplosion( self.Entity , self.Entity:GetPos() )
	else
		ACF_HEKill( self.Entity , VectorRand() )
	end
	
end

function ENT:IsDamaged( Damage, Inflictor )

	if self.Exploding or self.Damaged or not self.IsExplosive then return end
	local Ratio = (Damage/(self.ACF.MaxHealth/3))
	if ( Ratio + self.Capacity/self.Ammo ) > math.Rand(0,3) then  
		self.Damaged = CurTime() + (5 - Ratio*3)
		Wire_TriggerOutput(self.Entity, "On Fire", 1)
	end

end

function ENT:OnRemove()
	for Key,Value in pairs(self.Master) do
		if self.Master[Key] and self.Master[Key]:IsValid() then
			self.Master[Key]:Unlink( self.Entity )
			self.Ammo = 0
		end
	end
	Wire_Remove(self.Entity)
end

function ENT:OnRestore()
    Wire_Restored(self.Entity)
end

function ENT:PreEntityCopy()
	//Wire dupe info
	local DupeInfo = WireLib.BuildDupeInfo(self.Entity)
	if(DupeInfo) then
		duplicator.StoreEntityModifier(self.Entity,"WireDupeInfo",DupeInfo)
	end
end

function ENT:PostEntityPaste(Player,Ent,CreatedEntities)
	//Wire dupe info
	if(Ent.EntityMods and Ent.EntityMods.WireDupeInfo) then
		WireLib.ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
	end
end
