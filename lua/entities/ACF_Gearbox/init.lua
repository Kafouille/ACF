AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
	
	self.Master = {}
	
	self.IsMaster = {}
	self.WheelLink = {}
	self.WheelAxis = {}
	self.WheelRopeL = {}
	self.WheelOutput = {}
	self.WheelVel = {}
	self.WheelNum = 0
	
	self.Clutch = 0
	self.Brake = 0
	
	self.Gear = 0
	self.GearRatio = 0
	self.ChangeFinished = 0
	
	self.LegalThink = 0
	
	self.RPM = {}
	self.CurRPM = 0
	self.InGear = false
	self.CanUpdate = true
	self.LastActive = 0
	self.Legal = true
	
	self.Inputs = Wire_CreateInputs( self.Entity, { "Gear" , "Clutch" , "Brake" } )
	self.Outputs = WireLib.CreateSpecialOutputs( self.Entity, { "Ratio", "Entity" , "DebugN" }, { "NORMAL" , "ENTITY" , "NORMAL" , "NORMAL" } )
	Wire_TriggerOutput(self.Entity, "Entity", self.Entity)
	self.WireDebugName = "ACF Gearbox"

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
	
	Gearbox.Clutch = Gearbox.MaxTorque

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
	
	-- Gearbox.Output = {}
	-- table.insert(Gearbox.Output, 1, ents.Create("prop_physics"))
	-- Gearbox.Output[1]:SetAngles(Angle)
	-- Gearbox.Output[1]:SetPos(Pos + Gearbox:GetForward()*20)
	-- Gearbox.Output[1]:SetModel( "models/props_pipes/pipe01_connector01.mdl" )
	-- Gearbox.Output[1]:Spawn()
	-- Gearbox.Output[1]:SetCollisionGroup( COLLISION_GROUP_WORLD )
	
	-- constraint.Axis(Gearbox.Output[1], Gearbox, 0, 0, Gearbox.Output[1]:WorldToLocal(Gearbox:GetPos()), Gearbox.Output[1]:WorldToLocal(Gearbox:GetPos()), 0, 0, 0, 0)
	
	
	undo.Create("ACF Gearbox")
		undo.AddEntity( Gearbox )
		undo.SetPlayer( Owner )
	undo.Finish()
	
	Owner:AddCount("_acf_Gearbox", Gearbox)
	Owner:AddCleanup( "acfmenu", Gearbox )
	
	return Gearbox
end
list.Set( "ACFCvars", "acf_gearbox" , {"id", "data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10"} )
duplicator.RegisterEntityClass("acf_gearbox", MakeACF_Gearbox, "Pos", "Angle", "Id", "Gear1", "Gear2", "Gear3", "Gear4", "Gear5", "Gear6", "Gear7", "Gear8", "Gear9", "Gear0" )

function ENT:Update( ArgsTable )	--That table is the player data, as sorted in the ACFCvars above, with player who shot, and pos and angle of the tool trace inserted at the start

	local Feedback = "Gearbox updated successfully"
	if ( ArgsTable[1] != self.Owner ) then --Argtable[1] is the player that shot the tool
		Feedback = "You don't own that gearbox !"
	return end
		
	if ( ArgsTable[4] != self.Id ) then --Argtable[4] is the gearbox ID, if it doesn't match don't load the new settings
		Feedback = "Wrong gearbox model ! You need to load settings made with the same gearbox"
	return end
	
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
		
	self.Gear = 0
	
	return Feedback
end

function ENT:TriggerInput( iname , value )

	if ( iname == "Gear" and self.Gear != math.floor(value) ) then
		self:ChangeGear(math.floor(value))
	elseif ( iname == "Clutch" ) then
		self.Clutch = math.Clamp(1-value,0,1)*self.MaxTorque
	elseif ( iname == "Brake" ) then
		self.Brake = math.Clamp(value,0,10)
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

function ENT:Calc( Engine )
	
	if self.ChangeFinished < CurTime() and self.GearRatio != 0 then
		self.InGear = true
	end
	
	for Key, WheelEnt in pairs(self.WheelLink) do		--First let's check if our entities are functional
		if not IsValid(WheelEnt) then
			table.remove(self.WheelLink,Key)
			table.remove(self.WheelAxis,Key)
			self.WheelNum = table.Count(self.WheelAxis)
		else
			local WheelPhys = WheelEnt:GetPhysicsObject()
			if not IsValid(WheelPhys) then
				WheelEnt:Remove()
				table.remove(self.WheelLink,Key)
				table.remove(self.WheelAxis,Key)
				self.WheelNum = table.Count(self.WheelAxis)
			end
		end
	end
	
	local BoxPhys = self:GetPhysicsObject()
	local RPM = 0
	local SelfWorld = self:LocalToWorld(BoxPhys:GetAngleVelocity())-self:GetPos()
	for Key, WheelEnt in pairs(self.WheelLink) do
		local WheelPhys = WheelEnt:GetPhysicsObject()
		local VelDiff = (WheelEnt:LocalToWorld(WheelPhys:GetAngleVelocity())-WheelEnt:GetPos()) - SelfWorld
		self.WheelVel[Key] = VelDiff:Dot(WheelEnt:LocalToWorld(self.WheelAxis[Key])-WheelEnt:GetPos())
		RPM = RPM - self.WheelVel[Key]
	end
	if self.GearRatio != 0 then
		RPM = RPM / self.WheelNum / self.GearRatio / 6
	else
		RPM = 0
	end
	
	return RPM
