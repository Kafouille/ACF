AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_init.lua" )

include('shared.lua')

function ENT:Initialize()
		
	self.Inputs = Wire_CreateInputs( self.Entity, { "Fire", "Ammo" } )
	self.Outputs = WireLib.CreateSpecialOutputs( self.Entity, { "Ready", "Entity" }, { "NORMAL" , "ENTITY" } )
	Wire_TriggerOutput(self.Entity, "Entity", self.Entity)
	self.WireDebugName = "ACF Engine"

end  

function MakeACF_Engine(Owner, Pos, Angle, Id)

	--if not Owner:CheckLimit("_acf_engine") then return false end
	
	local Engine = ents.Create("ACF_Engine")
	local List = list.Get("ACFWeapons")
	local Classes = list.Get("ACFClasses")
	if not Engine:IsValid() then return false end
	Engine:SetAngles(Angle)
	Engine:SetPos(Pos)
	Engine:Spawn()

	Engine:SetPlayer(Owner)
	Engine.Owner = Owner
	Engine.Id = Id
	Engine.Caliber	= List["Engines"][Id]["caliber"]
	Engine.Model = List["Engines"][Id]["model"]
	Engine.Mass = List["Engines"][Id]["weight"]
	Engine.Class = List["Engines"][Id]["gunclass"]
	Engine:SetModel( Engine.Model )	
	
	Engine:PhysicsInit( SOLID_VPHYSICS )      	
	Engine:SetMoveType( MOVETYPE_VPHYSICS )     	
	Engine:SetSolid( SOLID_VPHYSICS )

	local phys = Engine:GetPhysicsObject()  	
	if (phys:IsValid()) then 
		phys:SetMass( Engine.Mass ) 
	end
	
	Engine.Output = ents.Create("prop_physics")
	Engine.Output:SetAngles(Angle)
	Engine.Output:SetPos(Pos + Engine:GetForward()*20)
	Engine.Output:SetModel( "models/props_phx/smallwheel.mdl" )
	Engine.Output:Spawn()
	Engine.Output:SetCollisionGroup( COLLISION_GROUP_NONE )
	
	constraint.Axis(Engine, Engine.Output, 0, 0, Engine:GetPos(), Pos + Engine:GetForward()*20, 0, 0, 0, 0)
	
	undo.Create("ACF Engine")
		undo.AddEntity( Engine )
		undo.SetPlayer( Owner )
	undo.Finish()
	
	Owner:AddCount("_acf_engine", Engine)
	Owner:AddCleanup( "acfmenu", Engine )
	
	return Engine
end
list.Set( "ACFCvars", "acf_engine" , {"id"} )
duplicator.RegisterEntityClass("acf_engine", MakeACF_Engine, "Pos", "Angle", "Id")

function ENT:TriggerInput( iname , value )

	if (iname == "Power") then
		
	end		

end

function ENT:Think()

	local Time = CurTime()

	self.Entity:NextThink(Time)
	return true
	
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
		duplicator.StoreEntityModifier( self.Entity, "ACFAmmoLink", info )
	end
	
	//Wire dupe info
	local DupeInfo = WireLib.BuildDupeInfo(self.Entity)
	if(DupeInfo) then
		duplicator.StoreEntityModifier(self.Entity,"WireDupeInfo",DupeInfo)
	end
	
end

function ENT:PostEntityPaste( Player, Ent, CreatedEntities )

	if (Ent.EntityMods) and (Ent.EntityMods.ACFAmmoLink) and (Ent.EntityMods.ACFAmmoLink.entities) then
		local AmmoLink = Ent.EntityMods.ACFAmmoLink
		if AmmoLink.entities and table.Count(AmmoLink.entities) > 0 then
			for _,AmmoID in pairs(AmmoLink.entities) do
				local Ammo = CreatedEntities[ AmmoID ]
				if Ammo and Ammo:IsValid() then
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
	Wire_Remove(self.Entity)
end

function ENT:OnRestore()
    Wire_Restored(self.Entity)
end


