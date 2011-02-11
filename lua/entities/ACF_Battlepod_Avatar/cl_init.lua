
include( 'shared.lua' )

function ENT:Initialize( )
	
end

function ENT:Draw( )
	
	if ( !ValidEntity( self.Pod ) || !ValidEntity( self.Pod:GetDriver() ) ) then return end
	self:DrawModel()
	
end

function ENT:Think( )

	// update player
	local pl = self.Entity:GetNetworkedEntity( "Player" )
	self.Player = pl
	
	local Pod = self:GetOwner()
	self.Pod = Pod
	
	self.Entity:NextThink( CurTime() + 0.1 )
	
	return true;
	
end

/*---------------------------------------------------------
   Name: BuildBonePositions
   Desc: 
---------------------------------------------------------*/
function ENT:BuildBonePositions( NumBones, NumPhysBones )
 
	// You can use this section to position the bones of
	// any animated model using self:SetBonePosition( BoneNum, Pos, Angle )
 
	// This will override any animation data and isn't meant as a 
	// replacement for animations. We're using this to position the limbs
	// of ragdolls.
 
end
 
 
 
/*---------------------------------------------------------
   Name: SetRagdollBones
   Desc: 
---------------------------------------------------------*/
function ENT:SetRagdollBones( bIn )
 
	// If this is set to true then the engine will call 
	// DoRagdollBone (below) for each ragdoll bone.
	// It will then automatically fill in the rest of the bones
 
	self.m_bRagdollSetup = bIn
 
end
 
 
/*---------------------------------------------------------
   Name: DoRagdollBone
   Desc: 
---------------------------------------------------------*/
function ENT:DoRagdollBone( PhysBoneNum, BoneNum )
 
	// self:SetBonePosition( BoneNum, Pos, Angle )
 
end
 
