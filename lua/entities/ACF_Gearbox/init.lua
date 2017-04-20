AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
	
	self.IsGeartrain = true
	self.Master = {}
	
	self.IsMaster = {}
	self.WheelLink = {}
	self.WheelSide = {}
	self.WheelCount = {}
	self.WheelAxis = {}
	self.WheelRopeL = {}
	self.WheelOutput = {}
	self.WheelReqTq = {}
	self.WheelVel = {}
	
	self.TotalReqTq = 0
	self.RClutch = 0
	self.LClutch = 0
	self.LBrake = 0
	self.RBrake = 0

	self.Gear = 1
	self.GearRatio = 0
	self.ChangeFinished = 0
	
	self.LegalThink = 0
	
	self.RPM = {}
	self.CurRPM = 0
	self.InGear = false
	self.CanUpdate = true
	self.LastActive = 0
	self.Legal = true
	
end  

function MakeACF_Gearbox(Owner, Pos, Angle, Id, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10)

	if not Owner:CheckLimit("_acf_misc") then return false end
	
	local Gearbox = ents.Create("ACF_Gearbox")
	local List = list.Get("ACFEnts")
	local Classes = list.Get("ACFClasses")
	if not Gearbox:IsValid() then return false end
	Gearbox:SetAngles(Angle)
	Gearbox:SetPos(Pos)
	Gearbox:Spawn()

	Gearbox:SetPlayer(Owner)
	Gearbox.Owner = Owner
	Gearbox.Id = Id
	Gearbox.Model = List["Mobility"][Id]["model"]
	Gearbox.Mass = List["Mobility"][Id]["weight"]
	Gearbox.SwitchTime = List["Mobility"][Id]["switch"]
	Gearbox.MaxTorque = List["Mobility"][Id]["maxtq"]
	Gearbox.Gears = List["Mobility"][Id]["gears"]
	Gearbox.Dual = List["Mobility"][Id]["doubleclutch"]
	Gearbox.GearTable = List["Mobility"][Id]["geartable"]
		Gearbox.GearTable["Final"] = Data10
		Gearbox.GearTable[1] = Data1
		Gearbox.GearTable[2] = Data2
		Gearbox.GearTable[3] = Data3
		Gearbox.GearTable[4] = Data4
		Gearbox.GearTable[5] = Data5
		Gearbox.GearTable[6] = Data6
		Gearbox.GearTable[7] = Data7
		Gearbox.GearTable[8] = Data8
		Gearbox.GearTable[9] = Data9
		Gearbox.GearTable[0] = 0
		
		Gearbox.Gear0 = Data10
		Gearbox.Gear1 = Data1
		Gearbox.Gear2 = Data2
		Gearbox.Gear3 = Data3
		Gearbox.Gear4 = Data4
		Gearbox.Gear5 = Data5
		Gearbox.Gear6 = Data6
		Gearbox.Gear7 = Data7
		Gearbox.Gear8 = Data8
		Gearbox.Gear9 = Data9
				
	Gearbox:SetModel( Gearbox.Model )	
		
	local Inputs = {"Gear","Gear Up","Gear Down"}
	if Gearbox.Dual then
		table.insert(Inputs,"Left Clutch")
		table.insert(Inputs,"Right Clutch")
		table.insert(Inputs,"Left Brake")
		table.insert(Inputs,"Right Brake")
	else
		table.insert(Inputs, "Clutch")
		table.insert(Inputs, "Brake")
	end
	
	Gearbox.Inputs = Wire_CreateInputs( Gearbox.Entity, Inputs )
	Gearbox.Outputs = WireLib.CreateSpecialOutputs( Gearbox.Entity, { "Ratio", "Entity" , "Current Gear" }, { "NORMAL" , "ENTITY" , "NORMAL" , "NORMAL" } )
	Wire_TriggerOutput(Gearbox.Entity, "Entity", Gearbox.Entity)
	Gearbox.WireDebugName = "ACF Gearbox"
	
	Gearbox.LClutch = Gearbox.MaxTorque
	Gearbox.RClutch = Gearbox.MaxTorque

	Gearbox:PhysicsInit( SOLID_VPHYSICS )      	
	Gearbox:SetMoveType( MOVETYPE_VPHYSICS )     	
	Gearbox:SetSolid( SOLID_VPHYSICS )

	local phys = Gearbox:GetPhysicsObject()  	
	if (phys:IsValid()) then 
		phys:SetMass( Gearbox.Mass ) 
	end
	
	Gearbox.In = Gearbox:WorldToLocal(Gearbox:GetAttachment(Gearbox:LookupAttachment( "input" )).Pos)
	Gearbox.OutL = Gearbox:WorldToLocal(Gearbox:GetAttachment(Gearbox:LookupAttachment( "driveshaftL" )).Pos)
	Gearbox.OutR = Gearbox:WorldToLocal(Gearbox:GetAttachment(Gearbox:LookupAttachment( "driveshaftR" )).Pos)
		
	undo.Create("ACF Gearbox")
		undo.AddEntity( Gearbox )
		undo.SetPlayer( Owner )
	undo.Finish()
	
	Owner:AddCount("_acf_Gearbox", Gearbox)
	Owner:AddCleanup( "acfmenu", Gearbox )
	
	Gearbox:ChangeGear(1)
	
	timer.Simple(0.5, function() Gearbox:UpdateHUD() end ) 
		
	return Gearbox
