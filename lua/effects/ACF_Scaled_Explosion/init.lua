
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
	
	self.Origin = data:GetOrigin()
	self.DirVec = data:GetNormal()
	self.Scale = data:GetScale()
	self.Radius = data:GetRadius()
	self.Emitter = ParticleEmitter( self.Origin )
	
	local ImpactTr = { }
		ImpactTr.start = self.Origin - self.DirVec*20
		ImpactTr.endpos = self.Origin + self.DirVec*20
	local Impact = util.TraceLine(ImpactTr)					--Trace to see if it will hit anything
	
	self.Normal = Vector(0,0,1)
	if Impact.HitSky or not Impact.Hit then
		Normal = Vector(1,1,0)
	else
		Normal = Impact.HitNormal
	end
		
	for i=0, 3*self.Radius do
	
		local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Origin )
		if (Smoke) then
			Smoke:SetVelocity( Normal * math.random( 60,100*self.Radius) + VectorRand() * math.random( 25,50*self.Radius) )
			Smoke:SetLifeTime( 0 )
			Smoke:SetDieTime( math.Rand( 1 , 2 )*self.Radius/3  )
			Smoke:SetStartAlpha( math.Rand( 50, 150 ) )
			Smoke:SetEndAlpha( 0 )
			Smoke:SetStartSize( 20*self.Scale )
			Smoke:SetEndSize( 30*self.Radius )
			Smoke:SetRoll( math.Rand(150, 360) )
			Smoke:SetRollDelta( math.Rand(-0.2, 0.2) )			
			Smoke:SetAirResistance( 100 ) 			 
			Smoke:SetGravity( Vector( math.random(-5,5)*self.Radius, math.random(-5,5)*self.Radius, -50 ) ) 			
			Smoke:SetColor( 90,90,90 )
		end
	
	end
		
	for i=0, 2*self.Radius do
	 
		local Flame = self.Emitter:Add( "particles/flamelet"..math.random(1,5), self.Origin)
		if (Flame) then
			Flame:SetVelocity( VectorRand() * math.random(50,150*self.Radius) )
			Flame:SetLifeTime( 0 )
			Flame:SetDieTime( 0.15 )
			Flame:SetStartAlpha( math.Rand( 50, 255 ) )
			Flame:SetEndAlpha( 0 )
			Flame:SetStartSize( 10*self.Scale )
			Flame:SetEndSize( 60*self.Scale )
			Flame:SetRoll( math.random(120, 360) )
			Flame:SetRollDelta( math.Rand(-1, 1) )			
			Flame:SetAirResistance( 300 ) 			 
			Flame:SetGravity( Vector( 0, 0, 4 ) ) 			
			Flame:SetColor( 255,255,255 )
		end
		
	end
	
	for i=0, 4*self.Radius do
	
		local Debris = self.Emitter:Add( "effects/fleck_tile"..math.random(1,2), self.Origin )
		if (Debris) then
			Debris:SetVelocity ( VectorRand() * math.random(150*self.Radius,250*self.Radius) )
			Debris:SetLifeTime( 0 )
			Debris:SetDieTime( math.Rand( 1.5 , 3 )*self.Radius/3 )
			Debris:SetStartAlpha( 255 )
			Debris:SetEndAlpha( 0 )
			Debris:SetStartSize( 3*self.Scale )
			Debris:SetEndSize( 3*self.Scale )
			Debris:SetRoll( math.Rand(0, 360) )
			Debris:SetRollDelta( math.Rand(-3, 3) )			
			Debris:SetAirResistance( 10 ) 			 
			Debris:SetGravity( Vector( 0, 0, -650 ) ) 			
			Debris:SetColor( 120,120,120 )
		end
	end
	
	for i=0, 5*self.Radius do
	
		local Embers = self.Emitter:Add( "particles/flamelet"..math.random(1,5), self.Origin )
		if (Embers) then
			Embers:SetVelocity ( VectorRand() * math.random(70*self.Radius,160*self.Radius) )
			Embers:SetLifeTime( 0 )
			Embers:SetDieTime( math.Rand( 0.3 , 1 )*self.Radius/3 )
			Embers:SetStartAlpha( 255 )
			Embers:SetEndAlpha( 0 )
			Embers:SetStartSize( 3*self.Scale )
			Embers:SetEndSize( 0*self.Scale )
			Embers:SetStartLength( 20*self.Scale )
			Embers:SetEndLength ( 0*self.Scale )
			Embers:SetRoll( math.Rand(0, 360) )
			Embers:SetRollDelta( math.Rand(-0.2, 0.2) )	
			Embers:SetAirResistance( 20 ) 			 
			Embers:SetGravity( Vector( 0, 0, -650 ) ) 			
			Embers:SetColor( 200,200,200 )
		end
	end
	
	for i=0, 2*self.Radius do
		local Whisp = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Origin )
			if (Whisp) then
				Whisp:SetVelocity(VectorRand() * math.random( 150,250*self.Radius) )
				Whisp:SetLifeTime( 0 )
				Whisp:SetDieTime( math.Rand( 3 , 5 )*self.Radius/3  )
				Whisp:SetStartAlpha( math.Rand( 20, 50 ) )
				Whisp:SetEndAlpha( 0 )
				Whisp:SetStartSize( 40*self.Scale )
				Whisp:SetEndSize( 80*self.Radius )
				Whisp:SetRoll( math.Rand(150, 360) )
				Whisp:SetRollDelta( math.Rand(-0.2, 0.2) )			
				Whisp:SetAirResistance( 100 ) 			 
				Whisp:SetGravity( Vector( math.random(-5,5)*self.Radius, math.random(-5,5)*self.Radius, 0 ) ) 			
				Whisp:SetColor( 150,150,150 )
			end
	end
	
	if self.Scale > 1 then
		for i=0, 0.5*self.Radius do
			local Cookoff = EffectData()				
				Cookoff:SetOrigin( self.Origin )
				Cookoff:SetScale( self.Scale )
			util.Effect( "ACF_Cookoff", Cookoff )
		end
	end
	WorldSound( "ambient/explosions/explode_5.wav", self.Origin , math.Clamp(self.Scale*40,75,165), math.max(300 - self.Scale*50,15))
	WorldSound( "ambient/explosions/explode_4.wav", self.Origin , math.Clamp(self.Scale*40,75,165), math.max(300 - self.Scale*100,15))
 end   
   
