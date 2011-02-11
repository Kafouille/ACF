
AddCSLuaFile( 'cl_init.lua' )
AddCSLuaFile( 'shared.lua' )
include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr)
	local SpawnPos = tr.HitPos + tr.HitNormal * 100
	local ent = ents.Create( "ACF_Battlepod_Avatar" )
	ent:SetNWEntity( "Avatar", self.Avatar )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:SetPlayer( ply )
	return ent
end

function ENT:Initialize( )

	self:DrawShadow( false )
	self:SetModel( self.Model )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	
end

function ENT:UpdateTransmitState( )

	return TRANSMIT_ALWAYS
	
end

function ENT:SetPlayer( pl )

	self.Entity:SetNetworkedEntity( "Player", pl )
	self.Player = pl
	
	if ( ValidEntity( pl ) && pl:IsPlayer() ) then
	
		self.Model = pl:GetModel()
		self.Entity:SetModel( self.Model )
		
	end
	
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	
	self.Entity:NextThink( CurTime() )
	
end

function ENT:Think( )

	local pl = self.Entity:GetNetworkedEntity( "Player" )
		
	self.Entity:NextThink( CurTime() + 0.2 )
	return true
	
end

/*---------------------------------------------------------
   Name: SelectSchedule
---------------------------------------------------------*/
function ENT:SelectSchedule()
 
	--self:StartSchedule( schdChase ) //run the schedule we created earlier
 
end

