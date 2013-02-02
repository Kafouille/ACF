AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:Initialize()   

	self.Timer = CurTime() + 60
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS ) 
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	local phys = self.Entity:GetPhysicsObject()  	
	if (phys:IsValid()) then  		
		phys:Wake()
	end 
	
end   
 
function ENT:Think()
	
	if (self.Timer < CurTime()) then
		self.Entity:Remove()
	end
	
	self.Entity:NextThink( CurTime() + 60)
	
	return true
	
end

function ENT:OnTakeDamage( dmginfo )

	// React physically when shot/getting blown
	self.Entity:TakePhysicsDamage( dmginfo )
	
end