end
list.Set( "ACFCvars", "acf_gearbox" , {"id", "data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10"} )
duplicator.RegisterEntityClass("acf_gearbox", MakeACF_Gearbox, "Pos", "Angle", "Id", "Gear1", "Gear2", "Gear3", "Gear4", "Gear5", "Gear6", "Gear7", "Gear8", "Gear9", "Gear0" )

function ENT:Update( ArgsTable )	--That table is the player data, as sorted in the ACFCvars above, with player who shot, and pos and angle of the tool trace inserted at the start

	local Feedback = "Gearbox updated successfully"
	if ( ArgsTable[1] != self.Owner ) then --Argtable[1] is the player that shot the tool
		Feedback = "You don't own that gearbox !"
	return Feedback end
		
	local Id = ArgsTable[4]	--Argtable[4] is the engine ID
	local List = list.Get("ACFEnts")
	
	if ( List["Mobility"][Id]["model"] != self.Model ) then --Make sure the models are the sames before doing a changeover
		Feedback = "The new gearbox needs to have the same size and orientation as the old one !"
	return Feedback end
		
	if self.Id != Id then
		local Inputs = {"Gear","Gear Up","Gear Down"}
		if self.Dual then
			table.insert(Inputs,"Left Clutch")
			table.insert(Inputs,"Right Clutch")
			table.insert(Inputs,"Left Brake")
			table.insert(Inputs,"Right Brake")
		else
			table.insert(Inputs, "Clutch")
			table.insert(Inputs, "Brake")
		end
		
		self.Id = Id
		self.Mass = List["Mobility"][Id]["weight"]
		self.SwitchTime = List["Mobility"][Id]["switch"]
		self.MaxTorque = List["Mobility"][Id]["maxtq"]
		self.Gears = List["Mobility"][Id]["gears"]
		self.Dual = List["Mobility"][Id]["doubleclutch"]
		
		self.Inputs = Wire_CreateInputs( self.Entity, Inputs )
		
	end
	
	self.GearTable["Final"] = ArgsTable[14]
	self.GearTable[1] = ArgsTable[5]
	self.GearTable[2] = ArgsTable[6]
	self.GearTable[3] = ArgsTable[7]
	self.GearTable[4] = ArgsTable[8]
	self.GearTable[5] = ArgsTable[9]
	self.GearTable[6] = ArgsTable[10]
	self.GearTable[7] = ArgsTable[11]
	self.GearTable[8] = ArgsTable[12]
	self.GearTable[9] = ArgsTable[13]
	self.GearTable[0] = 0
	
	self.Gear0 = ArgsTable[14]
	self.Gear1 = ArgsTable[5]
	self.Gear2 = ArgsTable[6]
	self.Gear3 = ArgsTable[7]
	self.Gear4 = ArgsTable[8]
	self.Gear5 = ArgsTable[9]
	self.Gear6 = ArgsTable[10]
	self.Gear7 = ArgsTable[11]
	self.Gear8 = ArgsTable[12]
	self.Gear9 = ArgsTable[13]
		
	self:ChangeGear(1)
		
	self:UpdateHUD()
	
	return Feedback
end

function ENT:UpdateHUD()

	umsg.Start( "ACFGearbox_SendRatios", ply )
		umsg.Entity( self.Entity )
		umsg.String( self.Id )
		umsg.Short( self.Gear0*100 )
		for I=1 , self.Gears do
			umsg.Short( self.GearTable[I]*100 )
		end
		umsg.Bool( self.Dual )
	umsg.End()
	
end

