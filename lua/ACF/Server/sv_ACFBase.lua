function ACF_Create ( Entity , Recalc )

	--Density of steel = 7.8g cm3 so 7.8kg for a 1mx1m plate 1m thick
	
	local Size = Entity.OBBMaxs(Entity) - Entity.OBBMins(Entity)
	local Aera = ((Size.x * Size.y)+(Size.x * Size.z)+(Size.y * Size.z)) * 6.45 --Converting from square in to square cm, fuck imperial
	local Volume = Size.x * Size.y * Size.z * 16.38
	local Armour = Entity:GetPhysicsObject():GetMass()*1000 / Aera / 0.78 --So we get the equivalent thickness of that prop in mm if all it's weight was a steel plate
	local Health = Volume/ACF.Threshold							--Setting the threshold of the prop aera gone 
	local Percent = 1 
	
	if Recalc then
		Percent = Entity.ACF.Health/Entity.ACF.MaxHealth
	end
	Entity.ACF = {} 
	Entity.ACF.Health = Health * Percent
	Entity.ACF.MaxHealth = Health
	Entity.ACF.Armour = Armour * (0.5 + Percent/2)
	Entity.ACF.MaxArmour = Armour
	Entity.ACF.Type = nil
	Entity.ACF.Mass = Entity:GetPhysicsObject():GetMass()
	Entity.ACF.Density = (Entity:GetPhysicsObject():GetMass()*1000)/Volume

	if Entity:IsPlayer() || Entity:IsNPC() then
		Entity.ACF.Type = "Squishy"
	elseif Entity:IsVehicle() then
		Entity.ACF.Type = "Vehicle"
	else
		Entity.ACF.Type = "Prop"
	end
	
end

function ACF_Check ( Entity )
	
	if ( IsValid(Entity) ) then
		if ( Entity:GetPhysicsObject():IsValid() and !Entity:IsWorld() and !Entity:IsWeapon() ) then
			local Class = Entity:GetClass()
			--print(Class)
			if ( Class != "gmod_ghost" and Class != "debris" and Class != "prop_ragdoll" and not string.find( Class , "func_" )  ) then
				if !Entity.ACF then 
					ACF_Create( Entity )
				elseif Entity.ACF.Mass != Entity:GetPhysicsObject():GetMass() then
					ACF_Create( Entity , true )
				end
				return Entity.ACF.Type	
			end	
		end
	end
	return false
	
end

function ACF_Damage ( Entity , Energy , FrAera , Angle , Inflictor ) 
	
	local Activated = ACF_Check( Entity )
	
	if Activated == "Prop" then	
	
		local Armour = Entity.ACF.Armour/math.abs( math.cos(math.rad(Angle)) ) --Calculate Line Of Sight thickness of the armour
		local Structure = Entity.ACF.Density --Structural strengh of the material, derived from prop density, denser stuff is more vulnerable (Density is different than armour, calculated off real volume)
		
		local MaxPenetration = (Energy.Penetration / FrAera) * ACF.KEtoRHA							--Let's see how deep the projectile penetrates ( Energy = Kinetic Energy, FrAera = Frontal aera in cm2 )
		local Penetration = math.min( MaxPenetration , Armour )			--Clamp penetration to the armour thickness
		
		local Crush = (Energy.Momentum * math.min(Penetration/MaxPenetration,1)) * ACF.KEtoCrush / (1+Entity.ACF.Density)^2
		
		local Damage = (Penetration/Armour * FrAera) + Crush 	-- This is the volume of the hole caused by our projectile 
		--print("Energy : " ..Energy)
		--print("Aera : " ..FrAera)
		--print("Penetration : " ..Penetration)
		--print("Max Penetration : " ..MaxPenetration)
		--print("Base Armour : "..Entity.ACF.Armour)
		--print("Effective Armour : "..Armour)
		--print("PenDmg : " ..(Penetration/Armour * FrAera))
		--print("Crush : " ..Crush)
		local Kill = false
		if Damage >= Entity.ACF.Health then
			Kill = true 
			if Entity.KillAction then
				Entity:IsKilled( Inflictor )
			end
		else
			Entity.ACF.Health = Entity.ACF.Health - Damage
			Entity.ACF.Armour = Entity.ACF.MaxArmour * (0.5 + Entity.ACF.Health/Entity.ACF.MaxHealth/2) --Simulating the plate weakening after a hit
			if Entity.DamageAction then
				Entity:IsDamaged( Damage, Inflictor )
			end
		end
		
		local HitRes = {}
			HitRes.Overkill = (MaxPenetration - Penetration)
			HitRes.Loss = Penetration/MaxPenetration
			HitRes.Kill = Kill
			
		return HitRes
		
	elseif Activated == "Vehicle" then
	
		local Armour = Entity.ACF.Armour/math.abs( math.cos(math.rad(Angle)) ) --Calculate Line Of Sight thickness of the armour
		local MaxPenetration = (Energy.Penetration / FrAera) * ACF.KEtoRHA							--Let's see how deep the projectile penetrates ( Energy = Kinetic Energy, FrAera = Frontal aera in cm2 )
		local Penetration = math.min( MaxPenetration , Armour )			--Clamp penetration to the armour thickness
		local Crush = (Energy.Momentum * math.min(MaxPenetration/Penetration,1)) * ACF.KEtoCrush / Entity.ACF.Density
		local Damage = (Penetration/Armour * FrAera) + Crush 	-- This is the volume of the hole caused by our projectile 
		local Driver = Entity:GetDriver()
		if Driver:IsValid() then
			local Damage = (math.min( MaxPenetration*100 , 300 ) * FrAera)
			Driver:TakeDamage( Damage , Inflictor )
			local Health = Driver:Health() - Damage*10
			if Health <= 0 then
				Driver:Kill( Inflictor )
			else
				Driver:SetHealth(Health)
			end
		end

		local Kill = false
		if Damage >= Entity.ACF.Health then
			Kill = true 
		else
			Entity.ACF.Health = Entity.ACF.Health - Damage
			Entity.ACF.Armour = Entity.ACF.Armour * (0.5 + Entity.ACF.Health/Entity.ACF.MaxHealth/2) --Simulating the plate weakening after a hit
		end
		
		local HitRes = {}
			HitRes.Overkill = (MaxPenetration - Penetration)
			HitRes.Loss = Penetration/MaxPenetration							--Fraction of power the shell Has left after penetration
			HitRes.Kill = Kill
			
		return HitRes
		
	elseif Activated == "Squishy" then
	
		local Armour = Entity.ACF.Armour/math.abs( math.cos(math.rad(Angle)) ) --Calculate Line Of Sight thickness of the armour
		local MaxPenetration = (Energy.Penetration / FrAera) * ACF.KEtoRHA *100			--Let's see how deep the projectile penetrates ( Energy = Kinetic Energy, FrAera = Frontal aera in cm2 )
		local Penetration = math.min( MaxPenetration , Armour*100 )			--Clamp penetration to the armour thickness (Multipled by 100 because you aren't steel)
		local Crush = (Energy.Momentum * math.min(MaxPenetration/Penetration,1)) * ACF.KEtoCrush / Entity.ACF.Density
		local Damage = (Penetration/Armour * FrAera) + Crush 	-- This is the volume of the hole caused by our projectile 
		Entity:TakeDamage( Damage+Crush/100 , Inflictor )
		
		local HitRes = {}
			HitRes.Overkill = (MaxPenetration - Penetration)
			HitRes.Loss = Penetration/MaxPenetration							--Fraction of power the shell Has left after penetration
			HitRes.Kill = false
			
		return HitRes
		
	end
	
end
