
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
	
	self.Origin = data:GetOrigin()
	self.DirVec = data:GetNormal()
	self.Scale = data:GetScale()
	self.Emitter = ParticleEmitter( self.Origin )

	--self.Entity:EmitSound( "ambient/explosions/explode_1.wav" , 100 + self.Radius*10, 200 - self.Radius*10 )
		
	for i=0, 10*self.Scale do
	
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Origin )
		if (Smoke) then
			Smoke:SetVelocity( self.DirVec * math.random( 200,400*self.Scale) + VectorRand() * math.random( 20,100*self.Scale) )
			Smoke:SetLifeTime( 0 )
			Smoke:SetDieTime( math.Rand( 0.5 , 1 )  )
			Smoke:SetStartAlpha( math.Rand( 100, 255 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( 3 )
			Smoke:SetEndSize( 20*self.Scale )
			Smoke:SetRoll( math.Rand(150, 360) )
			Smoke:SetRollDelta( math.Rand(-2, 2) )			
			Smoke:SetAirResistance( 200 ) 			 
			Smoke:SetGravity( Vector( math.random(-20,20)*self.Scale, math.random(-20,20)*self.Scale, 50 ) ) 			
			Smoke:SetColor( 180 , 180 , 180 )
		end
	
	end
	
	for i=0, 30*self.Scale do
	
		local Debris = self.Emitter:Add( "effects/fleck_tile"..math.random(1,2), self.Origin )
		if (Debris) then
			Debris:SetVelocity ( self.DirVec * math.random(400,1200*self.Scale) + VectorRand() * math.random(70,100*self.Scale) )
			Debris:SetLifeTime( 0 )
			Debris:SetDieTime( 0.5 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( 3 )
			Debris:SetEndSize( 3 )
			Debris:SetRoll( math.Rand(0, 360) )
			Debris:SetRollDelta( math.Rand(-0.2, 0.2) )			
			Debris:SetAirResistance( 100 ) 			 			
			Debris:SetColor( 100,100,100 )
		end
	end
	
	for i=0, 4*self.Scale do
	
		local Embers = self.Emitter:Add( "particles/flamelet"..math.random(1,5), self.Origin )
		if (Embers) then
			Embers:SetVelocity ( self.DirVec * math.random(200,800) + VectorRand() * math.random(50*self.Scale,80*self.Scale) )
			Embers:SetLifeTime( 0 )
			Embers:SetDieTime( math.Rand( 2 , 4 ) )
			Embers:SetStartAlpha( 255 )
			Embers:SetEndAlpha( 0 )
			Embers:SetStartSize( 2 )
			Embers:SetEndSize( 2 )
			Embers:SetRoll( math.Rand(0, 360) )
			Embers:SetRollDelta( math.Rand(-0.2, 0.2) )			
			Embers:SetAirResistance( 100 ) 			 		
			Embers:SetColor( 100,80,90 )
		end
	end

	local Sparks = EffectData()
		Sparks:SetOrigin( self.Origin )
		Sparks:SetNormal( self.DirVec*-1 )
		Sparks:SetMagnitude( self.Scale*5 )
		Sparks:SetScale( self.Scale*2 )
		Sparks:SetRadius( self.Scale*5 )
	util.Effect( "Sparks", Sparks )
	
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

 