function ENT:TriggerInput( iname , value )

	if ( iname == "Gear" and self.Gear != math.floor(value) ) then
		self:ChangeGear(math.floor(value))
	elseif ( iname == "Gear Up" ) then
		if ( self.Gear < self.Gears and value > 0 ) then
			self:ChangeGear(math.floor(self.Gear + 1))
		end
	elseif ( iname == "Gear Down" ) then
		if ( self.Gear > 1 and value > 0 ) then
			self:ChangeGear(math.floor(self.Gear - 1))
		end
	elseif ( iname == "Clutch" ) then
		self.LClutch = math.Clamp(1-value,0,1)*self.MaxTorque
		self.RClutch = math.Clamp(1-value,0,1)*self.MaxTorque
	elseif ( iname == "Brake" ) then
		self.LBrake = math.Clamp(value,0,100)
		self.RBrake = math.Clamp(value,0,100)
	elseif ( iname == "Left Brake" ) then
		self.LBrake = math.Clamp(value,0,100)
	elseif ( iname == "Right Brake" ) then
		self.RBrake = math.Clamp(value,0,100)
	elseif ( iname == "Left Clutch" ) then
		self.LClutch = math.Clamp(1-value,0,1)*self.MaxTorque
	elseif ( iname == "Right Clutch" ) then
		self.RClutch = math.Clamp(1-value,0,1)*self.MaxTorque
	end		

end

function ENT:Think()

	local Time = CurTime()
	
	if self.LegalThink < Time and self.LastActive+2 > Time then
		self:CheckRopes()
		if self.Entity:GetPhysicsObject():GetMass() < self.Mass or self.Entity:GetParent():IsValid() then
			self.Legal = false
		else 
			self.Legal = true
		end
		self.LegalThink = Time + (math.random(5,10))
	end
	
	self.Entity:NextThink(Time+0.2)
	return true
	
end

function ENT:CheckRopes()
	
	for WheelKey,Ent in pairs(self.WheelLink) do
		local Constraints = constraint.FindConstraints(Ent, "Rope")
		if Constraints then
		
			local Clean = false
			for Key,Rope in pairs(Constraints) do
				if Rope.Ent1 == self.Entity or Rope.Ent2 == self.Entity then
					if Rope.length + Rope.addlength < self.WheelRopeL[WheelKey]*1.5 then
						Clean = true
					end
				end
			end
			
			if not Clean then
				self:Unlink( Ent )
			end
			
		else
			self:Unlink( Ent )
		end
		
		local DrvAngle = (self.Entity:LocalToWorld(self.WheelOutput[WheelKey]) - Ent:GetPos()):GetNormalized():DotProduct( (self:GetRight()*self.WheelOutput[WheelKey].y):GetNormalized() )
		if ( DrvAngle < 0.7 ) then
			self:Unlink( Ent )
		end
	end
	
end

function ENT:CheckEnts()		--Check if every entity we are linked to still actually exists
	
	for Key, WheelEnt in pairs(self.WheelLink) do
		if not IsValid(WheelEnt) then
			table.remove(self.WheelAxis,Key)
			table.remove(self.WheelSide,Key)
		else
			local WheelPhys = WheelEnt:GetPhysicsObject()
			if not IsValid(WheelPhys) then
				WheelEnt:Remove()
				table.remove(self.WheelAxis,Key)
				table.remove(self.WheelSide,Key)
			end
		end
	end
	
end

function ENT:Calc( InputRPM, InputInertia )

	if self.LastActive == CurTime() then return math.min(self.TotalReqTq, self.MaxTorque) end
	if self.ChangeFinished < CurTime() and self.GearRatio != 0 then
		self.InGear = true
	else return 0 end

	self:CheckEnts()

	local BoxPhys = self:GetPhysicsObject()
	local SelfWorld = self:LocalToWorld(BoxPhys:GetAngleVelocity())-self:GetPos()
	self.WheelReqTq = {}
	self.TotalReqTq = 0
	
	for Key, WheelEnt in pairs(self.WheelLink) do
		if ( WheelEnt:IsValid() ) then
			local Clutch = 0
			if self.WheelSide[Key] == 0 then
				Clutch = self.LClutch
			elseif self.WheelSide[Key] == 1 then
				Clutch = self.RClutch
			end
		
			self.WheelReqTq[Key] = 0
			if WheelEnt.IsGeartrain then
				self.WheelReqTq[Key] = math.abs(WheelEnt:Calc( InputRPM*self.GearRatio, InputInertia/self.GearRatio )*self.GearRatio)
			else
				local RPM = self:CalcWheel( Key, WheelEnt, SelfWorld )
				if (InputRPM > 0 and RPM < InputRPM) or (InputRPM < 0 and RPM > InputRPM) then
                    self.WheelReqTq[Key] = math.min(Clutch, (InputRPM - RPM)*InputInertia )
                end
			end
			self.TotalReqTq = self.TotalReqTq + self.WheelReqTq[Key]
		else
			table.remove(self.WheelLink, Key)
		end
	end
			
	return math.min(self.TotalReqTq, self.MaxTorque)