end

function ENT:Act( Torque )
	
	local GearedTq = math.min(Torque,self.Clutch) / self.GearRatio / self.WheelNum
	local BoxPhys = self:GetPhysicsObject()
	Wire_TriggerOutput(self.Entity, "DebugN", GearedTq)
	
	local BrakeMult = 0
	for Key, OutputEnt in pairs(self.WheelLink) do
		local OutPhys = OutputEnt:GetPhysicsObject()
		local OutPos = OutputEnt:GetPos()
		local TorqueAxis = OutputEnt:LocalToWorld(self.WheelAxis[Key]) - OutPos
		local Cross = TorqueAxis:Cross( Vector(TorqueAxis.y,TorqueAxis.z,TorqueAxis.x) )
		local Inertia = OutPhys:GetInertia()
		if self.Brake > 0 then
			BrakeMult = self.WheelVel[Key] * Inertia * self.Brake / 10
		end
		local TorqueVec = TorqueAxis:Cross(Cross):GetNormalized() 
		local Force = TorqueVec * GearedTq + TorqueVec * BrakeMult
		OutPhys:ApplyForceOffset( Force * -1, OutPos + Cross*40 )
		OutPhys:ApplyForceOffset( Force, OutPos + Cross*-40 )
	end

	if BoxPhys:IsValid() then	
		local Force = self:GetForward() * GearedTq - self:GetForward() * BrakeMult
		BoxPhys:ApplyForceOffset( Force * 0.5, self:GetPos() + self:GetUp()*-40 )
		BoxPhys:ApplyForceOffset( Force * -0.5, self:GetPos() + self:GetUp()*40 )
	end
	
	self.LastActive = CurTime()
	
end

function ENT:ChangeGear(value)

	self.Gear = math.Clamp(value,0,self.Gears)
	self.GearRatio = (self.GearTable[self.Gear] or 0)*self.GearTable["Final"]
	self.ChangeFinished = CurTime() + self.SwitchTime
	self.InGear = false
	
	self:EmitSound("buttons/lever7.wav",250,100)
	Wire_TriggerOutput(self.Entity, "Ratio", self.GearRatio)
	
end

function ENT:Link( Target )

	if ( !Target or Target:GetClass() != "prop_physics" ) then return "Can only link plain props" end
		
	local LinkPos = Vector(0,0,0)
	if self.Entity:WorldToLocal(Target:GetPos()).y < 0 then
		LinkPos = self.OutL
	else
		LinkPos = self.OutR
	end
	
	local DrvAngle = (self.Entity:LocalToWorld(LinkPos) - Target:GetPos()):GetNormalized():DotProduct( (self:GetRight()*LinkPos.y):GetNormalized() )
	if ( DrvAngle < 0.7 ) then
		return "Cannot link due to excessive driveshaft angle"
	end
	
	table.insert(self.WheelLink,Target)
	table.insert(self.WheelAxis,Target:WorldToLocal(self.Entity:GetRight()+Target:GetPos()))
	
	local RopeL = ( self.Entity:LocalToWorld(LinkPos)-Target:GetPos() ):Length()
	constraint.Rope( self.Entity, Target, 0, 0, LinkPos, Vector(0,0,0), RopeL, RopeL*0.2, 0, 1, "cable/cable2", false )
	table.insert( self.WheelRopeL,RopeL )
	table.insert( self.WheelOutput,LinkPos )
	
	self.WheelNum = table.Count(self.WheelAxis)
	
	return false
	
end

function ENT:Unlink( Target )

	local Success = false
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
			
			table.remove(self.WheelLink,Key)
			table.remove(self.WheelAxis,Key)
			table.remove(self.WheelRopeL,Key)
			table.remove(self.WheelOutput,Key)
			Success = true
		end
	end
		
	self.WheelNum = table.Count(self.WheelAxis)
		
	if Success then
		return false
	else
		return "Didn't find the wheel to unlink"
	end

end

//Duplicator stuff

function ENT:PreEntityCopy()

	//Link Saving
	local info = {}
	local entids = {}
	for Key, Value in pairs(self.WheelLink) do					--First clean the table of any invalid entities
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


