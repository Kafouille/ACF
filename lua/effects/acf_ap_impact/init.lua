
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
	
	self.Caliber = data:GetEntity():GetNetworkedInt( "Caliber" ) or 10
	self.Origin = data:GetOrigin()
	self.DirVec = data:GetNormal() 
	self.Velocity = data:GetScale() --Mass of the projectile in kg
	self.Mass = data:GetMagnitude() --Velocity of the projectile in gmod units
	self.Emitter = ParticleEmitter( self.Origin )
	
	self.Scale = math.max(self.Mass * (self.Velocity/39.37)/100,1)^0.3

	--self.Entity:EmitSound( "ambient/explosions/explode_1.wav" , 100 + self.Radius*10, 200 - self.Radius*10 )
	
	local BulletEffect = {}
		BulletEffect.Num = 1
		BulletEffect.Src = self.Origin - self.DirVec
		BulletEffect.Dir = self.DirVec
		BulletEffect.Spread = Vector(0,0,0)
		BulletEffect.Tracer = 0
		BulletEffect.Force = 0
		BulletEffect.Damage = 0	 
	LocalPlayer():FireBullets(BulletEffect) 
	
	local DentType = ""
	if self.Caliber <= 3 then
		DentType = "ACF_impact"..tostring(math.random(1,5)).."_small"
	elseif self.Caliber <= 10.5 then
		DentType = "ACF_impact"..tostring(math.random(1,5)).."_medium"
	elseif self.Caliber > 10.5 then
		DentType = "ACF_impact"..tostring(math.random(1,5)).."_big"
	end
	util.Decal(DentType, self.Origin + self.DirVec*10, self.Origin - self.DirVec*10)
	
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

 