/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if Normal != Vector(1,1,0) then
	
		local Timer = CurTime() + 3
		local Density = 7*self.Radius
		local Angle = Normal:Angle()
		if Timer > CurTime() then
			
			for i=0, Density do	
				
				Angle:RotateAroundAxis(Angle:Forward(), (360/Density))
				local ShootVector = Angle:Up()
				local Smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Origin )
				if (Smoke) then
					Smoke:SetVelocity( ShootVector * math.Rand(5,200*self.Radius) )
					Smoke:SetLifeTime( 0 )
					Smoke:SetDieTime( math.Rand( 1 , 2 )*self.Radius /3 )
					Smoke:SetStartAlpha( math.Rand( 50, 120 ) )
					Smoke:SetEndAlpha( 0 )
					Smoke:SetStartSize( 8*self.Scale )
					Smoke:SetEndSize( 12*self.Radius )
					Smoke:SetRoll( math.Rand(0, 360) )
					Smoke:SetRollDelta( math.Rand(-0.2, 0.2) )			
					Smoke:SetAirResistance( 200 ) 			 
					Smoke:SetGravity( Vector( math.Rand( -20 , 20 ), math.Rand( -20 , 20 ), math.Rand( 10 , 100 ) ) )			
					Smoke:SetColor( 90,90,90 )
				end	
			
			end
			
		else	
		self.Emitter:Finish() 
		return false
		end
	
	else
	
		for i=0, 10*self.Radius do
	
			local AirBurst = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Origin )
			if (AirBurst) then
				AirBurst:SetVelocity( VectorRand() * math.random( 150,200*self.Radius) )
				AirBurst:SetLifeTime( 0 )
				AirBurst:SetDieTime( math.Rand( 1 , 2 )*self.Radius/3  )
				AirBurst:SetStartAlpha( math.Rand( 100, 255 ) )
				AirBurst:SetEndAlpha( 0 )
				AirBurst:SetStartSize( 25*self.Scale )
				AirBurst:SetEndSize( 35*self.Radius )
				AirBurst:SetRoll( math.Rand(150, 360) )
				AirBurst:SetRollDelta( math.Rand(-0.2, 0.2) )			
				AirBurst:SetAirResistance( 200 ) 			 
				AirBurst:SetGravity( Vector( math.random(-10,10)*self.Radius, math.random(-10,10)*self.Radius, 20 ) ) 			
				AirBurst:SetColor( 90,90,90 )
			end
		end
		self.Emitter:Finish() 
		return false
	
	end
	
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end

 
