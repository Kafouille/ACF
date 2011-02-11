
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
	
	local Gun = data:GetEntity()
	local Propellant = data:GetScale()
	local Class = Gun:GetNWString( "Class" )
	local RoundType = ACF.IdRounds[data:GetSurfaceProp()]
	
	
	local Muzzle = Gun:GetAttachment( Gun:LookupAttachment( "muzzle" ) )
	ParticleEffect( ACF.Classes["GunClass"][Class]["muzzleflash"], Muzzle.Pos, Muzzle.Ang, Gun )
	Gun:Animate( Class, Propellant )
	
 end 
   
   
/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end

 