end

function ENT:CalcWheel( Key, WheelEnt, SelfWorld )
	if ( WheelEnt:IsValid() ) then
		local WheelPhys = WheelEnt:GetPhysicsObject()
		local VelDiff = (WheelEnt:LocalToWorld(WheelPhys:GetAngleVelocity())-WheelEnt:GetPos()) - SelfWorld
		local BaseRPM = VelDiff:Dot(WheelEnt:LocalToWorld(self.WheelAxis[Key])-WheelEnt:GetPos())
		local GearedRPM = BaseRPM / self.GearRatio / -6 --Reported BaseRPM is in angle per second and in the wrong direction, so we convert and add the gearratio
		self.WheelVel[Key] = BaseRPM
	
		return GearedRPM
	else
		return 0
	end
	
end

function ENT:Act( Torque, DeltaTime )
	
	local ReactTq = 0
	--local AvailTq = math.min(math.abs(Torque)/self.TotalReqTq,1)/self.GearRatio*-(-Torque/math.abs(Torque))		--Calculate the ratio of total requested torque versus what's avaliable, and then multiply it but the current gearratio
	 local AvailTq = 0
	if Torque != 0 then
		AvailTq = math.min(math.abs(Torque)/self.TotalReqTq,1)/self.GearRatio*-(-Torque/math.abs(Torque))
	end


	for Key, OutputEnt in pairs(self.WheelLink) do
		if self.WheelSide[Key] == 0 then
			Brake = self.LBrake
		elseif self.WheelSide[Key] == 1 then
			Brake = self.RBrake
		end
		
		if OutputEnt.IsGeartrain then
			OutputEnt:Act( self.WheelReqTq[Key]*AvailTq , DeltaTime )
		else
			self:ActWheel( Key, OutputEnt, self.WheelReqTq[Key]*AvailTq, Brake , DeltaTime )
			ReactTq = ReactTq + self.WheelReqTq[Key]*AvailTq
		end
	end
	
	local BoxPhys = self:GetPhysicsObject()
	if BoxPhys:IsValid() and ReactTq != 0 then	
		local Force = self:GetForward() * ReactTq - self:GetForward() * BrakeMult
		BoxPhys:ApplyForceOffset( Force * 39.37 * DeltaTime, self:GetPos() + self:GetUp()*-39.37 )
		BoxPhys:ApplyForceOffset( Force * -39.37 * DeltaTime, self:GetPos() + self:GetUp()*39.37 )
	end
	
	self.LastActive = CurTime()
	
end

function ENT:ActWheel( Key, OutputEnt, Tq, Brake , DeltaTime )

	local OutPhys = OutputEnt:GetPhysicsObject()
	local OutPos = OutputEnt:GetPos()
	local TorqueAxis = OutputEnt:LocalToWorld(self.WheelAxis[Key]) - OutPos
	local Cross = TorqueAxis:Cross( Vector(TorqueAxis.y,TorqueAxis.z,TorqueAxis.x) )
	local Inertia = OutPhys:GetInertia()
	local BrakeMult = 0
	if Brake > 0 then
		BrakeMult = self.WheelVel[Key] * Inertia * Brake / 10
	end
	local TorqueVec = TorqueAxis:Cross(Cross):GetNormalized() 
	local Force = TorqueVec * Tq + TorqueVec * BrakeMult
	OutPhys:ApplyForceOffset( Force * -39.37 * DeltaTime, OutPos + Cross*39.37)
	OutPhys:ApplyForceOffset( Force * 39.37 * DeltaTime, OutPos + Cross*-39.37 )
	
end

function ENT:ChangeGear(value)

	self.Gear = math.Clamp(value,0,self.Gears)
	self.GearRatio = (self.GearTable[self.Gear] or 0)*self.GearTable["Final"]
	self.ChangeFinished = CurTime() + self.SwitchTime
	self.InGear = false
	
	Wire_TriggerOutput(self.Entity, "Current Gear", self.Gear)
	self:EmitSound("buttons/lever7.wav",250,100)
	Wire_TriggerOutput(self.Entity, "Ratio", self.GearRatio)
	
end

