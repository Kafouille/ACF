
   
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
	local SoundPressure = (Propellant*1000)^0.5
	WorldSound( ACF.Classes["GunClass"][Class]["sound"], Gun:GetPos() , math.Clamp(SoundPressure,75,255), math.Clamp(50,15,255))
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