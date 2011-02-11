AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:SpawnFunction( ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( "ACF_Battlepod" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	return ent
end

function ENT:Initialize()

	self.Entity:SetUseType( SIMPLE_USE )

	self.Entity:SetModel("models/props/cs_office/Chair_office.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(50)
	end
	
end

function ENT:OnTakeDamage( dmg )
	self:TakePhysicsDamage( dmg )
	if ValidEntity(self.Driver) then
		--self.Driver:TakeDamage( dmg:GetDamage(), dmg:GetInflictor() )
	end
end

function ENT:Think()

	local Driver = self:GetDriver()
	if( ValidEntity( Driver ) ) then
		if( ValidEntity( self.Avatar ) ) then
			local Head = self.Avatar:LookupAttachment("eyes")
			local AngPos = self.Avatar:GetAttachment(Head)
			Driver:SetPos(AngPos.Pos)
			Driver:DrawWorldModel( false )
			Driver:SetNoDraw( true )
		end
		
		if( Driver:GetViewEntity() == Driver ) then
			Driver:SetViewEntity( self.Avatar )
		end
		
		if ( Driver:Alive() && Driver:IsConnected() ) then
			--SetPlayerAnimation( Driver )
		elseif ( !Driver:Alive() || !Driver:IsConnected() ) then
			self:SetDriver( NULL )
		end
		
	end

	self:NextThink( CurTime() )
	return true
	
end

function ENT:Use( activator, caller )

	if ( !ValidEntity( activator ) || !activator:IsPlayer() ) then
		return
	end

	self.NextUse = self.NextUse or 0
	if ( CurTime() < self.NextUse ) then
		return
	end

	self.NextUse = CurTime() + 1
	self:SetDriver( activator )

end

local function ACFPodKeyPress( pl, in_key )

	local Pod = pl:GetScriptedVehicle()
	if ( !ValidEntity( Pod ) || Pod:GetClass() != "acf_battlepod" ) then return end

	if ( in_key == IN_USE ) then
		Pod:SetDriver( NULL )
		Pod.NextUse = CurTime() + 1
	end

end
hook.Add( "KeyPress", "ACFPodKeyPress", ACFPodKeyPress )

 function ENT:OnRemove()

	self:SetDriver( NULL )
	
end

function ENT:MakeAvatar( pl )

	self.Avatar = ents.Create( "ACF_Battlepod_Avatar" )
	self.Avatar:SetPos(self:GetPos() + self:GetUp()*17 + self:GetForward()*-10)
	self.Avatar:SetAngles(self:GetAngles())
	self.Avatar:SetParent( self.Entity )
	self.Avatar:SetOwner( self.Entity )
	self.Avatar:Spawn()
	self:SetNWEntity( "Avatar", self.Avatar )

end

function ENT:SetDriver( pl )

	local driver = self:GetDriver()
	if( ValidEntity( driver ) ) then

		if ( ( pl == NULL || pl == nil ) ) then
			local Health = driver:Health()
			driver:SetScriptedVehicle( NULL )
			driver:SetMoveType( MOVETYPE_WALK )
			driver:UnSpectate()
			driver:DrawWorldModel( true )
			driver:SetNoDraw( false )
			driver:Spawn()
			driver:SetPos( self.Entity:GetPos()+Vector(0,0,50) )
			driver:SetHealth( Health )
			self:SetOwner( nil )
		else
			return
		end
		
	end
	
	if( ValidEntity( pl ) ) then
		
		if( ValidEntity(self.Avatar) ) then
			self.Avatar:SetPlayer( pl )
		else
			self:MakeAvatar( pl )
			self.Avatar:SetPlayer( pl )
		end
			
		if( ValidEntity( pl:GetScriptedVehicle() ) ) then		--Check if the player already has a scripted vehicle
			return
		end
		pl:SetScriptedVehicle( self )
		pl:SetMoveType( MOVETYPE_NONE )	
		--pl:Spectate( OBS_MODE_ROAMING )
		pl:DrawWorldModel( false )
		pl:SetNoDraw( true )
		pl:StripWeapons()
		self:SetOwner( pl )
		pl:SetViewEntity( self.Avatar )
		
	end

	self:SetNetworkedEntity( "Driver", pl )
	self:SetOwner( pl )

end

local function SetPlayerAnimation( pl, anim )

	local Pod = pl:GetScriptedVehicle()

	if ( !ValidEntity( Pod ) || Pod:GetClass() != "acf_battlepod" ) then return end
	local seq = "drive_jeep"
	seq = pl:LookupSequence( seq )

	pl:SetPlaybackRate( 1.0 )
	pl:ResetSequence( seq )
	pl:SetCycle( 0 )

	Pod.Avatar:SetPlaybackRate( 1.0 )
	Pod.Avatar:ResetSequence( seq )
	Pod.Avatar:SetCycle( 0 )

	return true

end
hook.Add( "SetPlayerAnimation", "ACFBattlepod_SetPlayerAnimation", SetPlayerAnimation )

function ENT:OnRemove()
	Wire_Remove(self.Entity)
end

function ENT:OnRestore()
    Wire_Restored(self.Entity)
end

function ENT:BuildDupeInfo()
	return WireLib.BuildDupeInfo(self.Entity)
end

function ENT:ApplyDupeInfo(ply, ent, info, GetEntByID)
	WireLib.ApplyDupeInfo( ply, ent, info, GetEntByID )
end

function ENT:PreEntityCopy()
	//build the DupeInfo table and save it as an entity mod
	local DupeInfo = self:BuildDupeInfo()
	if(DupeInfo) then
		duplicator.StoreEntityModifier(self.Entity,"WireDupeInfo",DupeInfo)
	end
end

function ENT:PostEntityPaste(Player,Ent,CreatedEntities)
	//apply the DupeInfo
	if(Ent.EntityMods and Ent.EntityMods.WireDupeInfo) then
		Ent:ApplyDupeInfo(Player, Ent, Ent.EntityMods.WireDupeInfo, function(id) return CreatedEntities[id] end)
	end
end

