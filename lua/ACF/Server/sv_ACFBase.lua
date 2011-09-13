function ACF_Activate ( Entity , Recalc )

	--Density of steel = 7.8g cm3 so 7.8kg for a 1mx1m plate 1m thick
	if Entity.SpecialHealth then
		Entity:ACF_Activate( Recalc )
		return
	end
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
					ACF_Activate( Entity )
				elseif Entity.ACF.Mass != Entity:GetPhysicsObject():GetMass() then
					ACF_Activate( Entity , true )
				end
				return Entity.ACF.Type	
			end	
		end
	end
	return false
	
end

function ACF_Damage ( Entity , Energy , FrAera , Angle , Inflictor ) 
	
	local Activated = ACF_Check( Entity )
	
	if Entity.SpecialDamage then
		return Entity:ACF_OnDamage( Entity , Energy , FrAera , Angle , Inflictor )
	elseif Activated == "Prop" then	
		
		return ACF_PropDamage( Entity , Energy , FrAera , Angle , Inflictor )
		
	elseif Activated == "Vehicle" then
	
		return ACF_VehicleDamage( Entity , Energy , FrAera , Angle , Inflictor )
		
	elseif Activated == "Squishy" then
	
		return ACF_SquishyDamage( Entity , Energy , FrAera , Angle , Inflictor )
		
	end
	
end

function ACF_CalcDamage( Entity , Energy , FrAera , Angle )

	local Armour = Entity.ACF.Armour/math.abs( math.cos(math.rad(Angle)) ) --Calculate Line Of Sight thickness of the armour
	local Structure = Entity.ACF.Density --Structural strengh of the material, derived from prop density, denser stuff is more vulnerable (Density is different than armour, calculated off real volume)
	
	local MaxPenetration = (Energy.Penetration / FrAera) * ACF.KEtoRHA							--Let's see how deep the projectile penetrates ( Energy = Kinetic Energy, FrAera = Frontal aera in cm2 )
	local Penetration = math.min( MaxPenetration , Armour )			--Clamp penetration to the armour thickness
	
	local Crush = (Energy.Momentum * math.min(Penetration/MaxPenetration,1)) * ACF.KEtoCrush / (1+Entity.ACF.Density)^2
	
	local HitRes = {}
	HitRes.Damage = (Penetration/Armour * FrAera) + Crush 	-- This is the volume of the hole caused by our projectile 
	HitRes.Overkill = (MaxPenetration - Penetration)
	HitRes.Loss = Penetration/MaxPenetration
	
	return HitRes
end

function ACF_PropDamage( Entity , Energy , FrAera , Angle , Inflictor )

	local HitRes = ACF_CalcDamage( Entity , Energy , FrAera , Angle )
	
	HitRes.Kill = false
	if HitRes.Damage >= Entity.ACF.Health then
		HitRes.Kill = true 
	else
		Entity.ACF.Health = Entity.ACF.Health - HitRes.Damage
		Entity.ACF.Armour = Entity.ACF.MaxArmour * (0.5 + Entity.ACF.Health/Entity.ACF.MaxHealth/2) --Simulating the plate weakening after a hit
	end
		
	return HitRes
	
end

function ACF_VehicleDamage( Entity , Energy , FrAera , Angle , Inflictor )

	local HitRes = ACF_CalcDamage( Entity , Energy , FrAera , Angle )
	
	local Driver = Entity:GetDriver()
	if Driver:IsValid() then
		Driver:TakeDamage( HitRes.Damage*2 , Inflictor )
	end

	HitRes.Kill = false
	if HitRes.Damage >= Entity.ACF.Health then
		HitRes.Kill = true 
	else
		Entity.ACF.Health = Entity.ACF.Health - HitRes.Damage
		Entity.ACF.Armour = Entity.ACF.Armour * (0.5 + Entity.ACF.Health/Entity.ACF.MaxHealth/2) --Simulating the plate weakening after a hit
	end
		
	return HitRes
end

function ACF_SquishyDamage( Entity , Energy , FrAera , Angle , Inflictor )

	local HitRes = ACF_CalcDamage( Entity , Energy , FrAera , Angle )

	Entity:TakeDamage(HitRes.Damage*2 , Inflictor )
	
	HitRes.Kill = false
		
	return HitRes
end