function ENT:Link( Target )

	if ( !Target or (Target:GetClass() != "prop_physics" and Target:GetClass() != "acf_gearbox") ) then return "Can only link plain props or other gearboxes" end
	
	for Key,Value in pairs(self.WheelLink) do
		if Value == Target then return "This is already linked to this gearbox !" end
	end
		
	local TargetPos = Target:GetPos()
	if Target.IsGeartrain then
		TargetPos = Target:LocalToWorld(Target.In)
	end
	local LinkPos = Vector(0,0,0)
	local Side = 0
	if self.Entity:WorldToLocal(TargetPos).y < 0 then
		LinkPos = self.OutL
		Side = 0
	else
		LinkPos = self.OutR
		Side = 1
	end
	
	local DrvAngle = (self.Entity:LocalToWorld(LinkPos) - TargetPos):GetNormalized():DotProduct( (self:GetRight()*LinkPos.y):GetNormalized() )
	if ( DrvAngle < 0.7 ) then
		return "Cannot link due to excessive driveshaft angle"
	end
	
	table.insert(self.WheelLink,Target)
	table.insert(self.WheelSide,Side)
	if not self.WheelCount[Side] then self.WheelCount[Side] = 0 end
	self.WheelCount[Side] = self.WheelCount[Side] + 1
	table.insert(self.WheelAxis,Target:WorldToLocal(self.Entity:GetRight()+TargetPos))
	
	local RopeL = ( self.Entity:LocalToWorld(LinkPos)-TargetPos ):Length()
	constraint.Rope( self.Entity, Target, 0, 0, LinkPos, Target:WorldToLocal(TargetPos), RopeL, RopeL*0.2, 0, 1, "cable/cable2", false )
	table.insert( self.WheelRopeL,RopeL )
	table.insert( self.WheelOutput,LinkPos )
	
	return false
	
end

function ENT:Unlink( Target )
	
	for Key,Value in pairs(self.WheelLink) do
		if Value == Target then
		
			local Constraints = constraint.FindConstraints(Value, "Rope")
			if Constraints then
				for Key,Rope in pairs(Constraints) do
					if Rope.Ent1 == self.Entity or Rope.Ent2 == self.Entity then
						Rope.Constraint:Remove()
					end
				end
			end
			
			if not self.WheelCount[self.WheelSide[Key]] then self.WheelCount[self.WheelSide[Key]] = 0 end
			self.WheelCount[self.WheelSide[Key]] = math.max(self.WheelCount[self.WheelSide[Key]] - 1,0)
			
			table.remove(self.WheelLink,Key)
			table.remove(self.WheelAxis,Key)
			table.remove(self.WheelSide,Key)
			table.remove(self.WheelRopeL,Key)
			table.remove(self.WheelOutput,Key)
			return false
		end
	end
	
	return "Didn't find the wheel to unlink"

end

//Duplicator stuff

function ENT:PreEntityCopy()

	//Link Saving
	local info = {}
	local entids = {}
	for Key, Value in pairs(self.WheelLink) do					--Clean the table of any invalid entities
		if not Value:IsValid() then
			table.remove(self.WheelLink, Key)
		end
	end
	for Key, Value in pairs(self.WheelLink) do					--Then save it
		table.insert(entids, Value:EntIndex())
	end
	
	info.entities = entids
	if info.entities then
		duplicator.StoreEntityModifier( self.Entity, "WheelLink", info )
	end
	
	//Wire dupe info
	local DupeInfo = WireLib.BuildDupeInfo(self.Entity)
	if(DupeInfo) then
		duplicator.StoreEntityModifier(self.Entity,"WireDupeInfo",DupeInfo)
	end
	
end

function ENT:PostEntityPaste( Player, Ent, CreatedEntities )

	//Link Pasting
	if (Ent.EntityMods) and (Ent.EntityMods.WheelLink) and (Ent.EntityMods.WheelLink.entities) then
		local WheelLink = Ent.EntityMods.WheelLink
		if WheelLink.entities and table.Count(WheelLink.entities) > 0 then
			for _,ID in pairs(WheelLink.entities) do
				local Linked = CreatedEntities[ ID ]
				if Linked and Linked:IsValid() then
					self:Link( Linked )
				end
			end
		end
		Ent.EntityMods.WheelLink = nil
	end
	
	//Wire dupe info
	if(Ent.EntityMods and Ent.EntityMods.WireDupeInfo) then
		WireLib.ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
	end

end

function ENT:OnRemove()

	for Key,Value in pairs(self.Master) do		--Let's unlink ourselves from the engines properly
		if self.Master[Key] and self.Master[Key]:IsValid() then
			self.Master[Key]:Unlink( self.Entity )
		end
	end
	
	Wire_Remove(self.Entity)
end

function ENT:OnRestore()
    Wire_Restored(self.Entity)
end


